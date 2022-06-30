class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic

  def verification
    if key.kind == "ssh-rsa"
      pk = SSHData::PublicKey.parse_openssh(key.content)
      sig = SSHData::Signature.parse_pem(signature)
      pk.fingerprint == sig.public_key.fingerprint && sig.verify(claim)
    else
      pk = Minisign::PublicKey.new(key.content)
      pk.verify(Minisign::Signature.new(signature), claim)
    end
  end
  def verified?
    !!verification
  end
end
