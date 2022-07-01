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
      signature: File.read("spec/fixtures/session.txt.minisig")
    )

    # client side
    click_on "I did this"
    expect(page).to have_content("Log Out jshawl")

    expect{
      click_on "Log Out jshawl"
    }.to change{Proof.count}.by(-1)

    expect(page).to have_content("Log In")
  end

  it 'gracefully fails on no session proof' do
    visit new_session_path(handle: 'jshawl')
    click_on "I did this"
    expect(page).to have_content("Try again?")
  end

  it 'redirects if already logged in' do
    allow_any_instance_of(ApplicationController).to receive(:current_handle).and_return("jshawl")
    visit new_session_path
    expect(page).to have_current_path(handle_path(id: 'jshawl'))
  end

  it 'prompts for signup if no handle exists' do
    visit new_session_path(handle: SecureRandom.hex)
    expect(page).to have_current_path(new_session_path)
  end
end
