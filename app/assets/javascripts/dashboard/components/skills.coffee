$(document).on 'turbolinks:load', ->
  Skills.init() if $('.skills').length

Skills = {
  init: ->
# Set template
    template = $('.skill-template')
    this.template = template.html()
    template.remove()

    # Start Sortable
    container = $('.skills:first')[0]
    sort = Sortable.create container, {
      animation: 150,
      handle: ".skill-handler",
      draggable: ".skill"
    }

    $('.skill').each ->
      Skills.initSkill $(this)

    this.createNew()

  initSkill: (el) ->
    el.find('.skill-remove').click ->
      el.remove()
    this.initStars(el)

  initStars: (el) ->
    mastery = el.find('[name="mastery[]"]')

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
    $('.skills:first').append(created)

    removeButton = created.find('.skill-remove')
    removeButton.hide()

    name = created.find('[name]')
    name.on 'input', ->
      removeButton.show()
      name.off 'input'
      Skills.createNew()
}
