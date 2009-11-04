// Javascript shorty client. Brad Gessler (c) 2009.
(function($){
  $.extend({
    shorty: {
      shorten: function(url, key, options){
        var location;
        var type = (key === 'undefined') ? 'POST' : 'PUT';
        var endpoint = (key === 'undefined') ? '/' : '/' + key;
        
        $.ajax({
          data: url,
          type: type,
          url: endpoint,
          complete: function(xhr){
            if(xhr.status === 201 && options.success){
              var location = xhr.getResponseHeader('location');
              options.success(location);
            }
          },
          error: function(xhr){
            if (options.success) { options.error(xhr.responseText); }
          }
        });
      },
      getKey: function(callback){
        $.get('/key/random', function(key){
          callback(key);
        });
      }
    }
  });  
})(jQuery);