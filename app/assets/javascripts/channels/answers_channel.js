var ready;

ready = function() {
  var answersList;
  answersList = $(".answers-table");
    
  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      console.log('Connected to answers channel!');
      var question_id = $('.question').data('id');
      
      if (question_id) {
        return this.perform('follow_answers', {id: question_id});
      }
      else
      {
        return this.perform('unfollow');
      }
    }
    ,

    received: function(data) {
      var current_user_id = gon.current_user_id;
      var answer_user_id = JSON.parse(data["answer_user_id"]);

      if (current_user_id !== answer_user_id) {
        return answersList.append(JST["templates/answer"]({ data: data}));
      }
    }
  });
}

$(document).on('turbolinks:load', ready);