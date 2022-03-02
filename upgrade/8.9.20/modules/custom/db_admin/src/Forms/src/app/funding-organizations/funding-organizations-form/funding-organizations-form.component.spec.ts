import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { FundingOrganizationsFormComponent } from './funding-organizations-form.component';

describe('FundingOrganizationsFormComponent', () => {
  let component: FundingOrganizationsFormComponent;
  let fixture: ComponentFixture<FundingOrganizationsFormComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ FundingOrganizationsFormComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(FundingOrganizationsFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
