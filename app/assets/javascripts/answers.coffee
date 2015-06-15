# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answerId = $(this).data('answerId')
    $answer = $(this).closest('#answer-' + answerId)
    $answer.find('.delete-attach-link').hide()
    $answer.find('.solution-link').hide()
    $answer.find('form#edit-answer-' + answerId).show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)