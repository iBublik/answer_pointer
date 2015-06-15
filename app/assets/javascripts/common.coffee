showForm = (objectType) ->
  $(".edit-#{objectType}-link").click (e) ->
    e.preventDefault()
    $(this).hide()
    objectId = $(this).data("#{objectType}Id")
    $("form#edit-#{objectType}-" + objectId).show()

showErrors = (formSelector, errorHtml) ->
  $form = $(formSelector)
  $errors = $answerForm.children('.error_explanation')

  if $errors.length
    $errors.html(errorsHtml)
  else
    $answerForm.prepend(errorsHtml)
    $errors = $answerForm.children('.error_explanation')

  $errors.stop().css( {opacity: 1} ).fadeOut( 5000, (-> $(this).remove()) )