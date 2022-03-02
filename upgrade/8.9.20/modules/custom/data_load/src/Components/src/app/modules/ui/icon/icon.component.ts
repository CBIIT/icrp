import { Component, Input, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import * as octicons from 'octicons';

@Component({
  selector: 'ui-icon',
  templateUrl: './icon.component.html',
  styleUrls: ['./icon.component.css']
})
export class IconComponent implements AfterViewInit {
  @Input() type: string = 'alert';

  @Input() width: number;

  @Input() height: number;

  @ViewChild('container') container: ElementRef;

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
    this.container.nativeElement.innerHTML = `
      <svg
        class="octicon"
        width="${this.width || octicons[this.type].width}"
        height="${this.height || octicons[this.type].height}"
        viewBox="${octicons[this.type].options.viewBox}"
        aria-hidden="true"
      >
        ${this.octicons[this.type].path}
      </svg>
    `;

/*
    let path = this.octicons[this.type].path;
    let domParser = new DOMParser();
    let pathElement = domParser.parseFromString(path, 'application/xml')
    console.log(pathElement);

    let svg = this.svg.nativeElement;

    svg.ownerDocument.importNode
*/
    //svg.innerHTML = path;
  }
}
