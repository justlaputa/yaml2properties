#!/usr/bin/env ruby
# This is a script to convert yaml structured messages
# in different languages to multiple Java Message.properties
# files

# Author: laputa

require 'yaml'

inFile = ARGV[0] || "Messages.yml"

if ! File.exist?(inFile)
  abort("input file %s does not exist" % inFile)
end

messageFileMap =
  {"en" => File.open("Messages.properties", mode="w"),
  "zh" => File.open("Messages_zh.properties", mode="w"),
  "ja" => File.open("Messages_ja.properties", mode="w")}

messageObj = YAML::load(File.open(inFile));

messageObj.each_pair do |key, messageMap|
  messageMap.each_pair do |lang, message|
    s = ""
    message = message || ""

    messageFileMap[lang].write(key + "=")

    if lang == "en"
      s = message
    else
      message.codepoints {|c| s += "\\u" + ("%04x" % c)}
    end

    messageFileMap[lang].write(s + "\n")
  end
end

messageFileMap.each_value do |f|
  f.close
end
