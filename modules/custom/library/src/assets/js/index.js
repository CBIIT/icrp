jQuery(function() {
  jQuery('#library-search .searchbox').on('click',function(e) {
    jQuery(e.currentTarget).find('input').focus();
  });
});
