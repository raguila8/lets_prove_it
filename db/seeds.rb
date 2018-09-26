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


  User.create(username: username, name: Faker::Name.name,
              email: email, password: "foobar", 
              password_confirmation: "foobar", occupation: Faker::Job.title,
              education: Faker::University.name, location: Faker::Address.city,
              reputation: Faker::Number.between(1, 25000), 
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

  #problem.reload

  # add problem comments
  2.times do |i|
    if Faker::Boolean.boolean
      Comment.create(content: Faker::Lorem.paragraph, 
                            commented_on: problem, 
                            user_id: User.order("random()").first.id)
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
        #proof.reload
        
      # add proof comments
      2.times.each do |k|
        if  Faker::Boolean.boolean
          Comment.create(content: Faker::Lorem.paragraph, 
                            commented_on: proof, 
                            user_id: User.order("random()").first.id)
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
