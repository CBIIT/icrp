import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DataUploadToolComponent } from './data-upload-tool.component';

describe('DataUploadToolComponent', () => {
  let component: DataUploadToolComponent;
  let fixture: ComponentFixture<DataUploadToolComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DataUploadToolComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DataUploadToolComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
