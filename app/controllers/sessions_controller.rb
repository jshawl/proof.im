class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:proof]
  def new
    if params[:handle]
      @handle = Handle.find_by_name(params[:handle])
      @session_secret = SecureRandom.uuid
      @claim = @handle.name + ":" + @session_secret
    end
  end
  def create
    claim = params[:session][:claim] + "\n"
    proof = Proof.find_by_claim(claim)
    proof.verified?
    session['proven_claim'] = claim
    redirect_to new_session_path
  end
  def destroy
    session.clear
    # destroy the Proof.find_by_claim
    redirect_to new_session_path
  end
  def proof
    signature = params[:signature].read
    claim = Base64.decode64(request.headers['Authorization'].split("Basic ")[1])
    handle = claim.split(":")[0]
    @handle = Handle.find_by_name(handle)
    @key = @handle.keys.first
    p = Proof.create(
      key: @key,
      claim: claim + "\n",
      content: signature
    )
    render json: {handle: handle, claim: claim, signature: signature}
  end
end
