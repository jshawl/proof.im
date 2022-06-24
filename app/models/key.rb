class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof

  def claim
    "I am proving that I am #{handle.name} on proof.im with the following public key:
#{content}"
  end

  def session_claim
    "I am #{handle.name} logging into proof.im"
  end
end
