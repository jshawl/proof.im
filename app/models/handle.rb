class Handle < ApplicationRecord
  has_many :keys
  validates :name, format: { with: /[a-zA-Z]+/ }
end
