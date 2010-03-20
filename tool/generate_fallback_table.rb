#!/usr/bin/env ruby

require 'rexml/document'

companies = %w(DoCoMo KDDI SoftBank Unicode)

class EmojiTable
  def initialize(xml_path)
    @doc = REXML::Document.new File.open(xml_path)
  end

  def generate_fallback_table(io, from_company, to_company)
    REXML::XPath.each(@doc.root, '//e') do |e|
      from = e.attribute(from_company.downcase).to_s
      from_encoding = company_name_to_encoding_name(from_company)
      to = e.attribute(to_company.downcase).to_s
      text_fallback = e.attribute('text_fallback').to_s
      name = e.attribute('name').to_s
      if from =~ /^(?:\*|\+)(.+)$/
        from = $1
      end
      if from.empty? || from !~ /^[0-9A-F]+$/
        # do nothing
      elsif to.empty? && !text_fallback.empty?
        from_utf8 = ucs_to_utf8(from.hex)
        io.puts %(        "\\u{#{from}}".force_encoding("#{from_encoding}") => "#{text_fallback}",)
      end
    end
  end

  private

  def ucs_to_utf8(cp)
    return [cp].pack("U*").unpack("H*").first
  end
end

def company_name_to_encoding_name(company_name)
  company_name == "Unicode" ? "UTF-8" : "UTF8-#{company_name}"
end

emoji_table = EmojiTable.new("emoji4unicode.xml")
companies = %w(DoCoMo KDDI SoftBank Unicode)

io = open("lib/emoji/fallback_table.rb", "w")

io.puts "# coding: utf-8"
io.puts "module Emoji"
io.puts "  FALLBACK_TABLE = {"
companies.each do |from_company|
  from_encoding = company_name_to_encoding_name(from_company)
  io.puts "    #{from_encoding.dump} => {"
  companies.each do |to_company|
    next if from_company == to_company
    to_encoding   = company_name_to_encoding_name(to_company)
    io.puts "      #{to_encoding.dump} => {"
    emoji_table.generate_fallback_table(io, from_company, to_company)
    io.puts "      },"
  end
  io.puts "    },"
end
io.puts "  }"
io.puts "end"
