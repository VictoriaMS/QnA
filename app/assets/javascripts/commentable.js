function showForm(link) {
  console.log(link.data('resourceType'))
  let resourceId = link.data('resourceId');
  let resourceType = link.data('resourceType')
  link.hide()
  $('form#comment_for_' + resourceType + '_' + resourceId).show()
}

function hideForm(resourceType) {
  $('#comment_body').val('')
  $('form.comment-for-' + resourceType).hide()
  $('a.comment-for-' + resourceType + '-link').show()
}
