class ProblemsController < ApplicationController
  impressionist actions: [:show]
  before_action :set_problem, only: [:show, :edit, :update, :destroy]

  # GET /problems
  # GET /problems.json
  def index
    @problems = Problem.all
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
    respond_to do |format|
      format.js {}
    end
  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(problem_params)
    @problem.user_id = current_user.id
    @new_images = problem_images_params["images"]
    images_array = @new_images.split(",")
    tags = problem_tags_params["tags"]
    tagsArray = tags.split(",")

    respond_to do |format|
        exception = @problem.save_with_topics_and_images(tagsArray, images_array, current_user)[:exception]
      if !exception
        format.html { redirect_to @problem, notice: 'Problem was successfully created.' }
        format.json { render :show, status: :created, location: @problem }
      else
        format.html { 
          flash.now[:failed_problem_create] = exception.message
          render :new 
        }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /problems/1
  # PATCH/PUT /problems/1.json
  def update
    @proof.update_attributes(problem_params)
    tags = problem_tags_params["tags"]
    tagsArray = tags.split(",")

    respond_to do |format|
      exception = @problem.save_with_topics(tagsArray)[:exception]
      if !exception
        @problem.add_new_images(current_user)
        format.html { redirect_to @problem, notice: 'Problem was successfully updated.' }
        format.json { render :show, status: :ok, location: @problem }
      else
        format.html { 
          flash.now[:failed_problem_create] = exception.message
          render :edit 
        }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /problems/1
  # DELETE /problems/1.json
  def destroy
    respond_to do |format|
      format.js {}
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_problem
      @problem = Problem.find(params[:id])
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
end
