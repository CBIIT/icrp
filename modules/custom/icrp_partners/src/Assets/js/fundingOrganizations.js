$(function() {
    var initialized = false;
    $('.nav-tabs a[href="#funding-organizations"]').on('shown.bs.tab', function(event) {
        if (!initialized) {
            $('#funding-organizations table').DataTable({
                pagingType: 'full_numbers',
                lengthMenu: [ 25, 50, 100, 150 ],
                dom: "'<'d-flex-responsive'<'mr-40 mv-5'f><'mr-40 mv-5'L><'mv-5'p>>'"
                   + "'<'table-responsive't>",
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
});