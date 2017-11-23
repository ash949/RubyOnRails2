App.product = App.cable.subscriptions.create("ProductChannel", {
  connected: function() {
    console.log('User connected');
    App.product.listen_to_comments();
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    var new_comment = '';
    var highest_rating_comment = '';
    var lowest_rating_comment = '';
    product_id = $('.product-showcase').data('product-id');
    if ( localStorage.getItem('user_id') != data.commentator_id ){
      $('.notification-popup').html("<strong>" + data.commentator_name + "</strong> has just reviewed " + data.product_name).promise().done(function(){
        $(this).fadeIn(300).delay(5000).fadeOut(300);
      });
      $.when(
        getComment( product_id, data.comment_id, function(returned){ new_comment = returned; }),
        getComment( product_id, data.highest_rating_comment_id, function(returned){ highest_rating_comment = returned; }),
        getComment( product_id, data.lowest_rating_comment_id, function(returned){ lowest_rating_comment = returned; }),
      ).done(function(){
        $.when(
          addComment("", new_comment, highest_rating_comment, lowest_rating_comment, data.product_rating)
        ).done(
          refreshProductRating()
        )
      });
    }
      
                 
  },
  listen_to_comments: function(){
    this.perform("listen", {
      product_id: $('.product-showcase').data('product-id')
    });
  }
});

$(document).on('turbolinks:load', function(){
  App.product.listen_to_comments();
});