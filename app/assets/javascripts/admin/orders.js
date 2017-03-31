$(document).on('turbolinks:load', function() {
  $('body').on('click', '.button-edit-order', function(e) {
    e.preventDefault();
    $('.order-modal-edit').css('display', 'block')
    $.ajax({
      dataType: 'html',
      url: $(this).attr('href'),
      method: 'get',
      success: function(data) {
        $('.modal-body-order-edit').html(data);
      }
    });
    $('.order-modal-edit').modal('toggle')
    return false
  });
})
