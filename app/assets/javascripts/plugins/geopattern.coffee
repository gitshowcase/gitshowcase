$(document).on 'turbolinks:load', ->
  $('[data-geopattern]').each ->
    $this = $(this)
    $this.geopattern $this.data('geopattern').toString()
