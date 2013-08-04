require 'test_helper'

class ProcedureProductTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ProcedureProduct.new.valid?
  end
end
