require 'test_helper'

class Api::V1::BugsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bug = bugs(:one)
  end

  test 'should index bugs' do
    get api_v1_bugs_url, as: :json
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)
    assert json_response.dig(:links, :first) != nil
    assert json_response.dig(:links, :last) != nil
    assert json_response.dig(:links, :prev) != nil
    assert json_response.dig(:links, :next) != nil
  end

  test 'should show bug by id' do
    get api_v1_bug_url(@bug), as: :json
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)
    assert_equal @bug.title, json_response.dig(:data, :attributes, :title)
    assert_equal @bug.user.id.to_s, json_response.dig(:data, :relationships, :user, :data, :id)
    assert_equal @bug.user.email, json_response.dig(:included, 0, :attributes, :email)
  end

  test 'should create bug' do
    assert_difference('Bug.count') do
      post api_v1_bugs_url,
           params: { bug: { title: @bug.title, description: @bug.description, priority: @bug.priority,
                            status: @bug.status, comments: @bug.comments } },
           headers: { Authorization: JsonWebToken.encode(user_id: @bug.user_id) },
           as: :json
    end
    assert_response :created
  end

  test 'should forbid create bug' do
    assert_no_difference('Bug.count') do
      post api_v1_bugs_url,
           params: { bug: { title: @bug.title, description: @bug.description, priority: @bug.priority,
                            status: @bug.status, comments: @bug.comments } },
           as: :json
    end
    assert_response :forbidden
  end

  test 'should update bug' do
    patch api_v1_bug_url(@bug),
          params: { bug: { title: @bug.title, description: @bug.description, priority: @bug.priority,
                           status: @bug.status, comments: @bug.comments } },
          headers: { Authorization: JsonWebToken.encode(user_id: @bug.user_id) },
          as: :json
    assert_response :success
  end

  test 'should forbid update bug' do
    patch api_v1_bug_url(@bug),
          params: { bug: { title: @bug.title, description: @bug.description, priority: @bug.priority,
                           status: @bug.status, comments: @bug.comments } },
          as: :json
    assert_response :forbidden
  end

  test 'should destroy bug' do
    assert_difference('Bug.count', -1) do
      delete api_v1_bug_url(@bug), headers: { Authorization: JsonWebToken.encode(user_id: @bug.user_id) },
                                   as: :json
    end
    assert_response :no_content
  end

  test 'should forbid destroy bug' do
    assert_no_difference('Bug.count') do
      delete api_v1_bug_url(@bug), headers: { Authorization: JsonWebToken.encode(user_id: users(:two).id) },
                                   as: :json
    end
    assert_response :forbidden
  end
end
