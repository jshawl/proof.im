# frozen_string_literal: true

class Key < ApplicationRecord
  belongs_to :handle
  has_many :proofs
  validates :content, presence: true

  before_save :set_kind

  scope :verified, -> { includes(:proofs).where.not({ proofs: { id: nil } }) }

  def key_id
    if kind&.match(/ssh/)
      SSHData::PublicKey.parse_openssh(content).fingerprint(md5: true)
    else
      Minisign::PublicKey.new(content).key_id
    end
  end

  private

  def set_kind
    self.kind = if content.match(/^ssh-/)
                  content.split[0]
                else
                  'minisign'
                end
  end
end
