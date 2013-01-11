#!/usr/bin/env ruby
# This is a script to convert yaml structured messages
# in different languages to multiple Java Message.properties
# files

# version: 0.1

require 'fileutils'
require 'yaml'

inFiles = Dir.glob("*.yml")

raise "No input files found" if inFiles.empty?

class Yaml2Properties
  def run(inFiles)

    puts "Generating property files..."

    content = ""

    inFiles.each {|filename|
      file = File.open(filename)
      content += file.read + "\n"
      file.close
    }

    messageFileMap = {
      "en" => File.open("Messages.properties", mode="w"),
      "zh" => File.open("Messages_zh.properties", mode="w"),
      "ja" => File.open("Messages_ja.properties", mode="w")
    }

    messageObj = YAML::load(content)

    messageObj.each_pair do |key, messageMap|
      messageMap.each_pair do |lang, message|
        s = ""
        message = message || ""

        messageFileMap[lang].write(key + "=")

        if lang == "en"
          s = message
        else
          if RUBY_VERSION >= "1.9.0"
            message.codepoints {|c| s += "\\u" + ("%04x" % c)}
          else
            message.unpack("U*").each {|c| s += "\\u" + ("%04x" % c)}
          end
        end
        messageFileMap[lang].write(s + "\n")
      end
    end

    messageFileMap.each_value do |f|
      f.close
    end

    puts "Successfuly generated property files:"
    puts "Messages.properties\nMessages_ja.properties\nMessages_zh.properties"

  end
end

# see http://stackoverflow.com/questions/582686/should-i-define-a-main-method-in-my-ruby-scripts
if __FILE__ == $0
  y2p = Yaml2Properties.new()
  y2p.run(inFiles)
end
