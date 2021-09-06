require 'test_helper'

class BugTest < ActiveSupport::TestCase
  test 'bug with invalid priority should be invalid' do
    bug = bugs(:one)
    assert_raises ArgumentError do
      bug.priority = -1
    end
  end

  test 'bug with valid priority should be valid' do
    bug = bugs(:one)
    bug.priority = 1
    assert bug.valid?
  end

  test 'bug with invalid status should be invalid' do
    bug = bugs(:one)
    assert_raises ArgumentError do
      bug.status = -1
    end
  end

  test 'bug with valid status should be valid' do
    bug = bugs(:one)
    bug.status = 1
    assert bug.valid?
  end
end
