class BasicBotService

  def initialize(message)
    @message = message
  end

  def sync_message
    if (!@message.text.blank?)
      if (!@message.from_me)
        if (@message.text.count("a-zA-Z") > 0)
          return return_default_message
        else
          # Checa CEP
          region = get_region_by_cep(@message.text)
          if (region[:result] == true and signup_subscription(@message.user_phone, region[:region], @message.text))
            response = "Alerta no bairro #{region[:region]} cadastrado com sucesso!"
            Message.create(from_me: true, text: response , user_id: @message.user_id)
            @message.update(sync: true)
            return {result: true, response: response }
          else
            return return_default_message  
          end
        end
      else
        whatsapp_result = WhatsappService.new.send_message(@message.user_id, @message.text)
        @message.update(sync: true) if whatsapp_result[:result]
        return whatsapp_result
      end
    end
    return {result: false}
  end

  def return_default_message
    default_text = "Oi. Eu sou o Charles!\n\n\nMinha missão é ajudar você e sua família a viverem em segurança e saber o que fazer numa situação de emergência!😉✅\n\n\nEstou aprendendo a conversar mas enquanto isso você pode cadastrar regiões para receber alertas de situações de risco, basta digitar o CEP."
    Message.create(from_me: true, text: default_text, user_id: @message.user_id)
    @message.update(sync: true)
    return {result: true, response: default_text}
  end

  def get_region_by_cep(cep)
    query = { 'address': cep, 'key': ENV['GOOGLE_MAPS_KEY'] }
    result = HTTParty.get('https://maps.googleapis.com/maps/api/geocode/json', query: query)
    body_result = JSON.parse(result.body,:symbolize_names => true)
    region = ''
    body_result[:results][0][:address_components].each do | address_component |
      address_component[:types].each do | type |
        if (type == 'sublocality')
          region = address_component[:long_name]
          return {result: true, region: region}
        end
      end
    end
    return {result: false, region: region}
  end

  def signup_subscription(user_phone, region, region_cep)
    subscription = Subscription.find_or_create_by(user_phone: user_phone, region: region) do | subscription |
      subscription.region_cep = region_cep
    end
    if subscription.save
      return {result: true, subscription: subscription}
    else
      return {result: false, subscription: nil}
    end
  end

  

end