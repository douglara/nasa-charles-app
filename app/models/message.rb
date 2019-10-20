class Message < ApplicationRecord
  belongs_to :conversation

  before_create :response
  


  def response

    first_message = "Oi. Eu sou o Charles!\n\nMinha missão é ajudar você e sua família a viverem em segurança e o que fazer numa situação de emergência!\n\nVocê pode cadastrar regiões para receber alertas de situações de risco, basta digitar 'Alerta'\n Ou para informar uma situação de risco digite 'Informar'"
    bairro = "Por favor envie o bairro"


    if (!self.from_me)
      puts("Faz o request para o Luis")
      result = LuisService.new.q(self.text)
      puts(result)
      self.intent = result[:body][:topScoringIntent][:intent]

      if (self.conversation.messages.last(2)[0]&.intent == 'ReportIssue')
        print('Gravado com sucesso!')
        self.conversation.update(:status => 'inactive')
        ResponseWorker.perform_in(2.seconds, self.conversation.id, "Incidente gravado com sucesso!")
        return
      end

      if (self.conversation.messages.last(2)[0]&.intent == 'SigninAlert')
        print('Cadastrado regiao com sucesso!')
        self.conversation.update(:status => 'inactive')
        ResponseWorker.perform_in(2.seconds, self.conversation.id, "Alerta gravado com sucesso!")
        return
      end

      if (result[:body][:topScoringIntent][:intent] == 'ReportIssue')
        print('Detalhe sobre o inciente')
        ResponseWorker.perform_in(2.seconds, self.conversation.id, "Por favor detalhe seu alerta e informe o bairro da reigão" )
      end

      if (result[:body][:topScoringIntent][:intent] == 'SigninAlert')
        print('Pede bairro')
        ResponseWorker.perform_in(2.seconds, self.conversation.id, bairro )
      end

      if (result[:body][:topScoringIntent][:intent] == 'None')
        print('Manda primeira mensagem')
        ResponseWorker.perform_in(2.seconds, self.conversation.id, first_message)
      end
    else
      WhatsappService.new.send_message(conversation.user.contact_id, self.text)
    end
  end

end
