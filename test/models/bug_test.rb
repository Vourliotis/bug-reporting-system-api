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

  test 'should filter bugs by status' do
    assert_equal [bugs(:two)], Bug.equal_to_status('0').to_a
  end

  test 'should filter bugs by reporter' do
    assert_equal [bugs(:one)], Bug.equal_to_reporter('3').to_a
  end

  test 'should sort bugs by title ascending' do
    assert_equal [bugs(:one), bugs(:two), bugs(:another_bug)], Bug.sorted('title', 'asc').to_a
  end

  test 'should sort bugs by title descending' do
    assert_equal [bugs(:another_bug), bugs(:two), bugs(:one)], Bug.sorted('title', 'desc').to_a
  end

  test 'search should not find bug and po as a result' do
    search_hash = { title: 'bug', reporter: '2' }
    assert Bug.search(search_hash).empty?
  end

  test 'search should find bug with rejected status' do
    search_hash = { title: 'bug', status: '1' }
    assert_equal [bugs(:another_bug)], Bug.search(search_hash)
  end

  test 'should get all bugs when no parameters' do
    assert_equal Bug.all.to_a, Bug.search({})
  end

  test 'search should filter by bug ids' do
    search_hash = { bug_ids: [bugs(:one).id] }
    assert_equal [bugs(:one)], Bug.search(search_hash)
  end

  test 'search should order bugs by descending title' do
    search_hash = { sort: 'title,desc' }
    assert_equal [bugs(:another_bug), bugs(:two), bugs(:one)], Bug.search(search_hash)
  end

  test 'search should order bugs by ascending title' do
    search_hash = { sort: 'title' }
    assert_equal [bugs(:one), bugs(:two), bugs(:another_bug)], Bug.search(search_hash)
  end
end
