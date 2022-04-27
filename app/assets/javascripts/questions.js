//= require commentable

$(document).on('turbolinks:load', function(){
  $('a.edit-question').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#edit-question-' + questionId).show();
  });

  $('a.comment-for-question-link').click(function(e) {
    e.preventDefault();
    showForm($(this))
  })
  
  $('form.comment-for-question').on('ajax:success', function(e) {
    let comment = e['detail'][0]
    let user = gon.user
    hideForm('question')
    $('.comments-for-question').append(JST['templates/comment']({comment: comment, user: user}))
  })

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      return this.perform('follow');
    },

    received: function(data) {
      let question = JSON.parse(data)
      let title = question['title']
      let rating = question['raiting']
      let url = 'questions/' + question['id']
      let id = question['id']
        
      $('.questions').append(JST['templates/question']({ question_title: title, question_url: url, question_raiting: rating, id: id }))
    }
  });
});
