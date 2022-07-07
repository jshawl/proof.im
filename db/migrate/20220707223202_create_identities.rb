class CreateIdentities < ActiveRecord::Migration[7.0]
  def change
    create_table :identities do |t|
      t.string :username
      t.references :handle, null: false, foreign_key: true
      t.references :proof, null: true, foreign_key: true
      t.string :public_claim_url
      t.integer :kind, default: 0

      t.timestamps
    end
  end
end
