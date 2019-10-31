require 'rails_helper'

RSpec.describe BasicBotService do
  let(:basic_bot) { BasicBotService.new(create(:message)) }

  describe '#initialize' do 
    it 'success' do
      VCR.use_cassette("services/basic_bot/initialize_success") do
        expect(basic_bot).to be_a BasicBotService
      end
    end
  end


  describe '#sync_message' do
    context "not from me" do
      it 'invalid_cep' do
        VCR.use_cassette("services/basic_bot/sync_message_not_from_me_invalid") do
          result = basic_bot.sync_message
          expect(result[:result]).to be true
        end
      end 
      it 'valid_cep' do
        VCR.use_cassette("services/basic_bot/sync_message_not_from_me_valid_cep") do
          basic_bot = BasicBotService.new(create(:message, text: '81900500'))
          result = basic_bot.sync_message
          expect(result[:result]).to be true and change { Subscription.count }.by(1)
          expect(result[:response]).to include("cadastrado")
        end
      end 
    end

    context "from me" do
      it 'success' do 
        VCR.use_cassette("services/basic_bot/sync_message_from_me_success") do
          result = BasicBotService.new(create(:message, text: 'teste', from_me: true, user_id: 'valid_number')).sync_message
          expect(result[:result]).to be true
        end
      end  
    end    
  end

  describe '#get_region_by_cep' do
    it 'success' do 
      VCR.use_cassette("services/basic_bot/get_region_by_cep_success") do
        result = basic_bot.get_region_by_cep('81900500')
        expect(result[:result]).to be true
      end    
    end
    it 'invalid address' do 
      VCR.use_cassette("services/basic_bot/get_region_by_cep_invalid_address") do
        result = basic_bot.get_region_by_cep('1')
        expect(result[:result]).to be false
      end    
    end
    it 'blank_address' do 
      VCR.use_cassette("services/basic_bot/get_region_by_cep_invalid_address") do
        result = basic_bot.get_region_by_cep('')
        expect(result[:result]).to be false
      end    
    end
  end

  describe '#signup_subscription' do
    it 'success' do
      VCR.use_cassette("services/basic_bot/signup_subscription_success") do
        message = create(:message_valid_cep)
        result = BasicBotService.new(message).signup_subscription(message.user_id, 'Region' ,message.text )
        expect(result[:result]).to be true and change { Subscription.count }.by(1)
      end
    end
    it 'failure' do
      VCR.use_cassette("services/basic_bot/signup_subscription_failure") do
        message = create(:message_invalid_cep)
        result = BasicBotService.new(message).signup_subscription(message.user_id, '' ,message.text )
        expect(result[:result]).to be false and change { Subscription.count }.by(0)
      end
    end
  end

end