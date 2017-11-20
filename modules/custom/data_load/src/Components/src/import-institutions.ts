import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { ImportInstitutionsModule } from './app/components/import-institutions/import-institutions.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(ImportInstitutionsModule)
  .catch(err => console.log(err));
