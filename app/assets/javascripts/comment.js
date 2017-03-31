$(document).on('turbolinks:load', function() {
  $('body').on('click', '.delete_comment', function(e) {
    e.preventDefault();
    if (confirm('are you sure')) {
      $cmt_id = $(this).attr('href').split('/')[4]
      $div_id = '#comment_' + $cmt_id
      $.ajax({
        dataType: 'html',
        url: $(this).attr('href'),
        method: 'delete',
        success: function() {
          $($div_id).hide();
        },
        error: function(){
          alert('something wrong')
        }
      })
    }
    return false;
  })

  $('body').on('click', '.new_comment', function() {
    $form = $(this);
    $form.submit(function(e) {
      e.preventDefault();
      e.stopImmediatePropagation();
      $.ajax({
        url: $form.attr('action'),
        method: $form.attr('method'),
        data: $form.serialize(),
        dataType: 'html',
        success: function(data) {
          $('#comments').append(data);
          $form[0].reset();
        },
        error: function(jqXHR, exception) {
          alert(I18n.t('something_wrong'))
        }
      })
    })
  });

});
