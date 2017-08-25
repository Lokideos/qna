var ready;
ready = function() {
  $('a.change-rate-question').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    $('.current_rating').html('');
    $('.current_rating').html('<p>Question Rating: ' + rating + '</p>');
    $('.rating_saved_vote').hide();
    $('.rating_options_vote').hide();
    $('.rating_options_cancel').show();
  });

  $('a.cancel-rate-question').bind('ajax:success', function (e, data, status, xhr) {
    var rating = $.parseJSON(xhr.responseText);
    $('.current_rating').html('');
    $('.current_rating').html('<p>Question Rating: ' + rating + '</p>');
    $('.rating_saved_cancel').hide();
    $('.rating_options_cancel').hide();
    $('.rating_options_vote').show();
  });  
};
$(document).ready(ready);
$(document).on('turbolinks:load',ready);
