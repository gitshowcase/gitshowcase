module OverviewHelper
  def current_url_without_parameters
    request.base_url + request.path
  end

  def date_ago_link(title, time)
    date = Date.today - time
    url = "#{current_url_without_parameters}?date=#{date}"
    link_to title, url, method: :get, class: 'btn btn-primary btn-sm'
  end
end
