import React from 'react';
import ReactDOM from 'react-dom';
import App from '../App';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
});

it('expects one to equal one', () => {
  expect(1).toEqual(1);
})