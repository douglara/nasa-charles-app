require 'rails_helper'

RSpec.describe BasicBotService do
  let(:basic_bot) { BasicBotService.new(create(:message)) }

  describe '#initialize' do 
    it 'success' do
      expect(basic_bot).to be_a BasicBotService
    end
  end


  describe '#sync_message' do
    context "not from me" do
      it 'invalid zip code' do 
        result = basic_bot.sync_message
        expect(result[:result]).to be true
      end 
      it 'valid zip code' do
        basic_bot = BasicBotService.new(create(:message, text: 'valid_zip'))
        result = basic_bot.sync_message
        expect(result[:result]).to be true
        expect(result[:response]).to  include("cadastrado")
      end 
    end

    context "from me" do
      it 'success' do 
        VCR.use_cassette("services/basic_bot/sync_message_from_me_success") do
          result = BasicBotService.new(create(:message, text: 'teste', from_me: true, user_id: 'teste_number')).sync_message
          expect(result[:result]).to be true
        end
      end  
    end    
  end

  describe '#get_region_by_cep' do
    it 'success' do 
      VCR.use_cassette("services/basic_bot/get_region_by_cep_success") do
        result = basic_bot.get_region_by_cep('81900500')
        puts (result)
        expect(result[:result]).to be true
      end    
    end
    it 'invalid address' do 
      VCR.use_cassette("services/basic_bot/get_region_by_cep_invalid_address") do
        result = basic_bot.get_region_by_cep('1')
        puts (result)
        expect(result[:result]).to be false
      end    
    end
  end

end