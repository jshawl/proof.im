class Key < ApplicationRecord
  belongs_to :handle
  has_one :proof
  validates :content, presence: true

  before_save :set_kind

  scope :verified, -> {includes(:proof).where.not({proof: {id: nil}})}

  def key_id
    Minisign::PublicKey.new(content).key_id
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
