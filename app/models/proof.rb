require 'net/http'
class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  enum kind: [:key, :session, :identity]

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
  def valid_signature?
    !!verification
  end
  def verified?
    if kind == "identity"
      return public_claim_exists? && valid_signature?
    end
    valid_signature?
  end
  def public_claim_exists?
    # todo handle timeout
    # todo cache response
    resp = Net::HTTP.get(URI("https://news.ycombinator.com/user?id=#{username}"))
    !!resp.match("https:&#x2F;&#x2F;proof.im&#x2F;#{key.handle.name}&#x2F;on-hn")
  end
end
