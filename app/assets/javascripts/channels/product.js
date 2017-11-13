App.product = App.cable.subscriptions.create("ProductChannel", {
  connected: function() {
    console.log('User connected');
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    //if ( localStorage.getItem('user_id') != data.commentator_id )
      $('.notification-popup').html("<strong>" + data.commentator_name + "</strong> has just reviewed " + data.product_name).promise().done(function(){
        $(this).fadeIn(300).delay(5000).fadeOut(300);
      });
  }
});
