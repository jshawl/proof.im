# frozen_string_literal: true

class CreateProofs < ActiveRecord::Migration[7.0]
  def change
    create_table :proofs do |t|
      t.references :key, null: false, foreign_key: true
      t.string :signature
      t.string :claim
      t.timestamps
    end
  end
end
