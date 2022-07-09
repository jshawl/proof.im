# frozen_string_literal: true

class AddUsernameToProofs < ActiveRecord::Migration[7.0]
  def change
    add_column :proofs, :username, :string
    add_column :proofs, :public_claim_url, :string
  end
end
