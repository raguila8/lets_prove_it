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

  def create
    @interactor = ProofPersistence::ProofCreationInteractor.call(self.params.merge(user_id: current_user.id))

    if @interactor.success?
      redirect_to @interactor.proof.problem, notice: 'Proof was successfully created.' 
    end
  end

  def update
    @interactor = ProofPersistence::ProofUpdateInteractor.call(self.params.merge(user_id: current_user.id))

    if @interactor.success?
      redirect_to @interactor.proof, notice: 'Proof was successfully updated.' 
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

  def comments
    
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
