require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should prompt for login" do
    get login_url 
    assert_response :success
  end

  test "create with a valid name and password should login and redirect to admin page" do
    post login_url(params: { name: @user.name, password: 'secret' })

    assert_redirected_to admin_url
    assert_equal @user.id, session[:user_id]
  end

  test "create with an invalid name and password should not login and redirect to login page" do
    post login_url(params: { name: "not a user", password: "not a password" })

    assert_redirected_to login_url
    assert_nil session[:user_id]
  end

  test "create with a valid name and invalid password should not login and redirect to login page" do
    post login_url(params: { name: @user.name, password: "not a password" })

    assert_redirected_to login_url
    assert_nil session[:user_id]
  end

  test "should logout" do
    delete logout_url

    assert_redirected_to store_index_url
    assert_nil session[:user_id]
  end

end
