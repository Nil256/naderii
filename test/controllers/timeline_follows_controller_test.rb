require 'test_helper'

class TimelineFollowsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get timeline_follows_create_url
    assert_response :success
  end

  test "should get destroy" do
    get timeline_follows_destroy_url
    assert_response :success
  end

end
