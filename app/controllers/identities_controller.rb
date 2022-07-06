class IdentitiesController < ApplicationController
  def new
    @proof = Proof.new(
      
    )
    @handle = Handle.find_by_name(params[:handle_id])

  end
  def claim
    @handle = Handle.find_by_name(params[:handle_id])
  end
end
