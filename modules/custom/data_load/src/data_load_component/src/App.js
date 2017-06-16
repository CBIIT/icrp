import React, { Component } from 'react';
import {
  Tabs,
  Tab,
} from 'react-bootstrap';
// import moment from 'moment';
import UploadFormComponent from './components/UploadFormComponent';
import NavigationComponent from './components/NavigationComponent';
import ValidationConfiguratorComponent from './components/ValidationConfiguratorComponent';
import ValidationSummaryComponent from './components/ValidationSummaryComponent';
import NewTableComponent from './components/NewTableComponent';
import Spinner from './components/SpinnerComponent'

import 'react-datepicker/dist/react-datepicker.css';
import './App.css';

class App extends Component {

  constructor(props) {
    super(props);

    this.state = {
      tabKey: 1,
      showDataTable: false,
      stats: {},
      columns: [],
      projects: [],
      tab2Disabled: true,
      tab3Disabled: true,
      page: 1,
      sortColumn: 'InternalId',
      sortDirection: 'ASC',
      loading: false,
      validationResults: []
    }
    this.handleFileUpload = this.handleFileUpload.bind(this);
    this.handleDataTableChange = this.handleDataTableChange.bind(this);
    this.handleLoadingStateChange = this.handleLoadingStateChange.bind(this);
    this.handleValidationResults = this.handleValidationResults.bind(this);
    this.handleTabSelect = this.handleTabSelect.bind(this);
    this.reset = this.reset.bind(this);
    this.handleEndLoading = this.handleEndLoading.bind(this);
  }

  reset() {
    this.setState({
      tabKey: 1,
      showDataTable: false,
      stats: {},
      columns: [],
      projects: [],
      tab2Disabled: true,
      tab3Disabled: true,
      page: 1,
      sortColumn: 'InternalId',
      sortDirection: 'ASC',
      loading: false,
      validationResults: []
    })
  }

  handleFileUpload(stats, columns, projects) {
    this.setState({ loading: false, stats: stats, columns: columns, projects: projects, showDataTable: true, tab2Disabled: false });
  }

  handleLoadingStateChange() {
    this.setState({ loading: true, validationResults: [], tab2Disabled: true, tab3Disabled: true });
  }

  handleDataTableChange(page, sortColumn, sortDirection, projects) {
    this.setState({ page: page, sortColumn: sortColumn, sortDirection: sortDirection, projects: projects });
  }

  handleValidationResults(results) {
    this.setState({ validationResults: results, loading: false });
  }

  handleEndLoading() {
    this.setState({ loading: false });
  }

  handleTabSelect(key) {
    this.setState({ tabKey: key });
  }

  render() {
    return (
      <div>
        <Spinner message="Loading Content..." visible={this.state.loading} />
        <Tabs activeKey={this.state.tabKey} onSelect={this.handleTabSelect} id="uncontrolled-tabs">
          <Tab eventKey={1} title="Load Workbook">
            <div className="tab-container">
              <UploadFormComponent onFileUploadSuccess={this.handleFileUpload} onLoadingStart={this.handleLoadingStateChange} onReset={this.reset} />
              <NewTableComponent visible={this.state.showDataTable} stats={this.state.stats} page={this.state.page}
                sortColumn={this.state.sortColumn} sortDirection={this.state.sortDirection}
                columns={this.state.columns} projects={this.state.projects} onChange={this.handleDataTableChange} />

              <NavigationComponent hasBackButton={false} hasNextButton={true} nextDisabled={this.state.tab2Disabled} clickHandler={this.handleTabSelect} thisTabId={1} cancelUrl={'https://icrpartnership-dev.org/FundingOrgs'} />

            </div>
          </Tab>
          <Tab eventKey={2} title="Data Integrity Check" disabled={this.state.tab2Disabled} >
            <div className="tab-container">
              <ValidationConfiguratorComponent onValidationResults={this.handleValidationResults} onLoadingStart={this.handleLoadingStateChange} />
              <ValidationSummaryComponent validationResults={this.state.validationResults}  onLoadingStart={this.handleLoadingStateChange} onLoadingEnd={this.handleEndLoading} />

              <NavigationComponent hasBackButton={true} hasNextButton={true} nextDisabled={this.state.tab3Disabled} clickHandler={this.handleTabSelect} thisTabId={2} cancelUrl={'https://icrpartnership-dev.org/FundingOrgs'} />

            </div>
          </Tab>

          <Tab eventKey={3} title="Import" disabled={this.state.tab3Disabled}>
            <div className="tab-container">

            </div>
          </Tab>
        </Tabs>

      </div>
    );
  }
}

export default App;
