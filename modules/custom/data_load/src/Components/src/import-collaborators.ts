import { platformBrowser } from '@angular/platform-browser';

import { ImportCollaboratorsModule } from './app/modules/import-collaborators/import-collaborators.module';

platformBrowser().bootstrapModule(ImportCollaboratorsModule)
  .catch(err => console.log(err));
