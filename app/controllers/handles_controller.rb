# frozen_string_literal: true

class HandlesController < ApplicationController
  def index; end

  def create
    @handle = Handle.find_or_create_by!(handle_params)
    redirect_to new_handle_key_path(handle_id: @handle.name)
  end

  def show
    @handle = Handle.find_by_name(params[:id])
    raise ActionController::RoutingError, 'not found' if @handle.nil?
  end

  private

  def handle_params
    params.require(:handle).permit(:name)
  end
end
