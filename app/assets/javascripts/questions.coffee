# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data('questionId')
    $('.question .delete-attach-link').hide()
    $('form#edit-question-' + questionId).show()

  PrivatePub.subscribe '/questions/index', (data, channel) ->
    question = $.parseJSON(data["question"])
    question.url = '/questions/' + question.id
    question.isAuthor = question.user_id == gon.current_user
    $(".questions").append ->
      HandlebarsTemplates['questions/question_preview'](question)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
