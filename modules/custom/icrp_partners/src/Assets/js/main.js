$(function() {
    var initialized = false;
    var table;

    $('.nav-tabs a[href="#partners"]').on('shown.bs.tab', function(event) {
        if (!initialized) {
            table = $('#partners table').DataTable({
                paging: false,
                ordering: false,
                dom: "<'table-responsive't>",
                autoWidth: false,
            });
            initialized = true;
        }
    });

    $('#exclude-former-partners').change(function(event) {
        if (this.checked && table) {
            table.column(4).search('Current').draw();
        }

        else if (!this.checked) {
            table.column(4).search('').draw();
        }
    });
});

$(function() {
    var initialized = false;
    var table;

    $('.nav-tabs a[href="#funding-organizations"]').on('shown.bs.tab', function(event) {
        if (!initialized) {
            table = $('#funding-organizations table').DataTable({
                pagingType: 'simple_numbers',
                lengthMenu: [ 25, 50, 100, 150 ],
                dom: "<'d-flex-responsive'<'mr-40 mv-5'f><'mr-40 mv-5'L><'mv-5'p>>"
                   + "<'table-responsive't>",
                autoWidth: false,
                language: {
                    lengthMenu: "Display _MENU_ of <b>_TOTAL_RECORDS_</b> funding organizations",
                }
            });

            window.setTimeout(function() {
                $('#funding-organizations table').enableResizableColumns({
                    preserveWidth: true,
                });
            }, 10);

            initialized = true;
        }
    });

    $('#exclude-former-funding-organizations').change(function(event) {
        if (this.checked && table) {
            table.column(2).search('Current').draw();
        }

        else if (!this.checked) {
            table.column(2).search('').draw();
        }
    });
});
