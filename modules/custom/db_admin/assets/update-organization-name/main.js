(function ($, drupalSettings) {
    var fields = drupalSettings.db_admin.update_organization_name.fields;
    var $form = $('#update-name-form');
    var formValues = getInitialFormValues();
    updateFormDisplay($form, formValues);
    console.log(fields);

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

        if (name === 'organizationType') {
            formValues.partnerId = '';
            formValues.currentName = '';
            formValues.sponsorCode = '';
            formValues.fundingOrgId = '';
            formValues.abbreviation = '';
            formValues.fundingOrganizations = [];
        }

        // populate fields for partner-only selection
        if (name === 'partnerId') {
            // partner is guaranteed to exist
            var partner = fields.partners.filter(function (p) {
                return +p.partnerid === +value;
            })[0];

            formValues.partner = partner;
            formValues.currentName = partner.name;
            formValues.sponsorCode = partner.sponsorcode;

            // attempt to populate funding org as well, if applicable
            var fundingOrganizations = fields.fundingOrganizations.filter(function (f) {
                return f.partner === partner.name;
            });

            formValues.fundingOrganizations = fundingOrganizations;

            if (fundingOrganizations.length) {
                let fundingOrganization = fundingOrganizations[0];
                formValues.fundingOrganization = fundingOrganization;
                formValues.fundingOrgId = fundingOrganization.fundingorgid;
                formValues.abbreviation = fundingOrganization.abbreviation;
            } else {
                formValues.fundingOrgId = '';
                formValues.abbreviation = '';
            }
        }

        else if (name === 'fundingOrgId') {
            var fundingOrganization = fields.fundingOrganizations.filter(function (p) {
                return +p.fundingorgid === +value;
            })[0];

            formValues.fundingOrganization = fundingOrganization;
            formValues.fundingOrgId = fundingOrganization.fundingorgid;
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
                    message: '<strong>' + oldName + ' (' + oldAbbreviation + ')</strong> has been renamed to <strong>' +
                        params.name + ' (' +
                        (params.sponsorCode || params.abbreviation) +
                        ')</strong>. ',
                });

                formValues = getInitialFormValues();
                updateFormDisplay($form, formValues);

                // patch fields with updated values
                $.getJSON('/api/admin/organization-name/fields').done(function(newFields) {
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
                $('#partnerId').append($('<option />').attr('data-type', 'partner').val(p.partnerid).text(p.name))
            });
            newFields.fundingOrganizations.forEach(function(f) {
                $('#fundingOrgId').append($('<option />').attr('data-type', 'fundingOrganization').val(f.fundingorgid).text(f.name))
            });
        }

        // show/hide funding organization options based on the current selection
        $('#fundingOrgId option').each(function () {
            var $this = $(this);
            var showInput = formValues.fundingOrganizations.filter(function (f) {
                return +f.fundingorgid === +$this.val();
            }).length > 0;

            if (showInput) {
                $this.removeAttr('hidden');
            } else {
                $this.attr('hidden', true);
            }
        });

        // update placeholder if no funding organizations are available
        $('#fundingOrgIdPlaceholder').text(
            formValues.partnerId && formValues.fundingOrganizations.length === 0
                ? 'No Available Funding Organizations'
                : 'Select a Funding Organization'
        )

        // replicate formValue to inputs
        $form.find('input, select').each(function () {
            if (this.type === 'radio') {
                this.checked = this.value === formValues[this.name];
            } else {
                this.value = formValues[this.name];
            }
        });

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

        // enable/disable submit based on form validity
        if (formValues.valid) {
            $form.find('[type="submit"]').removeAttr('disabled');
        } else {
            $form.find('[type="submit"]').attr('disabled', true);
        }
    }

})(jQuery, drupalSettings);