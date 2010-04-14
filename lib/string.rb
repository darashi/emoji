require_relative 'emoji'

class String
  def encode_with_fallback(encoding, *args)
    from = self.encoding.to_s
    to = encoding.to_s
    if table = ::Emoji::FALLBACK_TABLE[from][to]
      self.encode(encoding, fallback: table)
    else
      self.encode(encoding, *args)
    end
  end
end
