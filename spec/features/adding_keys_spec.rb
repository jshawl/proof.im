# frozen_string_literal: true
require 'rails_helper'
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
  it "only shows a link to edit if logged in" do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).not_to have_content("Edit Key")
  end
  it "only shows a link for current login handle when the key is verified" do
    @handle = Handle.create(name: 'jshawl')
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl2')
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).not_to have_content("Edit Key")


    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).not_to have_content("Edit Key")

    @proof = @key.proofs.create(signature: fixture('claim.txt.minisig'), claim: fixture('claim.txt'))
    allow_any_instance_of(ApplicationHelper).to receive(:current_handle).and_return('jshawl')
    visit handle_key_path(handle_id: 'jshawl', id: @key.fingerprint)
    expect(page).to have_content("Edit Key")

  end
end
