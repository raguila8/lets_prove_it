class ProblemsController < ApplicationController
  impressionist actions: [:show]
  before_action :active_problem, :set_problem, only: [:show, :edit, :update, :destroy, :log,
                                     :bookmark, :unbookmark, :followers, :comments]
  before_action :logged_in_user, only: [:edit, :update, :feed, :destroy, :follow, :unfollow]
  before_action :correct_reputation, only: [:edit, :update]

  def bookmark
    current_user.bookmark @problem
  end

  def unbookmark
    current_user.unbookmark @problem
  end

  def followers
  end

  def log
   
  end

  # GET /problems
  # GET /problems.json
  def index
    respond_to do |format|
      format.html {
        @problems = Problem.feed
      }

      format.js {
        @problems = Problem.feed({ filter: params[:filter], 
                                  sorter: params[:sorter],
                                  search_filter: params[:search_filter] })
      }
    end
  end

  def feed
    respond_to do |format|
      format.html {
        @problems = Problem.feed({ user: current_user })
      }

      format.js {
        @problems = Problem.feed({ user: current_user, 
                                  filter: params[:filter], 
                                  sorter: params[:sorter] })
      }
    end
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
    @proof = Proof.new
    @new_images = ""
  end

  # GET /problems/new
  def new
    @problem = Problem.new
    @new_images = ""
  end

  # GET /problems/1/edit
  def edit
    @new_images = ""
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # POST /problems
  # POST /problems.json
  def create
    @interactor = ProblemPersistence::ProblemCreationInteractor.call(self.params.merge(user_id: current_user.id))

    if @interactor.success?
      redirect_to @interactor.problem, notice: 'Problem was successfully created.' 
    else
      
      #flash[:error] = interactor.error
      #render :new
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    @interactor = ProblemPersistence::ProblemUpdateInteractor.call(self.params.merge(user_id: current_user.id))

    if @interactor.success?
      redirect_to @problem, notice: 'Problem was successfully updated.' 
    end

    #@problem.update_attributes(problem_params)
    #@new_images = problem_images_params["images"]
    #@new_images = "" if !@new_images
    #images_array = @new_images.split(",")
    #tags = problem_tags_params["tags"]
    #tagsArray = tags.split(",")
    #version_description = params["version"]["description"]

    #respond_to do |format|
      #@exception = @problem.save_edit(tagsArray, images_array, version_description, current_user)[:exception]
      #if !@exception
        #User who edits a problem automatically follows it
       # if !current_user.following? @problem
        #  current_user.follow @problem
       # end

        # Notify problem followers
        #Notifications::Sender::SendNotifications.new(notification_type: :updated_problem,
         #                                            actor: current_user,
          #                                           resource: @problem).call
=begin
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { 
          flash.now[:failed_problem_create] = @exception.message
          render :edit 
        }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
      format.js { @problem.reload }
=end
    #end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    respond_to do |format|
      format.js {}
    end  
  end

  def comments
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
    end

    def correct_reputation
      if current_user.reputation < 2000 and @problem.user != current_user
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end
 
    def correct_problem
      if @problem.user != current_user
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def problem_params
      params.require(:problem).permit(:title, :content)
    end

    def problem_tags_params
      params.require(:problem).permit(:tags)
    end

    def problem_images_params
      params.require(:problem).permit(:images)
    end

    # Confirms problem was not soft deleted
    def active_problem
      if Problem.find(params[:id]).soft_deleted?
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end
end
