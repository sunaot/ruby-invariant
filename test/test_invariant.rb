require 'test/unit'
require 'invariant'

class TestInvariant < Test::Unit::TestCase
  def test_invariant
    assert Sample.new(10).hello
  end

  def test_variant
    assert_raises(RuntimeError) { Sample.new(200).hello }
  end
end

class Sample
  extend  Invariant

  invariant do
    assert { @foo > 0 and @foo < 100 }
  end

  def initialize foo
    @foo = foo
  end

  def hello
    true
  end
end

Sample.enabled
