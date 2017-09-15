import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { GoogleMap } from './components';
import './index.css';

ReactDOM.render(
  <GoogleMap />,
  document.getElementById('icrp-map') as HTMLElement
);
