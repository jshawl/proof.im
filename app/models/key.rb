class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
  validates :content, presence: true

  before_save :set_kind

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def key_id
    if kind&.match(/ssh/)
      SSHData::PublicKey.parse_openssh(content).fingerprint
    else
      Minisign::PublicKey.new(content).key_id
    end
  end

  private
  def set_kind
    if self.content.match(/^ssh-/)
      self.kind = self.content.split(" ")[0]
    else
      self.kind = 'minisign'
    end
  end
end
