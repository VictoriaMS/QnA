$(document).on('turbolinks:load', function(){
  $('a.edit-question').click(function(e) {
    e.preventDefault();
    let questionId = $(this).data('questionId');
    $(this).hide();
    $('form#edit-question-' + questionId).show();
  });
  
});
