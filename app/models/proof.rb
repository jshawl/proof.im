class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic

  def verification
    if key.kind == "minisign"
      pk = Minisign::PublicKey.new(key.content)
      pk.verify(Minisign::Signature.new(signature), claim)
    else
      pk = SSHData::PublicKey.parse_openssh(key.content)
      sig = SSHData::Signature.parse_pem(signature)
      if pk.fingerprint == sig.public_key.fingerprint && sig.verify(claim)
        "Signature and key fingerprint verified"
      end
    end
  end
  def verified?
    !!verification
  end
end
