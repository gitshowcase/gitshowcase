$(document).on 'turbolinks:load', ->
  Domain.init() if $('#users-domain-view .steps').length

Domain = {
  steps: []

  init: ->
    this.initInvitationLink()

    this.steps = $('.step')
    this.steps.click (e) ->
      e.preventDefault()
      Domain.select($(this))

    this.select this.step()

  initInvitationLink: ->
    el = $('#invitation-link')
    new Clipboard('#' + el.attr('id'))

    el.tooltip({
      trigger: 'click',
      placement: 'bottom'
    })

    el.on('shown.bs.tooltip', ->
      setTimeout ->
        el.tooltip('hide')
      , 2000
    )

  select: (step) ->
    location.hash = step.attr('href')
    this.steps.removeClass 'active'
    step.addClass 'active'

  step: (hash) ->
    step = hash || location.hash || this.guess()
    result = this.steps.filter('[href="' + step + '"]')

    result = this.step('#choose') unless result.length
    result

  guess: ->
    return '#choose' unless $('input[name="user[domain]"]').val()
    return '#invite' if $('#invite .progress-content').length

    return '#configure'
}
