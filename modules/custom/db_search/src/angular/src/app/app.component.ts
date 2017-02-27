import { Component, Inject } from '@angular/core';

@Component({
  selector: 'icrp-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(@Inject('page_title') private pageTitle: string) {}

}
