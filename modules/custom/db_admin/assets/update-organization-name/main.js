(function ($, drupalSettings) {
    var fields = drupalSettings.db_admin.update_organization_name.fields;
    var $form = $('#update-name-form');
    var formValues = getInitialFormValues();
    updateFormDisplay($form, formValues);
    // console.log(fields);

    // on inputs, process changes to other form values
    $form.find('input, select').on('input', function (e) {
        var target = e.target;
        var name = target.name;
        var value = target.value;
        formValues[name] = value;

        // reset user-editable fields if any of the other fields changes
        if (![
            'newPartnerName',
            'newPartnerSponsorCode',
            'newFundingOrgName',
            'newFundingOrgAbbreviation',
        ].includes(name)) {
            formValues.newPartnerName = '';
            formValues.newPartnerSponsorCode = '';
            formValues.newFundingOrgName = '';
            formValues.newFundingOrgAbbreviation = '';
        }

        // clear rest of form if organization type has changed
        if (name === 'organizationType') {
            formValues.partnerId = '';
            formValues.currentName = '';
            formValues.sponsorCode = '';
            formValues.fundingOrgId = '';
            formValues.abbreviation = '';
            formValues.fundingOrganizations = [];
        }

        if (name === 'partnerId') {
            var partner = _(fields.partners).where({partnerid: +value})[0];
            var fundingOrganizations = _(fields.fundingOrganizations).where({partner: partner.name});

            formValues.partner = partner;
            formValues.currentName = partner.name;
            formValues.sponsorCode = partner.sponsorcode;
            formValues.fundingOrganizations = fundingOrganizations;

            if (fundingOrganizations.length) {
                var fundingOrganization = fundingOrganizations[0];
                formValues.fundingOrganization = fundingOrganization;
                formValues.fundingOrgId = fundingOrganization.fundingorgid;
                formValues.abbreviation = fundingOrganization.abbreviation;
            } else {
                formValues.fundingOrganization = null;
                formValues.fundingOrgId = '';
                formValues.abbreviation = '';
            }
        }

        // update fundingOrgId and abbreviation when funding organization is changed
        else if (name === 'fundingOrgId') {
            var fundingOrganization = _(fields.fundingOrganizations).findWhere({fundingorgid: +value});
            formValues.fundingOrganization = fundingOrganization;
            formValues.abbreviation = fundingOrganization.abbreviation;
        }

        formValues.valid = Boolean(
            (
                formValues.organizationType === 'partner' &&
                formValues.partnerId &&
                formValues.newPartnerName &&
                formValues.newPartnerSponsorCode
            ) || (
                formValues.organizationType === 'fundingOrg' &&
                formValues.partnerId &&
                formValues.fundingOrgId &&
                formValues.newFundingOrgName &&
                formValues.newFundingOrgAbbreviation
            )
        );

        updateFormDisplay($form, formValues);
    });

    // on submission, call backend and reload form with updated organizations
    $form.submit(function (e) {
        e.preventDefault();
        if (!formValues.valid) return false;

        $form.find('[type="submit"]').attr('disabled', true);
        var organizationType = formValues.organizationType;

        var endpoint = organizationType === 'partner'
            ? '/api/admin/partners/update-name'
            : '/api/admin/funding-organizations/update-name';

        var params = organizationType === 'partner'
            ? {
                partnerId: formValues.partnerId,
                name: formValues.newPartnerName,
                sponsorCode: formValues.newPartnerSponsorCode
            }
            : {
                fundingOrgId: formValues.fundingOrgId,
                name: formValues.newFundingOrgName,
                abbreviation: formValues.newFundingOrgAbbreviation,
            };

        $.post(endpoint, params)
            .done(function () {
                var oldName = organizationType === 'partner'
                    ? formValues.partner.name
                    : formValues.fundingOrganization.name;

                var oldAbbreviation = organizationType === 'partner'
                    ? formValues.partner.sponsorcode
                    : formValues.fundingOrganization.abbreviation;

                showAlert({
                    type: 'success',
                    message: _.template(
                        '<strong><%= oldName %> (<%= oldAbbreviation %>)</strong>' +
                        ' has been renamed to ' +
                        '<strong><%= newName %> (<%= newAbbreviation %>)</strong>'
                    )({
                        oldName: oldName,
                        oldAbbreviation: oldAbbreviation,
                        newName: params.name,
                        newAbbreviation: (params.sponsorCode || params.abbreviation)
                    }),
                });

                // patch fields with updated values
                $.getJSON('/api/admin/organization-name/fields').done(function(newFields) {
                    formValues = getInitialFormValues();
                    fields = newFields;
                    updateFormDisplay($form, formValues, newFields);
                })
            })
            .fail(function (e) {
                console.log(e);
                showAlert({
                    type: 'danger',
                    message: '<strong>Error: </strong>' + e.responseJSON,
                });
            })
            .always(function () {
                $form.find('[type="submit"]').removeAttr('disabled');
            });
    });

    $form.on('reset', function (e) {
        $('#alerts-container').empty();
    });

    function showAlert(config) {
        $('#alerts-container').empty();
        var template = $('#alert-template').html();
        var bootstrapAlert = $(template)
            .addClass('alert-' + config.type)
            .append(config.message);
        $('#alerts-container').append(bootstrapAlert);
    }

    function getInitialFormValues() {
        return {
            organizationType: 'partner',
            partnerId: '',
            currentName: '',
            sponsorCode: '',
            newPartnerName: '',
            newPartnerSponsorCode: '',
            fundingOrgId: '',
            abbreviation: '',
            newFundingOrgName: '',
            newFundingOrgAbbreviation: '',
            valid: false,
            fundingOrganizations: [],
            fundingOrganization: null,
            partner: null,
        };
    }

    // renders formValues to $form
    function updateFormDisplay($form, formValues, newFields) {

        if (newFields) {
            $('#partnerId option[data-type="partner"]').remove();
            $('#fundingOrgId option[data-type="fundingOrganization"]').remove();

            newFields.partners.forEach(function(p) {
                $('#partnerId').append(
                    $('<option />')
                        .attr('data-type', 'partner')
                        .val(p.partnerid)
                        .text(p.name)
                );
            });
            newFields.fundingOrganizations.forEach(function(f) {
                $('#fundingOrgId').append(
                    $('<option />')
                        .attr('data-type', 'fundingOrganization')
                        .val(f.fundingorgid)
                        .text(f.name)
                );
            });
        }

        // show/hide funding organization options based on the current selection
        $('#fundingOrgId option').each(function () {
            var $this = $(this);
            var showInput = !!_(formValues.fundingOrganizations).findWhere({fundingorgid: $this.val()});
            $this.attr('hidden', showInput ? null : true);
        });

        // update placeholder if no funding organizations are available
        $('#fundingOrgIdPlaceholder').text(
            formValues.partnerId && formValues.fundingOrganizations.length === 0
                ? 'No Available Funding Organizations'
                : 'Select a Funding Organization'
        );

        // show and hide inputs based on organizationType
        var $partnerOnlyFields = $form.find('[data-type="partner-only"]');
        var $fundingOrgOnlyFields = $form.find('[data-type="funding-org-only"]');

        if (formValues.organizationType === 'partner') {
            $partnerOnlyFields.show();
            $fundingOrgOnlyFields.hide();
        } else if (formValues.organizationType === 'fundingOrg') {
            $partnerOnlyFields.hide();
            $fundingOrgOnlyFields.show();
        }

        // replicate formValue to inputs
        $form.find('input, select').each(function () {
            if (this.type === 'radio') {
                this.checked = this.value === formValues[this.name];
            } else {
                this.value = formValues[this.name];
            }
        });

        // enable/disable submit based on form validity
        $form
            .find('[type="submit"]')
            .attr('disabled', formValues.valid ? null : true);
    }

})(jQuery, drupalSettings);