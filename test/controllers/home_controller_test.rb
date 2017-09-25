require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get root_path
    assert_response :success
  end

   test "should get help" do
    get help_path
    assert_response :success
  end

end
