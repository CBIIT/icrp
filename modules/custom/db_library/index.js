$(function() {
  $('#library-search .searchbox').on('click',function(e) {
    $(e.currentTarget).find('input').focus();
  });
});
