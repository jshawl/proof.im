module IdentityHelper
  def slug_from_proof(proof)
    proof.kind.gsub(/_identity/,'')
  end
  def kind_from_slug(slug)
    Proof.kinds[slug + "_identity"]
  end
  def identity_link(proof)
    mappings = {
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
    }
    slug = slug_from_proof(proof)
    service = mappings[slug.to_sym]
    link_to handle_identity_path(handle_id: @handle.name, service: slug) do 
      image_tag(service[:image][:path], alt: service[:image][:alt]) + proof.username 
    end
  end
end
