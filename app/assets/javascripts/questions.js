var ready;

ready = function() {
  var questionsList;
  questionsList = $(".questions-list");

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

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Connected!');
      return this.perform('follow');
    }
    ,

    received: function(data) {
      var current_user_id = gon.current_user_id;      
      var parsed_question = JSON.parse(data);
      var question_user_id = parsed_question.user_id;            
      return questionsList.append(JST["templates/question"]({ data: parsed_question}));
      // var table = document.getElementById("questions-list");
      // var row = table.insertRow(-1);
      // var cell1 = row.insertCell(0);
      // var cell2 = row.insertCell(1);
      // var cell3 = row.insertCell(2);
      // var cell4 = row.insertCell(3);
      // return cell1.innerHTML = parsed_question.title;
      // return questionsList.append(parsed_question.title);
      // return questionsList.append(parsed_question.user_id);
    }
  });  
};

$(document).on('turbolinks:load', ready);