class WhatsappService
  include HTTParty
  base_uri ENV['WHATSAPP_API_ENDPOINT']
  debug_output $stdout

  def send_message(contact_id, text)
    headers = {
      "Content-Type": 'application/json',
      "Authorization": "Bearer #{ENV['WHATSAPP_TOKEN']}"
    }
    body = {
      "to": "#{contact_id}",
      "text": "#{text}"
    }

    result = self.class.post('/messages', body: body.to_json, headers: headers)
    #json = JSON.parse(result.body) if result.body
    return {:result => result.code == 200, :text => text}
  end
end