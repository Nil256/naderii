require 'test_helper'

class PetsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get pets_create_url
    assert_response :success
  end

  test "should get destroy" do
    get pets_destroy_url
    assert_response :success
  end

end
