# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  Skills.init() if $('.user-skills-view').length

window['Skills'] = {
  init: ->
    # Set template
    template = $('.skill-edit-template')
    this.template = template.html()
    template.remove()

    # Start Sortable
    container = $('.skills-edit:first')[0]
    sort = Sortable.create container, {
      animation: 150,
      handle: ".skill-handler",
      draggable: ".skill-edit"
    }

    $('.skill-edit').each ->
      Skills.initSkill $(this)

    this.createNew()

  initSkill: (el) ->
    el.find('.skill-remove').click ->
      el.remove()
    this.initStars(el)

  initStars: (el) ->
    mastery = el.find('[name="mastery"]')

    stars = el.find('.skill-stars')
    stars.find('.skill-star').each ->
      $this = $(this)
      index = $this.index()

      hoverClass = 'skill-star-hover'
      normalClass = 'fa-star-o'
      activeClass = 'fa-star'

      $this.hover ->
        $this.parent().find('.skill-star')
          .removeClass(hoverClass)
          .filter(':lt(' + (index + 1) + ')')
          .addClass(hoverClass)
      , ->
        $this.parent().find('.skill-star').removeClass(hoverClass)

      $this.click ->
        mastery.val(index + 1)
        $this.parent().find('.skill-star')
          .filter(':gt(' + index + ')')
          .removeClass(activeClass)
          .addClass(normalClass)

        $this.parent().find('.skill-star')
          .filter(':lt(' + (index + 1) + ')')
          .removeClass(normalClass)
          .addClass(activeClass)

  createNew: ->
    created = $(this.template)
    this.initSkill created
    $('.skills-edit:first').append(created)

    removeButton = created.find('.skill-remove')
    removeButton.hide()

    name = created.find('[name]')
    name.on 'input', ->
      removeButton.show()
      name.off 'input'
      Skills.createNew()

  save: (url) ->
    skills = {}
    $('.skill-edit').each ->
      $this = $(this)
      name = $this.find('[name="name"]').val()
      return unless name.length

      mastery = parseInt($this.find('[name="mastery"]').val())
      skills[name] = mastery

    $.ajax({
      url,
      method: 'put',
      data: {user: {skills}}
    })
}
