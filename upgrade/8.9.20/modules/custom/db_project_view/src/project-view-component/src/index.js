import React from 'react';
import ReactDOM from 'react-dom';
import ProjectViewComponent from './ProjectViewComponent';

let root = document.getElementById('project-view-component');

ReactDOM.render(
  <ProjectViewComponent {...(root.dataset)} />,
  root
);
