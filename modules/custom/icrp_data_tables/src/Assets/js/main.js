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
    if (location.pathname != '/upload-completeness') return;

    var table = $('#upload-completeness').DataTable({
        pagingType: 'simple_numbers',
        lengthMenu: [
            25, 50, 100, 150
        ],
        dom: "<'d-flex align-items-center flex-wrap justify-content-between'"
            + "<li> p"
            + "><'table-responsive't>",
        autoWidth: false,
        language: {
            lengthMenu: 'Display _MENU_',
            info: '<label style="margin-left: 5px">of _TOTAL_ funding organizations</label>',
            infoFiltered: '',
            infoEmpty: '',
        },
        aaSorting: [],
    });

    $('#loading').hide();


    if (drupalSettings.isManager) {
        // allows a manager to update a funding organization's data upload status
        $('[data-funding-organization-id]').click(function(e) {
            e.preventDefault();

            // find the funding organization this link refers to
            var fundingOrgId = $(this).attr('data-funding-organization-id');
            var fundingOrg = drupalSettings.fundingOrganizations.find(function(e) {
                return e.id == fundingOrgId;
            });

            // open a modal dialog to edit the funding organization's upload status
            var modal = $('#edit-funding-organization-modal')
                .modal({backdrop: 'static'})
                .modal('show');

            // set the title of the modal
            $(modal).find('.modal-title').text(fundingOrg.fundingOrganization);

            // find each data column in the modal and populate its inputs with the correct value
            $(modal).find('table [data-column]').each(function() {
                var year = $(this).attr('data-column');
                var status = fundingOrg[year];
                $(this).find('input').val([status]);
            });

            $(modal).find('[data-submit]').click(function(e) {
                console.log($(modal).find('form').serializeArray())

            })

            var parameters = {
                fundingOrgId: fundingOrgId,
            }

        })

    }
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
