$(document).on 'turbolinks:load', ->
  fn = ->
    $this = $(this)
    group = $this.parents('.form-group:first')

    focused = $this.is(':focus')
    group.toggleClass('form-group-focused', focused)
    group.toggleClass('form-group-empty', !(focused || $this.val().length))

  inputs = $('input[type="text"].form-control, input[type="email"].form-control')
  inputs.each fn
  inputs.on 'input focus blur', fn
