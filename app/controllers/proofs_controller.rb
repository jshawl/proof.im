class ProofsController < ApplicationController
  def show
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.find(params[:key_id])
    @proof = @key.proof
  end

  private

  def proof_params
    params.require(:proof).permit(:content, :claim)
  end
end
