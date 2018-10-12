require 'rails_helper'
include Notifications::Sender

RSpec.describe Notifications::Sender::SendNotifications do
  let(:actor) { create(:user, reputation: 500) }
  let(:problem) { create(:problem, user: recipient, topics: [topic]) }
  let(:recipient) { create(:other_user, reputation: 500) }
  let(:topic) { create(:topic) }

  it "should create a SendUpvoteNotifications object when notification_type is :upvote" do
    sender = SendNotifications.new(notification_type: :upvote,
                                  actor: actor, resource: problem)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendUpvoteNotifications)
  end

  it "should create a SendCommentNotifications object when notification_type is :new_comment" do
    comment = create(:comment, commented_on: problem, user: actor)
    sender = SendNotifications.new(notification_type: :new_comment, 
                                   actor: actor,
                                   resource: comment)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendCommentNotifications)
  end

  it "should create a SendCommentNotifications object when notification_type is :updated_comment" do
    comment = create(:comment, commented_on: problem, user: actor)
    sender = SendNotifications.new(notification_type: :updated_comment, 
                                   actor: actor,
                                   resource: comment)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendCommentNotifications)
  end

  it "should create a SendProofNotifications instance variable when notification_type is :new_proof" do
    proof = create(:proof, problem: problem, user: actor)
    sender = SendNotifications.new(notification_type: :new_proof,
                                   actor: actor,
                                   resource: proof)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendProofNotifications)
  end

  it "should create a SendProofNotifications instance variable when notification_type is :updated_proof" do
    proof = create(:proof, problem: problem, user: actor)
    sender = SendNotifications.new(notification_type: :updated_proof,
                                   actor: actor,
                                   resource: proof)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendProofNotifications)
  end

  it "should create a SendProblemNotifications instance variable when notification_type is :new_problem" do
    problem.update(user: actor)
    sender = SendNotifications.new(notification_type: :new_problem,
                                   actor: actor,
                                   resource: problem)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendProblemNotifications)
  end

  it "should create a SendProblemNotifications instance variable when notification_type is :updated_problem" do
    sender = SendNotifications.new(notification_type: :updated_problem,
                                   actor: actor,
                                   resource: problem)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendProblemNotifications)
  end

  it "should create a SendTopicNotifications instance variable when notification_type is :new_topic" do
    sender = SendNotifications.new(notification_type: :new_topic,
                                   actor: actor,
                                   resource: topic)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendTopicNotifications)
  end

  it "should create a SendTopicNotifications instance variable when notification_type is :updated_problem" do
    sender = SendNotifications.new(notification_type: :updated_topic,
                                   actor: actor,
                                   resource: topic)
    expect(sender.instance_variable_get(:@notifications_sender)).to be_an_instance_of(SendTopicNotifications)
  end 
end

