# frozen_string_literal: true

class ProofsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create create_identity]
  before_action :find_handle

  def show
    @key = @handle.keys.find_by_fingerprint(params[:key_id])
    @proof = @key.proofs.first
  end

  def claim; end

  def show_identity
    @proofs = @handle.identities.where(kind: kind_from_slug(params[:service]))
  end

  # rubocop:disable Metrics/AbcSize
  def create_identity
    public_claim_url = Proof.identities[params[:service].to_sym][:public_claim_url]&.call(params[:handle_id])
    public_claim_url ||= params[:public_claim_url]

    proof = create_proof_if_valid_signature(params[:handle_id], "#{params[:service]}_identity", public_claim_url)

    return render json: { error: 'invalid signature' } if proof.nil?
    return render json: { error: 'invalid public_claim_url' } if proof && !proof.valid_public_claim_url?

    render json: { success: true }
  end
  # rubocop:enable Metrics/AbcSize

  def create
    username = params[:username]
    proof = create_proof_if_valid_signature(username, params[:kind])
    if proof
      render json: { success: true }
    else
      render json: { error: 'invalid signature' }
    end
  end

  private

  def find_handle
    @handle = Handle.find_by_name(params[:handle_id])
  end

  # rubocop:disable Metrics/MethodLength
  def create_proof_if_valid_signature(username, kind, public_claim_url = nil)
    signature = params[:signature].read
    claim = params[:claim].read
    # rubocop:disable Style/HashEachMethods
    @handle.keys.each do |key|
      # rubocop:enable Style/HashEachMethods
      proof = key.proofs.new(
        claim:,
        signature:,
        username:,
        kind:,
        public_claim_url:
      )
      begin
        if proof.valid_signature?
          proof.save
          return proof
        end
      # rubocop:disable Lint/RescueException
      rescue Exception => e
        # rubocop:enable Lint/RescueException
        Rails.logger.error e
      end
    end
    nil
  end
  # rubocop:enable Metrics/MethodLength
end
