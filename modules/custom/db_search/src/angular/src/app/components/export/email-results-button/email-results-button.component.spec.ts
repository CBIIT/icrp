import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EmailResultsButtonComponent } from './email-results-button.component';

describe('EmailResultsButtonComponent', () => {
  let component: EmailResultsButtonComponent;
  let fixture: ComponentFixture<EmailResultsButtonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EmailResultsButtonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EmailResultsButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
