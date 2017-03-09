import React from 'react';
import ReactDOM from 'react-dom';
import DataTable from './DataTable';
import DataTableUploadStatusReport from './DataTableUploadStatusReport';
import './table-twbs.css';


function buildTable(data) {

  const tableColumns = [
    { title: 'Name', tooltip:'Full name of the funding organization', prop: 'name' },
    { title: 'Abbreviation', tooltip:'ICRP abbreviation for the funding organization', prop: 'abbr' },
    { title: 'Country', tooltip:'ISO 3166-2 Country Code', prop: 'country' },
    { title: 'Sponsor Code', tooltip:'Abbreviation of the partner organization submitting data', prop: 'sponsor' },
    { title: 'Currency', tooltip:'Currency in which awards are submitted', prop: 'currency' },
    { title: 'Annualized Funding', tooltip:'If NO, funding for the lifetime of the award is complete. If YES, funding is updated annually and investment amounts for future years may not yet be complete', prop: 'annual' },
    { title: 'Last Import Date', tooltip:'Date on which the most recent import was uploaded to ICRP', prop: 'import_date' },
    { title: 'Import Description', tooltip:'Description of the latest upload to ICRP', prop: 'description' },
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
    { title: 'Partner', tooltip:'Partner', prop: 'partner' },
    { title: 'Funding Year', tooltip:'Funding year as submitted by the organization', prop: 'funding_year' },
    { title: 'Process Status', tooltip:'Process Status', prop: 'status' },
    { title: 'Received Data Submission', tooltip:'Received Data Submission', prop: 'received_date' },
    { title: 'Run pre-import validation', tooltip:'Date pre-import validation completed', prop: 'validation_date' },
    { title: 'Uploaded to Development DB', tooltip:'Uploaded to Development DB', prop: 'dev_date' },
    { title: 'Copied to Stage DB', tooltip:'Copied to Stage DB', prop: 'stage_date' },
    { title: 'Copied to Production DB', tooltip:'Date of upload to live database', prop: 'prod_date' },
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
