module ApplicationHelper
  def current_handle
    session['proven_claim']&.split(":")&[0]
  end
end
