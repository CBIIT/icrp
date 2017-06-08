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

import 'react-datepicker/dist/react-datepicker.css';
import './App.css';

class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      showDataTable: false,
      stats: {},
      projects: [],
      tab2Disabled: true,
      tab3Disabled: true

    }
    this.handleFileUpload = this.handleFileUpload.bind(this);
    this.handlePageChange = this.handlePageChange.bind(this);
  }

  handleFileUpload(stats, projects) {
    this.setState({ stats: stats, projects: projects, showDataTable: stats ? true : false, tab2Disabled: stats ? false : true });
  }

  handlePageChange(page, projects) {
    let newStats = {};
    newStats.totalRows = this.state.stats.totalRows;
    newStats.page = page;
    newStats.totalPages = this.state.stats.totalPages;
    newStats.showingFrom = (page * 25) + 1 - 25;
    newStats.showingTo = Math.min(page * 25 + 1, this.state.stats.totalRows);

    this.setState({ stats: newStats, projects: projects });
  }

  render() {
    return (
      <div>
        <Tabs defaultActiveKey={1} id="uncontrolled-tabs">
          <Tab eventKey={1} title="Load Workbook">
            <div className="tab-container">
              <UploadFormComponent onFileUploadSuccess={this.handleFileUpload} />
              {this.state.showDataTable ?
                <DataTableComponent stats={this.state.stats} projects={this.state.projects} onPageChange={this.handlePageChange} /> : null}

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
