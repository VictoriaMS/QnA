$(document).on('turbolinks:load', function(){
  $('a.edit-answer').click(function(e){
    e.preventDefault();
    let answerId = $(this).data('answerId')
    $(this).toggle()
    $('form#edit-answer-' + answerId ).toggle()
  })

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      let question = gon.question
      return this.perform('follow', { question: question })
    },
    received: function(data) {
      let answer = JSON.parse(data)
      let user = gon.user
      console.log(user)

      $('.answers').append(JST['templates/answer']({ answer: answer, user: user}))
    }
  })
})
