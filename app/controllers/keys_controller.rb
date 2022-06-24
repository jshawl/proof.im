class KeysController < ApplicationController
  def new
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.build
  end
  def create
    @handle = Handle.find_by_name(params[:handle_id])
    @key = @handle.keys.create!(key_params)
    redirect_to handle_path(id: @handle.name)
  end

  def index
    @handle = Handle.find_by_name(params[:handle_id])
    @keys = @handle.keys
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

  private
  def key_params
    params.require(:key).permit(:content)
  end
end
