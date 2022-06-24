class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof

  def claim
    "I am proving that I am #{handle.name} on proof.im with the following public key:
#{content}"
  end
end
