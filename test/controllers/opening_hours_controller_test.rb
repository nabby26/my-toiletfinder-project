require 'test_helper'

class OpeningHoursControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get opening_hours_new_url
    assert_response :success
  end

end
