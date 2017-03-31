$(document).on('ready page:load', function() {
  $('#delete-btn').on('click', function(){
    if(confirm('are_you_sure')){
      $(':checked').each(function(){
        id = $(this).attr('id');
        action = $(location).attr('href') + '/' + id;
        name = '#product' + id;
        $(name).hide();
        $.ajax({
          url: action,
          method: 'DELETE',
          data: {id: id},
          dataType: 'json',
          success: function(){
          },
          error: function() {
            alert('cant_delete')
          }
        })
      })
    };
  })
})
