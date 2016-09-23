ready = ->
  $('.button-collapse').sideNav()
  $('.parallax').parallax()
  $('.modal-trigger').leanModal()
  $('select').material_select()
  $('.dropdown-button').dropdown()

  $notice = $('.notice')
  if ($notice.text() != '')
    Materialize.toast($notice, 5000)

  $alert = $('.alert')
  if ($alert.text() != '')
    Materialize.toast($alert, 10000, 'orange')
    
  $errors = $('#error_explanation')
  if ($errors)
    Materialize.toast($errors, 10000 ,'red')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)