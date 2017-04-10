jQuery ($) ->
  $(document).on "turbolinks:load", ->
    $('.city-select').on 'change', (e) ->
      $('#stations').empty()
      city_id = $(this).prop('value')
      return unless city_id
      url = "/places/" + city_id + "/metro.json"
      jqxhr = $.get(url)
      jqxhr.done (data) ->
        load_stations(data)
      jqxhr.fail (xhr) ->
        show_errors($.parseJSON(xhr.responseText)['errors'])

    load_stations = (stations) ->
      $('#donation_place_id').empty()
      for station, index in stations
        $('#donation_place_id').append($("<option></option>").attr("value",station.id).text(station.name + ' (' +station.line + ')'));

    show_errors = (errors) ->
      $('#donation_place_id').empty()
      console.log(typeof errors)
      $.each errors, (index, error) ->
        elem = index.toString() + ' ' + error + "<br>"
        $('#donation_place_id').append(elem)