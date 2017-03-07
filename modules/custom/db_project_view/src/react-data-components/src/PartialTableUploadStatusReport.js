import $ from 'jquery';
import React, {Component} from 'react';
import Table from './Table';
import Pagination from './Pagination';

export default class PartialTableUploadStatusReport extends Component {
    exportResult() {
        fetch('/ExportUploadStatus')


         .then(function(response) {
            return response.json();
         })
         .then(function(json) {
	    document.location.href = json
         }.bind(this))
         .catch(function(ex) {
            console.log('parsing failed', ex)
         });

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
      <div className="container_funding_org">
        <font color="orange"><h1 class="titleOrg margin-right">ICRP Data Upload Status Report</h1></font>
        <p className="form-group">
          Information about the status of data submissions and uploads to the ICRP database is included below. Please note that each organization has its own data upload schedule and the latest data uploaded for each organization can be seen <a href="https://icrpartnership-test.org/FundingOrgs">here</a> 
 	      </p>
        <div className="row">
          <div className="col-xs-12">
            <div>
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-6 top-buffer">
            <div>
              <button onClick={this.exportResult} className="btn btn-default"><span className="glyphicon glyphicon-download-alt"></span>&nbsp;Export</button>
            </div>
	  </div>
          <div className="col-xs-6">
            <Pagination
              className="pagination pull-right"
              currentPage={pageNumber}
              totalPages={totalPages}
              onChangePage={onPageNumberChange}
            />
          </div>
        </div>
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
    );
  }

}
