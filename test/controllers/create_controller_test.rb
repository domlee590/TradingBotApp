require "test_helper"

class CreateControllerTest < ActionDispatch::IntegrationTest
  test "should get newbot" do
    get create_create_url
    assert_response :success
  end
end
