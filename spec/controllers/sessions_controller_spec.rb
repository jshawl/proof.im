require 'rails_helper'

describe 'SessionsController', type: :request do

  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: 'RWQVeYdkyHjdHNLkbGPUmaD1rn4Il43FUsIwos6raMWg0NC4AqGgejkA')
    @signature = File.read("spec/fixtures/session.txt.minisig")
    @claim = "jshawl:abc-123"
    @headers = {
      Authorization: "Basic #{Base64.encode64(@claim)}"
    }
  end

  it 'creates a proof of claim' do
    sig =  Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/session.txt.minisig"))
    params = {signature: sig}
    expect {
      post '/session/proof', params: params, headers: @headers
    }.to change{ Proof.count }.by(1)
    expect(Proof.last.claim).to eq(@claim + "\n")
    expect(Proof.last.content).to eq(@signature)
    expect(Proof.last.verified?).to eq(true)
  end
  it '404s when no proof exists for claim' do
    get '/session/proof_by_claim', headers: @headers
    expect(response.status).to eq(404)
  end
end
