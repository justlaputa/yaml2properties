#!/usr/bin/env ruby
require_relative './y2p'

describe Yaml2Properties, 'normal behavor' do
  before do
    @y2p = Yaml2Properties.new()
    @testFile = 'test.yml'
    @outDir = '.'
  end

  it 'create files in current directory by default' do
    @y2p.run(@testFile)
    File.exist?('Messages.properties').should == true
    File.exist?('Messages_zh.properties').should == true
    File.exist?('Messages_ja.properties').should == true
  end

  it 'create properties files in specified directory' do
    @outDir = 'test'
    @y2p.run(@testFile, @outDir)
    File.exist?('test/Messages.properties').should == true
    File.exist?('test/Messages_zh.properties').should == true
    File.exist?('test/Messages_ja.properties').should == true
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
    File.delete("#{@outDir}/Messages_zh.properties",
                "#{@outDir}/Messages_ja.properties",
                "#{@outDir}/Messages.properties")
  end
end
