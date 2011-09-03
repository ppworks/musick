$(function(e) {
  
  function listen_auto_paging() {
    $.fancybox.hideActivity();
    function loadOnScroll() {
      var content = $('.pagination_content');
      if (content.offset().top + content.height() < $(document).scrollTop() + $(window).height()) {
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
  
  function init() {
    listen_auto_paging();
  }
  
  init();
});
