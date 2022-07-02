class KeysController < ApplicationController
  def new
    @handle = Handle.find_by_name(params[:handle_id])
    if @handle.keys.any? && !current_handle
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
    @proof = @key.proofs.key.first || @key.proofs.new
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
