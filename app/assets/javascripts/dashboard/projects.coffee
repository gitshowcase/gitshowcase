# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  Projects.init() if $('#projects-index-view').length

window['Projects'] = {
  init: ->
    container = $('.projects:first')[0]
    sort = Sortable.create container, {
      animation: 150,
      handle: ".project-handler",
      draggable: ".project",
      onUpdate: (event) ->
        Projects.order()
    }

  order: ->
    list = []
    $('.projects [data-project-id]').each ->
      list.push $(this).data('project-id')
    $.post("projects/order", {order: list})

  show: (project_id) ->
    $.get('projects/' + project_id + ' /show')

  hide: (project_id) ->
    $.get('projects/' + project_id + '/hide')

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
