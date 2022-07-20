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
    expect(JSON.parse(response.body)).to eq({"success" => true})
  end
  it 'handles invalid signatures' do
    expect do
      post '/jshawl/proofs', params: {
        signature: uploaded_file('identity.txt.sig'),
        claim: uploaded_file('session.txt')
      }
    end.to change { Proof.count }.by(0)
    expect(JSON.parse(response.body)).to eq({"error" => "invalid signature"})
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
  it 'does not create a proof of identity with an invalid signature' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, 'https://news.ycombinator.com/user?id=jshawl')
      .to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
    expect do
      post '/jshawl/on-hn', params: identity_params.merge(claim: uploaded_file("session.txt"))
    end.to change { Proof.count }.by(0)
    expect(JSON.parse(response.body)).to eq({"error" => 'invalid signature'})
  end
  it 'creates GitHub identity proof' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, 'https://gist.github.com/jshawl/387459683b4dab2b6c07d428d188daa5')
      .to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-github")
    expect do
      post '/jshawl/on-github', params: identity_params.merge(public_claim_url: 'https://gist.github.com/jshawl/387459683b4dab2b6c07d428d188daa5')
    end.to change { Proof.count }.by(1)
    expect(Proof.last.username).to eq('jshawl')
    expect(Proof.last.verified?).to be(true)
    get '/jshawl/on-github'
    expect(response.body).to match('✅')
  end
  it 'doesnt allow rogue identity urls' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, 'https://example.com')
      .to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-github")
    expect do
      post '/jshawl/on-github', params: identity_params.merge(public_claim_url: 'https://example.com')
    end.to change { Proof.count }.by(1)
    expect(Proof.last.username).to eq('jshawl')
    expect(Proof.last.verified?).to be(false)
    expect(JSON.parse(response.body)).to eq({"error" => "invalid public_claim_url"})
    get '/jshawl/on-github'
    expect(response.body).not_to match('✅')
  end
  it 'shows proof of identity' do
    @key = @handle.keys.create(content: KEYS::RSA)
    stub_request(:get, 'https://news.ycombinator.com/user?id=jshawl')
      .to_return(status: 200, body: "Here's some proof: https:&#x2F;&#x2F;proof.im&#x2F;jshawl&#x2F;on-hn")
    post '/jshawl/on-hn', params: identity_params
    expect(@handle.identities.length).to eq(1)
    get '/jshawl/on-hn'
    expect(response.body).to match('✅')
  end
end
