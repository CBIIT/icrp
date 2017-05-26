import { IcrpSearchFrontendPage } from './app.po';

describe('icrp-search-frontend App', () => {
  let page: IcrpSearchFrontendPage;

  beforeEach(() => {
    page = new IcrpSearchFrontendPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('icrp works!');
  });
});
