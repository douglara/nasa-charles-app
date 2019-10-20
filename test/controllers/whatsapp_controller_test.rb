require 'test_helper'

class WhatsappControllerTest < ActionDispatch::IntegrationTest
  test "should get webhook" do
    get whatsapp_webhook_url
    assert_response :success
  end

end
