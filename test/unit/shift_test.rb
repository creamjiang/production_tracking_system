require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Shift.new.valid?
  end
end
