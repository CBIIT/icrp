(function ($) {
  Drupal.behaviors.countryIncomeBandBehavior = {
    attach: function (context, settings) {
      var countryIncomeBands = {};
      var incomeBandTitles = {
        H: 'High Income',
        MU: 'Upper Middle Income',
        ML: 'Lower Middle Income',
        L: 'Low Income'
      };

      // load income bands for each country
      $.getJSON('/api/country-income-bands').then(function setCountryIncomeBands(countries) {
        countries.forEach(function setCountryIncomeBand(country) {
          countryIncomeBands[country.abbreviation] = country.incomeBand;
        });
      });

      // when the country is changed, update the income band
      $('[name="country"]').change(function setIncomeBand() {
        var country = $(this).val();
        var incomeBand = countryIncomeBands[country] || '';
        var incomeBandTitle = incomeBandTitles[incomeBand] || 'N/A';

        $('[name="income_band"]').val(incomeBand).change();
        $('#edit-country--description').text("World Bank Income Band: " + incomeBandTitle);
      });

      // when the income band is changed, set reduced fees if applicable
      $('[name="income_band"]').change(function setReducedFees() {
        var incomeBand = $(this).val();
        var reducedFees = incomeBand == 'MU' || incomeBand == 'ML' || incomeBand == 'L';

        if (reducedFees) {
          $('[name="reduced_fees"]').prop('checked', true);
          $('.max_fee').hide();
          $('.reduced_fee').show();
        } else {
          $('[name="reduced_fees"]').prop('checked', false);
          $('.max_fee').show();
          $('.reduced_fee').hide();
        }
      });
    }
  }
})(jQuery);