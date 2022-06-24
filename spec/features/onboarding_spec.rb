require 'rails_helper'

describe 'Claiming a Handle' do
  it 'redirects to new keys path' do
    visit root_path
    fill_in 'handle[name]', with: 'jshawl'
    click_on 'Create Handle'
    expect(page).to have_current_path('/jshawl/keys/new')
  end
end
