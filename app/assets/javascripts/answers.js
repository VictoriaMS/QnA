$(document).on('turbolinks:load', function(){
  $('a.edit-answer').click(function(e){
    e.preventDefault();
    let answerId = $(this).data('answerId')
    $(this).toggle()
    $('form#edit-answer-' + answerId ).toggle()
  })

  $('a.voted_up_link').on('ajax:success', function(e){
    let answer = e['detail']
    $('.voted_up').html(answer.voted_up)
  })

  $('a.voted_down_link').on('ajax:success', function(e){
    let answer = e['detail'][0]
    $('.voted_down').html(answer.voted_down)
  })
})
