$(function(e) {
  window.fbAsyncInit = function() {
    FB.init({
        appId: $.fb_app_id,
        status: true,
        cookie: true,
        xfbml: true
    })
  }
    
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
      .bind('ajax:complete', function (ee) {
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
  
  function listen_links() {
    $('a.popup').fancybox({
      'href' : $(this).attr('href'),
      'hideOnContentClick' : true,
      'transitionIn' : 'none',
      'transitionOut' : 'none',
      'overlayColor': '#000',
      'overlayOpacity': 0.6,
      'centerOnScroll': true,
      'showCloseButton': false,
      'showNavArrows' : true,
      'padding': 0
    });
    
    $('a.read_more').click(function(e){
      e.preventDefault();
      $(this).hide();
      $(this).parent().find('.summary').hide();
      $(this).parent().find('.content').fadeIn(1000);
      $(this).parent().find('.read_less').fadeIn(1000);
    });
    $('a.read_less').click(function(e){
      e.preventDefault();
      $(this).hide();
      $(this).parent().find('.content').hide();
      $(this).parent().find('.summary').fadeIn(1000);
      $(this).parent().find('.read_more').fadeIn(1000);
    });
  }
  
  function popup(title, content) {
    $('#fancybox_inline h1').text('success');
    $('#fancybox_inline article').html(content);
    $('#fancybox_inline').show();
    $.fancybox({
      'href' : '#fancybox_inline',
      'hideOnContentClick' : true,
      'type' : 'inline',
      'transitionIn' : 'none',
      'transitionOut' : 'none',
      'overlayColor': '#fff',
      'overlayOpacity': 0.6,
      'centerOnScroll': true,
      'showCloseButton': false,
      'onClosed' : function() {$('#fancybox_inline').hide();}
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
    listen_links();
    round_image();
    $.musick = {};
    $.musick.popup = popup;
    $.musick.init = function() {
      round_image();
    };
  }
  
  init();
});
