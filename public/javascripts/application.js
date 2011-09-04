$(function(e) {
  
  function listen_auto_paging() {
    $.fancybox.hideActivity();
    function loadOnScroll() {
      var content = $('.pagination_content');
      
      if (content.offset().top + content.height() <= $(document).scrollTop() + $(window).height()) {
        $(this)
          .unbind('ajax:success', listen_auto_paging)
          .bind('ajax:success', listen_auto_paging);
        $.fancybox.showActivity();
        $('#paginator a').click();
        $(window).unbind('scroll');
      }
    }
    if ($('#paginator a').size() > 0) {
      $(window).scroll(loadOnScroll);
    }
  }
  
  function round_image() {
    $("img.rounded-img1, img.rounded-img2").load(function() {
      
      $(this).wrap(function(){
        return '<span class="' + $(this).attr('class') + '" style="background:url(' + $(this).attr('src') + ') no-repeat center center; width: ' + $(this).width() + 'px; height: ' + $(this).height() + 'px;" />';
      });
      $(this).css("opacity","0");
    
      $("a span.rounded-img1").hover(function(e) {
        $(this).removeClass("rounded-img1");
        $(this).addClass("rounded-img2");
      }, function(e) {
        $(this).removeClass("rounded-img2");
        $(this).addClass("rounded-img1");
      });
    });
  }
  
  function init() {
    listen_auto_paging();
    round_image();
    $.musick = {};
    $.musick.init = function() {
      round_image();
    };
  }
  
  init();
});
