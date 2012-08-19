#!/bin/env ruby
# This is a script to convert yaml structured messages
# in different languages to multiple Java Message.properties
# files

# Author: laputa

require 'yaml'

messageFileMap =
  {"en" => File.open("Messages.properties", mode="w"),
  "zh" => File.open("Messages_zh.properties", mode="w"),
  "ja" => File.open("Messages_ja.properties", mode="w")};

messageObj = YAML::load(File.open("test.yml"));

messageObj.each_pair do |key, messageMap|
  messageMap.each_pair do |lang, message|
    messageFileMap[lang].write(key + "=")
    messageFileMap[lang].write(message + "\n")
  end
end

messageFileMap.each_value do |f|
  f.close
end
