class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic

  def verification
    pk = Minisign::PublicKey.new(key.content)
    pk.verify(Minisign::Signature.new(content), claim)
  end
  def verified?
    !!verification
  end
end
