import { TestBed, inject } from '@angular/core/testing';

import { NonPartnersApiService } from './non-partners-api.service';

describe('NonPartnersApiService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [NonPartnersApiService]
    });
  });

  it('should be created', inject([NonPartnersApiService], (service: NonPartnersApiService) => {
    expect(service).toBeTruthy();
  }));
});
