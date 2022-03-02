import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { WebsiteInputComponent } from './website-input.component';

describe('WebsiteInputComponent', () => {
  let component: WebsiteInputComponent;
  let fixture: ComponentFixture<WebsiteInputComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ WebsiteInputComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(WebsiteInputComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
