// @ts-nocheck
$(function() {


    var map = new google.maps.Map(document.getElementById('icrp-map'), {
        center: {
            lat: 20,
            lng: 0
        },
        zoom: 2,
        disableDefaultUI: true,
        zoomControl: true,
        backgroundColor: '#64aad8',
        styles: getDefaultStyles(),
    });

    var locations = [];
    var markers = [];
    var infoWindows = [];
    var polylines = [];

    var overlayInitialized = false;
    var overlay = new google.maps.OverlayView();
    overlay.draw = function() {};
    overlay.setMap(map);

    map.addListener('idle', function() {
        if (!overlayInitialized && overlay.getProjection()) {
            overlayInitialized = true;
            initMap();
            window.createOverlayForMap(map);
        }
    });

    map.addListener('click', function() {
        for (var i = 0; i < infoWindows.length; i ++)
            infoWindows[i].close();
    });

    // resize map icons when zoom level is changed.
    map.addListener('zoom_changed', function() {
        for (let i = 0; i < markers.length; i ++) {
            if (markers[i].getMap() != null && markers[i].resizable) {
                let zoom = map.getZoom();
                let icon = markers[i].getIcon();
                if (icon) {
                    markers[i].setIcon({
                        url: icon.url,
                        scaledSize: {width: zoom + 12, height: zoom + 16},
                    });
                }
            }
        }

    })

    function initMap() {
        locations = window.db_people_map.funding_details.map(function(record) {
            return {
                name: record.pi_name,
                isPrincipalInvestigator: record.is_pi == 1,
                institution: record.institution,
                location: [record.city, record.state, record.country]
                    .filter(Boolean).join(', '),
                latitude: +record.lat,
                longitude: +record.long,
            }
        }).filter(function(record) {
            return !(record.latitude == 0 && record.longitude == 0);
        });

        drawMap();
    }

    function drawMap() {
        clearMarkers();
        var groups = groupItems(overlay, locations, 40);
        var centerCoordinates = {lat: 0, lng: 0};

        groups.forEach(function(group) {
            if (group.length == 1) {
                (function() {
                    var item = group[0];
                    var position = {
                        lng: + item.longitude,
                        lat: + item.latitude,
                    };

                    if (item.isPrincipalInvestigator)
                        centerCoordinates = position;

                    var infoWindow = new google.maps.InfoWindow({
                        content: $('<div>')
                            .append($('<b>').text(item.isPrincipalInvestigator ? 'Principal Investigator: ' : 'Collaborator: '))
                            .append($('<span>').text(item.name))
                            .append($('<hr>').css('margin', '0 0 8px 0'))
                            .append($('<div>').text('Institution: ' + item.institution))
                            .append($('<div>').text('Location: ' + item.location))
                            .get(0)
                    });

                    var marker = createMarker(
                        item.isPrincipalInvestigator ? 'marker.orange.svg' : 'marker.steelblue.svg',
                        {lat: item.latitude, lng: item.longitude},
                        item.isPrincipalInvestigator ? 1 : 0,
                        map
                    );

                    marker.addListener('click', function() {
                    for (var i = 0; i < infoWindows.length; i ++)
                        infoWindows[i].close();
                        infoWindow.open(map, marker);
                    });

                    infoWindows.push(infoWindow);
                    markers.push(marker);
                })();
            }

            else if (group.length > 1) {
                (function() {

                    var bounds = group.reduce(function(bounds, item) {
                        return bounds.extend({
                            lat: +item.latitude,
                            lng: +item.longitude
                        });
                    }, new google.maps.LatLngBounds());
                    var position = bounds.getCenter();

                    var pi = group.filter(function(item) {
                        return item.isPrincipalInvestigator;
                    });

                    var message = pi && pi.length > 0
                        ? '<b>PI: </b>' + pi[0].name + ' and ' + (group.length - 1) + ' other collaborators'
                        : '<b>Collaborators: </b>' + group[0].name + ' and ' + (group.length - 1) + ' other collaborators';

                    if (pi && pi.length > 0)
                        centerCoordinates = position;


                    var filename = pi && pi.length
                        ? 'marker.group.orange.svg'
                        : 'marker.group.steelblue.svg';

                    var marker = new google.maps.Marker({
                        position: position,
                        map: map,
                        label: {
                            color: 'black',
                            text: (group.length).toLocaleString(),
                            fontSize: '10px',
                            fontWeight: 'bolder',
                        },
                        icon: {
                            url: '/modules/custom/db_map/src/assets/images/' + filename,
                            anchor: {x: 20, y: 20},
                        },

                        zIndex: 10
                    })
                    marker.resizable = false;

                    var infoWindow = new google.maps.InfoWindow({
                        content: $('<div>')
                            .append($('<div>')
                                .html(message)
                                .css('color', 'steelblue')
                                .css('text-decoration', 'underline')
                                .css('cursor', 'pointer')
                                .click(function() {
                                    map.fitBounds(bounds);
                                    // marker.setMap(null);
                                    // locations.length = 0;
                                    // group.forEach(function(item) {
                                    //     locations.push(item);
                                    // });
                                    setTimeout(function() {
                                        drawMap();
                                    }, 100);
                                }))
                            .get(0)
                    });

                    marker.addListener('click', function() {
                        for (var i = 0; i < infoWindows.length; i ++)
                            infoWindows[i].close();
                        infoWindow.open(map, marker);
                    })

                    infoWindows.push(infoWindow);
                    markers.push(marker);
                })();
            }
        });

        markers.forEach(function(marker) {
            polylines.push(new google.maps.Polyline({
                path: [
                  centerCoordinates,
                  marker.getPosition(),
                ],
                strokeColor: '#666',
                strokeWeight: 1,
                map: map
            }))
        });

        map.setZoom(map.getZoom());
    }

    function clearMarkers() {
        for (var i = 0; i < markers.length; i ++)
            markers[i].setMap(null);

        for (var j = 0; j < infoWindows.length; j ++)
            infoWindows[j].close();

        for (var k = 0; k < polylines.length; k ++)
            polylines[k].setMap(null);

        markers.length = 0;
        infoWindows.length = 0;
        polylines.length = 0;

        // force redraw
        map.setZoom(map.getZoom());
    }


    function createMarker(fileName, position, zIndex, map) {
        return new google.maps.Marker({
            position: position,
            map: map,
            icon: {
                url: '/modules/custom/db_map/src/assets/images/' + fileName,
            },
            zIndex: zIndex || 0
        });
    }


    function groupItems(overlay, locations, radius) {

        if (radius == 0) {
            return locations.map(function(location) {
                return [location];
            })
        }

        var groups = [];
        var projection = overlay.getProjection();
        var markers = (locations || []).map(function(location) {
            var marker = new google.maps.Marker({
                position: {
                    lat: +location.latitude,
                    lng: +location.longitude
                }
            });
            marker.metadata = location;
            return marker;
        })

        // iterate through each marker
        markers.forEach(function(marker) {

            // attempt to find the closest group to the marker
            var minDistance = Number.MAX_VALUE;
            var closestGroup = null;

            groups.forEach(function(group) {
                var distance = distanceBetween(
                    projection.fromLatLngToDivPixel(getBounds(group).getCenter()),
                    projection.fromLatLngToDivPixel(marker.getPosition())
                );

                if (distance < minDistance) {
                    minDistance = distance;
                    closestGroup = group;
                }
            });

            // if we did not find any groups within the minimum radius
            // then create a new group from the current marker
            if (closestGroup == null || minDistance > radius) {
                groups.push([marker])
            }
            else if (closestGroup != null) {
                closestGroup.push(marker);
            }
        });

        return groups.map(function(group) {
            return group.map(function(marker) {
                return marker.metadata;
            })
        });
    }

    function getBounds(markers) {
        return markers.reduce(function(bounds, marker) {
            return bounds.extend(marker.getPosition());
        }, new google.maps.LatLngBounds());
    }

    function distanceBetween(a, b) {
        return Math.sqrt(
            Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2)
        );
    }

    function getDefaultStyles() {
        return [
            {
                "elementType": "geometry",
                "stylers": [
                    {
                        "color": "#f5f5f5"
                    }
                ]
            }, {
                "elementType": "labels",
                "stylers": [
                    {
                        "lightness": 40
                    }
                ]
            }, {
                "featureType": "administrative",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#27709a"
                    }
                ]
            }, {
                "featureType": "administrative.country",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "color": "#a0cce7"
                    }
                ]
            }, {
                "featureType": "administrative.country",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#2b7bac"
                    }
                ]
            }, {
                "featureType": "administrative.province",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#aa8bc9"
                    }
                ]
            }, {
                "featureType": "landscape",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#1e824c"
                    }
                ]
            }, {
                "featureType": "landscape",
                "elementType": "labels.text.stroke",
                "stylers": [
                    {
                        "color": "#ffffff"
                    }
                ]
            }, {
                "featureType": "landscape.man_made",
                "elementType": "geometry",
                "stylers": [
                    {
                        "visibility": "off"
                    }, {
                        "weight": 1
                    }
                ]
            }, {
                "featureType": "landscape.man_made",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "color": "#a0cce7"
                    }, {
                        "saturation": 55
                    }, {
                        "visibility": "off"
                    }
                ]
            }, {
                "featureType": "landscape.man_made",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "color": "#e1d3fa"
                    }, {
                        "visibility": "on"
                    }
                ]
            }, {
                "featureType": "poi",
                "stylers": [
                    {
                        "visibility": "on"
                    }
                ]
            }, {
                "featureType": "poi",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#058ab6"
                    }
                ]
            }, {
                "featureType": "road",
                "stylers": [
                    {
                        "weight": 1.5
                    }
                ]
            }, {
                "featureType": "road",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "color": "#a0cce7"
                    }
                ]
            }, {
                "featureType": "road",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            }, {
                "featureType": "road.arterial",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "color": "#d6ecf5"
                    }, {
                        "visibility": "on"
                    }
                ]
            }, {
                "featureType": "road.highway",
                "elementType": "geometry",
                "stylers": [
                    {
                        "saturation": -75
                    }, {
                        "lightness": 100
                    }, {
                        "visibility": "on"
                    }
                ]
            }, {
                "featureType": "road.highway",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "color": "#b3d7ec"
                    }, {
                        "visibility": "on"
                    }
                ]
            }, {
                "featureType": "road.highway",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "color": "#a0cce7"
                    }, {
                        "visibility": "off"
                    }
                ]
            }, {
                "featureType": "road.local",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "color": "#d6ecf5"
                    }, {
                        "visibility": "on"
                    }
                ]
            }, {
                "featureType": "road.local",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            }, {
                "featureType": "water",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "color": "#64aad8"
                    }
                ]
            }, {
                "featureType": "water",
                "elementType": "labels.text",
                "stylers": [
                    {
                        "color": "#674190"
                    }
                ]
            }, {
                "featureType": "water",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "color": "#eaeaea"
                    }
                ]
            }
        ];
    }
})

drupalSettings.db_map = {
  initPeopleMap: function() {
    var baseUrl = '/modules/custom/db_map/src/assets/images/',
        markerBounds = new google.maps.LatLngBounds(),
        boundsFound = false,
        markers = [],
        pi = [],
        collab = [],
        polyline = [],
        iw = new google.maps.InfoWindow({closeBoxURL:""}),
        map = new google.maps.Map(document.getElementById('icrp-map'), {
          center: {lat:0,lng:0},
          zoom: 2,
          styles: [
            {
              "elementType": "geometry",
              "stylers": [
                {
                  "color": "#f5f5f5"
                }
              ]
            },
            {
              "elementType": "labels",
              "stylers": [
                {
                  "lightness": 40
                }
              ]
            },
            {
              "featureType": "administrative.country",
              "elementType": "geometry.stroke",
              "stylers": [
                {
                  "color": "#a0cce7"
                }
              ]
            },
            {
              "featureType": "poi",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            },
            {
              "featureType": "road",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            },
            {
              "featureType": "transit",
              "stylers": [
                {
                  "visibility": "off"
                }
              ]
            },
            {
              "featureType": "water",
              "elementType": "geometry.fill",
              "stylers": [
                {
                  "color": "#64aad8"
                }
              ]
            }
          ],
        });
    for (var index in db_people_map.funding_details) {
      var detail = db_people_map.funding_details[index];
      if ((detail.lat || detail.lat === 0) && (detail.long || detail.long === 0)) {
        boundsFound = true;
        var is_pi = parseInt(detail.is_pi),
            loc = {
              lat: parseFloat(detail.lat),
              lng: parseFloat(detail.long)
            };
        if (loc.lat > 90 || loc.lat < -90) {
          let hold = loc.lat;
          loc.lat = loc.lng;
          loc.lng = hold;
        }
        var marker = new google.maps.Marker({
              map: map,
              icon: is_pi ? baseUrl+'marker.orange.svg' : baseUrl+'marker.yellow.svg',
              position: loc
            }),
            content = '<b>'+(is_pi?'Principal Investigator':'Collaborator')+':</b> '+(detail.pi_name==""?'Name not available':detail.pi_name)+'<br/>'+
                      '<hr style="margin:.5em 0px;"/>'+
                      'Institution: '+detail.institution+'<br/>'+
                      'Location: '+[detail.city, detail.state, detail.country].filter(e => e && e.length).join(', ');
        marker.addListener('click',(function(marker,content,infowindow) {
          return function() {
            if (infowindow.getMap() === null || typeof infowindow.getMap() === 'undefined' || infowindow.getAnchor() !== marker) {
              infowindow.setContent(content);
              infowindow.setAnchor(marker);
            } else {
              infowindow.close();
            }
          };
        })(marker,content,iw));
        (is_pi?pi:collab).push(marker);
        markerBounds.extend(marker.getPosition());
      }
    }
    for (var i in pi) {
      for (var j in collab) {
        polyline.push(new google.maps.Polyline({
          path: [
            pi[i].position,
            collab[j].position,
          ],
          strokeColor: '#666',
          strokeWeight: 1,
          map: map
        }));
      }
    }
    if (boundsFound) {
      var ne = markerBounds.getNorthEast(),
          sw = markerBounds.getSouthWest(),
          latVar = Math.max(1-(ne.lat()-sw.lat()),0)/2,
          lngVar = Math.max(1-(ne.lng()-sw.lng()),0)/2;
      markerBounds.extend({lat:ne.lat()+latVar,lng:ne.lng()-lngVar});
      markerBounds.extend({lat:sw.lat()-latVar,lng:sw.lng()+lngVar});
      map.fitBounds(markerBounds);
      google.maps.event.addListenerOnce(map, 'bounds_changed', function(event) {
        if (this.getZoom() < 2) {
          this.setZoom(2);
        }
      });
    }


    function clearMarkers() {
        for (var i = 0; i < markers.length; i ++)
            markers[i].setMap(null);

        markers.length = 0;

        // force redraw
        map.setZoom(map.getZoom());
    }

    function createMarker(imageFile, position, zIndex, map) {
        return new google.maps.Marker({
            position: position,
            map: map,
            icon: {
                url: baseUrl + imageFile,
                origin: {x: 6, y: 16},
            },
            zIndex: zIndex || 0
        });
    }


    function groupItems(overlay, locations, radius) {

        if (radius == 0) {
            return locations.map(function(location) {
                return [location];
            })
        }

        var groups = [];
        var projection = overlay.getProjection();
        var markers = (locations || []).map(function(location) {
            var marker = new google.maps.Marker({
                position: {
                    lat: +location.latitude,
                    lng: +location.longitude
                }
            });
            marker.metadata = location;
            return marker;
        })

        // iterate through each marker
        markers.forEach(function(marker) {

            // attempt to find the closest group to the marker
            var minDistance = Number.MAX_VALUE;
            var closestGroup = null;

            groups.forEach(function(group) {
                var distance = distanceBetween(
                    projection.fromLatLngToDivPixel(getBounds(group).getCenter()),
                    projection.fromLatLngToDivPixel(marker.getPosition())
                );

                if (distance < minDistance) {
                    minDistance = distance;
                    closestGroup = group;
                }
            });

            // if we did not find any groups within the minimum radius
            // then create a new group from the current marker
            if (closestGroup == null || minDistance > radius) {
                groups.push([marker])
            }
            else if (closestGroup != null) {
                closestGroup.push(marker);
            }
        });

        return groups.map(function(group) {
            return group.map(function(marker) {
                return marker.metadata;
            })
        });
    }

    function getBounds(markers) {
        return markers.reduce(function(bounds, marker) {
            return bounds.extend(marker.getPosition());
        }, new google.maps.LatLngBounds());
    }

    function distanceBetween(a, b) {
        return Math.sqrt(
            Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2)
        );
    }





    window.createOverlayForMap(map);
  }
};
