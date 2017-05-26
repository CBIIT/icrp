import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ResultsTablePanelComponent } from './results-table-panel.component';

describe('ResultsTablePanelComponent', () => {
  let component: ResultsTablePanelComponent;
  let fixture: ComponentFixture<ResultsTablePanelComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ResultsTablePanelComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ResultsTablePanelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
