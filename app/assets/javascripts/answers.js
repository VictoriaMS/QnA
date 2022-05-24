//= require commentable

$(document).on('turbolinks:load', function(){
  $('a.edit-answer').click(function(e){
    e.preventDefault();
    let answerId = $(this).data('answerId')
    $(this).toggle()
    $('form#edit-answer-' + answerId ).toggle()
  })

  $('a.comment-for-answer-link').click(function(e) {
    e.preventDefault();
    showForm($(this))
  })

  $('form.comment-for-answer').on('ajax:success', function(e) {
    let comment = e['detail'][0].comment
    let user = gon.user
    let answerId = comment.commentable_id
    hideForm('answer')
    $('.comments-for-answer-' + answerId).append(JST['templates/comment']({comment: comment, user: user}))
  })

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      let question = gon.question
      return this.perform('follow', { question: question })
    },
    received: function(data) {
      let answer = JSON.parse(data)
      let user = gon.user

      $('.answers').append(JST['templates/answer']({ answer: answer, user: user}))
    }
  })
})
