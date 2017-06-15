import React from 'react';
import ReactDOM from 'react-dom';
import Form from './Form';
import registerServiceWorker from './registerServiceWorker';
import './index.css';

ReactDOM.render(
  <Form />,
  document.getElementById('add-funding-organization'),
  registerServiceWorker);
