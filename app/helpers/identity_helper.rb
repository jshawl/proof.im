# frozen_string_literal: true

module IdentityHelper
  def kind_from_slug(slug)
    Proof.kinds["#{slug}_identity"]
  end

  def identity_link(proof)
    service = Proof.identities[proof.slug.to_sym]
    link_to handle_identity_path(handle_id: @handle.name, service: proof.slug) do
      image_tag(service[:image][:path], alt: service[:image][:alt]) + proof.username
    end
  end
end
