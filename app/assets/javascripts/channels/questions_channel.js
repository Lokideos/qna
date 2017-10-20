var ready;

ready = function() {
  var questionsList;
  questionsList = $(".questions-list");
  
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
    }
  });
};

$(document).on('turbolinks:load', ready);