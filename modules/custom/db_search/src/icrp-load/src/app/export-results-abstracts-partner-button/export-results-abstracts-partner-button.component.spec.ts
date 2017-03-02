/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { ExportResultsAbstractsPartnerButtonComponent } from './export-results-abstracts-partner-button.component';

describe('ExportResultsAbstractsPartnerButtonComponent', () => {
  let component: ExportResultsAbstractsPartnerButtonComponent;
  let fixture: ComponentFixture<ExportResultsAbstractsPartnerButtonComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ExportResultsAbstractsPartnerButtonComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExportResultsAbstractsPartnerButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
