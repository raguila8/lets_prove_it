class ImagesController < ApplicationController
  before_action :set_image, only: [:destroy]

  def destroy
    @image.destroy if @image.belongs_to_a_model?
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def create
    @image = Image.new(image_params)
    @image.user_id = current_user.id 
   
    respond_to do |format|
      if @image.save
        format.json { render :show, status: :created, location: @image }
      else
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:image_data)
    end
end
