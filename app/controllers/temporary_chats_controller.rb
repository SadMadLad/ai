class TemporaryChatsController < ApplicationController
  def show
    @uuid = SecureRandom.uuid
  end

  def create
    @chat = OpenStruct.new(chat_params)

    TemporaryChannel.respond(@chat)
  end

  private
    def chat_params
      @chat_params ||= params.require(:chat).permit(:uuid, :message)
    end
end
