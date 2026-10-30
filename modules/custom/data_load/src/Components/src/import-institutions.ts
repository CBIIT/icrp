import { platformBrowser } from '@angular/platform-browser';

import { ImportInstitutionsModule } from './app/modules/import-institutions/import-institutions.module';

platformBrowser().bootstrapModule(ImportInstitutionsModule)
  .catch(err => console.log(err));
