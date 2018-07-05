class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :problems, :users, :logs, :follow, :unfollow]

  def follow
    current_user.follow @topic
  end

  def unfollow
    current_user.unfollow @topic
  end
  
  def logs

  end

  # GET /topics
  # GET /topics.json
  def index
    respond_to do |format|
      format.html {

      }

      format.json { 
        data = Topic.where("name LIKE :name", { name: "#{params[:term]}%" }).map {|t| t.name}
        render json: { suggestions: data, success: true }
      }
    end
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  end

  # GET /topics/new
  def new
    @topic = Topic.new
    @new_images = ""
  end

  # GET /topics/1/edit
  def edit
    @new_images = ""
  end

  def problems
    @problems = @topic.feed
  end

  def users
    
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)
    @new_images = topic_images_params["images"]
    images_array = @new_images.split(",")
    @exception = @topic.save_new(images_array, current_user)[:exception]

    respond_to do |format|
      if !@exception
        format.html { redirect_to @topic, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    @topic.update_attributes(topic_params)
    @new_images = topic_images_params["images"]
    images_array = @new_images.split(",")
    version_description = params["version"]["description"]

    @exception = @topic.save_edit(images_array, version_description, current_user)[:exception]

    respond_to do |format|
      if !@exception
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name, :description)
    end

    def topic_images_params
      params.require(:topic).permit(:images)
    end

end
