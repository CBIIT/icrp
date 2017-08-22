import React, {Component} from 'react';
import { Button, Col, FormGroup, Row } from 'react-bootstrap';
import DataGrid from './DataGrid';
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

    this.setState({
      file: file,
      institutions: csv.data,
      headers: csv.meta.fields,
      showTable: false,
    });
  }

  reset() {
    this.setState(this.initialState());

    for (let key in this.elements) {
      this.elements[key].value = '';
    }
  }


  addInstitutions() {

  }
  

  render() {
    let {
      file, 
      institutions, 
      failedInstitutions, 
      headers, 
      showTable, 
      showModal
    } = this.state;

    return (
      <div>
        <div className="bordered clearfix m-b-10">
          <Row className="form-group">
            <Col sm={6}>
              <label className="m-l-5">Institution File (.csv) *</label> 
              <input 
                type="file" 
                className="m-l-5"
                ref={fileInput => this.elements.fileInput = fileInput}
                onChange={event => this.loadFile(event.target)} 
              />
            </Col>

            <Col sm={6} className="text-right">
              <Button 
                className="m-t-5 m-r-5"
                onClick={event => this.setState({showTable: true})} 
                disabled={!file}>
                Load
              </Button>

              <Button 
                className="m-t-5 m-r-5"
                onClick={event => this.reset()}>
                Reset
              </Button>
            </Col>
          </Row>

          <br />

          <div className="m-5">
            <DataGrid
              visible={showTable}
              rows={institutions}
              columns={headers}
            />
          </div>
        </div>

        <div className="text-center">
          
          <Button
            className="m-5"
            onClick={event => this.addInstitutions()}>
            Add Institutions
          </Button>
          
          <Button 
            className="m-5"
            href={this.CANCEL_URL}>
            Cancel
          </Button>
        </div>
      </div>
    );
  }
}