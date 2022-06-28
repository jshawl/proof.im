class ProofsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.find(params[:key_id])
    @proof = @key.proof
  end

  def create
    signature = params[:signature].read
    claim = params[:claim].read
    handle = params[:handle]
    @handle = Handle.find_by_name(handle)
    @key = @handle.keys.first
    Proof.create!(
      key: @key,
      claim: claim,
      signature: signature
    ).verified?

    head 200
  end
end
