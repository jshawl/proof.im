class ProofsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :create_identity]

  def show
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.find(params[:key_id])
    @proof = @key.proofs.first
  end

  def claim
    @handle = Handle.find_by_name(params[:handle_id])
  end

  def show_identity
    @handle = Handle.find_by_name(params[:handle_id])
    key_ids = @handle.keys.pluck(:id)
    @proofs = Proof.where('key_id in (?)', key_ids).where(kind: 'identity')
  end

  def create_identity
    username = params[:handle_id]
    create_proof_if_verified(username,"identity")
    head 200
  end

  def create
    username = params[:username]
    create_proof_if_verified(username, params[:kind])
    head 200
  end

  private

  def create_proof_if_verified(username,kind)
    handle = params[:handle_id]
    signature = params[:signature].read
    claim = params[:claim].read
    @handle = Handle.find_by_name(handle)
    @handle.keys.each do |key|
      proof = Proof.new(
        key: key,
        claim: claim,
        signature: signature,
        username: username,
        kind: kind
      )
      begin
        if proof.verified?
          proof.save
        end
      rescue Exception => e
        Rails.logger.error e
      end
    end
  end
end
