# frozen_string_literal: true

module IdentityHelper
  MAPPINGS = {
    hn: {
      image: {
        path: 'hn.png',
        alt: 'Y Combinator Logo'
      }
    },
    github: {
      image: {
        path: 'github.png',
        alt: 'GitHub Logo'
      }
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
