require 'rails_helper'

describe 'Key' do
  before do
    @handle = Handle.create(name: "jshawl")
  end
  it 'sets the kind for ssh keys' do
    @key = @handle.keys.create(content: File.read("spec/fixtures/id_rsa.pub"))
    expect(@key.kind).to eq("ssh-rsa")
  end
  it 'sets the kind for minisign keys' do
    @key = @handle.keys.create(content: minisign_public_key)
    expect(@key.kind).to eq("minisign")
  end
  it 'has a key id' do
    @key = @handle.keys.create(content: minisign_public_key)
    expect(@key.key_id).to eq('1CDD78C864877915')
    @key = @handle.keys.create(content: File.read("spec/fixtures/id_rsa.pub"))
    expect(@key.key_id).to eq('1mTk52X83F69zQ6c/Tu+71rTkqCG3/jO3sWi1pijHt4')
  end
end
