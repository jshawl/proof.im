class RegistrationsController < ApplicationController
  def new
    @handle = Handle.new
  end
end
