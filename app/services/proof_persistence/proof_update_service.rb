module ProofPersistence
  class ProofUpdateService
    attr_reader :proof

    def initialize(params)
      @user = User.find(params[:user_id])
      @images = params[:proof][:images].split(",")
      @version_description = params["version"]["description"]
      @problem = Problem.find(params[:proof][:problem_id])
      content = params[:proof][:content]
      @proof = Proof.find(params[:id])
      @proof.update_attributes(content: content)

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

          # Any user who edits a proof for a problem automatically follows it
          @user.follow @problem if !@user.following? @problem

          # Notify users who have commented on or edited proof
          Notifications::Sender::SendNotifications.new(notification_type: :updated_proof,
                                                     actor: @user,
                                                     resource: @proof).call

        end
      end
    end

    def create_version!
      @version = Version.create!(versioned: @proof, 
                    version_number: Version.next_version_number(@proof), 
                    user_id: @user.id, title: @problem.title, 
                    content: @proof.content, description: @version_description)
    end
  end
end
