import { Injectable } from '@angular/core';

@Injectable()
export class SpinnerConfig {
  /** Controls the visibility of this spinner */
  public active: boolean = true;

  /** If true, this spinner can be dismissed by clicking on it */
  public dismissible: boolean = false;

  /** Controls the size of the spinner (in pixels) */
  public size: number = 25;
}