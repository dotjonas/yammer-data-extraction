require 'test_helper'

class YammerControllerTest < ActionController::TestCase
  test "should get auth" do
    get :auth
    assert_response :success
  end

  test "should get success" do
    get :success
    assert_response :success
  end

  test "should get app" do
    get :app
    assert_response :success
  end

end
