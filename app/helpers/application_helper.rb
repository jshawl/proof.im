module ApplicationHelper
  def current_handle
    return nil unless session['proven_claim']
    session['proven_claim'].split(":")[0]
  end
  def session_proof
    Proof.find_by_claim(session['proven_claim']+"\n")
  end

  def handle_key_claim(handle, key)
    "I am proving that I am #{handle} on proof.im with the following public key:\n#{key}"
  end
end
