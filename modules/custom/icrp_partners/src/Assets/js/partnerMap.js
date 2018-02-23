// @ts-nocheck
(function () {
    var map = new google
        .maps
        .Map(document.getElementById('partner-map'), {
            center: {
                lat: 20,
                lng: 0
            },
            zoom: 2,
            disableDefaultUI: true,
            zoomControl: true,
            backgroundColor: 'transparent',
            styles: getDefaultStyles(),
        });

    var markers = [];
    var infoWindows = [];

    $('#select-partner, #exclude-former').change(function () {
        var sponsorCode = $('#select-partner').val();
        var excludeFormer = $('#exclude-former').prop('checked');

        var partners = window.mapData.partners.filter(function (partner) {
            return !(partner.Latitude == 0 && partner.Longitude == 0)
                && (sponsorCode == '' || sponsorCode == partner.SponsorCode)
                && (excludeFormer == false || !/Former/i.test(partner.Status))
        })

        var fundingOrganizations = window.mapData.fundingOrganizations.filter(function (fundingOrganization) {
            return !(fundingOrganization.Latitude == 0 && fundingOrganization.Longitude == 0)
                && (sponsorCode == '' || sponsorCode == fundingOrganization.SponsorCode)
                && (excludeFormer == false || !/Former/i.test(fundingOrganization.MemberStatus));
        });

        for (var i = 0; i < markers.length; i ++)
            markers[i].setMap(null);

        for (var j = 0; j < infoWindows.length; j ++)
            infoWindows[j].close();

        partners.forEach(function(partner) {
            var position = {
                lng: + partner.Longitude,
                lat: + partner.Latitude
            };

            var infoWindow = new google.maps.InfoWindow({
                content: $('<div/>')
                    .append($('<h4>').text(partner.Name).css('margin', '0 0 `8px 0').css('display', 'inline-block'))
                    .append($('<a />', {href: 'mailto:' + partner.Email}).addClass('pull-right').html('email <i class="far fa-envelope"></i>'))
                    .append($('<hr/>').css('margin', '0 0 8px 0'))
                    .append($('<img />', {
                        src: '/sites/default/files/partner-logos/' + partner.LogoFile
                    }).css('width', '100px').css('margin', '0 10px 10px 0').addClass('pull-left'))
                    .append($('<div />').html(partner.Description))
                    .prop('outerHTML')
            });

            var fillOpacity = /current/i.test(partner.Status) ? 1 : 0.5
            var marker = createMarker('steelblue', position, fillOpacity, 0, map)
            marker.addListener('click', function() {
               for (var i = 0; i < infoWindows.length; i ++)
                   infoWindows[i].close();
                infoWindow.open(map, marker);
            });

            infoWindows.push(infoWindow);
            markers.push(marker);
        });

        fundingOrganizations.forEach(function(fundingOrganization) {
            var position = {
                lng: + fundingOrganization.Longitude,
                lat: + fundingOrganization.Latitude
            };

            var infoWindow = new google.maps.InfoWindow({
                content: $('<div/>')
                    .append($('<h4>').text(fundingOrganization.Name).css('margin', '0 0 `8px 0'))
                    .append($('<hr/>').css('margin', '0 0 8px 0'))
                    .append($('<div />').html())
                    .prop('outerHTML')
            });

            var marker = createMarker('orange', position, 1, -1, map);
            marker.addListener('click', function() {
                for (var i = 0; i < infoWindows.length; i ++)
                    infoWindows[i].close();
                 infoWindow.open(map, marker);
             });

            infoWindows.push(infoWindow);
            markers.push(marker);
        })

    }).trigger('change');

    function createMarker(color, position, fillOpacity, zIndex, map) {
        return new google
            .maps
            .Marker({
                position: position,
                map: map,
                icon: {
                    path: "M 0 0, C -8 -10 8 -10 0 0, M 1 -5, A 1 1 0 1 0 1 -4.999",
                    fillOpacity: fillOpacity || 1,
                    fillColor: color,
                    strokeColor: 'white',
                    strokeOpacity: 1,
                    strokeWeight: 1,
                    scale: 3
                },
                zIndex: zIndex || 0
            });
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
})();