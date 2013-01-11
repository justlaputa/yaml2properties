#!/usr/bin/env ruby
require_relative './y2p'

describe Yaml2Properties, 'normal behavor' do
  before do
    @y2p = Yaml2Properties.new()
    @testFile = ['test.yml']
  end

  it 'create files in current directory by default' do
    @y2p.run(@testFile)
    File.exist?('Messages.properties').should == true
    File.exist?('Messages_zh.properties').should == true
    File.exist?('Messages_ja.properties').should == true
  end

  it 'create Messages_zh.properties' do
    @y2p.run(@testFile)
    open('Messages_zh.properties') {|file|
      file.readlines[0].should == "my.test.message.warn=\\u8b66\\u544a\\u4fe1\\u606f\n"
    }
  end

  it 'create Messages_ja.properties' do
    @y2p.run(@testFile)
    open('Messages_ja.properties') {|file|
      file.readlines[0].should == "my.test.message.warn=\\u8b66\\u544a\\u30e1\\u30c3\\u30bb\\u30fc\\u30b8\n"
    }
  end

  it 'create Messages.properties' do
    @y2p.run(@testFile)
    open('Messages.properties') {|file|
      file.readlines[0].should == "my.test.message.warn=Warning message\n"
    }
  end

  after do
    File.delete("Messages_zh.properties",
                "Messages_ja.properties",
                "Messages.properties")
  end
end

describe Yaml2Properties, 'multiple input files' do
  before do
    @y2p = Yaml2Properties.new()
    @testFiles = ['test.yml', 'test_2.yml']
  end

  it 'create files in current directory' do
    @y2p.run(@testFiles)
    File.exist?('Messages.properties').should == true
    File.exist?('Messages_zh.properties').should == true
    File.exist?('Messages_ja.properties').should == true
  end

  it 'create Messages_zh.properties' do
    @y2p.run(@testFiles)
    open('Messages_zh.properties') {|file|
      file.readline.should == "my.test.message.warn=\\u8b66\\u544a\\u4fe1\\u606f\n"
      file.readline.should == "my.test.message.error=\\u9519\\u8bef\\u4fe1\\u606f\n"
      file.readline.should == "not.my.test.message.warn=\\u8b66\\u544a\\u4fe1\\u606f\n"
    }
  end

  it 'create Messages_ja.properties' do
    @y2p.run(@testFiles)
    open('Messages_ja.properties') {|file|
      file.readline.should == "my.test.message.warn=\\u8b66\\u544a\\u30e1\\u30c3\\u30bb\\u30fc\\u30b8\n"
      file.readline.should == "my.test.message.error=\\u30a8\\u30e9\\u30fc\\u30e1\\u30c3\\u30bb\\u30fc\\u30b8\n"
      file.readline.should == "not.my.test.message.warn=\\u8b66\\u544a\\u30e1\\u30c3\\u30bb\\u30fc\\u30b8\n"
    }
  end

  it 'create Messages.properties' do
    @y2p.run(@testFiles)
    open('Messages.properties') {|file|
      file.readline.should == "my.test.message.warn=Warning message\n"
      file.readline.should == "my.test.message.error=Error message\n"
      file.readline.should == "not.my.test.message.warn=Warning message\n"
    }
  end

  after do
    File.delete("Messages_zh.properties",
                "Messages_ja.properties",
                "Messages.properties")
  end
end
