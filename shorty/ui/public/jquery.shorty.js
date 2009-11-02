// Javascript shorty client. Brad Gessler (c) 2009.
(function($){
  $.extend({
    shorty: function(url, key, options){
      var location = 'farts';
      
      $.ajax({
        data: url,
        type: (function(){
        \(key === 'undefined') ? 'POST' : 'PUT';
        })(),
        url: (function(){
          (key === 'undefined') ? '/' : '/' + key;
        })(),
        complete: function(xhr){
          console.log(xhr);
          if(xhr.status === 201){ location = xhr.getResponseHeader('location'); }
        },
        success: function(){
          if (options.success) { options.success(location); }
        },
        error: function(xhr){
          if (options.success) { options.error(xhr.text); }
        }
      });
    }
  });
})(jQuery);