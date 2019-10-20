class ResponseWorker
  include Sidekiq::Worker

  def perform(conversation_id,text)
    conversation = Conversation.find(conversation_id)
    Message.create(conversation: conversation, text: text, from_me: true)
  end
end
