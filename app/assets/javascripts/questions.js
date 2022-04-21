$(document).on('turbolinks:load', function(){

  $('a.edit-question').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#edit-question-' + questionId).show();
  });

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      return this.perform('follow');
    },

    received: function(data) {
      let question = JSON.parse(data)
      let question_title = question['title']
      let question_body = question['body']
      let question_url = 'questions/' + question['id']
        
      $('.questions').append(JST['templates/question']({question_title: question_title, question_body: question_body }))
    }
  });
});
