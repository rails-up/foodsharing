jQuery ($) ->
  $(document).on "turbolinks:load", ->
    $(".player").mb_YTPlayer()
