require "test_helper"

class TradersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get traders_index_url
    assert_response :success
  end

  test "should get show" do
    get traders_show_url
    assert_response :success
  end

  test "should get new" do
    get traders_new_url
    assert_response :success
  end

  test "should get edit" do
    get traders_edit_url
    assert_response :success
  end

  test "should get create" do
    get traders_create_url
    assert_response :success
  end

  test "should get update" do
    get traders_update_url
    assert_response :success
  end

  test "should get destroy" do
    get traders_destroy_url
    assert_response :success
  end
end
