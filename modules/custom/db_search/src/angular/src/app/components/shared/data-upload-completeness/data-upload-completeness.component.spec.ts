import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DataUploadCompletenessComponent } from './data-upload-completeness.component';

describe('DataUploadCompletenessComponent', () => {
  let component: DataUploadCompletenessComponent;
  let fixture: ComponentFixture<DataUploadCompletenessComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DataUploadCompletenessComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DataUploadCompletenessComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
