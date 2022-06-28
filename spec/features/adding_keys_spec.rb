describe "Adding Keys" do
  it "doesn't conflict with onboarding" do
    allow_any_instance_of(ApplicationController).to receive(:current_handle).and_return("jshawl")
    @handle = Handle.create(name: "jshawl")
    @key = @handle.keys.create(content: minisign_public_key)
    @proof = @key.create_proof(signature: File.read("spec/fixtures/claim.txt.minisig"))

    visit new_handle_key_path(handle_id: "jshawl")
    expect(page).to have_current_path(new_handle_key_path(handle_id: "jshawl"))
  end
end
