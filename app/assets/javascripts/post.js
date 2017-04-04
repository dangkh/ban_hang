$(document).on('turbolinks:load', function() {
  if ($(".body-post").length > 0){
    var $post = $( ".post" ),
    str = $(".body-post").text()
    html = $.parseHTML( str ),
    $(".body-post").hide()
    $post.append( html );
  }
})
