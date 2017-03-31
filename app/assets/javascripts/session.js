$(document).on('ready page:load', function() {
  $(':input').on('click',function(){
    id = $(this).attr('id');
    uniform_resource_locator = 'http://localhost:3000/sessions/' + id;
    value = $(this).val();
    $.ajax({
      url: uniform_resource_locator,
      method: 'PATCH',
      data: {value: value, id: id, status: 'ajax'},
      dataType: 'json',
      success: function(result){
        money = $('#total_price').text();
        money = money.substring(1, money.length);
        tmp = parseFloat(money) + result;
        $('#total_price').text('$' + Number(tmp.toFixed(2)));
        money = $('#price'+id).text().replace(/\s/g,'');
        money = money.substring(1, money.length);
        tmp = parseFloat(money) + result;
        $('#price'+id).text('$' + Number(tmp.toFixed(2)));
      }
    });
  });
});
