import React, { Component } from 'react';
import DataTable from './DataTable';
import './App.css';

class App extends Component {
  data = [];
  columns = [];

  getCancerTypes() {
    return ;
  }

  render() {
    return (
      <div className="responsive">
        <DataTable columns={this.columns} data={this.data} />
      </div>
    );
  }
}

export default App;
