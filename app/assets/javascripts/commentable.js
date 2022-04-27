function showForm(link) {
  console.log(link.data('resourceType'))
  let resourceId = link.data('resourceId');
  let resourceType = link.data('resourceType')
  link.toggle()
  $('form#comment_for_' + resourceType + '_' + resourceId).toggle()
}

function hideForm(resourceType) {
  $('#comment_body').val('')
  $('form.comment-for-' + resourceType).toggle()
  $('a.comment-for-' + resourceType + '-link').toggle()
}
