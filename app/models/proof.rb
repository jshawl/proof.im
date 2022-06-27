class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  def verification
    p "using #{key.content}"
    klaim = claim || key.claim
    p "using claim: #{klaim}"
    p "using content: #{content}"
    pk = Minisign::PublicKey.new(key.content)
    sig = Minisign::Signature.new(content)
    pk.verify(sig, klaim)
  end
  def verified?
    !!verification
  end
end
