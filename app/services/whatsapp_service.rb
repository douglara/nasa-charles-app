class WhatsappService
  include HTTParty
  base_uri ENV['WHATSAPP_API_ENDPOINT']
  debug_output $stdout

  def send_message(contact_id, text)
    sender_id = "575be6fb-ab51-47db-9c85-9982bf47b4e1"
    headers = {
      "Content-Type": 'application/x-www-form-urlencoded',
      "Authorization": "Bearer #{ENV['WHATSAPP_TOKEN']}"
    }
    number = JSON.parse(self.class.get("/contacts/#{contact_id}", headers: headers).body,:symbolize_names => true) 
    puts('Resultado')
    puts(number[:data][:number].inspect)
    
    body = {
      "number": "#{number[:data][:number]}",
      "serviceId": sender_id,
      "text": "#{text}"
    }

    result = self.class.post('/messages', body: body, headers: headers)
    json = JSON.parse(result.body) if result.body
    return {:result => result.code == 200, :text => text}
  end
end