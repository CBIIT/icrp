import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SimpleSelectComponent } from './simple-select.component';

describe('SimpleSelectComponent', () => {
  let component: SimpleSelectComponent;
  let fixture: ComponentFixture<SimpleSelectComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SimpleSelectComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SimpleSelectComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
