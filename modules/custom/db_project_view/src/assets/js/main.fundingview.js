function googleTranslateElementInit() {
  new google.translate.TranslateElement({
    pageLanguage: 'undefined', 
    layout: google.translate.TranslateElement.InlineLayout.HORIZONTAL,
    autoDisplay: false, 
    multilanguagePage: true
  }, 'google_translate_element');
}