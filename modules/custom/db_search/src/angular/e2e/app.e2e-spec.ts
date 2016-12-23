import { IcrpDatabasePage } from './app.po';

describe('icrp-database App', function() {
  let page: IcrpDatabasePage;

  beforeEach(() => {
    page = new IcrpDatabasePage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
