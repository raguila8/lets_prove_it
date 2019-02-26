module ProblemPersistence
  class ProblemUpdateService
    attr_reader :problem

    def initialize(params)
      prepare_tags(params[:tags])
      @user = User.find(params[:user_id])
      @images = params[:problem][:images].split(",")
      @version_description = params["version"]["description"]
      title = params[:problem][:title]
      content = params[:problem][:content]
      @problem = Problem.find(params[:id])
      @problem.update_attributes(title: title, content: content)

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
          @problem.save!
          create_version!
          update_tags! if topics_changed?
          Image.add_new_images!(@problem, @images, @user)
          @user.follow @problem if !@user.following? @problem

          # Notify problem followers
          Notifications::Sender::SendNotifications.new(notification_type: :updated_problem,
                                                     actor: @user,
                                                     resource: @problem).call

        end
      end
    end

    def create_version!
      @version = Version.create!(versioned: @problem, 
                    version_number: Version.next_version_number(@problem), 
                    user_id: @user.id, title: @problem.title, 
                    content: @problem.content, description: @version_description)
    end

    def update_tags!
      @version.add_topics!(@tags)
      destroy_removed_tags!

      @tags.each do |tag|
        topic = Topic.find_by(name: tag)

        topic = (topic.nil? ? create_new_tag!(tag) : topic)
        add_tag_to_problem!(topic) if topic_added?(topic.name)
      end
    end

    def create_new_tag!(tag)
      Topic.create!(name: tag)
    end

    def add_tag_to_problem!(topic)
      @problem.topics << topic
    end

    def topics_changed?
      @problem.topics.each do |topic|
        if topic_removed?(topic.name)
          return true
        end
      end

      @tags.each do |tag|
        if topic_added?(tag)
          return true
        end
      end

      return false
    end

    def destroy_removed_tags!
      @problem.topics.each do |topic|
        remove_topic!(topic) if topic_removed?(topic.name) 
      end
    end

    def topic_removed?(tag)
      !@tags.include?(tag)
    end

    def topic_added?(tag)
      !@problem.topics.map{|t| t.name}.include?(tag)
    end

    def remove_topic!(topic)
      ProblemTopic.find_by(problem_id: @problem.id, topic_id: topic.id).destroy!
    end

    def prepare_tags(tags)
      @tags = tags.map{ |t| t.downcase.titleize }.uniq
    end   
  end
end

