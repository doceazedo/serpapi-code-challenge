require "test_helper"

class PaintingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get paintings_index_url
    assert_response :success
  end
end
