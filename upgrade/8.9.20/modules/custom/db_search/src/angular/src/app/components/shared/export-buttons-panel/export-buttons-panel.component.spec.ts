import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ExportButtonsPanelComponent } from './export-buttons-panel.component';

describe('ExportButtonsPanelComponent', () => {
  let component: ExportButtonsPanelComponent;
  let fixture: ComponentFixture<ExportButtonsPanelComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ExportButtonsPanelComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ExportButtonsPanelComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
