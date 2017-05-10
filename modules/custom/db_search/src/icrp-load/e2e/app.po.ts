import { browser, element, by } from 'protractor';

export class IcrpSearchFrontendPage {
  navigateTo() {
    return browser.get('/');
  }

  getParagraphText() {
    return element(by.css('icrp-root h1')).getText();
  }
}
