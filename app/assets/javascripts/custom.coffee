$(document).on "turbolinks:load", ->
  $('div.calendar').calendar
    firstDayOfWeek: 1

  $('.calendar_range_start').calendar
    endCalendar: $('.calendar_range_end'),
    type: 'date',
    firstDayOfWeek: 1

  $('.calendar_range_end').calendar
    startCalendar: $('.calendar_range_start'),
    type: 'date',
    firstDayOfWeek: 1

  $('.ui.accordion').accordion()
  $('.ui.dropdown').dropdown
    action: 'hide'

  $('select.dropdown').dropdown()

  $('#calendar').fullCalendar
    firstDay: '1',
    eventSources: [
      '/calendars.json'
    ],
    timeFormat: 'H:mm',
    displayEventEnd: 'true',
    eventRender: (event, element) ->
      element.qtip
        content: {
          title: { text: event.title },
          text: event.description
        },
        position: {
          my: 'center center',
          at: 'top center'
        },
        style: {
          classes: 'qtip-green qtip-shadow qtip-rounded'
        }

      return
  $('i.close.icon').click ->
    $('#' + @closest('div').id).hide()
    return

