import React, { Component } from 'react'
import { Table } from './Table';
import './DataTable.css';


export default class DataTable extends Component {

  constructor(props) {
    super(props);

    this.state = {
      headers: props.headers,
      data: props.data,
      sortState: props.sortState || {
        column: props.headers[0].key,
        direction: 'ascending',
      },
      paginationState: props.paginationState || {
        page: 1,
        size: 50,
      },
    };

    if (this.state.data) {
      this.setState({
        visibleData: this.applyCallbacks(this.state.data)
      })
    }

    if (this.props.dataSource) {
      this.fetchData();
    }
  }

  async fetchData() {
    let response = await fetch(this.props.dataSource);
    let data = await response.json();

    this.setState({
      data: data,
      visibleData: this.applyCallbacks(data),
    });
  }

  paginationCallback(paginationState) {

  }

  sortCallback(column, sortState) {
    let isAscending = true;
    
    if (column === sortState.column) {
      isAscending = sortState.direction === 'ascending' ? false : true;
    }

    let newSortState = {
      column: column,
      direction: isAscending ? 'ascending' : 'descending'  
    }

    this.setState({
      sortState: newSortState
    }, () => {
      this.setState({
        visibleData: this.applyCallbacks(this.state.data)
      })
    }
    );
  }

  applyCallbacks(data) {
    let searchResults = this.searchFunction(data, '');
    let paginationResults = this.paginationFunction(searchResults, this.state.paginationState);
    let sortResults = this.sortFunction(paginationResults, this.state.sortState);

    return sortResults;
  }

  searchFunction(data, text) {
    let visibleData = this.deepClone(data);
    return visibleData.filter(row => {
      for (let key in row) {
        if (!text || text.length === 0 || row[key].toString().indexOf(text) > -1) 
          return true;
      }

      return false;

    });
  }

  paginationFunction(data, paginationState) {
    let visibleData = this.deepClone(data);
    return visibleData;
  }

  sortFunction(data, sortState) {
    let visibleData = this.deepClone(data);
    let column = sortState.column;
    let isAscending = sortState.direction === 'ascending';

    visibleData.sort((a, b) => {
      let valueA = a[column] || '';
      let valueB = b[column] || '';

      if (isNaN(valueA) || isNaN(valueB)) {
        return isAscending 
          ? valueA.localeCompare(valueB)
          : valueB.localeCompare(valueA);
      }

      else {
        return isAscending
          ? valueA - valueB
          : valueB - valueA;
      }
    })

    return visibleData;
  }

  deepClone(obj) {
    return JSON.parse(JSON.stringify(obj));
  }

  render() {
    let props = {
      headers: this.state.headers,
      data: this.state.visibleData,
      sortState: this.state.sortState,
      sortCallback: this.sortCallback.bind(this),
      enableSorting: this.props.enableSorting,
    };

    return <Table {...props} />;

  }
}