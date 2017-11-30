import { TestBed, inject } from '@angular/core/testing';

import { DataUploadService } from './data-upload.service';

describe('DataUploadService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [DataUploadService]
    });
  });

  it('should be created', inject([DataUploadService], (service: DataUploadService) => {
    expect(service).toBeTruthy();
  }));
});
