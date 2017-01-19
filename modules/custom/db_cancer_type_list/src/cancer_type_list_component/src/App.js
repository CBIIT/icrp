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

  async getCancerTypes() {
    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = window.location.pathname;
    
    let response = await fetch(`${protocol}//${hostname}${pathname}/get`, {
 //     credentials: 'include'
    })

    this.setState({
      data: await response.json(), 
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
