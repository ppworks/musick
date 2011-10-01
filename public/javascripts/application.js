$(function(e) {
  window.fbAsyncInit = function() {
    FB.init({
        appId: $.fb_app_id,
        status: true,
        cookie: true,
        xfbml: true
    })
  }
    
  function listen_scroll_page() {
    function loadOnScroll() {
      var content = $('body');
      var popup = $('#fancybox-wrap');
      if (content.height() < popup.height()) {
        content = popup;
      }
      if (content.offset().top + content.height() <= $(document).scrollTop() + $(window).height()) {
        $('div.youtube_list').addClass('hide');
      } else {
        $('div.youtube_list').removeClass('hide');
      }
    }
    
    $(window).scroll(loadOnScroll);
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
  
  function listen_auto_grow() {
    $('textarea.auto_grow, textarea.auto_grow_reverse')
    .autogrow()
    .live('click', function(e) {
        $(this).autogrow();
    });
  }
  
  function listen_remote_true() {
    $('form[data-remote="true"]').live('submit', function(e) {
      $.fancybox.showActivity();
      $('div#actions').hide();
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
  
  function listen_popup() {
    $('a.popup').fancybox({
      'href' : $(this).attr('href'),
      'hideOnContentClick' : false,
      'transitionIn' : 'ease.in',
      'transitionOut' : 'ease.out',
      'overlayColor': '#000',
      'overlayOpacity': 0.3,
      'showCloseButton': false,
      'showNavArrows' : 'no',
      'scrolling': 'auto',
      'autoScale': true,
      'padding': 0,
      'onComplete': function() {
        $('div#fancybox-overlay').css({'height' : $(document).height()});
        $('div#fancybox-wrap').unbind('mousewheel.fb');
        //$.musick.init();
      }
    });
    
    $('a.popup_action')
    .live('selectstart', function(e) {e.preventDefault();})
    .live('click', function(e) {e.preventDefault();})
    .live('click', function(e) {
      $.fancybox.showActivity();
      $.ajax({
        url : '/social/posts/new_with_action',
        data : {
          'data-target-attributes' : $(this).data('target-attributes'),
          'data-target-object' : $(this).data('target-object'),
          'data-target-name' : $(this).data('target-name'),
          'data-target-image' : $(this).data('target-image'),
        },
        success: function(data) {
          success_new_with_action(data, e);
        }
      });
    });
    
    var success_new_with_action = function(data, e) {
      $.fancybox.hideActivity();
      $('div#actions')
      .html(data);
      
      $('div#actions')
      .css('top', e.pageY + 2 + 'px')
      .show()
      .find('textarea')
      .blur();
      
      if (($(window).width()/2) < e.pageX) {
        $('div#actions').css('right', $(window).width() - e.pageX - 30 + 'px');
        $('div#actions').css('left', 'auto');
        $('div#actions div.wrapper').removeClass('left');
        $('div#actions div.wrapper').addClass('right');
      } else {
        $('div#actions').css('left', e.pageX - 30 + 'px');
        $('div#actions').css('right', 'auto');
        $('div#actions div.wrapper').removeClass('right');
        $('div#actions div.wrapper').addClass('left');
      }
      $.musick.init();
    };
    
    $('div#actions')
    .hover(function(e){}, function(e) {
        $(this).hide();
    });
    $('div#fancybox-overlay').live('click', function(e) {
      $('div#actions').hide();
    });
    $('div#container').live('click', function(e) {
      $('div#actions').hide();
    });
  }
  
  function listen_links() {
    $('a.read_more').live('click', function(e){
      e.preventDefault();
      $(this).hide();
      $(this).parent().find('.summary').hide();
      $(this).parent().find('.content').fadeIn(1000);
      $(this).parent().find('.read_less').fadeIn(1000);
    });
    $('a.read_less').live('click', function(e){
      e.preventDefault();
      $(this).hide();
      $(this).parent().find('.content').hide();
      $(this).parent().find('.summary').fadeIn(1000);
      $(this).parent().find('.read_more').fadeIn(1000);
    });
    $('a[href="/users/auth/facebook"], a[href="/users/auth/twitter"], a[href="/users/auth/mixi"]').live('click', function(e) {
      e.preventDefault();
      $.fancybox.showActivity();
      var href = $(this).attr('href');
      setTimeout(function() {
          window.location.href = href;
      }, 200);
    });
    $('a.external').live('click', function(e) {
      e.preventDefault();
      window.open($(this).attr('href'));
    });
    
    $('.comment_action a').live('click', function(e) {
      e.preventDefault();
      var post_id = $(this).closest('div.post').data('id');
      $('div.post[data-id="' + post_id + '"]').find('textarea').focus();
    });
    
    $('.new_comment textarea').live('focus', function(e) {
      $(this).addClass('focus');
      $(this).closest('form').find('.image').show();
    }).live('blur', function(e) {
      $(this).removeClass('focus');
      $(this).closest('form').find('.image').hide();
    })
    .blur()
    ;
    
    $('nav#user').click(function(e) {
      if ($(this).hasClass('clicked')) {
        $(this).find('ul').fadeIn(100);
        $(this).addClass('hover');
      } else {
        $(this).find('ul').fadeOut(100);
        $(this).removeClass('hover');
      }
      $(this).toggleClass('clicked');
    })
    .hover(function(e) {
      $(this).addClass('hover');
      $(this).find('ul').fadeIn(100);
    }, function(e) {
      $(this).removeClass('hover');
      $(this).find('ul').fadeOut(100);
    });
    $('nav#user li').hover(function(e) {
      $(this).addClass('hover');
    }, function(e) {
      $(this).removeClass('hover');
    });
    
    $('a.with_tooltip').live('hover', function(e) {
      var tooltip = $(this).data('tooltip');
      tooltip = tooltip.replace(/\n/g, '<br />');
      var a = $(this);
      $('.ui-tooltip-top').remove();

      if (e.type == 'mouseenter') {
        
        var span = $('<span class="ui-tooltip-top" style="display:none;">' + tooltip + '</span>')
        .css('position', 'absolute')
        .css('z-index', 3000)
        .appendTo($('body'));
        
        span
        .css('top', a.offset().top + a.height() + 8)
        .css('left', a.offset().left + a.width()/2 - span.width()/2)
        .show()
        ;
      }
    });
  }
  
  function listen_search_element() {
    
    $('form#search_element').bind('submit', function(e) {
      e.preventDefault();
      $.fancybox.hideActivity();
    });
    $('form#search_element input[type="search"]').bind('keyup', function(e) {
      var keyword = $(this).val();
      $('.searchable').removeClass('highlight');
      $('.search_hidable').show();
      if (keyword == '') return;
      $.each($('.searchable'), function(i, elm) {
        if ($(elm).text().match(keyword)) {
          $(elm).addClass('highlight');
        } else {
          $(elm).closest('.search_hidable').hide();
        }
      });
    })
  }
  
  function popup(title, content) {
    $('#fancybox_inline h1').text(title);
    $('#fancybox_inline article').html(content);
    $('#fancybox_inline').show();
    $.fancybox({
      'href' : '#fancybox_inline',
      'hideOnContentClick' : true,
      'type' : 'inline',
      'transitionIn' : 'none',
      'transitionOut' : 'none',
      'overlayColor': '#000',
      'overlayOpacity': 0.2,
      'centerOnScroll': true,
      'showCloseButton': false,
      'onClosed' : function() {$('#fancybox_inline').hide();}
    });
  }
  
  function fix_url() {
    if (window.location.href.match(/#_=_/)) {
      window.location.hash = '#\\(^o^)/';
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
  
  function listen_comment_all() {
    $('.show_all_comment a').live('click', function(e) {
      e.preventDefault();
      $(this).closest('ul').find('li').show();
      $(this)
      .closest('li')
      .remove();
    });
    }
    
  function listen_like_all() {
    $('a.like_users').live('click', function(e) {
      e.preventDefault();
      $(this).next('ul')
      .css('display', 'inline')
      .fadeIn(200);
    })
    .live('mouseover', function(e) {
      e.preventDefault();
      $(this).next('ul')
      .css('display', 'inline')
      .fadeIn(200);
    })
    .live('mouseout', function(e) {
      e.preventDefault();
      $(this)
      .next('ul')
      .fadeOut(200);
    })
  }
  
  function fetch_providers_profiles() {
    var unknown_count = $('.unknown').size();
    if (!unknown_count) {
      return;
    }
    providers = {}
    $('.unknown').each(function(i, elm) {
      provider_id = $(elm).data('provider-id');
      if (!providers[provider_id]) {
        providers[provider_id] = [];
      }
      providers[provider_id].push($(elm).data('user-key'));
    });
    for (provider_id in providers) {
      $.ajax('/providers/' + provider_id + '/profiles?user_keys=' + providers[provider_id].join(','))
    }
  }
  
  function sync_post() {
    var size = $('div.post').size();
    var success_count = 0;
    $.each($('div.post'), function (i, element) {
      var post_id = $(element).data('id');
      $.ajax({
        url : '/posts/' + post_id + '/sync',
        type : 'post',
        success : function() {
          success_count++;
          if (success_count == size) {
            $.musick.fetch_providers_profiles();
          }
        }
      });
    });
  }
  
  function listen_form_element() {
    $('.checkbox').change(function(){
      if ($(this).is(':checked')) {
        $(this).next('label').addClass('selected');
      } else {
        $(this).next('label').removeClass('selected');
      }
    });
    $('.radio').change(function(){
      if($(this).is(':checked')){
        $('.selected:not(:checked)').removeClass('selected');
        $(this).next('label').addClass('selected');
      }
    });
    $('.checkbox').change();
    $('.radio').change();
  }
  
  function init() {
    //listen_auto_paging();
    listen_scroll_page();
    listen_auto_grow();
    listen_remote_true();
    listen_popup();
    listen_links();
    listen_search_element();
    fix_url();
    round_image();
    fetch_providers_profiles();
    listen_comment_all();
    listen_like_all();
    sync_post();
    listen_form_element();
    $.musick = {};
    $.musick.popup = popup;
    $.musick.init = function() {
      round_image();
      listen_popup();
      fetch_providers_profiles();
      listen_form_element();
    };
    $.musick.fetch_providers_profiles = fetch_providers_profiles;
  }
  
  init();
});
