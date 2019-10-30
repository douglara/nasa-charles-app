require 'rails_helper'

RSpec.describe BasicBotService do
  let(:whatsapp_service) { WhatsappService.new }

  describe '#initialize' do 
    it 'success' do
      expect(whatsapp_service).to be_a WhatsappService
    end
  end

  describe '#send_message' do 
    it 'success' do
      VCR.use_cassette("services/whatsapp/send_message_success") do
        expect(whatsapp_service.send_message("number","teste")[:result]).to be true
      end
    end
  end

end