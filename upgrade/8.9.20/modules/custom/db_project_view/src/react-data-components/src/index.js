import React from 'react';
import ReactDOM from 'react-dom';
import DataTable from './DataTable';
import DataTableUploadStatusReport from './DataTableUploadStatusReport';
import './table-twbs.css';


function buildTable(data) {

  const tableColumns = [
    { title: 'Name', tooltip:'Full name of the funding organization', prop: 'Name' },
    { title: 'Type', tooltip:'Type of funding organization (Government, Non-Profit, Other)', prop: 'Type' },
    { title: 'Abbreviation', tooltip:'ICRP abbreviation for the funding organization', prop: 'Abbreviation' },
    { title: 'Sponsor Code', tooltip:'Abbreviation of the partner organization submitting data', prop: 'SponsorCode' },
    { title: 'Country', tooltip:'ISO 3166-2 Country Code', prop: 'Country' },
    { title: 'Currency', tooltip:'Currency in which awards are submitted', prop: 'Currency' },
    { title: 'Annualized Funding', tooltip:'If NO, funding for the lifetime of the award is complete. If YES, funding is updated annually and investment amounts for future years may not yet be complete', prop: 'IsAnnualized' },
    { title: 'Last Import Date', tooltip:'Date on which the most recent import was uploaded to ICRP', prop: 'LastImportDate' },
    { title: 'Import Description', tooltip:'Description of the latest upload to ICRP', prop: 'LastImportDesc' },
  ];

  return (
    <DataTable
      className="container"
      tableClass="striped hover responsive"
      keys="id"
      columns={tableColumns}
      initialData={data}
      initialPageLength={25}
      initialSortBy={{ prop: 'Name', order: 'ascending' }}
      pageLengthOptions={[ 25, 50, 100, 150 ]}
    />
  );
}


function buildUploadStatusReportTable(data) {

  const tableColumns = [
    { title: 'Partner', tooltip:'Partner', prop: 'Partner' },
    { title: 'Funding Year', tooltip:'Funding year as submitted by the organization', prop: 'FundingYear' },
    { title: 'Status', tooltip:'Process Status', prop: 'Status' },
    { title: 'Type', tooltip:'New data, or updates overwriting existing data', prop: 'Type' },
    { title: 'Records Imported', tooltip:'Number of project funding records submitted (unique AltIDs)', prop: 'Count' },
    { title: 'Submission Date', tooltip:'Received Data Submission', prop: 'ReceivedDate' },
    { title: 'Stage Date', tooltip:'Copied to Stage DB', prop: 'UploadToStageDate' },
    { title: 'Production Date', tooltip:'Date of upload to live database', prop: 'UploadToProdDate' },
    { title: 'Notes', tooltip:'Description of the latest upload to ICRP', prop: 'Note' },
  ];

  return (
    <DataTableUploadStatusReport
      className="container"
      keys="id"
      columns={tableColumns}
      initialData={data}
      initialPageLength={25}
      pageLengthOptions={[ 10, 25, 50 ]}
    />
  );
}

var elementExists = document.getElementById("funding_org_root");
if (elementExists == null) {
fetch('/getUploadStatus')
  .then(res => res.json())
  .then((rows) => {

    let data = rows.map(row => {
      let obj = {};
      for (let key in row) {
        obj[key] = row[key] || '';
      }

      // ensure missing columns exist
      for (let key of ['Type', 'Count']) {
        if (!obj[key]) {
          obj[key] = '';
        }
      }

      return obj;
    })

    ReactDOM.render(buildUploadStatusReportTable(data), document.getElementById('upload_status_report_root'));
  });
}
else {
fetch('/getFundingOrg')
  .then(res => res.json())
  .then((rows) => {
    let data = rows.map(row => {
      let obj = {};
      for (let key in row) {
        if (key === 'IsAnnualized') {
          obj[key] = row[key] === '1' ? 'YES' : 'NO';
        }

        else if (key === 'LastImportDate') {
          let lastImportDate = row[key];
          obj[key] = lastImportDate ? lastImportDate.split(' ')[0] : null;
        }

        else {
          obj[key] = row[key] || '';
        }
      }
      return obj;
    })

    ReactDOM.render(buildTable(data), document.getElementById('funding_org_root'));
  });
}
