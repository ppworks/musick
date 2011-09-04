$(function(e) {
  
  function listen_auto_paging() {
    function loadOnScroll() {
      var content = $('.pagination_content');
      
      if (content.offset().top + content.height() <= $(document).scrollTop() + $(window).height()) {
        $(this)
          .unbind('ajax:success', listen_auto_paging)
          .bind('ajax:success', listen_auto_paging);
        $('#paginator a').click();
        $(window).unbind('scroll');
      }
    }
    if ($('#paginator a').size() > 0) {
      $(window).scroll(loadOnScroll);
    }
  }
  
  function listen_remote_true() {
    $('form').live('submit', function(e) {
      $.fancybox.showActivity();
      var find_key = "input[type='text'].auto_clear, textarea.auto_clear";
      $(this).find(find_key).attr('readonly', 'readonly');
      $(this)
      .unbind('ajax:success')
      .bind('ajax:success', function (ee) {
         $(this).find(find_key)
         .val('')
         .removeAttr('readonly');
         $.fancybox.hideActivity();
      });
    });
    $($.rails.linkClickSelector)
      .live('ajax:beforeSend', function(e) {
          $.fancybox.showActivity();
      })
      .live('ajax:complete', function(e) {
          $.fancybox.hideActivity();
    });
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
    listen_remote_true();
    round_image();
    $.musick = {};
    $.musick.init = function() {
      round_image();
    };
  }
  
  init();
});
