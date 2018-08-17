class UsersController < ApplicationController
  before_action :authenticate_user!, only:  [:follow, :unfollow, :vote]
  before_action :correct_user, only: [:edit, :update, :update_image]
  before_action :set_user, only: [:follow, :unfollow, :proofs,
                                     :problem_edits, :problems_following,
                                     :topics_following, :topic_edits, :show, 
                                     :activity, :followers, :following, :edit,
                                     :update_image ]
  after_action :create_activity, only: [:vote]

  def follow
    current_user.follow @user
    # Notify user
    Notification.notify_user(@user, current_user, "started following", @user)
  end

  def unfollow
    current_user.unfollow @user
    #Noticication.find_by(recipient: @user, actor: current_user, 
    #               action: "followed", notifiable: @user).destroy
  end

  def activity
    @activities = @user.activities.order(created_at: :desc)
  end

  def followers
    @users = @user.followers
  end

  def following
    @users = @user.following
  end

  def proofs
    @proofs = @user.proofs.order(created_at: :desc)
  end

  def problem_edits
    @versions = @user.versions.where(topic_id: nil).order(created_at: :desc)
  end

  def problems_following
    @problems = @user.problems_following.order(created_at: :desc)
  end

  def topics_following
    @topics = @user.topics_following.order(created_at: :desc)
  end

  def topic_edits
    @versions = @user.versions.where(problem_id: nil).order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
			# Handle a successful update
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
  end

  def update_image
    if @user.update_attributes(avatar: params[:user][:avatar])
      # Handle a successful update
			flash[:success] = "Profile updated"
			redirect_to @user
    else
      flash.now[:error] = @user.errors.full_messages.first
      render 'show'
    end
  end

  def vote
    @model = params[:votable_type].capitalize.constantize.find(params[:id])
    @action_taken = current_user.vote(params[:vote_type], @model)
        
    respond_to do |format|
      format.js
      format.json
      format.html
    end
  end

  def index
    respond_to do |format|
      format.json {
        data = User.where("username LIKE :name", { name: "#{params[:term]}%" }).map {|t| t.username}
        render json: { suggestions: data, success: true }
      }

      format.html {
        @users = User.feed({user: current_user})
      }

      format.js {
        @users = User.feed({user: current_user, filter: params[:filter], 
                             sorter: params[:sorter], 
                             search_filter: params[:search_filter]})
      }
    end
  end

  def main_search
    respond_to do |format|
			format.json {
				@suggestions = User.search("%#{params[:query]}%")
				render json: {suggestions: @suggestions }
			}
		end
  end 

  private

    def user_params
      params.require(:user).permit( :username, :email, :name, :occupation, 
                                   :location, :education, :bio)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def create_activity
      if @voted
        if @vote_type == "like"
          if @votable_type == "problem"
            Activity.create(user: current_user, action: "liked", 
                      acted_on: @problem, linkable: @problem)
          elsif @votable_type == "proof"
            Activity.create(user: current_user, action: "liked", 
                      acted_on: @proof, linkable: @proof.problem)
          elsif @votable_type == "comment"
            Activity.create(user: current_user, action: "liked", 
                      acted_on: @comment, linkable: @comment.proof.problem)
          end
        else
          Activity.where(user: current_user, action: "liked", acted_on: @model).each do |activity|
            activity.destroy
          end
        end
      end
    end
end
