import React, {Component} from 'react';
import { Alert, Button, Modal } from 'react-bootstrap';
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
      showMessage: false,
    }
  }

  reset(elements) {
    this.setState(this.initialState());
    for (let key in elements) {
      elements[key].value = '';
    }
  }

  showTable(event) {
    let {headers, institutions} = event;
    let showTable = true;
    let showMessage = false;
    this.setState({ headers, institutions, showTable, showMessage });
  }

  async addInstitutions() {

    let { headers, institutions } = this.state;
    let data = institutions.map(institution =>
      headers.map(header => institution[header])
    );

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = 'DataUploadTool/addInstitutions';
    let response = await fetch(`${protocol}//${hostname}/${pathname}`, {
      method: 'POST',
      credentials: 'same-origin',
      body: JSON.stringify(data),
    });

    let failedInstitutions = await response.json();
    let showMessage = true;
    console.log(failedInstitutions);

    this.setState({ failedInstitutions, showMessage });
  }

  render() {
    let {
      headers,
      institutions,
      failedInstitutions,
      showMessage,
      showTable,
      showModal,
    } = this.state;

    let successCount = institutions.length - failedInstitutions.length;
    let failedCount = failedInstitutions.length;

    return (
      <div>
        { showMessage && failedCount > 0 &&
          <Alert bsStyle="danger" onDismiss={event => this.setState({showMessage: false})}>
            {successCount} institutions were added successfully
            <span class="m-l-5" style={{cursor: 'pointer'}} onClick={event => this.setState({showModal: true})}>
              . {failedCount} failed to add because they already exist in the system.
            </span>
          </Alert>
        }

        { showMessage && failedCount == 0 &&
          <Alert onDismiss={event => this.setState({showMessage: false})}>
            {successCount} institutions were added successfully.
          </Alert>
        }

        <Modal show={showModal} onHide={event => this.setState({showModal: false})}>
          <Modal.Header closeButton>
            <Modal.Title>Institutions</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <DataGrid
              className="m-5"
              visible={showTable}
              rows={failedInstitutions}
              columns={headers}
            />
          </Modal.Body>
          <Modal.Footer>
            <Button onClick={event => this.setState({showModal: false})}>Close</Button>
          </Modal.Footer>
        </Modal>

        <div className="bordered clearfix m-b-10">
          <FileInput
             onLoad={event => this.showTable(event)}
             onReset={elements => this.reset(elements)}
          />

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