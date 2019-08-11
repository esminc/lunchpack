module ApplicationHelper
  def active(path)
    request.path == path ? 'active': ''
  end
end
