module ProblemCreation
  class ProblemCreationService
    attr_reader :problem

    def initialize(params)
      prepare_tags!(params[:tags])
      @user = User.find(params[:user_id])
      @images = params[:problem][:images].split(",")
      title = params[:problem][:title]
      content = params[:problem][:content]
      @problem = Problem.new(title: title, content: content, user_id: @user.id)

      call
    end

    def call
      problem_transaction
    end

    private

    def problem_transaction
      begin
        ActiveRecord::Base.transaction do
          #add_tags!
          #create_new_tags!
          #add_tags_to_problem!
          @problem.save!
          create_version!
          #add_tags!
          Image.add_new_images!(@problem, @images, @user)
          @user.follow @problem if !@user.following? @problem
        end
      end
    end

    def create_version!
      @version = Version.create!(versioned: @problem, version_number: 1, 
                    user_id: @user.id, title: @problem.title, 
                    content: @problem.content, description: "Problem created")
    end

    def add_tags!
      @tags.each do |tag|
        topic = Topic.find_by(name: tag)

        topic = (topic.nil? ? create_new_tag!(tag) : topic)
        add_tag_to_problem!(topic)
      end
    end

    def create_new_tag!(tag)
      Topic.create!(name: tag)
    end

    def add_tag_to_problem!(topic)
      @problem.topics << topic
    end

=begin
    def add_tags!
      @tags.each do |tag|
        topic = Topic.find_by(name: tag)
        if topic.nil?
          topic = Topic.create!(name: tag)
        end
        
        if ProblemTopic.find_by(problem_id: @problem.id, topic_id: topic.id).nil?
          ProblemTopic.create!(problem_id: @problem.id, topic_id: topic.id)
          @version.addTopic! topic
        end
      end
    end
=end

    def prepare_tags!(tags)
      #raise Errors::ProblemHasNoTopicsError.new if tags.length == 0
      @tags = tags.map{ |t| t.downcase.titleize }.uniq
      
    end    
  end
end

