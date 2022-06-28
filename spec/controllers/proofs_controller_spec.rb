require 'rails_helper'

describe 'Proofs controller', type: :request do
  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: minisign_public_key)
  end
  it 'creates proofs' do
    signature =  Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/session.txt.minisig"))
    claim = Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/session.txt"))
    post '/proofs', params: {
      signature: signature,
      claim: claim,
      handle: 'jshawl'
    }
  end
end
