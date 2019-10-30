class WhatsappController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    if (params["message"]["type"] == 'chat' )
      Message.create(user_id:params["message"]["from"].split("@")[0], text: params["message"]["body"], from_me: false)
    end
  end
end
