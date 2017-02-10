import React from 'react';
import ReactDOM from 'react-dom';
import DataTable from './DataTable';
import DataTableUploadStatusReport from './DataTableUploadStatusReport';
import './table-twbs.css';


function buildTable(data) {

  const tableColumns = [
    { title: '', prop: 'index', sortable: false},
    { title: 'Name', prop: 'name' },
    { title: 'Abbreviation', prop: 'abbr' },
    { title: 'Country', prop: 'country' },
    { title: 'Sponsor Code', prop: 'sponsor' },
    { title: 'Currency', prop: 'currency' },
    { title: 'Annualized Funding', prop: 'annual' },
    { title: 'Last Import Date', prop: 'import_date' },
    { title: 'Import Description', prop: 'description' },
  ];

  return (
    <DataTable
      className="container"
      keys="id"
      columns={tableColumns}
      initialData={data}
      initialPageLength={20}
      initialSortBy={{ prop: 'name', order: 'ascending' }}
      pageLengthOptions={[ 10, 20, 50 ]}
    />
  );
}


function buildUploadStatusReportTable(data) {

  const tableColumns = [
    { title: '', prop: 'index', sortable: false},
    { title: 'Partner', prop: 'partner' },
    { title: 'Funding Year', prop: 'funding_year' },
    { title: 'Process Status', prop: 'status' },
    { title: 'Received Data Submission', prop: 'received_date' },
    { title: 'Run pre-import validation', prop: 'validation_date' },
    { title: 'Uploaded to Development DB', prop: 'dev_date' },
    { title: 'Copied to Stage DB', prop: 'stage_date' },
    { title: 'Copied to Production DB', prop: 'prod_date' },
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
