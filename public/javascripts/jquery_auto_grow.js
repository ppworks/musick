(function($) {
/*
* Auto-growing textareas; technique ripped from Facebook
*/
    $.fn.autogrow = function(options) {
        
        this.filter('textarea').each(function() {
            if ($(this).data('attach-auto-grow')) {
                return;
            }
            var $this = $(this),
                minHeight = $this.height(),
                lineHeight = $this.css('lineHeight');
            $this.data('attach-auto-grow', 1);
            var shadow = $('<div></div>').css({
                position: 'absolute',
                top: -10000,
                left: -10000,
                width: $(this).width() - parseInt($this.css('paddingLeft')) - parseInt($this.css('paddingRight')),
                fontSize: $this.css('fontSize'),
                fontFamily: $this.css('fontFamily'),
                lineHeight: $this.css('lineHeight'),
                padding: $this.css('padding'),
                resize: 'none'
            }).appendTo(document.body);
            
            var update = function(e) {
                if (e && $this.hasClass('auto_grow_reverse')) {
                    if (e && (e.type == 'keyup' || e.type == 'keydown') && (e.keyCode == 13 || e.keyCode == 229)) {
                        if ($.browser.mozilla) {
                            $this.data('enter-ime', 0);
                        } else if (e.type == 'keydown') {
                            if (e.keyCode == 229) {
                                $this.data('enter-ime', 1);
                            } else {
                                $this.data('enter-ime', 0);
                            }
                        }
                        if (!$this.data('enter-ime') && !e.shiftKey) {
                            if (e.type == 'keydown') {
                                $this.closest('form').submit();
                            }
                            e.preventDefault();
                            return;
                        }
                    }
                }
                var times = function(string, number) {
                    var _res = '';
                    for(var i = 0; i < number; i ++) {
                        _res = _res + string;
                    }
                    return _res;
                };
                
                var val = this.value.replace(/</g, '&lt;')
                                    .replace(/>/g, '&gt;')
                                    .replace(/&/g, '&amp;')
                                    .replace(/\n$/, '<br/>&nbsp;')
                                    .replace(/\n/g, '<br/>')
                                    .replace(/ {2,}/g, function(space) { return times('&nbsp;', space.length -1) + ' ' });
                
                shadow.html(val);

                if (shadow.height() != minHeight) {
                  $(this).css('height', Math.max(shadow.height() + 10, minHeight));
                }
            
            }
            
            $(this).change(update).keyup(update).keydown(update);
            
            update.apply(this);
            
        });
        
        return this;
        
    }
    
})(jQuery);