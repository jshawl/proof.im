class SessionsController < ApplicationController
  def new
    if params[:handle]
      @handle = Handle.find_by_name(params[:handle])
      @session_secret = SecureRandom.uuid
      @claim = @handle.name + ":" + @session_secret
    end
  end
  def create
    claim = params[:session][:claim]
    proof = Proof.find_by_claim(claim + "\n")
    proof.verified?
    session['proven_claim'] = claim
    redirect_to new_session_path
  end
  def destroy
    session.clear
    # destroy the Proof.find_by_claim
    redirect_to new_session_path
  end
end
