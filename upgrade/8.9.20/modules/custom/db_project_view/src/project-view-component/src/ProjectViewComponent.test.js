import React from 'react';
import ReactDOM from 'react-dom';
import ProjectViewComponent from './ProjectViewComponent';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<ProjectViewComponent />, div);
});
