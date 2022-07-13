# frozen_string_literal: true
require 'rails_helper'

describe 'Adding Identities' do
  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::RSA)
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    allow_any_instance_of(ApplicationHelper).to receive(:session_proof).and_return(OpenStruct.new(
      key: @key
    ))
  end

  it 'prompts the user to curl' do
    visit '/jshawl/on-hn'
    expect(page.body).to match(/curl.+claim\.txt/)
  end

  it 'shows proof post curl' do
    # server side
    @proof = @key.proofs.create(
      kind: 'hn_identity',
      claim: fixture('identity.txt'),
      signature: fixture('identity.txt.sig'),
      username: 'jshawl',
      public_claim_url: 'https://news.ycombinator.com/user?id=jshawl'
    )

    stub_request(:get, "https://news.ycombinator.com/user?id=jshawl").
      to_return(status: 200, body: "https://proof.im/jshawl/on-hn", headers: {})

    visit '/jshawl/on-hn'
    expect(page.body).not_to match(/curl/)

    visit '/jshawl'
    expect(page.body).to match('Y Combinator Logo')
  end

end
