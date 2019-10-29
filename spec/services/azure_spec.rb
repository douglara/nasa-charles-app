require 'rails_helper'

RSpec.describe AzureService do

  let(:azure_service) { AzureService.new }

  
  describe "#env_variables" do 
  
    it "AZURE_TOKEN" do 
        expect(ENV["AZURE_TOKEN"].blank?).to be false
    end

  end


  describe '#initialize' do 
    it 'success' do
      expect(azure_service).to be_a AzureService
    end
  end


  describe "#create_token" do 
    it "success" do
      VCR.use_cassette("services/azure/create_token_success") do
        result = azure_service.create_token()
        expect(result[:result]).to be true
        expect(result[:body][:conversationId].blank?).to be false
        expect(result[:body][:token].blank?).to be false
      end
    end

    it "failure" do
      VCR.use_cassette("services/azure/create_token_failure") do
        ENV["AZURE_TOKEN"] = "failure"
        expect(azure_service.create_token()[:result]).to be false
      end
    end
  end

  describe '#create_conversation' do
    it 'success' do 
      VCR.use_cassette("services/azure/create_conversation_success") do
        result = azure_service.create_conversation("valid_token")
        expect(result[:result]).to be true
      end    
    end

    it 'failure' do 
      VCR.use_cassette("services/azure/create_conversation_failure") do
        result = azure_service.create_conversation("invalid_token")
        expect(result[:result]).to be false
      end 
    end
  end

  describe '#send_message' do
    it 'success' do 
      VCR.use_cassette("services/azure/send_message_success") do
        result = azure_service.send_message("valid_conversation", "conversation_valid_token", "Test", "user1")
        expect(result[:result]).to be true
      end    
    end

    it 'failure' do 
      VCR.use_cassette("services/azure/send_message_failure") do
        result = azure_service.send_message("invalid_conversation", "invalid_token", "Test", "user1")
        expect(result[:result]).to be false
      end 
    end
  end


end