// @ts-nocheck

$(function () {
    var table = $('#upload-status').DataTable({
        pagingType: 'simple_numbers',
        lengthMenu: [
            25, 50, 100, 150
        ],
        dom: "<'d-flex align-items-center flex-wrap justify-content-between'"
            + "Cp"
            + "><'table-responsive't>",
        autoWidth: false,
        language: {
            lengthMenu: 'Display _MENU_',
            info: '<label style="margin-left: 5px">of _TOTAL_ funding organizations</label>',
            infoFiltered: '',
            infoEmpty: '',
        },
        aaSorting: [],
        customDom: function(settings) {
            return $('<a href="/export/upload-status" class="btn btn-default btn-sm">')
                .text('Export')
                .prepend('<i class="fas fa-download mr-5">')

            ;
        },
    })

    setTimeout(function () {
        $('#upload-status')
            .enableResizableColumns({
                preserveWidth: true,
                columnWidth: 80,
            });
    }, 10);
});


$(function () {
    var table = $('#cancer-types').DataTable({
        dom: "<'table-responsive't>",
        autoWidth: false,
        aaSorting: [],
        paging: false,
    });

    setTimeout(function () {
        $('#cancer-types')
            .enableResizableColumns({
                preserveWidth: true,
                columnWidth: 80,
            });
    }, 0);
});
