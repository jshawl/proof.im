class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
  validates :content, presence: true

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def key_id
    Minisign::PublicKey.new(content).key_id
  end
end
