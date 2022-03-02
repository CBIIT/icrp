import { TestBed, inject } from '@angular/core/testing';

import { PartnersApiService } from './partners-api.service';

describe('PartnersApiService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [PartnersApiService]
    });
  });

  it('should be created', inject([PartnersApiService], (service: PartnersApiService) => {
    expect(service).toBeTruthy();
  }));
});
