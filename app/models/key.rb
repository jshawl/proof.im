class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
  validates :content, presence: true

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def key_id
    Minisign::PublicKey.new(content).key_id
  end

  def session_claim
    "#{handle.name}@proof.im:#{SecureRandom.uuid}"
  end

  # def claim=(cl)
  #   @claim = cl
  # end

  def claim
    read_attribute(:claim) || "I am proving that I am #{handle.name} on proof.im with the following public key:
#{content}\n"
  end
end
