import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { InstitutionsFormComponent } from './institutions-form.component';

describe('InstitutionsFormComponent', () => {
  let component: InstitutionsFormComponent;
  let fixture: ComponentFixture<InstitutionsFormComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ InstitutionsFormComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(InstitutionsFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
