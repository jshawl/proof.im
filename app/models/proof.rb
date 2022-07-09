# frozen_string_literal: true

require 'net/http'
class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  enum kind: %i[key session identity]

  def verification
    if key.kind == 'minisign'
      minisign_verification
    else
      ssh_verification
    end
  end

  def ssh_verification
    pk = SSHData::PublicKey.parse_openssh(key.content)
    sig = SSHData::Signature.parse_pem(signature)
    'Signature and key fingerprint verified' if pk.fingerprint == sig.public_key.fingerprint && sig.verify(claim)
  end

  def minisign_verification
    pk = Minisign::PublicKey.new(key.content)
    pk.verify(Minisign::Signature.new(signature), claim)
  end

  def valid_signature?
    !!verification
  end

  def verified?
    return public_claim_exists? && valid_signature? if kind == 'identity'

    valid_signature?
  end

  def public_claim_exists?
    # TODO: handle timeout
    # todo cache response
    resp = Net::HTTP.get(URI("https://news.ycombinator.com/user?id=#{username}"))
    !!resp.match("https:&#x2F;&#x2F;proof.im&#x2F;#{key.handle.name}&#x2F;on-hn")
  end
end
