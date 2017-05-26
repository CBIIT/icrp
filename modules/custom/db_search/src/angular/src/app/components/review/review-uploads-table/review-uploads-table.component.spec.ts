import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ReviewUploadsTableComponent } from './review-uploads-table.component';

describe('ReviewUploadsTableComponent', () => {
  let component: ReviewUploadsTableComponent;
  let fixture: ComponentFixture<ReviewUploadsTableComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ReviewUploadsTableComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ReviewUploadsTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
