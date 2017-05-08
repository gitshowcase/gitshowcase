$(document).on 'turbolinks:load', ->
  AnalyticsOverview.init() if $('#analytics-overview-view').length

AnalyticsOverview = {
  init: ->
    google.charts.load('current', {'packages': ['corechart']});
    google.charts.setOnLoadCallback(AnalyticsOverview.draw)

  draw: ->
    AnalyticsOverview.drawGeneral()

  drawGeneral: ->
    data = AnalyticsOverview.dataTable([
      {name: 'daily_count_users', label: 'New Users'},
      {name: 'daily_count_projects', label: 'New Projects'}
    ])
    options = AnalyticsOverview.options {
      series: {
        0: {targetAxisIndex: 0},
        1: {targetAxisIndex: 1}
      },
      vAxes: {
        0: {title: 'New Users'},
        1: {title: 'New Projects'}
      }
    }

    chart = new google.visualization.LineChart($('#general-chart')[0]);
    chart.draw(data, options);

  options: (extra) ->
    Object.assign({
      width: '100%',
      height: '350',
      legend: 'bottom',
      chartArea: {left: 60, top: 20, right: 60, bottom: 60, width: '100%', height: '350'}
    }, extra || {})

  data: ->
    return AnalyticsOverview._data if AnalyticsOverview._data

    AnalyticsOverview._data = window.snapshots.map (array) ->
      array.date = 'Date(' + array.date.split('-').join(', ') + ')'
      array

  dataTable: (fields) =>
    cols = [
      {type: 'date', label: 'Date'},
    ].concat(fields)

    fields_with_date = ['date'].concat(fields)
    rows = AnalyticsOverview.data().map (row) ->
      fields_with_date.map (field) -> row[field.name || field]

    google.visualization.arrayToDataTable([cols].concat(rows))
}
