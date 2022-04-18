$(document).on('turbolinks:load', function(){
  $('a.edit-question').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#edit-question-' + questionId).show();
  });

  $('a.voted-up-link').on('ajax:success', function(e){
    let resource = e['detail'][0]

    $('.raiting').html(resource.raiting)
  })

  $('a.voted-down-link').on('ajax:success', function(e){
    let resource = e['detail'][0]

    $('.raiting').html(resource.raiting)
  })
});
