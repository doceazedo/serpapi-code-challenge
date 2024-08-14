require "test_helper"

class PaintingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get paintings_url
    assert_response :success
  end

  test "should return valid JSON response" do
    get paintings_url
    assert_response :success

    body = JSON.parse(response.body)
    assert body.key?("artworks"), "Response should contain \"artworks\" key"
    assert body["artworks"].is_a?(Array), "Key \"artworks\" should be an array"
  end

  test "artworks should have valid fields" do
    get paintings_url
    assert_response :success

    artworks = JSON.parse(response.body)["artworks"]

    artworks.each do |artwork|
      assert artwork.is_a?(Hash), "Each artwork should be an object"

      assert artwork.key?("name"), "Artwork should have \"name\""
      assert artwork["name"].is_a?(String), "Key \"name\" should be a string"

      assert artwork.key?("extensions"), "Artwork should have \"extensions\""
      assert artwork["extensions"].is_a?(Array), "Key \"extensions\" should be an array"

      assert artwork.key?("link"), "Artwork should have \"link\""
      assert artwork["link"].is_a?(String), "Key \"link\" should be a string"

      assert artwork.key?("image"), "Artwork should have \"image\""
      assert [ NilClass, String ].include?(artwork["image"].class), "Key \"image\" should be a string or null"

      if artwork["image"].is_a?(String)
        assert artwork["image"].start_with?("data:image/"), "Key \"image\" should be a inline base64 image"
      end
    end
  end
end
