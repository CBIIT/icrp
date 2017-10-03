drupalSettings.db_map = {
  initMap: function() {
    var baseUrl = '/sites/default/files/db_map/',
        map_center = db_people_map.funding_details.map(function(entry) {
          return {
            lat: parseFloat(entry.lat),
            lng: parseFloat(entry.long),
          };
        });
    map_center.unshift({
      latmin: Number.POSITIVE_INFINITY,
      latmax: Number.NEGATIVE_INFINITY,
      lngmin: Number.POSITIVE_INFINITY,
      lngmax: Number.NEGATIVE_INFINITY,
    });
    map_center = map_center.reduce(function(obj1,obj2) {
      return {
        latmin: obj2.lat < obj1.latmin ? obj2.lat : obj1.latmin,
        latmax: obj2.lat > obj1.latmax ? obj2.lat : obj1.latmax,
        lngmin: obj2.lng < obj1.lngmin ? obj2.lng : obj1.lngmin,
        lngmax: obj2.lng > obj1.lngmax ? obj2.lng : obj1.lngmax,
      };
    });
    var map_width = document.getElementById('icrp-map').offsetWidth,
        angle1 = map_center.lngmax-map_center.lngmin,
        angle2 = map_center.latmax-map_center.latmin,
        angle = angle1 > angle2 ? angle1 : angle2;
    angle = angle < 0 ? angle+360 : angle;
    var map = new google.maps.Map(document.getElementById('icrp-map'), {
      zoom: Math.round(Math.log(map_width*360/angle/256)/Math.LN2)-1,
      center: {
        lat: (map_center.latmin+map_center.latmax)/2,
        lng: (map_center.lngmin+map_center.lngmax)/2,
      },
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
    var pi = [],
        collab = [],
        polyline = [];
    for (var index in db_people_map.funding_details) {
      var detail = db_people_map.funding_details[index],
          is_pi = parseInt(detail.is_pi);
      var loc = {
        'lat': parseFloat(detail.lat),
        'lng': parseFloat(detail.long)
      };
      (is_pi?pi:collab).push(
        new google.maps.Marker({
          map: map,
          icon: is_pi ? baseUrl+'orangepin.png' : baseUrl+'yellowpin.png',
          position: loc,
          title: detail.pi_name,
        })
      );
    }
    for (var i in pi) {
      for (var j in collab) {
        polyline.push(new google.maps.Polyline({
          path: [
            pi[i].position,
            collab[j].position,
          ],
          strokeColor: '#000000',
          strokeWeight: 1,
          map: map
        }));
      }
    }
  }
};