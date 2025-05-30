require "test_helper"

class MlModelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ml_models_index_url
    assert_response :success
  end

  test "should get show" do
    get ml_models_show_url
    assert_response :success
  end
end
