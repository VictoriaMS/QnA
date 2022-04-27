$(document).on('turbolinks:load', function(){

  $('a.edit-question').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#edit-question-' + questionId).show();
  });

  $('a.add-comment-link').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#add_comment_for_question_' + questionId).show();
  })
  
  $('form.add-comment').on('ajax:success', function(e) {
    let comment = e['detail'][0]
    let user = gon.user
    $('#comment_body').val('')
    $('form.add-comment').hide()
    $('a.add-comment-link').show()
    $('.comments').append(JST['templates/comment']({comment: comment, user: user}))
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
