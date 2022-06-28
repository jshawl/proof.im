class SessionsController < ApplicationController
  def new
    if current_handle
      return redirect_to handle_path(id: current_handle)
    end
    if params[:handle]
      @handle = Handle.find_by_name(params[:handle])
      if @handle.nil?
        flash[:notice] = "That handle hasn't been claimed yet. <a href='/registrations/new'>Claim It</a>"
        return redirect_to new_session_path
      end
      @session_secret = SecureRandom.uuid
      @claim = @handle.name + ":" + @session_secret
    end
  end
  def create
    claim = params[:session][:claim]
    proof = Proof.find_by_claim(claim + "\n")
    begin
      proof.verified?
    rescue
      flash[:notice] = 'No proof of that claim exists. Try again?'
      return redirect_back(fallback_location: new_session_path)
    end
    flash[:notice] = 'Logged in successfully!'
    session['proven_claim'] = claim
    redirect_to handle_path(id: current_handle)
  end
  def destroy
    session.clear
    # destroy the Proof.find_by_claim
    redirect_to new_session_path
  end
end
