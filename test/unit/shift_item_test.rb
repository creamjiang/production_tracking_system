require 'test_helper'

class ShiftItemTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ShiftItem.new.valid?
  end
end
