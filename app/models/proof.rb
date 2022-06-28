class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  def verification
    p "using #{key.content}"
    klaim = claim || key.claim
    p "using claim: #{klaim}"
    p "using content: #{content.gsub(/\r/,'')}"
    pk = Minisign::PublicKey.new(key.content)
    sig = Minisign::Signature.new(content.gsub(/\r/,''))
    pk.verify(sig, klaim)
  end
  def verified?
    !!verification
  end
end
