module ApplicationHelper
  def active(path)
    request.path == path ? 'active': ''
  end

  def project_list(member)
    if member.projects.present?
      member.projects.pluck(:name).join(',')
    else
      '-'
    end
  end
end
