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
            $(modal).find('.modal-title').text('Update Data Upload Completeness - '
                + fundingOrg.fundingOrganization);

            // find each data column in the modal and populate its inputs with the correct value
            $(modal).find('table [data-column]').each(function() {
                var year = $(this).attr('data-column');
                var status = fundingOrg[year];
                $(this).find('input').val([status]);
            });


            // when we submit this modal's form, we should update the upload status
            // if successful, update the main table's images in-place to reflect the new status
            $(modal).find('[data-submit]').click(function(e) {

                // contains name, value pairs for data upload years and their status
                // eg: [{name: '2018', value: 2}, {name: '2017', value: 1}, ...]
                var fundingOrgStatus = $(modal).find('form').serializeArray();

                var completedYears = fundingOrgStatus.filter(function(e) {
                    return e.value == 2;
                }).map(function(e) {
                    return e.name;
                });

                var partialUploadYears = fundingOrgStatus.filter(function(e) {
                    return e.value == 1;
                }).map(function(e) {
                    return e.name;
                });

                var parameters = {
                    fundingOrgId: fundingOrgId,
                    completedYears: completedYears.join(','),
                    partialUploadYears: partialUploadYears.join(','),
                };

                // update upload completeness
                // if we are successful, update the table images
                $.post('/update-upload-completeness', JSON.stringify(parameters))
                    .done(function(response) {
                        // a response of true means "success"
                        if (response) {

                            // a key of '0' means we should use a gray dot (no data uploaded)
                            // '1': green dot (partial upload)
                            // '2': yellow dot (completed upload)
                            var imagesPath = drupalSettings.basePath + '/src/Assets/images/';
                            var imageAttributes = [
                              {src: imagesPath + '/gray-dot.svg', title: 'No Data'},
                              {src: imagesPath + '/yellow-dot.svg', title: 'Partial Upload'},
                              {src: imagesPath + '/green-dot.svg', title: 'Upload Complete'},
                            ];

                            // status = { name: 'year of status', value: 'value of status (either 0,1,2)'}
                            fundingOrgStatus.forEach(function(status) {
                                fundingOrg[status.name] = status.value;

                                // get the source of the new status image
                                var attributes = imageAttributes[+status.value];

                                // find the image for the funding organization's year
                                // and update its src attribute
                                var tableCell = $('#upload-completeness td').filter(function() {
                                    return $(this).attr('data-id') == fundingOrgId
                                        && $(this).attr('data-column') == status.name;
                                });

                                $(tableCell).find('img').attr(attributes);
                                $(tableCell).find('[data-value]').text(status.value);
                            });
                            $(modal).modal('hide');

                            var alert = $('#alert-template .alert').clone();
                            alert.addClass('alert-success')
                                .find('.alert-content')
                                .html('The funding organization <b>' + fundingOrg.fundingOrganization + '</b> has been updated.');
                            $('#status').html(alert);
                        }
                    }).fail(function(error) {
                        console.log(error);
                        // var errorResponse = JSON.parse(error.responseJSON);
                        $(modal).modal('hide');
                        var alert = $('#alert-template .alert').clone();
                        alert.addClass('alert-danger')
                            .find('.alert-content')
                            .text('The funding organization could not be updated: ' + error.responseJSON);
                        $('#status').html(alert);
                    });
            })
        })
    }

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
