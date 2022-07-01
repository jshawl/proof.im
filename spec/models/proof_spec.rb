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
end
