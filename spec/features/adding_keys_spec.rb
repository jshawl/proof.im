describe "Adding Keys" do
  it "doesn't conflict with onboarding" do
    allow_any_instance_of(ApplicationController).to receive(:current_handle).and_return("jshawl")
    @handle = Handle.create(name: "jshawl")
    @key = @handle.keys.create(content: KEYS::MINISIGN)
    @proof = @key.proofs.create(signature: fixture("claim.txt.minisig"))
    expect(@proof.kind).to eq("key")
    visit new_handle_key_path(handle_id: "jshawl")
    expect(page).to have_current_path(new_handle_key_path(handle_id: "jshawl"))
  end
end
