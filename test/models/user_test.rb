require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user with valid email should be valid' do
    user = User.new(email: 'valid@email.com', password_digest: 'password')
    assert user.valid?
  end

  test 'user with invalid email should be invalid' do
    user = User.new(email: 'invalid', password_digest: 'password')
    assert_not user.valid?
  end

  test 'user with duplicate email should be invalid' do
    other_user = users(:one)
    user = User.new(email: other_user.email, password_digest: 'password')
    assert_not user.valid?
  end

  test 'destroy user should destroy linked bug' do
    assert_difference('Bug.count', -1) do
      users(:one).destroy
    end
  end

  test 'user with invalid role should be invalid' do
    user = users(:one)
    assert_raises ArgumentError do
      user.role = -1
    end
  end

  test 'user with valid role should be valid' do
    user = users(:one)
    user.role = 1
    assert user.valid?
  end
  
  test 'should filer users by role' do
    assert_equal [users(:one)], User.equal_to_role(3)
  end
end
