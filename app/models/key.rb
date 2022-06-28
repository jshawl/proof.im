class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
  validates :content, presence: true

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def key_id
    if kind == "minisign"
      return Minisign::PublicKey.new(content).key_id
    end
    if kind == "pgp"
      return "pgpIDhere"
    end
  end
end
