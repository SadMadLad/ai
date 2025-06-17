class ChatJob < ApplicationJob
  def perform(chat)
    TemporaryChatChannel.respond(chat)
  end
end
