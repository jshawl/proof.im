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

  def create_identity
    username = params[:handle_id]
    public_claim_url = if params[:service] == 'hn'
                         "https://news.ycombinator.com/user?id=#{username}"
                       else
                         params[:public_claim_url]
                       end
    create_proof_if_valid_signature(username, "#{params[:service]}_identity", public_claim_url)
    head 200
  end

  def create
    username = params[:username]
    create_proof_if_valid_signature(username, params[:kind])
    head 200
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
        proof.save if proof.valid_signature?
      # rubocop:disable Lint/RescueException
      rescue Exception => e
        # rubocop:enable Lint/RescueException
        Rails.logger.error e
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
