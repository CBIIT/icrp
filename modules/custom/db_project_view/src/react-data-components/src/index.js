import React from 'react';
import ReactDOM from 'react-dom';
import DataTable from './DataTable';
import DataTableUploadStatusReport from './DataTableUploadStatusReport';
import './table-twbs.css';


function buildTable(data) {

  const tableColumns = [
    { title: 'Name', tooltip:'Name', prop: 'name' },
    { title: 'Abbreviation', tooltip:'Abbreviation', prop: 'abbr' },
    { title: 'Country', tooltip:'Country', prop: 'country' },
    { title: 'Sponsor Code', tooltip:'Sponsor Code', prop: 'sponsor' },
    { title: 'Currency', tooltip:'Currency', prop: 'currency' },
    { title: 'Annualized Funding', tooltip:'Annualized Funding', prop: 'annual' },
    { title: 'Last Import Date', tooltip:'Last Import Date', prop: 'import_date' },
    { title: 'Import Description', tooltip:'Import Description', prop: 'description' },
  ];

  return (
    <DataTable
      className="container"
      tableClass="striped hover responsive"
      keys="id"
      columns={tableColumns}
      initialData={data}
      initialPageLength={25}
      initialSortBy={{ prop: 'name', order: 'ascending' }}
      pageLengthOptions={[ 25, 50, 100, 150 ]}
    />
  );
}


function buildUploadStatusReportTable(data) {

  const tableColumns = [
    { title: '', tooltip:'', prop: 'index', sortable: false},
    { title: 'Partner', tooltip:'Partner', prop: 'partner' },
    { title: 'Funding Year', tooltip:'Funding Year', prop: 'funding_year' },
    { title: 'Process Status', tooltip:'Process Status', prop: 'status' },
    { title: 'Received Data Submission', tooltip:'Received Data Submission', prop: 'received_date' },
    { title: 'Run pre-import validation', tooltip:'Run pre-import validation', prop: 'validation_date' },
    { title: 'Uploaded to Development DB', tooltip:'Uploaded to Development DB', prop: 'dev_date' },
    { title: 'Copied to Stage DB', tooltip:'Copied to Stage DB', prop: 'stage_date' },
    { title: 'Copied to Production DB', tooltip:'Copied to Production DB', prop: 'prod_date' },
  ];

  return (
    <DataTableUploadStatusReport
      className="container"
      keys="id"
      columns={tableColumns}
      initialData={data}
      initialPageLength={20}
      initialSortBy={{ prop: 'received_date', order: 'descending' }}
      pageLengthOptions={[ 10, 20, 50 ]}
    />
  );
}

var elementExists = document.getElementById("funding_org_root");
if (elementExists == null) {
fetch('/getUploadStatus')
  .then(res => res.json())
  .then((rows) => {
    ReactDOM.render(buildUploadStatusReportTable(rows), document.getElementById('upload_status_report_root'));
  });
}
else {
fetch('/getFundingOrg')
  .then(res => res.json())
  .then((rows) => {
    ReactDOM.render(buildTable(rows), document.getElementById('funding_org_root'));
  });
}
