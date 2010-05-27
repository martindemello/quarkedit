require 'test/unit'
require 'fsed'
require 'stringio'

# test data
Str1 = "This is line 1"
Str2 = "And this is the second line"
Line1 = Str1.split(//)
Line2 = Str2.split(//)

class TestBuffer < Test::Unit::TestCase
  def setup
    a = StringIO.new [Str1, Str2].join("\n")
    @buf = Editors::FSED::Buffer.new(10, nil)
    @buf.read_from_io(a)
  end

  def test_basics
    assert_equal @buf.length, 2
    assert_equal Line1, @buf.row(1)
    assert_equal Line2, @buf.row(2)
    assert_nil @buf.row(3)
    assert_equal Line1.length, @buf.line_length(1)
    assert_equal Line2.length, @buf.line_length(2)
    assert_equal 0, @buf.line_length(3)
    assert_equal Str1 + "\n" + Str2 + "\n",  @buf.to_s(0, 2)
  end

  def test_clear
    @buf.clear
    assert_equal "", @buf.to_s(0,2)
  end

  def test_split
    @buf.split_line_at(1, 6)
    assert_equal @buf.length, 3
    assert_equal "This i".split(//), @buf.row(1)
    assert_equal "s line 1".split(//), @buf.row(2)
    assert_equal Line2, @buf.row(3)
    assert_nil @buf.row(4)
  end
end
