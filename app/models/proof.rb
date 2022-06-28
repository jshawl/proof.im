class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  def verification
    klaim = claim || key.claim
    pk = Minisign::PublicKey.new(key.content)
    sig = Minisign::Signature.new(content.gsub(/\r/,''))
    pk.verify(sig, klaim)
  end
  def verified?
    !!verification
  end
end
