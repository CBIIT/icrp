import $ from 'jquery';
import React, {Component} from 'react';
import Table from './Table';
import Pagination from './Pagination';

export default class PartialTableUploadStatusReport extends Component {
    async exportUploadStatus() {
      try {
        let response = await fetch('/ExportUploadStatus');
        let json = await response.json();
        document.location.href = json;
      }

      catch (error) {
        console.error('exception occured: ', error);
      }
   }

  render() {
    const {
      onFilter, onPageSizeChange, onPageNumberChange, onSort,
      pageLengthOptions, columns, keys, buildRowOptions,
    } = this.props;

    const {
      page, pageSize, pageNumber,
      totalPages, sortBy, filterValues,totalRecords,
    } = this.props.data;

    return (
      <div className="form-group">
        <h1>Data Upload Status Report</h1>
        <p>
          Information about the status of data submissions and uploads to the ICRP database is included below. Please note that each organization has its own data upload schedule and the latest data uploaded for each organization can be seen <a href="https://icrpartnership-test.org/FundingOrgs">here</a>.
 	      </p>

        <div style={{position: 'relative', marginBottom: '5px'}}>
            <button onClick={this.exportUploadStatus} className="btn btn-default">
              <span className="glyphicon glyphicon-download-alt" style={{display: 'inline-block', marginRight: '5px'}}></span>
              Export
            </button>
            <div style={{margin: 0, position: 'absolute', right: 0, bottom: 0}}>
              <Pagination
                className="pagination"
                currentPage={pageNumber}
                totalPages={totalPages}
                onChangePage={onPageNumberChange}
              />
            </div>
        </div>

        <div className="table-responsive">
          <Table
            className="table table-bordered table-striped table-condensed table-hover table-narrow table-nowrap"
            dataArray={page}
            columns={columns}
            keys={keys}
            buildRowOptions={buildRowOptions}
            sortBy={sortBy}
            onSort={onSort}
          />
        </div>
      </div>
    );
  }

}
