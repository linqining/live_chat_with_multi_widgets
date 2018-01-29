class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    Rails.logger.info "== params: #{params.inspect}"
    Rails.logger.info "== params[:message][:state]: #{params[:message][:state]}"
    Rails.logger.info "== message_params: #{message_params.inspect}"
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    if params[:message][:state].present? && params[:message][:state] == 'user_typing'
      Rails.logger.info "== @user_typing = true"
      @user_typing = true
    else
      Rails.logger.info "== @user_typing = false"
      @user_typing = false
      @message.save!
    end
    @path = conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end