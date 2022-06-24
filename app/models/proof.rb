class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic

  def verification
    pk = Minisign::PublicKey.new(key.content)
    sig = Minisign::Signature.new(content)
    pk.verify(sig, key.claim + "\n")
  end
end
