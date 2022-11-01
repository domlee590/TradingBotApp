require "test_helper"

class BotsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get bots_new_url
    assert_response :success
  end

  test "should get create" do
    get bots_create_url
    assert_response :success
  end

  test "should get edit" do
    get bots_edit_url
    assert_response :success
  end

  test "should get update" do
    get bots_update_url
    assert_response :success
  end

  test "should get destroy" do
    get bots_destroy_url
    assert_response :success
  end

  test "should get show" do
    get bots_show_url
    assert_response :success
  end
end
