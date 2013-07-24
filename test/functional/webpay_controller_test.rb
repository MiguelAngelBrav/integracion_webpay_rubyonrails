require 'test_helper'

class WebpayControllerTest < ActionController::TestCase
  test "the truth" do
    post :check

	response.status.must_equal 200
  end
end
