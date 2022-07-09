# frozen_string_literal: true

require 'rails_helper'

describe 'Proofs controller', type: :request do
  def uploaded_file(path)
    Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/#{path}"))
  end

  def identity_params
    {
      signature: uploaded_file('identity.txt.sig'),
      claim: uploaded_file('identity.txt')
    }
  end

  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
  end
  it 'creates session proofs' do
    expect do
      post '/jshawl/proofs', params: {
        signature: uploaded_file('session.txt.minisig'),
        claim: uploaded_file('session.txt')
      }
    end.to change { Proof.count }.by(1)
  end
  it 'creates proof of identity' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, 'https://news.ycombinator.com/user?id=jshawl')
      .to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
    expect do
      post '/jshawl/on-hn', params: identity_params
    end.to change { Proof.count }.by(1)
    expect(Proof.last.username).to eq('jshawl')
    expect(Proof.last.verified?).to be(true)
  end
  it 'shows proof of identity' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, 'https://news.ycombinator.com/user?id=jshawl')
      .to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
    post '/jshawl/on-hn', params: identity_params
    get '/jshawl/on-hn'
  end
end
