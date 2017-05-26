import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReviewSummaryPanelComponent } from './review-summary-panel.component';

describe('ReviewSummaryPanelComponent', () => {
  let component: ReviewSummaryPanelComponent;
  let fixture: ComponentFixture<ReviewSummaryPanelComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReviewSummaryPanelComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReviewSummaryPanelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
