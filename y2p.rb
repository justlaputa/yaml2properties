#!/usr/bin/env ruby
# This is a script to convert yaml structured messages
# in different languages to multiple Java Message.properties
# files

# version: 0.1

require 'fileutils'
require 'yaml'

inFile = ARGV[0] || "Messages.yml"
outDir = ARGV[1] || "."

if ! File.exist?(inFile)
  abort("input file %s does not exist" % inFile)
end

class Yaml2Properties
  def run(inFile, outDir='.')
    FileUtils.mkdir_p(outDir) if ! File.exist?(outDir)

    messageFileMap = {
      "en" => File.open("#{outDir}/Messages.properties", mode="w"),
      "zh" => File.open("#{outDir}/Messages_zh.properties", mode="w"),
      "ja" => File.open("#{outDir}/Messages_ja.properties", mode="w")
    };

    messageObj = YAML::load(File.open(inFile));

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
  end
end

# see http://stackoverflow.com/questions/582686/should-i-define-a-main-method-in-my-ruby-scripts
if __FILE__ == $0
  y2p = Yaml2Properties.new()
  y2p.run(inFile, outDir)
end
