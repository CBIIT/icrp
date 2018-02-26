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

    map.addListener('click', function() {
        for (var i = 0; i < infoWindows.length; i ++)
            infoWindows[i].close();
    });

    // resize map icons when zoom level is changed.
    map.addListener('zoom_changed', function() {
        for (let i = 0; i < markers.length; i ++) {
            if (markers[i].getMap() != null) {
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

    $('#select-partner, #exclude-former').change(function () {
        var sponsorCode = $('#select-partner').val();
        var excludeFormer = $('#exclude-former').prop('checked');

        var partners = window.mapData.partners.filter(function (partner) {
            return !(partner.latitude == 0 && partner.longitude == 0)
                && (sponsorCode == '' || sponsorCode == partner.sponsorcode)
                && (excludeFormer == false || !/former/i.test(partner.status))
        })

        var fundingOrganizations = window.mapData.fundingOrganizations.filter(function (fundingOrganization) {
            return !(fundingOrganization.latitude == 0 && fundingOrganization.longitude == 0)
                && (sponsorCode == '' || sponsorCode == fundingOrganization.sponsorcode)
                && (excludeFormer == false || !/former/i.test(fundingOrganization.memberstatus))
                && (!/partner/i.test(fundingOrganization.membertype))
        });

        for (var i = 0; i < markers.length; i ++)
            markers[i].setMap(null);

        for (var j = 0; j < infoWindows.length; j ++)
            infoWindows[j].close();

        var bounds = new google.maps.LatLngBounds();

        partners.forEach(function(partner) {
            var position = {
                lng: + partner.longitude,
                lat: + partner.latitude
            };

            var infoWindow = new google.maps.InfoWindow({
                content: $('<div/>')
                    .css('margin', '0 4px 0 0')
                    .css('line-height', '1.25')
                    .css('font-weight', 'normal')
                    .append($('<div/>')
                        .addClass('d-flex justify-content-between')
                        .append($('<div>')
                            .css('margin', '0 16px 8px 0')
                            .html(
                                partner.website
                                    ? $('<a>', {
                                        href: partner.website,
                                        target: '_blank',
                                    }).text(partner.name)
                                    : $('<span>').text(partner.name))
                            .prepend($('<b>')
                                .text('Partner:')
                                .css('margin-right', '4px'))
                            .append($('<span>')
                                .text(/former/i.test(partner.status) ? '(Former)' : '')
                                .css('color', '#aaa')
                                .css('margin-left', '4px')))

                        .append(
                            partner.email
                                ? $('<a>', {href: 'mailto:' + partner.email})
                                    .append('<span style="margin-right: 4px;">email</span>')
                                    .append('<i class="far fa-envelope"></i>')
                                : ''
                        )
                    )
                    .append($('<hr>').css('margin', '0 0 8px 0'))
                    .append($('<span>').html(
                        partner.logofile
                            ? $('<img>', {
                                src: '/data/uploads/partner-logos/' + partner.logofile,
                                alt: 'Logo for ' + partner.name})
                                    .css('max-width', '100px')
                                    .css('max-height', '100px')
                                    .css('margin', '0 10px 6px 0')
                                    .addClass('pull-left')
                            : ''))
                    .append($('<div>').html(partner.description))
                    .append($('<hr>').css('margin', '8px 0 8px 0'))
                    .append($('<div>')
                        .text('Country: ' + partner.country))
                    .append($('<div>')
                        .text('Funding Organization: ' + (function(partner) {
                            var fundingOrganization = mapData.fundingOrganizations.filter(function(fundingOrganization) {
                                return /partner/i.test(fundingOrganization.membertype)
                                    && fundingOrganization.sponsorcode === partner.sponsorcode
                                    && fundingOrganization.name === partner.name
                            });

                            return fundingOrganization && fundingOrganization.length > 0
                                ? 'Yes' + (/former/i.test(fundingOrganization[0].memberstatus) ? ' (Former)' : '')
                                : 'No';
                        })(partner)))
                    .prop('outerHTML')
            });

            var marker = createMarker('steelblue', position, 0, map)
            marker.addListener('click', function() {
               for (var i = 0; i < infoWindows.length; i ++)
                   infoWindows[i].close();
                infoWindow.open(map, marker);
            });

            infoWindows.push(infoWindow);
            markers.push(marker);
            bounds.extend(marker.getPosition());
        });

        fundingOrganizations.forEach(function(fundingOrganization) {
            var position = {
                lng: + fundingOrganization.longitude,
                lat: + fundingOrganization.latitude
            };

            var infoWindow = new google.maps.InfoWindow({
                content: $('<div>')
                    .css('margin', '0 4px 0 0')
                    .css('line-height', '1.25')
                    .css('font-weight', 'normal')
                    .append($('<div>')
                        .css('margin', '0 16px 8px 0')
                        .html(
                            fundingOrganization.website
                                ? $('<a>', {
                                    href: fundingOrganization.website,
                                    target: '_blank',
                                }).text(fundingOrganization.name)
                                : $('<span>').text(fundingOrganization.name))
                            .prepend($('<b>')
                                .text('Funding Organization:')
                                .css('margin-right', '4px')))
                    .append($('<hr>').css('margin', '0 0 8px 0'))
                    .append($('<div>').html('<b>Partner: </b>'
                        + mapData.partners.filter(function(partner) {
                            return partner.sponsorcode == fundingOrganization.sponsorcode
                        })[0].name))
                    .append($('<div/>').html('<b>Sponsor Code: </b>' + fundingOrganization.sponsorcode))
                    .append($('<div/>').html('<b>Country: </b>' + fundingOrganization.country))
                    .prop('outerHTML')
            });

            var marker = createMarker('orange', position, -1, map);
            marker.addListener('click', function() {
                for (var i = 0; i < infoWindows.length; i ++)
                    infoWindows[i].close();
                 infoWindow.open(map, marker);
             });

            infoWindows.push(infoWindow);
            markers.push(marker);
            bounds.extend(marker.getPosition());
        })

        if (sponsorCode == '' || (partners.length == 0 && fundingOrganizations.length == 0)) {
            map.panTo({lat: 15, lng: 0});
            map.setZoom(2)
        } else {
            map.fitBounds(bounds);
            if (partners.length + fundingOrganizations.length == 1
                || (partners.length == 1 && fundingOrganizations.length == 1
                    && partners[0].latitude == fundingOrganizations[0].latitude
                    && partners[0].longitude == fundingOrganizations[0].longitude)
            ) {
                map.setZoom(4);
            }
        }

    }).trigger('change');

    function createMarker(color, position, zIndex, map) {
        return new google.maps.Marker({
            position: position,
            map: map,
            icon: {
                url: '/modules/custom/icrp_partners/src/Assets/images/marker.' + color + '.svg',
                origin: {x: 6, y: 16},
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