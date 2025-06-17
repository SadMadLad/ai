class TemporaryChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chats_#{params[:uuid]}"
  end

  def unsubscribed
  end

  class << self
    def respond(chat)
      OllamaClient.new.complete(prompt: chat.message) do |response_chunk|
        ActionCable.server.broadcast(
          "chats_#{chat.uuid}",
          {
            message: response_chunk.completion,
            done: response_chunk.raw_response["done"]
          }
        )
      end
    end
  end
end
