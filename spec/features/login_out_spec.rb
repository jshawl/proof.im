require 'rails_helper'

describe 'Logging In' do
  before do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: minisign_public_key)
  end
  it 'logs in and out' do
    visit new_session_path
    allow(SecureRandom).to receive(:uuid).and_return('abc-123')
    visit new_session_path(handle: 'jshawl')

    # server side
    Proof.create(
      key: @key,
      claim: File.read("spec/fixtures/session.txt"),
      content: File.read("spec/fixtures/session.txt.minisig")
    )

    # client side
    click_on "I did this"
    expect(page).to have_content("Log Out jshawl")

    click_on "Log Out jshawl"
    expect(page).to have_content("Log In")
  end
end
