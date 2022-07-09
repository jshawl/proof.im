require 'rails_helper'

describe 'Proof' do
  before do
    @handle = Handle.create(name: "jshawl")
    @key = @handle.keys.create(content: KEYS::RSA)
  end
  it 'supports ssh keys' do
    @proof = @key.proofs.create(
      signature: fixture("content.txt.rsa.sig"),
      claim: fixture("content.txt")
    )
    expect(@proof.verified?).to be(true)
  end
  it 'verifies matching ssh keys' do
    @proof = @key.proofs.create(
      signature: fixture("content.txt.rogue.sig"),
      claim: fixture("content.txt")
    )
    expect(@proof.verified?).to be(false)
  end
  describe 'of identity' do
    before do
      @proof = @key.proofs.create(
        kind: :identity,
        claim: fixture("identity.txt"),
        signature: fixture("identity.txt.sig"),
        username: 'jshawl'
      )
    end
    it 'proves identities when the public claim is present' do
      stub_request(:get, "https://news.ycombinator.com/user?id=jshawl").
        to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
      expect(@proof.verified?).to be(true)
    end
    it 'is not proven when the public claim is absent' do
      stub_request(:get, "https://news.ycombinator.com/user?id=jshawl").
          to_return(status: 200, body: "Here's some proof: https://example.com")
      expect(@proof.verified?).to be(false)
    end
  end
end
