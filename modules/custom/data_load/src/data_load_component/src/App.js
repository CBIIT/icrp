import React, { Component } from 'react';
import {
  Tabs,
  Tab,
} from 'react-bootstrap';
// import moment from 'moment';
import UploadFormComponent from './components/UploadFormComponent';
import DataTableComponent from './components/DataTableComponent';
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
      showDataTable: false,
      stats: {},
      columns: [],
      projects: [],
      tab2Disabled: true,
      tab3Disabled: true,
      page: 1,
      sortColumn: 'InternalId',
      sortDirection: 'ASC',
      loading: false

    }
    this.handleFileUpload = this.handleFileUpload.bind(this);
    this.handleDataTableChange = this.handleDataTableChange.bind(this);
    this.handleLoadingStateChange = this.handleLoadingStateChange.bind(this);
  }

  handleFileUpload(stats, columns, projects) {
    this.setState({ loading: false, stats: stats, columns: columns, projects: projects, showDataTable: stats ? true : false, tab2Disabled: stats ? false : true });
  }

  handleLoadingStateChange() {
    this.setState({ loading: true });
  }

  handleDataTableChange(page, sortColumn, sortDirection, projects) {
    this.setState({ page: page, sortColumn: sortColumn, sortDirection: sortDirection, projects: projects });
  }

  render() {
    return (
      <div>
        <Spinner message="Loading Content..." visible={this.state.loading} />
        <Tabs defaultActiveKey={1} id="uncontrolled-tabs">
          <Tab eventKey={1} title="Load Workbook">
            <div className="tab-container">
              <UploadFormComponent onFileUploadSuccess={this.handleFileUpload} onLoadingStart={this.handleLoadingStateChange} />
                {/*<DataTableComponent stats={this.state.stats} projects={this.state.projects} onPageChange={this.handlePageChange} />*/}
                <NewTableComponent visible={this.state.showDataTable} stats={this.state.stats} page={this.state.page} 
                sortColumn={this.state.sortColumn} sortDirection={this.state.sortDirection} 
                columns={this.state.columns} projects={this.state.projects} onChange={this.handleDataTableChange} />

              <NavigationComponent hasBackButton={false} hasNextButton={true} nextDisabled={this.state.tab2Disabled} />

            </div>
          </Tab>
          <Tab eventKey={2} title="Data Integrity Check">
            <div className="tab-container">
              <ValidationConfiguratorComponent />
              <ValidationSummaryComponent />

              <NavigationComponent hasBackButton={true} hasNextButton={true} nextDisabled={this.state.tab3Disabled} />

            </div>
          </Tab>

          <Tab eventKey={3} title="Import">
            <div className="tab-container">

            </div>
          </Tab>
        </Tabs>

      </div>
    );
  }
}

export default App;
