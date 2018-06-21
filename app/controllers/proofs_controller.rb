class ProofsController < ApplicationController
  before_action :set_proof, only: [:show, :edit, :cancel_edit, :update, :destroy]

  # GET /proofs
  # GET /proofs.json
  def index
    @proofs = Proof.all
  end

  # GET /proofs/1
  # GET /proofs/1.json
  def show
  end

  # GET /proofs/new
  def new
    @proof = Proof.new
  end

  # GET /proofs/1/edit
  def edit
    respond_to do |format|
      format.js {}
    end
  end

  def cancel_edit
    respond_to do |format|
      format.js {}
    end
  end

  # POST /proofs
  # POST /proofs.json
  def create
    @proof = Proof.new(proof_params)
    @problem = Problem.find(@proof.problem_id)
    @proof.problem_id = @problem.id
    @proof.user_id = current_user.id

    respond_to do |format|
      if @proof.save
        @proof.add_new_images(current_user)
        format.html { redirect_to @problem, notice: 'Proof was successfully created.' }
        format.json { render :show, status: :created, location: @proof }
      else
        format.html {  render :template => "problems/show", locale: {id: @problem.id} }
        format.json { render json: @proof.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proofs/1
  # PATCH/PUT /proofs/1.json
  def update
    @proof.update_attributes(proof_params)
    @problem = Problem.find(@proof.problem_id)

    respond_to do |format|
      if @proof.save 
        @proof.add_new_images(current_user)
        format.js {}
      else
        format.js {}
      end
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
end
