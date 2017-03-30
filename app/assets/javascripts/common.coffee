jQuery ($) ->
  $(document).on "turbolinks:load", ->
    #welcome page player initialize
    $(".player").mb_YTPlayer()

    $(".notification").delay(3000).toggle('fadeout')

    $('[data-provider="summernote"]').each ->
      $(this).summernote
        height: 400
        popover: false
        toolbar: [
          ['style', ['bold', 'italic', 'underline', 'clear']],
          ['font', ['strikethrough', 'superscript', 'subscript']],
          ['fontsize', ['fontsize']],
          ['color', ['color']],
          ['para', ['ul', 'ol', 'paragraph', 'hr']],
          ['height', ['height']],
          ['misc', ['fullscreen', 'codeview']]
        ]
