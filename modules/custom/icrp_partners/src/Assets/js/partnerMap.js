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

        var bounds = new google.maps.LatLngBounds();

        partners.forEach(function(partner) {
            var position = {
                lng: + partner.Longitude,
                lat: + partner.Latitude
            };

            var infoWindow = new google.maps.InfoWindow({
                content: $('<div/>')
                    .css('margin', '0 4px 0 0')
                    .css('line-height', '1.15')
                    .css('font-weight', 'normal')
                    .append($('<div/>')
                        .addClass('d-flex justify-content-between')
                        .append($('<b>')
                            .css('margin', '0 16px 8px 0')
                            .html(
                                partner.Website
                                    ? $('<a>', {
                                        href: partner.Website,
                                        target: '_blank',
                                    }).text(partner.Name)
                                    : $('<span>').text(partner.Name))
                            .prepend($('<b>')
                                .text('Partner:')
                                .css('margin-right', '4px')))
                        .append(
                            partner.Email
                                ? $('<a>', {href: 'mailto:' + partner.Email})
                                    .append('<span style="margin-right: 4px;">email</span>')
                                    .append('<i class="far fa-envelope"></i>')
                                : ''
                        )
                    )
                    .append($('<hr>').css('margin', '0 0 8px 0'))
                    .append($('<span>').html(
                        partner.LogoFile
                            ? $('<img>', {
                                src: '/data/uploads/partner-logos/' + partner.LogoFile,
                                alt: 'Logo for ' + partner.Name})
                                    .css('max-width', '100px')
                                    .css('max-height', '100px')
                                    .css('margin', '0 10px 6px 0')
                                    .addClass('pull-left')
                            : ''))
                    .append($('<div />').html(partner.Description))
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
                lng: + fundingOrganization.Longitude,
                lat: + fundingOrganization.Latitude
            };

            var infoWindow = new google.maps.InfoWindow({
                content: $('<div/>')
                    .css('margin', '0 4px 0 0')
                    .css('line-height', '1.15')
                    .css('font-weight', 'normal')
                    .append($('<b>')
                        .css('margin', '0 16px 8px 0')
                        .html(
                            fundingOrganization.Website
                                ? $('<a>', {
                                    href: fundingOrganization.Website,
                                    target: '_blank',
                                }).text(fundingOrganization.Name)
                                : $('<span>').text(fundingOrganization.Name))
                            .prepend($('<b>')
                                .text('Funding Organization:')
                                .css('margin-right', '4px')))
                    .append($('<hr/>').css('margin', '0 0 8px 0'))
                    .append($('<div/>').html('<b>Partner: </b>'
                        + partners.filter(function(partner) {
                            return partner.SponsorCode == fundingOrganization.SponsorCode
                        })[0].Name))
                    .append($('<div/>').html('<b>Sponsor Code: </b>' + fundingOrganization.SponsorCode))
                    .append($('<div/>').html('<b>Country: </b>' + fundingOrganization.Country))
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

        if (sponsorCode == '') {
            map.panTo({lat: 15, lng: 0});
            map.setZoom(2)
        } else {
            map.fitBounds(bounds);
            if (partners.length + fundingOrganizations.length == 1
                || (partners.length == 1 && fundingOrganizations.length == 1
                    && partners[0].Latitude == fundingOrganizations[0].Latitude
                    && partners[0].Longitude == fundingOrganizations[0].Longitude)
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