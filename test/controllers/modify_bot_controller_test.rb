require "test_helper"

class ModifyBotControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get modify_bot_new_url
    assert_response :success
  end

  test "should get edit" do
    get modify_bot_edit_url
    assert_response :success
  end
end
