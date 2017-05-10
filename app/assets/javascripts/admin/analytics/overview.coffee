$(document).on 'turbolinks:load', ->
  AnalyticsOverview.init() if $('#analytics-overview-view').length

AnalyticsOverview = {
  init: ->
    google.charts.load('current', {'packages': ['corechart']})
    google.charts.setOnLoadCallback(AnalyticsOverview.draw)

  draw: ->
    AnalyticsOverview.drawGeneral()
    AnalyticsOverview.drawUserCompleteness()
    AnalyticsOverview.drawDomainsInvitations()
    AnalyticsOverview.drawInvitationFunnel()

  drawGeneral: ->
    data = AnalyticsOverview.dataTable([
      {name: 'daily_count_users', label: 'New Users'}
      {name: 'daily_count_projects', label: 'New Projects'}
    ])

    options = AnalyticsOverview.options {
      series: {
        0: {targetAxisIndex: 0}
        1: {targetAxisIndex: 1}
      }
      vAxes: {
        0: {title: 'New Users'}
        1: {title: 'New Projects'}
      }
    }

    chart = new google.visualization.LineChart($('#general-chart')[0])
    chart.draw(data, options)

  drawUserCompleteness: ->
    data = AnalyticsOverview.dataTable([
      {name: 'avg_user_completeness', label: 'Average'}
      {name: 'daily_avg_user_completeness', label: 'Daily Average'}
      {name: 'daily_count_user_weak_completeness', label: 'Weak'}
      {name: 'daily_count_user_medium_completeness', label: 'Medium'}
      {name: 'daily_count_user_strong_completeness', label: 'Strong'}
      {name: 'daily_count_user_very_strong_completeness', label: 'Very Strong'}
    ])

    options = AnalyticsOverview.options {
      series: {
        0: {targetAxisIndex: 0}
        1: {targetAxisIndex: 0}
        2: {targetAxisIndex: 1}
        3: {targetAxisIndex: 1}
        4: {targetAxisIndex: 1}
        5: {targetAxisIndex: 1}
        6: {targetAxisIndex: 1}
      }
      vAxes: {
        0: {title: 'Average'}
        1: {title: 'Count'}
      }
    }

    chart = new google.visualization.LineChart($('#user-completeness-chart')[0])
    chart.draw(data, options)

  drawDomainsInvitations: ->
    data = AnalyticsOverview.dataTable([
      {name: 'daily_count_domains', label: 'Domains'}
      {name: 'daily_count_invitations', label: 'Invitations'}
    ])

    options = AnalyticsOverview.options {
      series: {
        0: {targetAxisIndex: 0}
        1: {targetAxisIndex: 1}
      },
      vAxes: {
        0: {title: 'Domains'}
        1: {title: 'Invitations'}
      }
    }

    chart = new google.visualization.LineChart($('#domains-invitations-chart')[0])
    chart.draw(data, options)

  drawInvitationFunnel: ->
    data = AnalyticsOverview.dataTable([
      {name: 'count_zero_invitations', label: '0'}
      {name: 'count_one_invitations', label: '1'}
      {name: 'count_two_invitations', label: '2'}
      {name: 'count_three_invitations', label: '3'}
      {name: 'count_four_invitations', label: '4'}
      {name: 'count_five_invitations', label: '5'}
      {name: 'count_six_more_invitations', label: '6+'}
    ])

    options = AnalyticsOverview.options()

    chart = new google.visualization.LineChart($('#invitation-funnel-chart')[0])
    chart.draw(data, options)

  options: (extra) ->
    Object.assign({
      width: '100%'
      height: '350'
      legend: 'bottom'
      chartArea: {left: 60, top: 20, right: 60, bottom: 60, width: '100%', height: '350'}
    }, extra || {})

  data: ->
    return AnalyticsOverview._data if AnalyticsOverview._data

    AnalyticsOverview._data = window.snapshots.map (row) ->
      date = row.date.split('-')
      date[1] = parseInt(date[1]) - 1

      row.date = 'Date(' + date.join(', ') + ')'
      row.avg_user_completeness = row.total_user_completeness / (row.count_users || 1)
      row.daily_avg_user_completeness = row.daily_total_user_completeness / (row.daily_count_users || 1)
      row

  dataTable: (fields) =>
    cols = [
      {type: 'date', label: 'Date'},
    ].concat(fields)

    fields_with_date = ['date'].concat(fields)
    rows = AnalyticsOverview.data().map (row) ->
      fields_with_date.map (field) -> row[field.name || field]

    google.visualization.arrayToDataTable([cols].concat(rows))
}
