require 'test_helper'

class ToiletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @toilet = toilets(:one)
  end

  test "should get index" do
    get toilets_url
    assert_response :success
  end

  test "should get new" do
    get new_toilet_url
    assert_response :success
  end

  test "should create toilet" do
    assert_difference('Toilet.count') do
      post toilets_url, params: { toilet: { description: @toilet.description, disabled_opt: @toilet.disabled_opt, gender_neutral: @toilet.gender_neutral, location: @toilet.location, parentsRoom: @toilet.parentsRoom, title: @toilet.title } }
    end

    assert_redirected_to toilet_url(Toilet.last)
  end

  test "should show toilet" do
    get toilet_url(@toilet)
    assert_response :success
  end

  test "should get edit" do
    get edit_toilet_url(@toilet)
    assert_response :success
  end

  test "should update toilet" do
    patch toilet_url(@toilet), params: { toilet: { description: @toilet.description, disabled_opt: @toilet.disabled_opt, gender_neutral: @toilet.gender_neutral, location: @toilet.location, parentsRoom: @toilet.parentsRoom, title: @toilet.title } }
    assert_redirected_to toilet_url(@toilet)
  end

  test "should destroy toilet" do
    assert_difference('Toilet.count', -1) do
      delete toilet_url(@toilet)
    end

    assert_redirected_to toilets_url
  end
end
