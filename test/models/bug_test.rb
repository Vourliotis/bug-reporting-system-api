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
  
  test 'should filter bugs by title' do
    assert_equal 1, Bug.filter_by_title('simple').count
  end
  
  test 'should filter bugs by priority' do
    assert_equal [bugs(:another_bug)], Bug.equal_to_priority(0)
  end
  
  test 'should filter bugs by status' do
    assert_equal [bugs(:two)], Bug.equal_to_status(0)
  end
  
  test 'should filter bugs by reporter' do
    assert_equal [bugs(:one)], Bug.equal_to_reporter(3)
  end
  
  test 'should sort bugs by title ascending' do
    assert_equal [bugs(:one), bugs(:two), bugs(:another_bug)], Bug.sorted('title', 'asc').to_a
  end
  
  test 'should sort bugs by title descending' do
    assert_equal [bugs(:another_bug), bugs(:two), bugs(:one)], Bug.sorted('title', 'desc').to_a
  end
end
