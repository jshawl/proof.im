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

  def tab_for(title, &)
    @headers ||= []
    @headers << title
    @bodies ||= []
    @bodies << capture(&)
  end

  def tabs
    yield
    render 'tabs', headers: @headers, bodies: @bodies
  end
end
