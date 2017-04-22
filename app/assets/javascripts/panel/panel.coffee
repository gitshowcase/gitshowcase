$(document).on 'turbolinks:load', ->
  $('.menu nav a[href="' + location.pathname + '"]')
    .addClass('active')
