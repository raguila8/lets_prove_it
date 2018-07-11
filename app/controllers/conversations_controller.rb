class ConversationsController < ApplicationController
  def index
    @conversations = current_user.mailbox.conversations
  end

  def show
    @conversations = current_user.mailbox.conversations
    @conversation = current_user.mailbox.conversations.find(params[:id])
    @conversation.mark_as_read(current_user)
  end

  def new
    @recipients = User.all - [current_user]
  end

  def create
    recipient = User.find_by(username: params[:user])
    if !recipient.nil?
      existing_conversation = current_user.mailbox.conversations_with(recipient)
      if existing_conversation.empty?
        @receipt = current_user.send_message(recipient, params[:body], "Message")
        if !@receipt.nil?
          redirect_to conversation_path(@receipt.conversation)
        end
      else
        @receipt = current_user.reply_to_conversation(existing_conversation[0], params[:body].strip)
        if !@receipt.message.nil?
          redirect_to conversation_path(existing_conversation[0])
        end
      end
    else
      @error_message = "#{params[:user]} is not a valid user."
    end
  end

  def mark_as_read
    @conversation = current_user.mailbox.conversations.find(params[:id])
    if @conversation.is_read?(current_user)
      @conversation.mark_as_unread(current_user)
    else
      @conversation.mark_as_read(current_user)
    end

    respond_to do |format|
      format.js {}
    end
  end

  def mark_all_as_read
    current_user.mailbox.conversations.each do |conversation|
      conversation.mark_as_read(current_user)
    end

    respond_to do |format|
      format.js {}
    end

  end
end
