class MessagesController < ApplicationController
  before_action :set_conversation
  
  def create
    
    @receipt = current_user.reply_to_conversation(@conversation, params[:body].strip)
    #redirect_to conversation_path(receipt.conversation)

    respond_to do |format|
      format.js {}
    end
  end
  private

    def set_conversation
      @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
    end
end
