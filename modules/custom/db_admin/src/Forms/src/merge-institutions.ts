import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { MergeInstitutionsModule } from './app/merge-institutions/merge-institutions.module';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

platformBrowserDynamic().bootstrapModule(MergeInstitutionsModule)
  .catch(err => console.log(err));
