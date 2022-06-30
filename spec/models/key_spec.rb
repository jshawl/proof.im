require 'rails_helper'

describe 'Key' do
  it 'sets the kind for ssh keys' do
    @handle = Handle.create(name: "jshawl")
    @key = @handle.keys.create(content: File.read("spec/fixtures/id_rsa.pub"))
    expect(@key.kind).to eq("ssh-rsa")
  end
  it 'sets the kind for minisign keys' do
    @handle = Handle.create(name: "jshawl")
    @key = @handle.keys.create(content: minisign_public_key)
    expect(@key.kind).to eq("minisign")
  end
end
