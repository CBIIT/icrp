/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { UiChartComponent } from './ui-chart.component';

describe('UiChartComponent', () => {
  let component: UiChartComponent;
  let fixture: ComponentFixture<UiChartComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UiChartComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UiChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
