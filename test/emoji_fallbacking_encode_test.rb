# coding: utf-8
require 'test/unit'
require_relative '../lib/string'

class EmojiFallbackingEncodeTest < Test::Unit::TestCase
  def test_emoji_fukuro
    assert_equal utf8_kddi("[ふくろ]"), utf8_docomo("\u{E6AD}").encode_with_fallback("UTF8-KDDI")
  end

  def test_non_emoji_fu
    assert_equal utf8_kddi("\u{3075}"), utf8_docomo("\u{3075}").encode_with_fallback("UTF8-KDDI")
  end

  private
  def utf8_docomo(str)
    str.force_encoding("UTF8-DoCoMo")
  end

  def utf8_kddi(str)
    str.force_encoding("UTF8-KDDI")
  end
end
