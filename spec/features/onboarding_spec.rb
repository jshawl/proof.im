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
  it 'shows a profile if verified key' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: 'RWQVeYdkyHjdHNLkbGPUmaD1rn4Il43FUsIwos6raMWg0NC4AqGgejkA')
    @proof = @key.create_proof(content: File.read("spec/fixtures/claim.txt.minisig"))

    visit root_path
    fill_in 'handle[name]', with: 'jshawl'
    click_on 'Create Handle'
    expect(page).to have_content('This handle has already been claimed')
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
    visit handle_key_claim_path(handle_id: @handle.name, key_id: @key.id, format: 'txt')
    visit handle_key_path(handle_id: @handle.name, id: @key.id)
    fill_in 'proof[content]', with: File.read("spec/fixtures/claim.txt.minisig")
    click_on 'Create Proof'
    expect(page).to have_content('Signature and comment signature verified')
  end
  it 'has a show route' do
    @handle = Handle.create(name: 'jshawl')
    visit handle_path(id: @handle.name)
    expect(page.status_code).to eq(200)
  end
end

describe 'Claiming a handle that already has keys' do
  it 'should not allow randos to add keys' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: 'RWQVeYdkyHjdHNLkbGPUmaD1rn4Il43FUsIwos6raMWg0NC4AqGgejkA')
    @proof = @key.create_proof(content: File.read("spec/fixtures/claim.txt.minisig"))
    visit handle_path(id: @handle.name)
    expect(page).to have_no_content('Add a public key')
  end
end
