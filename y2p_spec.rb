require './y2p'

describe Yaml2Properties, 'normal behavor' do
  before do
    @y2p = Yaml2Properties.new()
  end
  it 'create Messages_zh.properties' do
    @y2p.run('test.yml')
    open('Messages_zh.properties') {|file|
      file.readlines[0].should == "my.test.message.warn=\\u8b66\\u544a\\u4fe1\\u606f\n"
    }
  end
  it 'create Messages_ja.properties' do
    @y2p.run('test.yml')
    open('Messages_ja.properties') {|file|
      file.readlines[0].should == "my.test.message.warn=\\u8b66\\u544a\\u30e1\\u30c3\\u30bb\\u30fc\\u30b8\n"
    }
  end
  it 'create Messages.properties' do
    @y2p.run('test.yml')
    open('Messages.properties') {|file|
      file.readlines[0].should == "my.test.message.warn=Warning message\n"
    }
  end
  after do
    File.delete('Messages_zh.properties', 'Messages_ja.properties', 'Messages.properties')
  end
end
