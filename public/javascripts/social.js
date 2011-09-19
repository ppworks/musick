$(function(e) {
  
  function listen_friend_selector() {
    $('ul.friends>li button').click(function(e) {
      $(this).closest('li').toggleClass('selected');
      var text = $(this).data('alternative-label');
      $(this).data('alternative-label', $(this).text());
      $(this).text(text);
      
      var select_data_id = $(this).closest('.profile').data('id');
      if ($(this).closest('li').hasClass('selected')) {
        $('ul#to_friends').append('<li data-id="' + select_data_id + '">' + $(this).closest('.profile').find('h1').text() + '</li>');
      } else {
        $('ul#to_friends>li[data-id="' + select_data_id + '"]').remove();
      }
      var to_provider_user_keys = [];
      $.each($('ul#to_friends>li'), function(i, elm) {
        to_provider_user_keys.push($(elm).data('id'));
      });
      $('input#to_provider_user_keys').val(to_provider_user_keys.join(','));
    });
  }
  
  function init() {
    if ($('body').attr('id') == 'social_friends') {
      listen_friend_selector();
    }
  }
  init();
});
