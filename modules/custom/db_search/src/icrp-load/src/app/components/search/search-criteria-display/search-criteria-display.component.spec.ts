import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SearchCriteriaDisplayComponent } from './search-criteria-display.component';

describe('SearchCriteriaDisplayComponent', () => {
  let component: SearchCriteriaDisplayComponent;
  let fixture: ComponentFixture<SearchCriteriaDisplayComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ SearchCriteriaDisplayComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(SearchCriteriaDisplayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
