import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { DataUploadToolModule } from './app/modules/data-upload-tool/data-upload-tool.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(DataUploadToolModule)
  .catch(err => console.log(err));
