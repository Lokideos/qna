var ready;
ready = function() {
  $('.edit-answer-link').click(function(e) {
    e.preventDefault();
    
    $(this).hide();
    answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  });
};
$(document).ready(ready);
$(document).on('turbolinks:load',ready);
$(document).on('turbolinks:update',ready);