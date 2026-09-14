import { platformBrowser } from '@angular/platform-browser';

import { DataUploadToolModule } from './app/modules/data-upload-tool/data-upload-tool.module';

platformBrowser().bootstrapModule(DataUploadToolModule)
  .catch(err => console.log(err));
