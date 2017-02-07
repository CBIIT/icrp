import $ from 'jquery';
import React, {Component} from 'react';
import Table from './Table';
import Pagination from './Pagination';

export default class PartialTableUploadStatusReport extends Component {
    exportResult() {
    $.ajax({
        url: '/ExportUploadStatus',
        dataType: 'jsonp',
        cache: false,
        success: function(data) {
            document.location.href=data.json()
        }.bind(this),
            error: function(xhr, status, err) {
            console.error(this.props.url, status, err.toString());
        }.bind(this)
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
        <font color="orange"><h3 class="titleOrg margin-right">ICRP Data Upload Status Report</h3></font>
        <p>
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
          className="table table-bordered"
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
