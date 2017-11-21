drupalSettings.db_map = {
  initPeopleMap: function() {
    var baseUrl = '/sites/default/files/db_map/',
        markerBounds = new google.maps.LatLngBounds(),
        boundsFound = false,
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
            },
            marker = new google.maps.Marker({
              map: map,
              icon: is_pi ? baseUrl+'orangepin.png' : baseUrl+'yellowpin.png',
              position: loc,
              title: detail.pi_name,
            }),
            content = '<b>'+(is_pi?'Principal Investigator':'Collaborator')+'</b><br/>'+
                      '<hr style="margin:.5em 0px;"/>'+
                      'Name: '+detail.pi_name+'<br/>'+
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
    }
    window.createOverlayForMap(map);
  }
};