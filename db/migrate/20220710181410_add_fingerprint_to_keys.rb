class AddFingerprintToKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :keys, :fingerprint, :string
    Key.all.each do |key|
      begin
        key.save
      rescue
        p key
      end
    end
  end
end
