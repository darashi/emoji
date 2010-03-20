require_relative 'encoding'
require_relative 'emoji'

class String
  def encode_with_fallback(encoding, *args)
    from = self.encoding.to_s
    to = encoding.to_s
    if ::Emoji::FALLBACK_TABLE[from][to]
      converter = ::Encoding::FallbackingConverter.new(from, to, ::Emoji::FALLBACK_TABLE[from][to])
      converter.fallbacking_convert(self)
    else
      self.encode(encoding, *args)
    end
  end
end
