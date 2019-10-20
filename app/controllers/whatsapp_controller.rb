class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if (params["data"]["isFromMe"] == false  and params["event"] == "message.created" and  params["data"]["text"] )
      puts('Mensagem recebida')
      user = User.find_or_create_by(contact_id: params["data"]["contactId"])
      if (user.messages.where(created_at: 1.minutes.ago..DateTime.now).blank?)
        conversation = Conversation.create(user: user)
        send_message = WhatsappService.new.send_message(params["data"]["contactId"],'Eaii broto')
        message = Message.create(conversation: conversation, text: params["data"]["text"], response: send_message[:text] )
      else


      end
    end
  end
end
