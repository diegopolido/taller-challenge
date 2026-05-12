require "test_helper"

class BorrowControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get borrow_create_url
    assert_response :success
  end

  test "should get return" do
    get borrow_return_url
    assert_response :success
  end
end
