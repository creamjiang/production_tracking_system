require 'test_helper'

class ColdStoreTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert ColdStore.new.valid?
  end
end
