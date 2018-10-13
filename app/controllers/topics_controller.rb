class TopicsController < ApplicationController
  before_action :set_topic, :active_topic, only: [:show, :edit, :update, :destroy, :problems, 
                                   :followers, :follow, :unfollow, 
                                   :log, :proofs, :description]

  def follow
    current_user.follow @topic
  end

  def unfollow
    current_user.unfollow @topic
  end

  # GET /topics
  # GET /topics.json
  def index
    respond_to do |format|
      format.html {
        @topics = Topic.feed
      }

      format.json { 
        data = Topic.where("name LIKE :name", { name: "#{params[:term]}%" }).active.map {|t| t.name}
        render json: { suggestions: data, success: true }
      }

      format.js {
        @topics = Topic.feed({sorter: params[:sorter], search_filter: params[:search_filter]})
      }
    end
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
    @problems = @topic.problems.order(created_at: :desc)
  end

  def followers
    @followers = @topic.followers.order(created_at: :desc)
  end

  def log
    @versions = @topic.versions.order(created_at: :desc)
  end

  def proofs
    @proofs = @topic.proofs.order(created_at: :desc)
  end

  def description
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
        #Notify followers when you create a topic
        Notifications::Sender::SendNotifications.new(notification_type: :new_topic,
                                                     actor: current_user,
                                                     resource: @topic).call

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

        Notifications::Sender::SendNotifications.new(notification_type: :updated_topic,
                                                     actor: current_user,
                                                     resource: @topic).call

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
      if params[:id].is_integer?
        @topic = Topic.find(params[:id])
      else
        @topic = Topic.find_by(name: params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name, :description)
    end

    def topic_images_params
      params.require(:topic).permit(:images)
    end

    # Confirms topic was not soft deleted
    def active_topic
      if Topic.find(params[:id]).soft_deleted?
        flash[:alert] = "Action not authorized"
        redirect_to root_url
      end
    end
end
