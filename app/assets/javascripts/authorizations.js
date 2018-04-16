$(function() {
  return $(document).ajaxError(function(event, xhr, ajaxOptions, thrownError) {
    var type;
    type = xhr.getResponseHeader("content-type");
    if (!type) {
      return;
    }
    if (type.indexOf('text/javascript') >= 0) {
      return $('p.js-json-alert').text(xhr.responseText);
    } else if (type.indexOf('application/json') >= 0) {
      return $('p.js-json-alert').text($.parseJSON(xhr.responseText)['error']);
    }
  });
});