class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def claim
    "I am proving that I am #{handle.name} on proof.im with the following public key:
#{content}"
  end
end
