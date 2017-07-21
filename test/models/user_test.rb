require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save user without first 1" do
    sleep 2
    user = User.new
    assert_not user.save, "Saved the user without a first name"
  end

  test "should not save user without first 2" do
    sleep 2
    user = User.new
    assert_not user.save, "Saved the user without a first name"
  end

  test "should not save user without first 3" do
    sleep 2
    user = User.new
    assert_not user.save, "Saved the user without a first name"
  end

  test "should not save user without first 4" do
    sleep 2
    user = User.new
    assert_not user.save, "Saved the user without a first name"
  end

  test "should not save user without first 5" do
    sleep 2
    user = User.new
    assert_not user.save, "Saved the user without a first name"
  end

  test "Create user with id 1 1" do
    User.create(id: 1, first: 'First', last: 'Last')
  end

  test "Create user with id 1 2" do
    User.create(id: 1, first: 'First', last: 'Last')
  end
end
