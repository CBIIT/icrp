import React, {Component} from 'react';
import Table from './Table';
import Pagination from './Pagination';

export default class PartialTable extends Component {

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
        <font color="orange"><h3 class="titleOrg margin-right">Funding Organizations</h3></font>
        <p>
ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below.
 	</p>
        <div className="row">
          <div className="col-xs-12">
            <div>
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-3 top-buffer">
            <div>
              <label htmlFor="search-field">Search&nbsp; </label>
              <input
                id="search-field"
                type="search"
                size="30"
                value={filterValues.globalSearch}
                onChange={onFilter.bind(null, 'globalSearch')}
              />
             </div>
          </div>
          <div className="col-xs-5 top-buffer">
            <div>
              <label htmlFor="page-menu"> Show &nbsp; </label>
              <select
                id="page-menu"
                value={pageSize}
                onChange={onPageSizeChange}
              >
                {pageLengthOptions.map(opt =>
                  <option key={opt} value={opt}>
                    {opt === 0 ? 'All' : opt}
                  </option>
                )}
              </select>
              &nbsp; out of  <b>{totalRecords}</b> Funding Organizations 
            </div>
	  </div>
          <div className="col-xs-4">
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
