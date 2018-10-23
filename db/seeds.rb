require 'rubystats'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(username:  "raguila8",
             email: "rodrigoaguilar887@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
						 name: "Rodrigo Aguilar", occupation: "Unemployed",
             education: "Johns Hopkins University", location: "Los Angeles",
             reputation: 25000, bio: Faker::Lorem.paragraph)


# create 15 random users
15.times do |n|
  username = Faker::Internet.user_name(5..8)
  while not User.find_by(username: username).nil?
    username = Faker::Internet.user_name(5..8)
  end

  email = Faker::Internet.email
  while not User.find_by(email: email).nil?
    email = Faker::Internet.email
  end

  reputation_dis = Rubystats::NormalDistribution.new(80, 100)
  reputation = reputation_dis.rng.round
  reputation = rand(1000..10000) if reputation < 0

  User.create(username: username, name: Faker::Name.name,
              email: email, password: "foobar", 
              password_confirmation: "foobar", occupation: Faker::Job.title,
              education: Faker::University.name, location: Faker::Address.city,
              reputation: reputation, 
              bio: Faker::Lorem.paragraph, avatar: Faker::Avatar.image)
end

# create 10 random topics along with their versions
list_of_topics = ["algebra", "calculus", "real-analysis", "complex-analysis", 
                  "number-theory", "topology", "geometry", "combinatorics", 
                  "representation-theory", "group-theory"]
list_of_topics.each do |topic|
  topic = Topic.create(name: topic, 
                  description: "<p>#{Faker::Lorem.paragraph(rand(1...8))}</p>")
end

# Create flag types
Flag.create(name: "spam", reportable_type: "all", description: "Content that causes a negative user experience by making it difficult to find more relevant and substantive material.")
Flag.create(name: "offensive", reportable_type: "all", description: "Content that is disrespectful, rude or abusive.")
Flag.create(name: "very low quality", reportable_type: "all", description: "Content that has severe formatting or content problems, and might not be salvageable through editing.")
Flag.create(name: "duplicate", reportable_type: "problem", description: "A problem that has been asked and proven before.")
Flag.create(name: "not a proof problem", reportable_type: "problem", description: "There is nothing to prove.")
Flag.create(name: "not a proof", reportable_type: "proof", description: "Content that does not attempt to prove the problem, or is not logically sound.")
Flag.create(name: "other", reportable_type: "all", description: "A problem not listed above that requires moderator intervention.")

spam_and_offensive_flags = [Flag.first, Flag.second]
votes = ['like', 'bad']

# create 20 random problems with proofs and comments along with corresponding
# versions

20.times do |n|
  title = Faker::Book.title
  while not Problem.find_by(title: title).nil?
    title = Faker::Book.title
  end
  problem = Problem.new(title: title, 
                     content: "<p>#{Faker::Lorem.paragraph(rand(1..3))}</p>")
  problem.user_id = User.order("random()").first.id
  tags = list_of_topics.sample(1 + rand(10))
  puts problem.save_new(tags, [], problem.user)[:exception]

  # votes
  5.times do |time|
    user = User.order("random()").first
    if !user.voted_for? problem
      problem.vote_by voter: user, vote: votes.sample
    end
  end

  rand(3..5).times do |sr|
    user = User.order("random()").first
    if !user.reported? problem
      report = Report.create(reportable: problem, 
                             user_id: user.id,
                             reason: Faker::Lorem.paragraph,
                             status: "pending")

      spam_and_offensive_flags.sample(rand(1..2)).each do |flag|
        FlagReport.create(report: report, flag: flag)
      end
    end
  end

  #problem.reload

  # add problem comments
  2.times do |i|
    if Faker::Boolean.boolean
      comment = Comment.create(content: Faker::Lorem.paragraph, 
                            commented_on: problem, 
                            user_id: User.order("random()").first.id)

      # votes
      5.times do |time|
        user = User.order("random()").first
        if !user.voted_for? comment
          comment.vote_by voter: user, vote: votes.sample
        end
      end

      rand(0..2).times do |rc|
        user = User.order("random()").first
        if !user.reported? comment
          report = Report.create(reportable: comment, 
                                 user_id: user.id,
                                 reason: Faker::Lorem.paragraph,
                                 status: "pending")

          Flag.all.sample(rand(Flag.count)).each do |flag|
            FlagReport.create(report: report, flag: flag)
          end
        end
      end

    end
  end

  # add proofs and proof comments
  2.times do |j|
    if Faker::Boolean.boolean
      # add proof
        proof = Proof.new(content: Faker::Lorem.paragraph(rand(1..5)), 
                          problem_id: problem.id, 
                          user_id: User.order("random()").first.id)
        puts proof.save_new([], proof.user)[:exception]
        
        # votes
        5.times do |time|
          user = User.order("random()").first
          if !user.voted_for? proof
            proof.vote_by voter: user, vote: votes.sample
          end
        end


        rand(3..5).times do |sr|
          user = User.order("random()").first
          if !user.reported? proof
            report = Report.create(reportable: proof, 
                                   user_id: user.id,
                                   reason: Faker::Lorem.paragraph,
                                   status: "pending")
            spam_and_offensive_flags.sample(rand(1..2)).each do |flag|
              FlagReport.create(report: report, flag: flag)
            end
          end
        end

        #proof.reload
        
      # add proof comments
      2.times.each do |k|
        if  Faker::Boolean.boolean
          comment = Comment.create(content: Faker::Lorem.paragraph, 
                            commented_on: proof, 
                            user_id: User.order("random()").first.id)

          # votes
          5.times do |time|
            user = User.order("random()").first
            if !user.voted_for? comment
              comment.vote_by voter: user, vote: votes.sample
            end
          end

          rand(0..2).times do |rc|
            user = User.order("random()").first
            if !user.reported? comment
              report = Report.create(reportable: comment, 
                                     user_id: user.id,
                                     reason: Faker::Lorem.paragraph,
                                     status: "pending")
       
              Flag.all.sample(rand(Flag.count)).each do |flag|
                FlagReport.create(report: report, flag: flag)
              end
            end
          end
        end
      end
    end
  end
end

# create user relationships with other users, topics and problems
followable_classes = ["Problem", "User", "Topic"]
User.all.each do |user|
  4.times do |n|
    if Faker::Boolean.boolean
      model = followable_classes[rand(3)].capitalize.constantize.order("random()").first
      if !user.following?(model)
        user.follow model
      end
    end
  end
end
