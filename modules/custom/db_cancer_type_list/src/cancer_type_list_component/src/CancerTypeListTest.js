import React from 'react';
import ReactDOM from 'react-dom';
import CancerTypeList from './CancerTypeList';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<CancerTypeList />, div);
});
