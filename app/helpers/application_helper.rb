module ApplicationHelper
  def inside_layout(layout = 'application', &block)
    render :inline => capture(&block), :layout => "layouts/#{layout}"
  end
end
