$ ->
  input = document.getElementById 'places'
  options =
    types: ['(cities)']

  autocomplete = new google.maps.places.Autocomplete input, options
