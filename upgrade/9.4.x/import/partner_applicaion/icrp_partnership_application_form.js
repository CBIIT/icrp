(function ($) {

    Drupal.behaviors.countryIncomeBandBehavior = {
      attach: function(context, settings) {
          var countryIncomeBands = {};
          var incomeBandTitles = {
            "H": "High Income", 
            "MU":"Upper Middle Income", 
            "ML":"Lower Middle Income", 
            "L":"Low Income"
          }
          
          $.getJSON('/api/country-income-bands').then(function(countries) {
            countries.forEach(function(country) {
              countryIncomeBands[country.abbreviation] = country.incomeBand;
            })
          });
          
          $('[name="country"]').change(function() {
            var country = $(this).val();
            var incomeBand = countryIncomeBands[country] || '';
            var incomeBandTitle = incomeBandTitles[incomeBand] || 'N/A';
            var reducedFees = (incomeBand == 'MU' || incomeBand == 'ML' || incomeBand == 'L');
            $('[name="income_band"]').val(incomeBand);
            $('#edit-country--description').text("World Bank Income Band: " + incomeBandTitle);
            $('[name="reduced_fees"]').prop('checked', reducedFees);

            if (reducedFees) {
                $('.max_fee').hide();
                $('.reduced_fee').show();
            } else {
                $('.max_fee').show();
                $('.reduced_fee').hide();
            }
          });
      }
    }
})(jQuery);