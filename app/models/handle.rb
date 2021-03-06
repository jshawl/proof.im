# frozen_string_literal: true

class Handle < ApplicationRecord
  has_many :keys
  validates :name, format: { with: /[a-zA-Z]+/ }

  def identities
    Proof.where('key_id in (?) AND kind > 1', key_ids)
  end
end
