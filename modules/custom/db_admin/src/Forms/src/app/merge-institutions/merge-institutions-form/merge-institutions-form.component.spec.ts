import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MergeInstitutionsFormComponent } from './merge-institutions-form.component';

describe('MergeInstitutionsFormComponent', () => {
  let component: MergeInstitutionsFormComponent;
  let fixture: ComponentFixture<MergeInstitutionsFormComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MergeInstitutionsFormComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MergeInstitutionsFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
