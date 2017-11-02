import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { FundingOrganizationFormComponent } from './funding-organization-form.component';

describe('FundingOrganizationFormComponent', () => {
  let component: FundingOrganizationFormComponent;
  let fixture: ComponentFixture<FundingOrganizationFormComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FundingOrganizationFormComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FundingOrganizationFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
