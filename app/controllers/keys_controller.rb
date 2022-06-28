class KeysController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:proof]

  def new
    @handle = Handle.find_by_name(params[:handle_id])
    if @handle.keys.any?
      flash[:notice] = 'This handle has already been claimed'
      return redirect_to handle_path(id: @handle.name)
    end
    @key = @handle.keys.build
  end
  def create
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.create!(key_params)
    redirect_to handle_key_path(handle_id: @handle.name, id: @key.id)
  end
  def show
    @handle = Handle.find_by_name(params[:handle_id])
    @key = Handle.find_by_name(params[:handle_id]).keys.find(params[:id])
    @proof = @key.proof || @key.build_proof
  end

  def claim
    @handle = Handle.find_by_name(params[:handle_id])
    @key = Handle.find_by_name(params[:handle_id]).keys.find(params[:key_id])
  end

  def proof
    signature = params[:signature].read
    claim = params[:claim].read
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.first
    pro = Proof.create!(
      key: @key,
      claim: claim,
      content: signature
    )
    pro.verified?
    render json: pro
  end

  private
  def key_params
    params.require(:key).permit(:content)
  end
end
