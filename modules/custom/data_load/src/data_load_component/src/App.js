import React, { Component } from 'react';
import {
  Tabs,
  Tab,
} from 'react-bootstrap';
import UploadFormComponent from './components/UploadFormComponent';
import NavigationComponent from './components/NavigationComponent';
import ValidationConfiguratorComponent from './components/ValidationConfiguratorComponent';
import ValidationSummaryComponent from './components/ValidationSummaryComponent';
import NewTableComponent from './components/NewTableComponent';
import Spinner from './components/SpinnerComponent';

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
      validationResults: [],
      validationRules: [],
      uploadType: 'new',
      sponsorCode: '',
      openSummary: false,
      openDetails: false,
      openSummaryDisabled: true,
      openDetailsDisabled: true,
      
      exportDisabled: true,
      fileName: '',
      loadingExport: false,
    }

    this.handleFileUpload = this.handleFileUpload.bind(this);
    this.handleDataTableChange = this.handleDataTableChange.bind(this);
    this.handleLoadingStateChange = this.handleLoadingStateChange.bind(this);
    this.handleValidationResults = this.handleValidationResults.bind(this);
    this.handleTabSelect = this.handleTabSelect.bind(this);
    this.handleSummaryCollapseToggle = this.handleSummaryCollapseToggle.bind(this);
    this.handleDetailsCollapseToggle = this.handleDetailsCollapseToggle.bind(this);
    this.handleExport = this.handleExport.bind(this);
    this.reset = this.reset.bind(this);
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
      validationResults: [],
      validationRules: [],
      uploadType: 'new',
      sponsorCode: '',
      openSummary: false,
      openDetails: false,
      openSummaryDisabled: true,
      openDetailsDisabled: true,
      exportDisabled: true,
      fileName: '',
      loadingExport: false,
    })
  }

  handleFileUpload(stats, columns, projects, sponsorCode, uploadType, fileName) {
    this.setState({ stats: stats, columns: columns, projects: projects, showDataTable: true, tab2Disabled: false, sponsorCode: sponsorCode, uploadType: uploadType, fileName: fileName });
  }

  handleLoadingStateChange() {
    this.setState({ validationResults: [], validationRules: [] });
  }

  handleDataTableChange(page, sortColumn, sortDirection, projects) {
    this.setState({ page: page, sortColumn: sortColumn, sortDirection: sortDirection, projects: projects });
  }

  handleValidationResults(results, validationRules) {
    let tab3Disabled = false;
    for (let i = 0; i < results.length; i++) {
      const result = results[i];
      const resultId = parseInt(result.id, 10);
      const validationRule = validationRules.find(rule => rule.id === resultId);

      this.setState({
        openSummary: true,
        openDetails: true,
      })

      if (resultId && result.validationResult === 'Failed' && validationRule.checked & validationRule.active) {
        tab3Disabled = true;
        this.setState({
          exportDisabled: false
        })
        break;
      }
    }

    this.setState({ validationResults: results, validationRules: validationRules, tab3Disabled: tab3Disabled, openSummary: true, openDetails: true,  openSummaryDisabled: false, openDetailsDisabled: false});
  }

  handleSummaryCollapseToggle() {
    this.setState({ openSummary: !this.state.openSummary })
  }

  handleDetailsCollapseToggle() {
    this.setState({ openDetails: !this.state.openDetails })
  }

  handleTabSelect(key) {
    this.setState({ tabKey: key });
  }

  async handleExport() {

    this.setState({
      loadingExport: true,
    })

    let parameters = {
      excludedRules: this.state.validationRules.filter(rule => !rule.checked || !rule.active).map(rule => rule.id).join(','),
      originalFileName: this.state.fileName,
      uploadType: this.state.uploadType,
      partnerCode: this.state.sponsorCode,
    };

    let data = new FormData();
    for(let key in parameters) {
      data.append(key, parameters[key]);
    }

    let protocol = window.location.protocol;
    let hostname = window.location.hostname;
    let pathname = 'DataUploadTool/export';
    if (hostname === 'localhost') {
        protocol = 'http:';
        //hostname = 'icrp-dataload';
    }

    let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'POST', body: data, credentials: 'same-origin' });
    let filePath = `${protocol}//${hostname}/modules/custom/data_load/exports/${await response.json()}`;

    console.log(filePath);

    this.setState({
      loadingExport: false,
    })

    window.location.href = (filePath);


  }

  render() {
    const homeLocation = window.location.protocol + '//' + window.location.host;
    return (
      <div>
        <Spinner message="Generating Export..." visible={this.state.loadingExport} />

        <Tabs activeKey={this.state.tabKey} onSelect={this.handleTabSelect} id="uncontrolled-tabs">
          <Tab eventKey={1} title="Load Workbook">
            <div className="tab-container">
              <UploadFormComponent 
                onFileUploadSuccess={this.handleFileUpload} 
                onLoadingStart={this.handleLoadingStateChange} 
                onReset={this.reset} />
              
              <NewTableComponent 
                visible={this.state.showDataTable} 
                stats={this.state.stats} 
                page={this.state.page}
                sortColumn={this.state.sortColumn} 
                sortDirection={this.state.sortDirection}
                columns={this.state.columns} 
                projects={this.state.projects} 
                onChange={this.handleDataTableChange} />

              <NavigationComponent 
                hasBackButton={false} 
                hasNextButton={true} 
                nextDisabled={this.state.tab2Disabled} 
                clickHandler={this.handleTabSelect} 
                thisTabId={1} 
                cancelUrl={homeLocation} />

            </div>
          </Tab>
          <Tab eventKey={2} title="Data Integrity Check" disabled={this.state.tab2Disabled} >
            <div className="tab-container">
              <ValidationConfiguratorComponent 
                onValidationResults={this.handleValidationResults} 
                onLoadingStart={this.handleLoadingStateChange} 
                uploadType={this.state.uploadType} 
                sponsorCode={this.state.sponsorCode} 
              />

              <ValidationSummaryComponent
                validationResults={this.state.validationResults}
                validationRules={this.state.validationRules}
                sponsorCode={this.state.sponsorCode}
                openSummary={this.state.openSummary}
                openDetails={this.state.openDetails}
                openSummaryDisabled={this.state.openSummaryDisabled}
                openDetailsDisabled={this.state.openDetailsDisabled}

                summaryToggleHandler={this.handleSummaryCollapseToggle}
                detailsToggleHandler={this.handleDetailsCollapseToggle} 

                exportDisabled={this.state.exportDisabled}
                onExport={this.handleExport}  
                loadingExport={this.state.loadingExport}
                
                
                
                />

              <NavigationComponent 
                hasBackButton={true} 
                hasNextButton={true} 
                nextDisabled={this.state.tab3Disabled} 
                clickHandler={this.handleTabSelect} 
                thisTabId={2} 
                cancelUrl={homeLocation} />

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
