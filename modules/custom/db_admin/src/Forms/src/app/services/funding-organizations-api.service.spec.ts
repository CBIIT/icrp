import { TestBed, inject } from '@angular/core/testing';

import { FundingOrganizationsApiService } from './funding-organizations-api.service';

describe('FundingOrganizationsApiService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [FundingOrganizationsApiService]
    });
  });

  it('should be created', inject([FundingOrganizationsApiService], (service: FundingOrganizationsApiService) => {
    expect(service).toBeTruthy();
  }));
});
