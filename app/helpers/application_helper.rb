# frozen_string_literal: true

module ApplicationHelper
  def current_handle
    return nil unless session['proven_claim']

    session['proven_claim'].split(':')[0]
  end

  def session_proof
    Proof.session.find_by_claim("#{session['proven_claim']}\n")
  end

  def handle_key_claim(handle, key)
    "I am proving that I am #{handle} on proof.im with the following public key:\n#{key}"
  end

  def identity_link(proof)
    if proof.kind == 'hn_identity'
      slug = 'hn'
      alt = 'Y Combinator Logo'
    end
    if proof.kind == 'github_identity'
      slug = 'github'
      alt = 'GitHub logo'
    end
    link_to handle_identity_path(handle_id: @handle.name, service: slug) do 
      image_tag("#{slug}.png", alt: alt) + proof.username 
    end
  end
end
