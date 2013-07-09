require 'test_helper'

describe WebpayControllerTest do
  it "check_mac" do
    post :check

    response.status.must_equal 200
  end
end
