import { TestBed } from '@angular/core/testing';

import { InstitutionsApiService } from './institutions-api.service';

describe('InstitutionsApiService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: InstitutionsApiService = TestBed.get(InstitutionsApiService);
    expect(service).toBeTruthy();
  });
});
