$(document).on('turbolinks:load', function(){
  $('a.edit-answer').click(function(e){
    e.preventDefault();
    let answerId = $(this).data('answerId')
    $(this).toggle()
    $('form#edit-answer-' + answerId ).toggle()
  })
})
