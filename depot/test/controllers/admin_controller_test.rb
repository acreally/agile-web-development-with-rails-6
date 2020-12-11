require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get admin page" do
    get admin_url
    assert_response :success
  end

end
