showForm = (objectType) ->
  $(".edit-#{objectType}-link").click (e) ->
    e.preventDefault()
    $(this).hide()
    objectId = $(this).data("#{objectType}Id")
    $("form#edit-#{objectType}-" + objectId).show()