require 'rails_helper'

describe 'Proof' do
  before do
    @handle = Handle.create(name: "jshawl")
    @key = @handle.keys.create(content: File.read("spec/fixtures/id_rsa.pub"))
  end
  it 'supports ssh keys' do
    @proof = @key.proofs.create(
      signature: File.read("spec/fixtures/content.txt.rsa.sig"),
      claim: File.read("spec/fixtures/content.txt")
    )
    expect(@proof.verified?).to be(true)
  end
  it 'verifies matching ssh keys' do
    @proof = @key.proofs.create(
      signature: File.read("spec/fixtures/content.txt.rogue.sig"),
      claim: File.read("spec/fixtures/content.txt")
    )
    expect(@proof.verified?).to be(false)
  end
  describe 'of identity' do
    before do
      @proof = @key.proofs.create(
        kind: :identity,
        claim: File.read("spec/fixtures/identity.txt"),
        signature: File.read("spec/fixtures/identity.txt.sig")
      )
    end
    it 'proves identities when the public claim is present' do
      stub_request(:get, "https://example.com/").
        to_return(status: 200, body: "Here's some proof: https://proof.im/jshawl/on-hn")
      expect(@proof.verified?).to be(true)
    end
    it 'is not proven when the public claim is absent' do
      stub_request(:get, "https://example.com/").
          to_return(status: 200, body: "Here's some proof: https://example.com")
      expect(@proof.verified?).to be(false)
    end
  end
end
