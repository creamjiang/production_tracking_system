require 'test_helper'

class TransactionSummaryTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert TransactionSummary.new.valid?
  end
end
