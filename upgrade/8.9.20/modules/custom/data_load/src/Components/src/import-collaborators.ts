import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { ImportCollaboratorsModule } from './app/modules/import-collaborators/import-collaborators.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(ImportCollaboratorsModule)
  .catch(err => console.log(err));
