$(document).on 'turbolinks:load', ->
  Projects.init() if $('#projects-view').length

window['Projects'] = {
  init: ->
    container = $('.projects:first')[0]

  show: (project_id) ->
    $.get('/dashboard/projects/' + project_id + ' /show')

  hide: (project_id) ->
    $.get('/dashboard/projects/' + project_id + '/hide')

  toggle: (element) ->
    el = $(element)

    parent = el.parents('[data-project-id]')
    project_id = parent.data('project-id')

    checked = el.is(':checked')
    if checked
      this.show(project_id)
      parent.removeClass('project-hidden')
    else
      this.hide(project_id)
      parent.addClass('project-hidden')
}
