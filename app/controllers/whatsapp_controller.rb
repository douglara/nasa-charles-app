class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if (params["data"]["isFromMe"] == false  and params["event"] == "message.created" and  params["data"]["text"] )
      user = User.find_or_create_by(contact_id: params["data"]["contactId"])
      messages = user.messages.where(created_at: 1.minutes.ago..DateTime.now)
      if (messages.last.conversation.status == 'inactive')
        conversation = Conversation.create(user: user)
      else
        conversation = Conversation.where(user: user).last()
      end
      message = Message.create(conversation: conversation, from_me: false, text: params["data"]["text"])
    end
  end
end
