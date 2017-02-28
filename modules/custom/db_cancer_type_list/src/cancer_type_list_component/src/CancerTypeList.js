import React, { Component } from 'react';
import DataTable from './DataTable';

class CancerTypeList extends Component {
  constructor() {
    super();
    this.state = {
      loading: true,
      data: [],
      columns: [],
    }
    this.getCancerTypes();
  }

  async getCancerTypes() {
    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = window.location.pathname;

    if (hostname === 'localhost') {
      protocol = 'https:';
      hostname = 'icrpartnership-dev.org';
      pathname = '/cancer-type-list'
    }

    let response = await fetch(`${protocol}//${hostname}${pathname}/get`, {
 //     credentials: 'include'
    })

    let results = await response.json();
   
    this.setState({
      loading: false,
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
          value: 'label',
          tooltip: 'Cancer Type',
        },
        {
          label: 'ICRP Code',
          value: 'icrp_code',
          tooltip: 'ICRP Code',
        },
        {
          label: 'ICD-10 Code',
          value: 'icd10_code',
          tooltip: 'ICD-10 Code',
        },
        {
          label: 'Description',
          value: 'description',
          tooltip: 'Description',
        }
      ]
    })
  }

  render() {
    return this.state.loading
      ? <div>Loading...</div>
      : <DataTable columns={this.state.columns} data={this.state.data} />
  }
}

export default CancerTypeList;
