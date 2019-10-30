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
          response = "Alerta cadastrado com sucesso!"
          Message.create(from_me: true, text: response , user_id: @message.user_id)
          @message.update(sync: true)
          return {result: true, response: response }
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

  def check_cep
  end

  def signup_notification
  end

  

end