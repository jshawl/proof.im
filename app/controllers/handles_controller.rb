class HandlesController < ApplicationController
  def index
  end
  def new
    @handle = Handle.new
  end
  def create
    @handle = Handle.find_or_create_by!(handle_params)
    redirect_to username_path(@handle.name)
  end
  def show
    @handle = Handle.find_by_name(params[:username])
  end
  private
  def handle_params
    params.require(:handle).permit(:name)
  end
end
