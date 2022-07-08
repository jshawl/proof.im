require 'rails_helper'

describe 'Proofs controller', type: :request do
  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
  end
  it 'creates proofs' do
    signature =  Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/session.txt.minisig"))
    claim = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/session.txt"))
    post '/jshawl/proofs', params: {
      signature: signature,
      claim: claim
    }
  end
  it 'creates proof of identity' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, "https://news.ycombinator.com/user?id=jshawl").
      to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
    signature =  Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/identity.txt.sig"))
    claim = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/identity.txt"))
    expect {
      post '/jshawl/on-hn', params: {
        signature: signature,
        claim: claim,
      }
    }.to change{Proof.count}.by(1)
    expect(Proof.last.username).to eq('jshawl')
    expect(Proof.last.verified?).to be(true)
  end
  it 'shows proof of identity' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, "https://news.ycombinator.com/user?id=jshawl").
      to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
    signature =  Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/identity.txt.sig"))
    claim = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/identity.txt"))
    post '/jshawl/on-hn', params: {
      signature: signature,
      claim: claim,
    }
    get '/jshawl/on-hn'
  end
end
