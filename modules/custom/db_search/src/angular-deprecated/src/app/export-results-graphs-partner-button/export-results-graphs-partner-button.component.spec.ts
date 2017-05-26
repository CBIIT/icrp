/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { ExportResultsGraphsPartnerButtonComponent } from './export-results-graphs-partner-button.component';

describe('ExportResultsGraphsPartnerButtonComponent', () => {
  let component: ExportResultsGraphsPartnerButtonComponent;
  let fixture: ComponentFixture<ExportResultsGraphsPartnerButtonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ExportResultsGraphsPartnerButtonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExportResultsGraphsPartnerButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
