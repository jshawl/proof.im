class Handle < ApplicationRecord
  has_many :keys
  has_many :identities
  validates :name, format: { with: /[a-zA-Z]+/ }
end
