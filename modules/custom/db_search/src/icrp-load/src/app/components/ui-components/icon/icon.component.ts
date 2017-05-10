import { Component, Input, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import * as octicons from 'octicons';

@Component({
  selector: 'ui-icon',
  templateUrl: './icon.component.html',
  styleUrls: ['./icon.component.css']
})
export class IconComponent implements AfterViewInit {
  @Input() type: string = 'alert';

  @ViewChild('svg') svg: ElementRef;

  octicons = null;

  constructor() {
    this.octicons = octicons;
  }

  ngAfterViewInit() {
    this.setSvgPath();
  }

  ngOnChanges() {
    this.setSvgPath();
  }

  setSvgPath() {
    let path = this.octicons[this.type].path;
    this.svg.nativeElement.innerHTML = this.octicons[this.type].path;
  }
}
