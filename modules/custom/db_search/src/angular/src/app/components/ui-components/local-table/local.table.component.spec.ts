import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LocalTableComponent } from './local.table.component';

describe('LocalTableComponent', () => {
  let component: LocalTableComponent;
  let fixture: ComponentFixture<LocalTableComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LocalTableComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LocalTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
