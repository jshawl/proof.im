class AddKindToProofs < ActiveRecord::Migration[7.0]
  def change
    add_column :proofs, :kind, :integer, default: 0
    Proof.where("length(claim) < 100").update(kind: 'session')
  end
end
