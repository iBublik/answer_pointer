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

  addAnswer = (data) ->
    $('.answers-count').html("#{data.answers_count} Answers")
    answer = data.answer
    answer.isAuthor = answer.user_id == gon.current_user

    answer.attachments = data.attachments
    for attach in answer.attachments
      attach.name = attach.file.url.split('/').slice(-1)[0]

    $('.answers').append ->
      HandlebarsTemplates['answers/answer'](answer)

    $("#answer-#{answer.id}").find('.solution-link').remove() unless gon.current_user

    $editForm = $('#new_answer').clone()
    $editForm.attr('id', "edit-answer-#{answer.id}")
             .attr('action', "/answers/#{answer.id}")
             .attr('data-remote', 'true')
             .removeClass('new_answer')
             .addClass('edit_answer')
             .prepend('<input type="hidden" name="_method" value="patch">')
    $editForm.find('input[type="submit"]')
             .addClass('save-answer-btn')
             .attr('input_html', "{:data=>{:answer_id=>#{answer.id}}}")
             .attr('value', 'Save')
    $editForm.find('.answer_body textarea').val("#{answer.body}")

    $("#answer-#{answer.id}").append($editForm)


  questionId = $('.question').data('questionId')
  PrivatePub.subscribe "/questions/#{questionId}/answers", (data, channel) ->
    response = $.parseJSON(data["response"])
    addAnswer(response)

  $('form.new_answer').on 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)

    $(@).find('#answer_body').val('')
    addAnswer(response) if !$("#answer-#{response.answer.id}").length

    $('.notice').html('Your answer successfully added')
  .on 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)

    $form = $(@).closest('form')
    $errors = $form.children('.error_explanation')
    errorsHtml = HandlebarsTemplates['shared/errors'](response)

    if $errors.length
      $errors.html(errorsHtml)
    else
      $form.prepend(errorsHtml)
      $errors = $form.children('.error_explanation')

    $errors.stop().css( {opacity: 1} ).fadeOut 5000, ->
        $(@).remove()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
