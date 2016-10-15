require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'tester@test.com', password:'123123')
    @user2 = User.create(email: 'tester2@test.com', password:'123123')
  end

  test 'full name should return Anonymous when no names assigned' do
    full = @user.full_name
    assert_equal("Anonymous", full)
  end

  test 'full name should return first + last when names are assigned' do
    full = @user2.full_name
    assert_equal("Bryan Kahler", full)
  end
end
