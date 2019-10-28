class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if (params["data"]["isFromMe"] == false  and params["event"] == "message.created" and  params["data"]["text"] )
      Message.find_or_create_by(message_id:params["data"]["id"]) do | message |
        message.user_id = params["data"]["fromId"]
        message.text = params["data"]["text"]
        message.from_me = false 
      end
    end
  end
end
