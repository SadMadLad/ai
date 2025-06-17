class ChatJob < ApplicationJob
  def perform(chat)
    TemporaryChannel.respond(chat)
  end
end
