ready = ->
  $('.vote-link').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $votableRating = $('#' + response.type + "-#{response.id} .rating")
    $votableRating.find('.rating-value').text("Rating: #{response.rating}")
    $votableRating.find('.vote-link').show()
    $votableRating.find(".vote-#{response.action}").hide()
    $cancelDOM = $votableRating.find('.vote-cancel')
    $cancelLink = $cancelDOM.find('a')
    $cancelDOM.html("Voted #{response.action}")
    $cancelDOM.append($cancelLink)
    $cancelDOM.show()
    $('.notice').text(response.message)
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.error').text(response.error)

  $('.vote-cancel').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $votableRating = $('#' + response.type + "-#{response.id} .rating")
    $votableRating.find('.rating-value').text("Rating: #{response.rating}")
    $votableRating.find('.vote-link').show()
    $votableRating.find('.vote-cancel').hide()
    $('.notice').text(response.message)
  .bind 'ajax:error', (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $('.error').text(response.error)

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
