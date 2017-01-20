# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  Project.init() if $('.dashboard-layout .index-view')

Projects = {
  init: ->
    false

  move: ->
    false

  show: ->
    false

  hide: ->
    false

  showAction: name ->
    false
}
