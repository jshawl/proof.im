# frozen_string_literal: true

class UpdateExistingKeys < ActiveRecord::Migration[7.0]
  def change
    Key.update(kind: 'minisign')
  end
end
