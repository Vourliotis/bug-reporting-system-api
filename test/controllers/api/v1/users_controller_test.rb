require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'shoud index users' do
    get api_v1_users_url, as: :json
    assert_response :success
  end

  test 'should show user with id' do
    get api_v1_user_url(@user), as: :json
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)
    assert_equal @user.email, json_response.dig(:data, :attributes, :email)
    assert_equal @user.bugs.first.id.to_s, json_response.dig(:data, :relationships, :bugs, :data, 0, :id)
    assert_equal @user.bugs.first.title, json_response.dig(:included, 0, :attributes, :title)
  end

  test 'should create user' do
    assert_difference('User.count') do
      post api_v1_users_url, params: { user: { email: 'test@test.org', password: '123456' } }, as: :json
    end
    assert_response :created
  end

  test 'should not create user with taken email' do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: @user.email, password: '123456' } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test 'should not create user with invalid email' do
    assert_no_difference('User.count') do
      post api_v1_users_url, params: { user: { email: 'invalid', password: '123456' } }, as: :json
    end
    assert_response :unprocessable_entity
  end

  test 'should update user' do
    patch api_v1_user_url(@user),
          params: { user: { email: @user.email, role: @user.role } },
          headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
          as: :json
    assert_response :success
  end
  test 'should forbid update user' do
    patch api_v1_user_url(@user),
          params: { user: { email: @user.email, role: @user.role } },
          as: :json
    assert_response :forbidden
  end

  test 'should not update user with invalid params' do
    patch api_v1_user_url(@user), params: { user: { email: 'invalid' } }, as: :json
    assert_response :forbidden
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete api_v1_user_url(@user),
             headers: { Authorization: JsonWebToken.encode(user_id: @user.id) },
             as: :json
    end
    assert_response :no_content
  end

  test 'should forbid destroy user' do
    assert_no_difference('User.count') do
      delete api_v1_user_url(@user), as: :json
    end
    assert_response :forbidden
  end
end
