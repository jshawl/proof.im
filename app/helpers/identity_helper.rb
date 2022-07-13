# frozen_string_literal: true

module IdentityHelper
  MAPPINGS = {
    hn: {
      image: {
        path: 'hn.png',
        alt: 'Y Combinator Logo'
      },
      claim_url_regex: %r{^https://news\.ycombinator\.com/user\?id=[a-zA-Z_]+$}
    },
    github: {
      image: {
        path: 'github.png',
        alt: 'GitHub Logo'
      },
      claim_url_regex: %r{^https://gist.github.com/[a-zA-Z0-_-]+/[a-z0-9]+}
    }
  }.freeze

  def kind_from_slug(slug)
    Proof.kinds["#{slug}_identity"]
  end

  def identity_link(proof)
    service = MAPPINGS[proof.slug.to_sym]
    link_to handle_identity_path(handle_id: @handle.name, service: proof.slug) do
      image_tag(service[:image][:path], alt: service[:image][:alt]) + proof.username
    end
  end
end
