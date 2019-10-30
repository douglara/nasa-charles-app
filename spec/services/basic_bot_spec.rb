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


end