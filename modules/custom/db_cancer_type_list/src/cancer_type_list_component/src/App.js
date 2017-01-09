import React, { Component } from 'react';
import DataTable from './DataTable';
import './App.css';

class App extends Component {
  constructor() {
    super();
    this.state = {
      data: [],
      columns: []
    }
    this.getCancerTypes();
  }

  getCancerTypes() {
    fetch('https://icrpartnership-demo.org/partners/cancer-type-list/get')
    .then(response => response.json())
    .then(response => {

      this.setState({
        data: response, 
        columns: [
          {
            label: 'Cancer Type',
            value: 'label',
            link: 'url'
          },
          {
            label: 'Additional Details',
            value: 'description'
          }
        ]
      })
    })
    return ;
  }

  render() {
    return (
      <div className="responsive">
        <DataTable columns={this.state.columns} data={this.state.data} />
      </div>
    );
  }
}

export default App;
