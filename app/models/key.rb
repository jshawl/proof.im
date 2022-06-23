class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
end
