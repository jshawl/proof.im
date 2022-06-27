require 'rails_helper'

describe 'SessionsController', type: :request do

  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: 'RWQVeYdkyHjdHNLkbGPUmaD1rn4Il43FUsIwos6raMWg0NC4AqGgejkA')
    @signature = 'untrusted comment: signature from minisign secret key
RUQVeYdkyHjdHLFplWGT4sQMIL7vLuem3XgGVNLrbvQOW6Wq9nTi3YsVw6FIEwHHwHs08Kcs9cB1sr0S5okiQ2Ivy8J9vrRBvAQ=
trusted comment: timestamp:1656210182	file:session.txt	hashed
AYakr4c5yEntn2YVcpHzCxjbbH7Znz3xMuPhpejeBBrjKB3cMbSz1mpRcS56RPng66kVazlIWyw5kegZd8WCBg=='
    @claim = 'jshawl:abc-123'
    @headers = {
      Authorization: "Basic #{Base64.encode64(@claim)}"
    }
  end

  it 'creates a proof of claim' do
    params = {}
    params[@signature] = ''
    
    expect {
      post '/session/proof', params: params, headers: @headers
    }.to change{ Proof.count }.by(1)
    expect(Proof.last.claim).to eq(@claim)
    expect(Proof.last.content).to eq(@signature)
    expect(Proof.last.verified?).to eq(true)
  end
  it 'can find a proof of claim' do
    Proof.create!(claim: @claim, content: @signature, key: @key)
    get '/session/proof_by_claim', headers: @headers
    body = JSON.parse(response.body)
    expect(body["claim"]).to eq(@claim)
    expect(body["signature"]).to eq(@signature)
    expect(body["verified"]).to eq(true)
    expect(cookies['proven_claim']).to eq(@claim)
  end
  it '404s when no proof exists for claim' do
    get '/session/proof_by_claim', headers: @headers
    expect(response.status).to eq(404)
  end
end
