$(function() {
  function searchVideo(){
    var query = $('.youtube').data('search-keyword');
    var maxResults = 14;
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
               + '" class="external"><img src="' + thumbnailUrl 
               + '" width="125" height="95"/></a></li></article>';
        }
      } else {
        html += "<p>not found</p>";
      }
      $('<ul class="youtube_list"></ul>').html(html).appendTo('body');
      console.info(html);
    },
    error: function(xOptions, textStatus){
    }
    });
  }
  searchVideo();
});
