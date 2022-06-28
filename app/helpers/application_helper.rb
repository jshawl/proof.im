module ApplicationHelper
  def current_handle
    return nil unless session['proven_claim']
    session['proven_claim'].split(":")[0]
  end
end
