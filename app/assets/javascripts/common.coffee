jQuery ($) ->
  $(document).on "turbolinks:load", ->
    #welcome page player initialize
    $(".player").mb_YTPlayer()

    $(".notification").delay(3000).toggle('fadeout')
