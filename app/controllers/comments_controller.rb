class CommentsController < ApplicationController
  def create
    
  end

  def edit
  end

  def update
  end

  private

    def comment_params
      params.require(:problem).permit(:content)
    end

end
