class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic

  before_save :ensure_newline
  def verification
    pk = Minisign::PublicKey.new(key.content)
    sig = Minisign::Signature.new(content.gsub(/\r/,''))
    pk.verify(sig, claim)
  end
  def verified?
    !!verification
  end

  def ensure_newline
    return true if claim.nil?
    unless claim.match(/\n$/)
      self.claim = self.claim + "\n"
    end
  end
end
