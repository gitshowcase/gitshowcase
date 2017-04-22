$(document).on 'turbolinks:load', ->
  alerts = $('.alert')
  alerts.alert()

  # Hide after 2s
  setTimeout ->
    alerts.alert('close')
  , 3000
