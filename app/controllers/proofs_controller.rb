class ProofsController < ApplicationController
  before_action :set_proof, only: [:show, :edit, :cancel_edit, :cancel_new, 
                                   :update, :destroy, :log]

  # GET /proofs
  # GET /proofs.json
  def index
    @proofs = Proof.all
  end

  # GET /proofs/1
  # GET /proofs/1.json
  def show
  end

  def log
  end

  # GET /proofs/new
  def new
    @proof = Proof.new
  end

  # GET /proofs/1/edit
  def edit
    @new_images = ""
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def cancel_edit
    respond_to do |format|
      format.js {}
    end
  end

  def cancel_new
    respond_to do |format|
      format.js {}
    end
  end

  # POST /proofs
  # POST /proofs.json
  def create
    @proof = Proof.new(proof_params)
    @problem = Problem.find(@proof.problem_id)
    #@proof.problem_id = @problem.id
    @proof.user_id = current_user.id
    @new_images = proof_images_params["images"]
    images_array = @new_images.split(",")


    respond_to do |format|
      exception = @proof.save_new(images_array, current_user)[:exception]
      if !exception
        #Any user who proofs a problem automatically follows it
        if !current_user.following? @problem
          current_user.follow @problem
        end

        # Create notifications for users following the problem
        (@problem.followers - [current_user]).each do |follower|
          Notification.notify_user(follower, current_user, "wrote a proof for", @proof.problem)
        end

        format.html { redirect_to @problem, notice: 'Proof was successfully created.' }
        format.json { render :show, status: :created, location: @proof }
      else
        format.html {
          flash.now[:failed_proof_create] = exception.message
          render :template => "problems/show", locale: { id: @problem.id } 
        }

        format.json { render json: @proof.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proofs/1
  # PATCH/PUT /proofs/1.json
  def update
    @proof.update_attributes(proof_params)
    @new_images = proof_images_params["images"]
    images_array = @new_images.split(",")
    version_description = params["version"]["description"]

    #@problem = Problem.find(@proof.problem_id)

    respond_to do |format|
      @exception = @proof.save_edit(images_array, current_user, version_description)[:exception]
      if !@exception
        # Notify users that follow the problem
        (@proof.problem.followers - [current_user]).each do |follower|
          Notification.notify_user(follower, current_user, "edited a proof for", @proof.problem)
        end
        format.html { redirect_to @proof.problem, notice: 'Proof was successfully updated.' }

      else
        format.html { render :edit }
      end
      format.js {}
    end
  end

  # DELETE /proofs/1
  # DELETE /proofs/1.json
  def destroy
    @problem = @proof.problem
    @proof.destroy
    respond_to do |format|
      format.html { 
        flash[:notice] = "Proof was successfully destroyed."
        redirect_to @problem
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proof
      @proof = Proof.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proof_params
      params.require(:proof).permit(:content, :problem_id)
    end

    def proof_images_params
      params.require(:proof).permit(:images)
    end

end
