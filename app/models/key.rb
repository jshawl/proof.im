class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
  validates :content, presence: true

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def key_id
    Minisign::PublicKey.new(content).key_id
  end

  def claim
    "I am proving that I am #{handle.name} on proof.im with the following public key:
#{content}\n"
  end
end
