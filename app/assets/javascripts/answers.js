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
$(document).on('turbolink:load', ready);
$(document).on('page:update', ready);