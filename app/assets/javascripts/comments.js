$(document).on('turbolinks:load', function(){
  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      let question = gon.question
      this.perform('follow', { question: question })
    },

    received: function(data) {
      let comment = JSON.parse(data)

      $('.comments-for-question').append(JST['templates/comment']({comment: comment}))
    }
  })
})
