require 'rails_helper'

describe 'Key' do
  before do
    @handle = Handle.create(name: "jshawl")
  end
  it 'sets the kind for ssh keys' do
    @key = @handle.keys.create(content: KEYS::RSA)
    expect(@key.kind).to eq("ssh-rsa")
  end
  it 'sets the kind for minisign keys' do
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    expect(@key.kind).to eq("minisign")
  end
  it 'has a key id' do
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    expect(@key.key_id).to eq('1CDD78C864877915')
    @key = @handle.keys.create(content: KEYS::RSA)
    expect(@key.key_id).to eq('85:32:3a:0b:31:e3:9d:16:b0:83:85:f0:0f:28:26:50')
  end
end
