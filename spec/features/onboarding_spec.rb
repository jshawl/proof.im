require 'rails_helper'

describe 'Claiming a Handle' do
  it 'redirects to new keys path' do
    expect {
      visit root_path
      fill_in 'handle[name]', with: 'jshawl'
      click_on 'Create Handle'
    }.to change{Handle.count}.by(1)
    expect(page).to have_current_path('/jshawl/keys/new')
  end
  it 'creates a key' do
    @handle = Handle.create(name: 'jshawl')
    expect{
      visit new_handle_key_path(handle_id: 'jshawl')
      fill_in 'key[content]', with: 'RWQVeYdkyHjdHNLkbGPUmaD1rn4Il43FUsIwos6raMWg0NC4AqGgejkA'
      click_on 'Create Key'
    }.to change {Key.count}.by(1)
    
    expect(page).to have_current_path("/jshawl/keys/#{@handle.keys.last.id}")
  end
  it 'asks for proof' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: 'RWQVeYdkyHjdHNLkbGPUmaD1rn4Il43FUsIwos6raMWg0NC4AqGgejkA')
    visit handle_key_path(handle_id: @handle.name, id: @key.id)
    fill_in 'proof[content]', with: File.read("spec/fixtures/claim.txt.minisig")
    click_on 'Create Proof'
    expect(page).to have_content('Signature and comment signature verified')
  end
end
