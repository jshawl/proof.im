class AddClaimToProofs < ActiveRecord::Migration[7.0]
  def change
    add_column :proofs, :claim, :string
  end
end
