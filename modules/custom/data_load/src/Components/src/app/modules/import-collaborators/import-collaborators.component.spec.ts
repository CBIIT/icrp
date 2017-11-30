import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ImportCollaboratorsComponent } from './import-collaborators.component';

describe('ImportCollaboratorsComponent', () => {
  let component: ImportCollaboratorsComponent;
  let fixture: ComponentFixture<ImportCollaboratorsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ImportCollaboratorsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ImportCollaboratorsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
