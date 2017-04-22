$(document).on 'turbolinks:load', ->
  $('.share-box').each ->
    $box = $(this)

    button = $box.find('.share-button:first')
    container = $box.find('.share-container:first')
    mask = container.find('.share-mask:first')

    button.click ->
      container.show()

    mask.click ->
      container.hide()
