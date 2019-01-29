require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first
    sign_in users(:one)
  end

  test 'should get index' do
    get admin_users_url
    assert_response :success
  end

  test 'should get show' do
    get admin_user_url @user
    assert_response :success
  end

  test 'should get new' do
    get new_admin_user_url
    assert_response :success
  end

  test 'should post create success' do
    assert_difference 'User.count' do
      post admin_users_url params: { user: { full_name: 'Test User', email: 'test@example.com' } }
    end
    assert_redirected_to admin_user_url User.last
  end

  test 'should post create fail' do
    assert_no_difference 'User.count' do
      post admin_users_url params: { user: { full_name: 'Test User' } }
    end
    assert_response :success
  end
end
