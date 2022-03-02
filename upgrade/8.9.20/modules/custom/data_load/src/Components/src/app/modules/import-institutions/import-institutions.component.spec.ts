import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ImportInstitutionsComponent } from './import-institutions.component';

describe('ImportInstitutionsComponent', () => {
  let component: ImportInstitutionsComponent;
  let fixture: ComponentFixture<ImportInstitutionsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ImportInstitutionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ImportInstitutionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
