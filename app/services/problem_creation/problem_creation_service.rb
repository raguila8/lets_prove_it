module ProblemCreation
  class ProblemCreationService
    attr_reader :problem

    def initialize(params)
      prepare_tags(params[:tags])
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
          add_tags!
          @problem.save!
          byebug
          create_version!
          Image.add_new_images!(@problem, @images, @user)
          @user.follow @problem if !@user.following? @problem
          Notifications::Sender::SendNotifications.new(notification_type: :new_problem,
                                                     actor: current_user,
                                                     resource: @interactor.problem).call
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

    def prepare_tags(tags)
      @tags = tags.map{ |t| t.downcase.titleize }.uniq
    end   
  end
end

