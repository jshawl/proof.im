# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def new
    @handle = Handle.new
  end
end
