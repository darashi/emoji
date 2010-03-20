class Encoding
  class FallbackingConverter < Converter
    def initialize(senc, denc, ftab, *opts)
      super(senc, denc, *opts)
      unless ftab.respond_to? :[]
        raise TypeError, "fallback table should have [] method"
      end
      @fallback_table = ftab
    end

    def fallbacking_convert(src)
      senc = self.source_encoding
      dst = ''
      while true
        case self.primitive_convert(src, dst)
        when :invalid_byte_sequence
          raise InvalidByteSequenceError
        when :undefined_conversion
          undef_char = self.primitive_errinfo[3].force_encoding(senc)
          if fallback = @fallback_table[undef_char]
            self.insert_output(fallback)
          else
            raise UndefinedConversionError
          end
        else
          break
        end
      end
      return dst
    end
  end
end
