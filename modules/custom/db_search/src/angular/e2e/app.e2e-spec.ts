import { IcrpSearchPage } from './app.po';

describe('icrp-search App', function() {
  let page: IcrpSearchPage;

  beforeEach(() => {
    page = new IcrpSearchPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
