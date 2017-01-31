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

    let results = await response.json();

    console.log(results);

    
    this.setState({
      data: results
        .map(result => {
          let parsed_result = {};

          // replace 'NULL' entries with empty strings
          for (let key of Object.keys(result)) {
            parsed_result[key] = result[key] 
              ? result[key].replace(/^NULL$/, '') 
              : '';
          }

          return parsed_result;
        }),
      columns: [
        {
          label: 'Cancer Type',
          value: 'label'
        },
        {
          label: 'ICRP Code',
          value: 'icrp_code'
        },
        {
          label: 'ICD-10 Code',
          value: 'icd10_code'
        },
        {
          label: 'Description',
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
