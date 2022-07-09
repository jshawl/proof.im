# frozen_string_literal: true

class CreateKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :keys do |t|
      t.references :handle, null: false, foreign_key: true
      t.string :kind
      t.string :content

      t.timestamps
    end
  end
end
