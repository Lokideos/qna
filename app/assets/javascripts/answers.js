var ready;
ready = function() {
  $(document).on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    
    $(this).hide();
    answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  });

  $('a.rate-good-answer').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    var answerId = $(this).data('answerId');
    $('.answer-rating-' + answerId).html('');
    $('.answer-rating-' + answerId).html('<p>Answer Rating: ' + rating + '</p>');
  });

  $('a.rate-bad-answer').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    var answerId = $(this).data('answerId');
    $('.answer-rating-' + answerId).html('');
    $('.answer-rating-' + answerId).html('<p>Answer Rating: ' + rating + '</p>');
  });
};
$(document).ready(ready);
$(document).on('turbolinks:load',ready);
