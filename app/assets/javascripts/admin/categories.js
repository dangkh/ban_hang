$(document).on('turbolinks:load', function() {
  $('body').on('click', '.button-edit-category', function(e) {
    e.preventDefault();
    $('#category-modal-edit').css('display', 'block')
    $.ajax({
      dataType: 'html',
      url: $(this).attr('href'),
      method: 'get',
      success: function(data) {
        $('.edit-category-modal-body').html(data);
      }
    });
    $('#category-modal-edit').modal('toggle');
    return false
  });
});
