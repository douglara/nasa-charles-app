class AzureService
  include HTTParty
  base_uri "https://directline.botframework.com/v3/directline"
  debug_output $stdout
  headers "Content-Type": "application/json; charset=utf-8"

  def sync_message(message)
    if (message.from_me)
      whatsapp_result = WhatsappService.new.send_message(message.user_id,message.text)
      message.update(sync: true) if whatsapp[:result]
      return whatsapp_result
    else
      # Generate Token
      token = create_token()
      
      # Create Conversation
      conversation = create_conversation(token[:body][:token])

      # Send Message
      message_result = send_message(conversation[:body][:conversationId], conversation[:body][:token], message.text, message.user_id )

      # Get response
      sleep(1)
      response = get_response(conversation[:body][:token], conversation[:body][:conversationId], message_result[:body][:id])
      while response[:result] == false do
        response = get_response(conversation[:body][:token], conversation[:body][:conversationId], message_result[:body][:id])
      end
      response
      save_respone = Message.create(from_me: true, text: response[:body][:activities].last()[:text], token: conversation[:body][:token], conversation_id: conversation[:body][:conversationId], user_id: message.user_id, message_id: response[:body][:id] )

      message.update(sync: true, conversation_id: conversation[:body][:conversationId], message_id: message_result[:body][:id], token: conversation[:body][:token] )
      return {:result => true}
    end
  end

  def get_response(token, conversation_id, message_id)
    headers = {
      "Authorization": "Bearer #{token}"
    }
    result = self.class.get("/conversations/#{conversation_id}/activities?replyToId#{message_id}", headers: headers)
    body_result = JSON.parse(result.body,:symbolize_names => true)
    return {:result => false, :body => body_result} if (result.code != 200 or body_result[:activities].count == 1)
    return {:result => result.code == 200, :body => body_result}
  end

  def create_token
    headers = {
      "Authorization": "Bearer #{ENV['AZURE_TOKEN']}"
    }

    result = self.class.post("/tokens/generate", headers: headers)
    return {:result => result.code == 200, :body => JSON.parse(result.body,:symbolize_names => true)}    
  end
  
  def create_conversation(token)
    headers = {
      "Authorization": "Bearer #{token}"
    }

    result = self.class.post("/conversations", headers: headers)
    return {:result => if [200, 201].include?(result.code) then true else false end, :body => JSON.parse(result.body,:symbolize_names => true)}    
  end

  def send_message(conversation_id, token, text, user_id)
    headers = {
      "Authorization": "Bearer #{token}",
      #"Content-Type": "application/json; charset=utf-8"
    }

    body = {
      "type": "message",
      "from": {
          "id": "#{user_id}"
      },
      "text": "#{text}"
    }.to_json

    result = self.class.post("/conversations/#{conversation_id}/activities", headers: headers, body: body)
    return {:result => result.code == 200, :body => JSON.parse(result.body,:symbolize_names => true)}    
  end

end