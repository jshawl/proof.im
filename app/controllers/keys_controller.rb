# frozen_string_literal: true

class KeysController < ApplicationController
  before_action :find_handle
  def new
    if @handle.keys.any? && !current_handle
      flash[:notice] = 'This handle has already been claimed'
      return redirect_to handle_path(id: @handle.name)
    end
    @key = @handle.keys.build
  end

  def create
    @key = @handle.keys.create!(key_params)
    redirect_to handle_key_path(handle_id: @handle.name, id: @key.fingerprint)
  end

  def edit
    @key = @handle.keys.find_by_fingerprint(params[:id])
  end

  def update
    @key = @handle.keys.find_by_fingerprint(params[:id])
    if @key.update(key_params)
      redirect_to handle_key_path(handle_id: @handle.name, id: @key.fingerprint)
    else
      flash[:notice] = "not a valid public key"
      redirect_to edit_handle_key_path(handle_id: @handle.name, id: @key.fingerprint)
    end
  end

  def show
    @key = @handle.keys.find_by_fingerprint(params[:id])
    @proof = @key.proofs.key.first || @key.proofs.new
  end

  def claim
    @key = @handle.keys.find_by_fingerprint(params[:key_id])
  end

  private

  def find_handle
    @handle = Handle.find_by_name(params[:handle_id])
  end

  def key_params
    params.require(:key).permit(:content)
  end
end
