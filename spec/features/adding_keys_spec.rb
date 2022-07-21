# frozen_string_literal: true

describe 'Adding Keys' do
  it "doesn't conflict with onboarding" do
    allow_any_instance_of(ApplicationController).to receive(:current_handle).and_return('jshawl')
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    @proof = @key.proofs.create(signature: fixture('claim.txt.minisig'), claim: fixture('claim.txt'))
    expect(@proof.kind).to eq('key')
    visit new_handle_key_path(handle_id: 'jshawl')
    expect(page).to have_current_path(new_handle_key_path(handle_id: 'jshawl'))
  end
end

describe 'Editing Keys' do
  it 'only shows a link to edit if logged in' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).not_to have_content('edit key')
  end
  it 'only shows a link for current login handle when the key is verified' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl2')
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).not_to have_content('edit key')

    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).not_to have_content('edit key')

    @proof = @key.proofs.create(signature: fixture('claim.txt.minisig'), claim: fixture('claim.txt'))
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).to have_content('edit key')
  end
  it 'can update keys' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    @proof = @key.proofs.create(signature: fixture('claim.txt.minisig'), claim: fixture('claim.txt'))
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    visit edit_handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    click_on("Update Key")
  end
  it 'prevents irreversible issues' do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    @proof = @key.proofs.create(signature: fixture('claim.txt.minisig'), claim: fixture('claim.txt'))
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    visit edit_handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    fill_in("key_content", with: "abcdefg")
    click_on("Update Key")
    expect(page).to have_content("not a valid public key")
  end
end
