// @ts-nocheck
(function () {
    var map = new google.maps.Map(document.getElementById('partner-map'), {
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

    var overlayInitialized = false;
    var overlay = new google.maps.OverlayView();
    overlay.draw = function() {};
    overlay.setMap(map);

    map.addListener('idle', function() {
        if (!overlayInitialized) {
            overlayInitialized = true;
            $('#select-partner').trigger('change');
        }
    });

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
            return (sponsorCode == '' || sponsorCode == partner.sponsorcode)
                && (excludeFormer == false || !/former/i.test(partner.status))
        });

        var fundingOrganizations = window.mapData.fundingOrganizations.filter(function (fundingOrganization) {
            return (sponsorCode == '' || sponsorCode == fundingOrganization.sponsorcode)
                && (excludeFormer == false || !/former/i.test(fundingOrganization.memberstatus))
        });

        $('[data-total-partners]').text(partners.length)
        $('[data-total-funding-organizations]').text(fundingOrganizations.length);

        var mappedPartners = partners.filter(function (partner) {
            return !(partner.latitude == 0 && partner.longitude == 0)
        })

        var mappedFundingOrganizations = fundingOrganizations.filter(function (fundingOrganization) {
            return !(fundingOrganization.latitude == 0 && fundingOrganization.longitude == 0)
                && !(/partner/i.test(fundingOrganization.membertype));
        });

        locations.length = 0;

        mappedPartners.forEach(function(partner) {
            partner.markerType = 'partner';
            locations.push(partner);
        })

        mappedFundingOrganizations.forEach(function(fundingOrganization) {
            fundingOrganization.markerType = 'fundingOrganization';
            locations.push(fundingOrganization);
        });

        drawMap();
        setTimeout(function() {
            // map.setZoom(map.getZoom());
            if (sponsorCode == '') {
                map.setZoom(2);
                map.setCenter({
                    lat: 20,
                    lng: 0
                });
            }

            else if (markers.length == 1) {
                map.setZoom(4);
                map.setCenter(markers[0].getPosition());
            }

            else {
                map.fitBounds(getBounds(markers));
            }
        }, 100);
    });

    function clearMarkers() {
        for (var i = 0; i < markers.length; i ++)
            markers[i].setMap(null);

        for (var j = 0; j < infoWindows.length; j ++)
            infoWindows[j].close();

        markers.length = 0;
        infoWindows.length = 0;

        // force redraw
        map.setZoom(map.getZoom());
    }

    function drawMap() {
        clearMarkers();
        var groups = groupItems(overlay, locations, 0);
        groups.forEach(function(group) {
            if (group.length == 1) {
                var item = group[0];
                var position = {
                    lng: + item.longitude,
                    lat: + item.latitude,
                };

                if (item.markerType == 'partner') {
                    (function() {
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
                                            item.website
                                                ? $('<a>', {
                                                    href: item.website,
                                                    target: '_blank',
                                                }).text(item.name)
                                                : $('<span>').text(item.name))
                                        .prepend($('<b>')
                                            .text('Partner:')
                                            .css('margin-right', '4px'))
                                        .append($('<span>')
                                            .text(/former/i.test(item.status) ? '(Former)' : '')
                                            .css('color', '#aaa')
                                            .css('margin-left', '4px')))

                                    .append(
                                        item.email
                                            ? $('<a>', {href: 'mailto:' + item.email})
                                                .append('<span style="margin-right: 4px;">email</span>')
                                                .append('<i class="far fa-envelope"></i>')
                                            : ''
                                    )
                                )
                                .append($('<hr>').css('margin', '0 0 8px 0'))
                                .append($('<span>').html(
                                    item.logofile
                                        ? $('<img>', {
                                            src: '/data/uploads/partner-logos/' + item.logofile,
                                            alt: 'Logo for ' + item.name})
                                                .css('max-width', '100px')
                                                .css('max-height', '100px')
                                                .css('margin', '0 10px 6px 0')
                                                .addClass('pull-left')
                                        : ''))
                                .append($('<div>').addClass('clearfix').html(item.description))
                                .append($('<hr>').css('margin', '8px 0 8px 0'))
                                .append($('<div>')
                                    .text('Country: ' + item.country))
                                .append($('<div>')
                                    .text('Funding Organization: ' + (function(item) {
                                        var fundingOrganizations = window.mapData.fundingOrganizations.filter(function (fundingOrganization) {
                                            return fundingOrganization.name == item.name;
                                        });
                                        return fundingOrganizations && fundingOrganizations.length > 0
                                            ? 'Yes' + (/former/i.test(fundingOrganizations[0].memberstatus) ? ' (Former)' : '')
                                            : 'No';
                                    })(item)))
                                [0]
                        });

                        var marker = createMarker('steelblue', position, 1, map);
                        marker.addListener('click', function() {
                        for (var i = 0; i < infoWindows.length; i ++)
                            infoWindows[i].close();
                            infoWindow.open(map, marker);
                        });

                        infoWindows.push(infoWindow);
                        markers.push(marker);
                    })();
                }

                else if (item.markerType == 'fundingOrganization') {
                    (function() {
                        var infoWindow = new google.maps.InfoWindow({
                            content: $('<div>')
                                .css('margin', '0 4px 0 0')
                                .css('line-height', '1.25')
                                .css('font-weight', 'normal')
                                .append($('<div/>')
                                    .addClass('d-flex justify-content-between')
                                    .append($('<div>')
                                        .css('margin', '0 16px 8px 0')
                                        .html(
                                            item.website
                                                ? $('<a>', {
                                                    href: item.website,
                                                    target: '_blank',
                                                }).text(item.name)
                                                : $('<span>').text(item.name))
                                        .prepend($('<b>')
                                            .text('Funding Organization:')
                                            .css('margin-right', '4px'))
                                        .append($('<span>')
                                            .text(/former/i.test(item.memberstatus) ? '(Former)' : '')
                                            .css('color', '#aaa')
                                            .css('margin-left', '4px')))
                                )
                                .append($('<hr>').css('margin', '0 0 8px 0'))
                                .append($('<div>')
                                    .addClass('d-flex')
                                    .append($('<div>')
                                        .css('min-width', '100px')
                                        .text('Partner: '))
                                    .append($('<div>').text(item.partner)))
                                .append($('<div>')
                                    .addClass('d-flex')
                                    .append($('<div>')
                                        .css('min-width', '100px')
                                        .text('Sponsor Code: '))
                                    .append($('<div>')
                                        .text(item.sponsorcode)))
                                .append($('<div>')
                                    .addClass('d-flex')
                                    .append($('<div>')
                                        .css('min-width', '100px')
                                        .text('Country: '))
                                    .append($('<div>')
                                        .text(item.country)))
                                [0]
                        });

                        var marker = createMarker('orange', position, -1, map);
                        marker.addListener('click', function() {
                            for (var i = 0; i < infoWindows.length; i ++)
                                infoWindows[i].close();
                            infoWindow.open(map, marker);
                        });

                        infoWindows.push(infoWindow);
                        markers.push(marker);
                    })();
                }
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

                    var partners = group.filter(function(item) {
                        return item.markerType === 'partner';
                    });

                    var fundingOrganizations = group.filter(function(item) {
                        return item.markerType === 'fundingOrganization';
                    });

                    var marker = createMarker('green', position, 1, map);

                    var infoWindow = new google.maps.InfoWindow({
                        content: $('<div>')
                            .css('margin', '0 4px 0 0')
                            .css('line-height', '1.25')
                            .css('font-weight', 'normal')
                            .append($('<b>')
                                .text(partners.length + ' Partner(s) and '
                                    + fundingOrganizations.length + ' Funding Organization(s)')
                                .css('color', 'steelblue')
                                .css('text-decoration', 'underline')
                                .css('cursor', 'pointer')
                                .click(function() {
                                    map.fitBounds(bounds);
                                    marker.setMap(null);

                                    locations.length = 0;
                                    group.forEach(function(item) {
                                        locations.push(item);
                                    });

                                    setTimeout(function() {
                                        drawMap();
                                        map.setZoom(map.getZoom());
                                    }, 100);
                                })
                            )
                            .append($('<hr>').css('margin', '0 0 8px 0'))
                            [0]
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
    }

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

    function groupMarkers(overlay, markers, radius) {
        var groups = [];
        var projection = overlay.getProjection();

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

        return groups;
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
})();