var ready;
ready = function() {
  $('a.rate-good-question').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    $('.current_rating').html('');
    $('.current_rating').html('<p>Question Rating: ' + rating + '</p>');
  });
  $('a.rate-bad-question').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    $('.current_rating').html('');
    $('.current_rating').html('<p>Question Rating: ' + rating + '</p>');
  });
};
$(document).ready(ready);
$(document).on('turbolinks:load',ready);
