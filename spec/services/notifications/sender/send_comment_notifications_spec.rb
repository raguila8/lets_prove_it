require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: recipient, topics: [topic]) }
  let(:recipient) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }
  let(:proof) { create(:proof, user: recipient, problem: problem) }

  it "should return the correct feedback" do
    comment = create(:comment, commented_on: problem, user: actor)
    feedback = SendNotifications.new(notification_type: :new_comment, resource: comment).call
    expect(feedback[:response]).to eq(:success)
    expect(feedback[:sent]).to eq(1)
  end

  it "should send a notification to the creator of a problem when it is commented on" do
    comment = create(:comment, commented_on: problem, user: actor)
    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: comment).call
    expect(Notification.all.count).to eq(1)
    expect(Notification.find_by(recipient: problem.user, actor: comment.user, 
                               notifiable: problem, action_type: "comment")).not_to be_nil
  end

  it "should send a notification to the creator of a proof when it is commented on" do
    comment = create(:comment, commented_on: proof, user: actor)
    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: comment).call
    expect(Notification.all.count).to eq(1)
    expect(Notification.find_by(recipient: proof.user, actor: comment.user, 
                               notifiable: proof, action_type: "comment")).not_to be_nil
  end

  it "should send notifications to commenters of a problem when a new comment is created" do
    third_user = create(:third_user, reputation: 100)
    fourth_user = create(:fourth_user, reputation: 100)
    comment1 = create(:comment, user: third_user, commented_on: problem)
    comment2 = create(:comment, user: fourth_user, commented_on: problem)
    my_comment = create(:comment, user: actor, commented_on: problem)

    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: my_comment).call
    expect(Notification.all.count).to eq(3)
    expect(Notification.find_by(recipient: comment1.user, actor: my_comment.user,
                               notifiable: problem, action_type: "comment")).not_to be_nil
    expect(Notification.find_by(recipient: comment2.user, actor: my_comment.user,
                               notifiable: problem, action_type: "comment")).not_to be_nil 
  end

  it "should send notifications to commenters of a proof when a new comment is added" do
    third_user = create(:third_user, reputation: 100)
    fourth_user = create(:fourth_user, reputation: 100)
    comment1 = create(:comment, user: third_user, commented_on: proof)
    comment2 = create(:comment, user: fourth_user, commented_on: proof)
    my_comment = create(:comment, user: actor, commented_on: proof)

    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: my_comment).call
    expect(Notification.all.count).to eq(3)
    expect(Notification.find_by(recipient: comment1.user, actor: my_comment.user,
                               notifiable: proof, action_type: "comment")).not_to be_nil
    expect(Notification.find_by(recipient: comment2.user, actor: my_comment.user,
                               notifiable: proof, action_type: "comment")).not_to be_nil 
  end

  it "should notify a user only once when their problem is commented on and they have also commented on it" do
    create(:comment, user: recipient, commented_on: problem)
    my_comment = create(:comment, user: actor, commented_on: problem)

    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: my_comment).call
    expect(Notification.all.count).to eq(1)
    expect(Notification.find_by(recipient: problem.user, actor: my_comment.user,
                               notifiable: problem, action_type: "comment")).not_to be_nil
  end

  it "should notify a user only once when their proof is commented on and they have also commented on it" do
    create(:comment, user: recipient, commented_on: proof)
    my_comment = create(:comment, user: actor, commented_on: proof)

    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: my_comment).call
    expect(Notification.all.count).to eq(1)
    expect(Notification.find_by(recipient: proof.user, actor: my_comment.user,
                               notifiable: proof, action_type: "comment")).not_to be_nil
  end

  it "should not notify you if you are the owner of the post" do
    problem_comment = create(:comment, user: problem.user, commented_on: problem)
    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: problem_comment).call
    expect(Notification.all.count).to eq(0)

    proof_comment = create(:comment, user: proof.user, commented_on: proof)
    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: proof_comment).call
    expect(Notification.all.count).to eq(0)
  end

  it "should not notify you when you comment a problem, even if you have previously commented on the problem" do
    create(:comment, user: actor, commented_on: problem)
    second_comment = create(:comment, user: actor, commented_on: problem)

    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: second_comment).call
    expect(Notification.all.count).to eq(1)
    expect(Notification.find_by(recipient: actor, actor: actor,
                               notifiable: problem, action_type: "comment")).to be_nil
  end

  it "should not notify you when you comment a proof, even if you have previously commented on the proof" do
    create(:comment, user: actor, commented_on: proof)
    second_comment = create(:comment, user: actor, commented_on: proof)

    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: second_comment).call
    expect(Notification.all.count).to eq(1)
    expect(Notification.find_by(recipient: actor, actor: actor,
                               notifiable: proof, action_type: "comment")).to be_nil
  end


  it "should only notify a user once even if they have commented on the post more than one time" do
    third_user = create(:third_user, reputation: 100)

    # Test for problem
    first_comment = create(:comment, user: third_user, commented_on: problem)
    second_comment = create(:comment, user: third_user, commented_on: problem)
    my_comment = create(:comment, user: actor, commented_on: problem)
    
    expect(Notification.all.count).to eq(0)
    SendNotifications.new(notification_type: :new_comment, resource: my_comment).call
    expect(Notification.all.count).to eq(2)
    expect(Notification.where(recipient: third_user, actor: actor,
                               notifiable: problem, action_type: "comment").count).to eq(1)

    # Test for proof
    first_comment = create(:comment, user: third_user, commented_on: proof)
    second_comment = create(:comment, user: third_user, commented_on: proof)
    my_comment = create(:comment, user: actor, commented_on: proof)

    expect(Notification.all.count).to eq(2)
    SendNotifications.new(notification_type: :new_comment, resource: my_comment).call
    expect(Notification.all.count).to eq(4)
    expect(Notification.where(recipient: third_user, actor: actor,
                               notifiable: proof, action_type: "comment").count).to eq(1)


  end
end
