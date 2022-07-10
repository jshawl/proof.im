# frozen_string_literal: true

class AddFingerprintToKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :keys, :fingerprint, :string
    Key.all.each do |key|
      key.save
    rescue StandardError
      p key
    end
  end
end
