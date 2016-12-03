jQuery ($) ->
  $(document).on "turbolinks:load", ->
    $('.city-select').on 'change', (e) ->
      $('#stations').empty()
      city_id = $(this).prop('value')
      url = "/cities/" + city_id + "/subway"
      jqxhr = $.get(url)
      jqxhr.done (data) ->
        load_stations(data)
      jqxhr.fail (xhr) ->
        # console.log(xhr.responseText)
        show_errors($.parseJSON(xhr.responseText)['errors'])

    load_stations = (stations) ->
      # target = $(e.target).parents('.parent-class')
      # if (target.hasClass('parent-class'))
      $('#stations').empty()
      for station, index in stations
        # console.log(station)
        elem = index.toString() + ' ' + station + "<br>"
        $('#stations').append(elem)

    show_errors = (errors) ->
      $('#stations').empty()
      # console.log(typeof errors)
      $.each errors, (index, error) ->
        elem = index.toString() + ' ' + error + "<br>"
        $('#stations').append(elem)
