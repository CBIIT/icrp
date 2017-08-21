import React, {Component} from 'react';
import { Button } from 'react-bootstrap';
import ReactDataGrid from 'react-data-grid';
import { parse } from '../services/ParseCSV';

export default class App extends Component {
  
  CANCEL_URL = window.location.protocol + '//' + window.location.host;
  state = this.initialState();
  elements = { fileInput: null }

  initialState() {
    return {
      file: null,
      fileInput: null,
      headers: [],
      institutions: [],
      failedInstitutions: [],
      showTable: false,
      showModal: false,
    }
  }

  async loadFile(element) {
    let file = element.files[0];
    let csv = await parse(file);

    console.log(csv, file);
    
    let headers = csv.meta.fields
      .map(header => ({
        key: header,
        name: header,
        sortable: true,
        resizable: true,
        width: 140,
        
      })
    );
    
    this.setState({
      file: file,
      institutions: csv.data,
      headers: headers,
    });
  }

  reset() {
    this.setState(this.initialState());

    for (let key in this.elements) {
      this.elements[key].value = '';
    }
  }


  handleGridSort(sortColumn, sortDirection) {
    const comparer = (a, b) => {
      if (sortDirection === 'ASC') {
        return (a[sortColumn] > b[sortColumn]) ? 1 : -1;
      } else if (sortDirection === 'DESC') {
        return (a[sortColumn] < b[sortColumn]) ? 1 : -1;
      }
    };

    const rows = sortDirection === 'NONE' ? this.state.originalRows.slice(0) : this.state.rows.sort(comparer);

//    this.setState({ rows });
  }

  addInstitutions() {

  }
  

  render() {
    let {file, institutions, failedInstitutions, headers} = this.state;

    return (
      <div>
        <div className="bordered">
          <label>Institution File (.csv) *</label> 
          <input 
            type="file" 
            ref={fileInput => this.elements.fileInput = fileInput}
            onChange={event => this.loadFile(event.target)} 
          />

          <Button 
            onClick={event => this.setState({showTable: true})} 
            disabled={!file}>
            Load
          </Button>

          <Button onClick={event => this.reset()}>
            Reset
          </Button>

          <br />

          <ReactDataGrid
            columns={headers}
            rowGetter={index => institutions[index]}
            rowsCount={institutions.length}
            onGridSort={(column, direction) => this.handleGridSort(column, direction)}
            minHeight={institutions.length > 25 ? 
              20 + (25 * 35) 
              : 20 + ((institutions.length + 1) * 35)}
          />;          
        </div>
        



        <div>
          <Button onClick={event => this.addInstitutions()}>Add Institutions</Button>
          <Button href={this.CANCEL_URL}>Cancel</Button>
        </div>
      </div>
    );
  }
}