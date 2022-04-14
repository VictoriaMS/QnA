$(document).on('turbolinks:load', function(){
  $('a.edit-question').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#edit-question-' + questionId).show();
  });

  $('a.voted_down_link').on('ajax:success', function(e){
    let question = e['detail'][0]
    $('.voted_down').html(question.voted_down)
  })

  $('a.voted_up_link').on('ajax:success', function(e){
    let question = e['detail'][0]
    $('.voted_up').html(question.voted_up)
  })
});
