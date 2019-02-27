module ProofPersistence
  class ProofCreationService
    attr_reader :proof

    def initialize(params)
      @user = User.find(params[:user_id])
      @images = params[:proof][:images].split(",")
      content = params[:proof][:content]
      @problem = Problem.find(params[:proof][:problem_id])
      @proof = Proof.new(content: content, problem_id: @problem.id, user_id: @user.id)

      call
    end

    def call
      proof_transaction
    end

    private

    def proof_transaction
      begin
        ActiveRecord::Base.transaction do
          @proof.save!
          create_version!
          Image.add_new_images!(@proof, @images, @user)
          @user.follow @problem if !@user.following? @problem

          # Create notifications for users following the problem
          Notifications::Sender::SendNotifications.new(notification_type: :new_proof,
                                                     actor: @user,
                                                     resource: @proof).call
        end
      end
    end

    def create_version!
      @version = Version.create!(versioned: @proof, version_number: 1, 
                    user_id: @user.id, title: @problem.title, 
                    content: @proof.content, description: "Proof created")
    end
  end
end
