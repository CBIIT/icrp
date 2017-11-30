import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { IntegrityCheckPageComponent } from './integrity-check-page.component';

describe('IntegrityCheckPageComponent', () => {
  let component: IntegrityCheckPageComponent;
  let fixture: ComponentFixture<IntegrityCheckPageComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ IntegrityCheckPageComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(IntegrityCheckPageComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
