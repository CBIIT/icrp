function googleTranslateElementInit() {
  new google.translate.TranslateElement({
    pageLanguage: 'undefined', 
    layout: google.translate.TranslateElement.InlineLayout.HORIZONTAL,
    autoDisplay: false, 
    multilanguagePage: true
  }, 'google_translate_element');
}

$(function() {
  $('#buttonShowAll').on('click',function(e) {
    e.preventDefault();
    var table = $('table.project-collaborators'),
        showall = table.hasClass('showall');
    table.toggleClass('showall',!showall);
    $(e.target).html('Show '+(showall?'All':'Less'));
  });
});
