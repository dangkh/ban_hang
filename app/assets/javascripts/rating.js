$(document).on('ready page:load', function() {
  var size;
  size = 20;
  $('.rating').on('mouseover', function() {
    size = $(this).css('font-size');
    $(this).css('font-size', '30px');
  });
  $('.rating').on('mouseout', function() {
    $(this).css('font-size', size);
  });
  return $('.rating').on('click', function() {
    var action, id, value;
    $('.rating').css('font-size', 20);
    size = 30;
    $(this).css('font-size', '30px');
    value = $(this).text();
    id = $('.rating-number-show').attr('id');
    action = 'http://localhost:3000/ratings/' + id;
    if (id > 0) {
      $.ajax({
        method: 'PATCH',
        url: action,
        data: {
          rate: value,
          id: id
        },
        dataType: 'json'
      });
    }
  });
});
