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
    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = window.location.pathname;

    if (hostname.indexOf('localhost') > -1) {
      protocol = 'https:';
      hostname = 'icrpartnership-demo.org';
      pathname = '/partners/cancer-type-list';
    }

    fetch(`${protocol}//${hostname}${pathname}/get`)
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
