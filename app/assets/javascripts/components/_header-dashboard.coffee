$(document).on 'turbolinks:load', ->
  alerts = $('.alert')
  alerts.alert()

  # Hide after 2s
  setTimeout ->
    true
  , 3000
