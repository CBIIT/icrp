import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SearchSummaryPanelComponent } from './search-summary-panel.component';

describe('SearchSummaryPanelComponent', () => {
  let component: SearchSummaryPanelComponent;
  let fixture: ComponentFixture<SearchSummaryPanelComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SearchSummaryPanelComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SearchSummaryPanelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
