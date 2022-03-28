$(document).on('turbolinks:load', function(){
  $('.user_questions').click(function(e){
      e.preventDefault()
      let AllQuestions = $('#all_questions')
      let UserQuestions = $('#user_questions')

      $('#all_questions').style.display = 'none'
      UserQuestions.toggle()
  })
})
