class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic

  def verification
    pk = Minisign::PublicKey.new(key.content)
    sig = Minisign::Signature.new(content.gsub(/\r/,''))
    pk.verify(sig, key.claim + "\n")
  end
end
