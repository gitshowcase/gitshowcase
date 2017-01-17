# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  homeView = $('.home-view')
  return unless homeView.length

  header = $('#header')
  navbar = header.find('.navbar:first')
  presenter = homeView.find('.presenter:first')

  handleNavbarcolor = ->
    if $(document).scrollTop() > (presenter.height() - navbar.height() * 4)
      header.removeClass('transparent')
    else header.addClass('transparent')

  $(document).scroll(handleNavbarcolor)
  handleNavbarcolor()
