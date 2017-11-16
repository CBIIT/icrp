import React, {Component} from 'react';
import { Alert, Button, Modal } from 'react-bootstrap';
import DataGrid from './DataGrid';
import FileInput from './FileInput';
import Spinner from './Spinner';

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
      loading: false,
      error: false,
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

    this.setState({
      loading: true,
    })
    let { headers, institutions } = this.state;
    let data = institutions.map(institution =>
      headers.map(header => institution[header])
    );

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = 'api/institutions/add';
    try {
      let response = await fetch(`${protocol}//${hostname}/${pathname}`, {
        method: 'POST',
        credentials: 'same-origin',
        body: JSON.stringify(data),
      });

      this.setState({
        failedInstitutions: await response.json(),
        showMessage: true,
        loading: false
      });
    } catch (e) {
      this.setState({
        loading: false,
        error: true,
      })
    }
  }

  render() {
    let {
      headers,
      institutions,
      failedInstitutions,
      showMessage,
      showTable,
      showModal,
      loading,
      error,
    } = this.state;

    let successCount = institutions.length - failedInstitutions.length;
    let failedCount = failedInstitutions.length;

    return (
      <div>
        <Spinner visible={loading} message="Loading..." />
        { showMessage &&
          <Alert bsStyle="success" onDismiss={event => this.setState({showMessage: false})}>
            {successCount === 1 && `${successCount} institution was added successfully.`}
            {successCount !== 1 && `${successCount} institutions were added successfully.`}
            { failedCount > 0 &&
              <span>
                <a className="failed-link" onClick={event => this.setState({showModal: true})}>
                  {failedCount} failed
                </a>
                to add because they already exist in the system.
              </span>
            }
          </Alert>
        }

        { error &&
          <Alert bsStyle="warning" onDismiss={event => this.setState({error: false})}>
            An error occured while attempting to connect to the database. Please try again later.
          </Alert>
        }

        <Modal show={showModal} onHide={event => this.setState({showModal: false})} bsSize="lg">
          <Modal.Header closeButton>
            <Modal.Title>Failed Records</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <DataGrid
              className="m-10"
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
             disabled={headers.length > 0}
          />

          <DataGrid
            className="m-10"
            visible={showTable}
            rows={institutions}
            columns={headers}
          />
        </div>

        <div className="text-center">
          <Button
            className="m-10"
            disabled={!showTable}
            onClick={event => this.addInstitutions()}>
            Add Institutions
          </Button>

          <Button
            className="m-10"
            href={this.CANCEL_URL}>
            Cancel
          </Button>
        </div>
      </div>
    );
  }
}