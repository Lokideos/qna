var ready;
ready = function() {
  $(document).on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    
    $(this).hide();
    answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  });

  $('a.change-rate-answer').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    var answerId = $(this).data('answerId');
    $('.answer-rating-value-' + answerId).html('');
    $('.answer-rating-value-' + answerId).html('<p>Answer Rating: ' + rating + '</p>');
    $('.rating-saved-vote-answer-' + answerId).hide();
    $('.rating-options-vote-answer-' + answerId).hide();
    $('.rating-options-cancel-answer-' + answerId).show();
  });

  $('a.cancel-rate-answer').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    var answerId = $(this).data('answerId');
    $('.answer-rating-value-' + answerId).html('');
    $('.answer-rating-value-' + answerId).html('<p>Answer Rating: ' + rating + '</p>');
    $('.rating-saved-cancel-answer-' + answerId).hide();
    $('.rating-options-cancel-answer-' + answerId).hide();
    $('.rating-options-vote-answer-' + answerId).show();
  });
  
};
$(document).ready(ready);
$(document).on('turbolinks:load',ready);
