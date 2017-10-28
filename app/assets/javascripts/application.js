// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require_tree .


var initMap;
var map;
var myCoordinates = {lat: 31.5208912, lng: 34.4421586};
initMap = function(){
  map = new google.maps.Map(document.getElementById('map'), {
    center: myCoordinates,
    zoom: 16
  });
};



var changeCoordinates;
changeCoordinates = function(){
  console.log('CLICKED');
  branch = $('#map-carousel .item.active').data('branch');
  $.get('/branches', {branch: branch}, function(data){
    console.log(data);
    data.lat = parseFloat(data.lat);
    data.lng = parseFloat(data.lng);
    var myLatlng = new google.maps.LatLng(data.lat, data.lng);
    console.log(data);
    map.panTo(myLatlng);
  });
};

$(document).ready(function(){
  $('#map-carousel .carousel-control').on('click', changeCoordinates);
});
