$(document).ready(function(){
  if ($('#leaflet-map').length > 0) {
    var latitude  = 25.2000;
    var longitude = 55.3000;

    var map = L.map('leaflet-map').setView([25.2000, 55.3000], 11);

    L.tileLayer('http://{s}.tile.cloudmade.com/CLOUDMADE_API_KEY_GOES_HERE/997/256/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
      maxZoom: 18
    }).addTo(map);

  // add a marker in the given location, attach some popup content to it and open the popup
  var marker;

  marker = L.marker([25.2000, 55.3000]);

  marker.addTo(map).bindPopup('Drag Me!').openPopup();

  // This enables a draggable/droppable pin

  marker.dragging.enable();

  marker.on('dragend', function(e){
    // do stuff
    });
  });

  $('#places').on( 'submit', function(e) {
    e.preventDefault();
    // var query = $('#places').val()
    // $.ajax({
    //   url: '/search_query',
    //   type: 'POST',
    //   data: { query: query }
    // }).done(function(data){
      // var locLatitude = parseFloat(data.latitude);
      // var locLongitude = parseFloat(data.longitude);
      // map.removeLayer(marker);
      // map.setView([locLatitude, locLongitude], 11);
      // marker = L.marker([locLatitude, locLongitude]);
      // marker.addTo(map);
      // marker.dragging.enable();

      // marker.on('dragend', function(e){
        // do stuff
    //   });
    });
  });
});
