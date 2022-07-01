class ProofsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.find(params[:key_id])
    @proof = @key.proofs.first
  end

  def create
    signature = params[:signature].read
    claim = params[:claim].read
    handle = params[:handle]
    @handle = Handle.find_by_name(handle)
    @handle.keys.each do |key|
      proof = Proof.new(
        key: key,
        claim: claim,
        signature: signature
      )
      begin
        if proof.verified?
          proof.save
        end
      rescue Exception => e
        Rails.logger.error e
      end
    end
    head 200
  end
end
