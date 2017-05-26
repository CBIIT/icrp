import { Component, Input, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import * as octicons from 'octicons';

@Component({
  selector: 'ui-icon',
  templateUrl: './icon.component.html',
  styleUrls: ['./icon.component.css']
})
export class IconComponent implements AfterViewInit {
  @Input() type: string = 'alert';

//  @ViewChild('svg') svg: ElementRef;

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
    let markup = `
      <svg
        class="octicon"
        width="${octicons[this.type].width}"
        height="${octicons[this.type].height}"
        viewBox="${octicons[this.type].options.viewBox}"
        aria-hidden="true"
      >
        ${this.octicons[this.type].path}
      </svg>
    `;


    this.container.nativeElement.innerHTML = markup;

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
