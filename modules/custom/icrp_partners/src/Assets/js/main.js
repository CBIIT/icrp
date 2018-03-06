// @ts-nocheck
$(function () {
    var initialized = false;
    var table;

    $('.nav-tabs a[href="#partners"]').on('shown.bs.tab', function (event) {
        if (!initialized) {
            table = $('#partners table').DataTable({
                pagingType: 'simple_numbers',
                lengthMenu: [
                    5, 10, 25,
                ],
                pageLength: 25,
                dom: "<'d-flex align-items-center flex-wrap justify-content-between'"
                    + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'f><'mr-40 mv-5'C>>"
                    + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'li><'mv-5'p>>"
                    + "><'table-responsive't>",
                autoWidth: false,
                language: {
                    lengthMenu: 'Display _MENU_',
                    info: '<label style="margin-left: 5px">of _TOTAL_ partners</label>',
                    infoFiltered: '',
                    infoEmpty: '',
                },
                customDom: function(settings) {
                    return $('<label>Exclude Former Partners</label>')
                        .css('font-weight', 'normal')
                        .addClass('cursor-pointer noselect')
                        .prepend($('<input type="checkbox">')
                            .css('margin-right', '5px')
                            .change(function (event) {
                                if (this.checked && table) {
                                    table
                                        .column(4)
                                        .search('Current')
                                        .draw();
                                } else if (!this.checked) {
                                    table
                                        .column(4)
                                        .search('')
                                        .draw();
                                }
                            })
                        );
                },
            });

            initialized = true;
        }
    });
});

$(function () {
    var initialized = false;
    var table;

    $('.nav-tabs a[href="#funding-organizations"]').on('shown.bs.tab', function (event) {
        if (!initialized) {
            table = $('#funding-organizations table').DataTable({
                pagingType: 'simple_numbers',
                lengthMenu: [
                    25, 50, 100, 150
                ],
                dom: "<'d-flex align-items-center flex-wrap justify-content-between'"
                    + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'f><'mr-40 mv-5'C>>"
                    + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'li><'mv-5'p>>"
                    + "><'table-responsive't>",
                autoWidth: false,
                language: {
                    lengthMenu: 'Display _MENU_',
                    info: '<label style="margin-left: 5px">of _TOTAL_ funding organizations</label>',
                    infoFiltered: '',
                    infoEmpty: '',
                },
                customDom: function(settings) {
                    return $('<label>Exclude Former Funding Organizations</label>')
                        .css('font-weight', 'normal')
                        .addClass('cursor-pointer noselect')
                        .prepend($('<input type="checkbox">')
                            .css('margin-right', '5px')
                            .change(function (event) {
                                if (this.checked && table) {
                                    table
                                        .column(2)
                                        .search('Current')
                                        .draw();
                                } else if (!this.checked) {
                                    table
                                        .column(2)
                                        .search('')
                                        .draw();
                                }
                            })
                        );
                },
            })

            window.setTimeout(function () {
                $('#funding-organizations table')
                    .enableResizableColumns({
                        preserveWidth: true,
                        columnWidth: 80,
                    });
            }, 10);

            initialized = true;
        }
    });
});



$(function () {
    var initialized = false;
    var table;

    $('.nav-tabs a[href="#non-partners"]').on('shown.bs.tab', function (event) {
        if (!initialized) {
            table = $('#non-partners table').DataTable({
                pagingType: 'simple_numbers',
                lengthMenu: [
                    5, 10, 25,
                ],
                pageLength: 25,
                dom: "<'d-flex align-items-center flex-wrap justify-content-between'"
                    + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'f><'mr-40 mv-5'C>>"
                    + "<'d-flex align-items-center flex-wrap'<'mr-40 mv-5'li><'mv-5'p>>"
                    + "><'table-responsive't>",
                autoWidth: false,
                language: {
                    lengthMenu: 'Display _MENU_',
                    info: '<label style="margin-left: 5px">of _TOTAL_ records</label>',
                    infoFiltered: '',
                    infoEmpty: '',
                },
                customDom: function(settings) {
                    return $('<span>');
                },
            })

            window.setTimeout(function () {
                $('#non-partners table')
                    .enableResizableColumns({
                        preserveWidth: true,
                        columnWidth: 80,
                    });
            }, 10);

            initialized = true;
        }
    });
});
