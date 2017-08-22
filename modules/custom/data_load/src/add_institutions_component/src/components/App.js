import React, {Component} from 'react';
import { Button, Col, FormGroup, Row } from 'react-bootstrap';
import DataGrid from './DataGrid';
import FileInput from './FileInput';
import { parse } from '../services/ParseCSV';

export default class App extends Component {

  CANCEL_URL = window.location.protocol + '//' + window.location.host;
  state = this.initialState();

  initialState() {
    return {
      headers: [],
      institutions: [],
      failedInstitutions: [],
      showTable: false,
      showModal: false,
    }
  }

  reset(elements) {
    this.setState(this.initialState());

    for (let key in elements) {
      elements[key].value = '';
    }
  }

  addInstitutions() {

  }

  render() {
    let {
      headers,
      institutions,
      failedInstitutions,
      showTable,
      showModal
    } = this.state;

    return (
      <div>
        <div className="bordered clearfix m-b-10">
          <FileInput
             onLoad={state => this.setState(state)}
             onReset={elements => this.reset(elements)}
          />

          <br />

          <DataGrid
            className="m-5"
            visible={showTable}
            rows={institutions}
            columns={headers}
          />
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