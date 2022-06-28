class ProofsController < ApplicationController
  def create
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.find(params[:key_id])
    @claim = "I am proving that I am #{@handle.name} on proof.im with the following public key:
#{@key.content}"
    @proof = @key.create_proof(proof_params.merge(claim: @claim))
    redirect_to handle_key_proof_path(@handle.name, @key)
  end

  def show
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.find(params[:key_id])
    @proof = @key.proof
  end

  private

  def proof_params
    params.require(:proof).permit(:content)
  end
end
