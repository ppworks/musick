$(function() {
  var maxResults = 14;
  function search_video(query){
    if (!query) {
      return;
    }
    listVideos(query, maxResults);
  }

  function listVideos(query, maxResults) {
    $.ajax({
    type:"GET",
    url:'http://gdata.youtube.com/feeds/videos',
    data: {
      'vq':query,
      'start-index':'1',
      'max-results':maxResults,
      'alt':'json-in-script',
      'format':'6'
    },
    dataType:    'jsonp',
    success: function(data) {
      $.fancybox.hideActivity();
      var html = '';
      if(data.feed.openSearch$totalResults.$t > 0){
        var entries = data.feed.entry;
        for(var i=0;i<entries.length;i++){
          //html += entries[i].content.$t;
          var entry = entries[i];
          var title = entry.title.$t.substr(0, 14);
          var thumbnailUrl = entries[i].media$group.media$thumbnail[0].url;
          var playerUrl = entries[i].media$group.media$content[0].url;
          var watchUrl = entries[i].media$group.media$player[0].url;
          html += '<li><article><h1><a href="' + watchUrl + '">'+ title +'</a></h1><a href="' + watchUrl 
               + '" rel="group_youtube"><img src="' + thumbnailUrl 
               + '" width="102" height="76" /></a></li></article>';
        }
      } else {
        html += "";
      }
      $('div.youtube_list').remove();
      $('<div class="youtube_list"></div>').html('<ul>' + html + '</ul>').appendTo('body');
      $('div.youtube_list a').click(function(e) {
        $.fancybox({
          'padding'   : 0,
          'autoScale'   : false,
          'transitionIn'  : 'elastic',
          'transitionOut' : 'elastic',
          'speedIn'   : 200, 
          'speedOut'    : 100,
          'centerOnScroll' : true,
          'title'     : this.title,
          'width'     : 640,
          'height'    : 385,
          'href'      : $(this).attr('href').replace(new RegExp("watch\\?v=", "i"), 'v/'),
          'type'      : 'swf',
          'swf'     : {
          'wmode'       : 'transparent',
          'allowfullscreen' : 'true'
          }
        });
    return false;
  });
    },
    error: function(xOptions, textStatus){
      $.fancybox.hideActivity();
    }
    });
  }
  
  $('a.youtube').live('click', function(e) {
    e.preventDefault();
    $.fancybox.showActivity();
    search_video($('.youtube').data('search-keyword'));
  });
  
  $.youtube_search = search_video;
});
