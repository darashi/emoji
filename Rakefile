require 'open-uri'

task :default => [:test]

task :test do
  ruby "test/*_test.rb"
end

task :fetch_table do
  url = "http://emoji4unicode.googlecode.com/svn/trunk/data/emoji4unicode.xml"
  xml = URI(url).read
  open("emoji4unicode.xml", "w") do |f|
    f.write xml
  end
end

task :generate_table do
  ruby "tool/generate_fallback_table.rb"
end
