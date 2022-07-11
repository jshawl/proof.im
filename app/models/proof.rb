# frozen_string_literal: true

require 'net/http'
class Proof < ApplicationRecord
  belongs_to :key # eventually polymorphic
  enum kind: %i[key session hn_identity github_identity]

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
    if kind.match /identity/
      return public_claim_exists? && valid_signature?
    end

    valid_signature?
  end

  def slug
    if kind == 'hn_identity'
      'hn'
    end
  end

  # def public_claim_url
  #   if kind == 'hn_identity'
  #     "https://news.ycombinator.com/user?id=#{username}"
  #   end
  # end

  def public_claim_exists?
    # TODO: handle timeout
    # todo cache response
    resp = Net::HTTP.get(URI(public_claim_url))
    !!(resp.match("https:&#x2F;&#x2F;proof.im&#x2F;#{key.handle.name}&#x2F;on-#{slug}") || resp.match("https://proof.im/#{key.handle.name}/on-#{slug}"))
  end
  
end
