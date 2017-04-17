$(document).on 'turbolinks:load', ->
  SetupCover.init() if $('.cover').length

SetupCover = {
  init: ->
    SetupCover.list = $('.cover')
    SetupCover.list.each -> SetupCover.initCover $(this)

  initCover: (cover) ->
    cover.click ->
      SetupCover.list.removeClass 'active'
      cover.toggleClass 'active'
      cover.find('img:first').attr 'src'
}
