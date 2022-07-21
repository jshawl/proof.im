require 'rails_helper'

describe 'Remembering Tabs' do
  it 'has the first tab checked by default' do
    visit root_path
    expect(find('[value="ssh-rsa"]')[:checked]).to eq("true")
    expect(find('[value="minisign"]')[:checked]).to eq("false")
    find('[value="minisign"]').click
    expect(find('[value="minisign"]')[:checked]).to eq("checked")
    visit root_path
    expect(find('[value="minisign"]')[:checked]).to eq("checked")
  end
end
