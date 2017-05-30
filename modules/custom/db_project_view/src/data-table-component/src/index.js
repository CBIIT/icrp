import React from 'react';
import ReactDOM from 'react-dom';
import DataTable from './DataTable';
import registerServiceWorker from './registerServiceWorker';
import './index.css';

let root = document.getElementById('root');
ReactDOM.render(
  <DataTable { ... root['properties'] } />, 
  root, 
  () => registerServiceWorker()
);
