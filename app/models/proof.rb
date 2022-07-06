class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  enum kind: [:key, :session, :hn_identity]

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

  def self.human_name_for_kind(kind)
    {
      hn_identity: 'Hacker News'
    }[kind.to_sym]
  end

  def self.identity_kinds
    self.kinds.select do |key, value|
      key.match /identity/
    end.transform_keys do |key|
      human_name_for_kind(key)
    end
  end
end
