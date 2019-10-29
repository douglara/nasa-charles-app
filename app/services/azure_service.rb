class AzureService
  include HTTParty
  base_uri "https://directline.botframework.com/v3/directline"
  debug_output $stdout
  headers "Content-Type": "application/json; charset=utf-8"

  def send_message(message)

    # Generate Token
    token = create_token()
    
    # Create Conversation
    conversation = create_conversation(token[:token])

    # Send Message
    message = send_message(conversation)

    # Get response
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