require 'test_helper'

class TestRAD < Test::Unit::TestCase
  def setup
    @rad = Rad::Dsl.evaluate( File.read( File.expand_path("../fixtures/Radfile", __FILE__) ) )
  end

  def test_wiring
    assert @rad.is_a?(Rad::Definition)
  end
end