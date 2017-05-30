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
        <font color="orange"><h1 class="titleOrg margin-right">Funding Organizations</h1></font>
        <p>
ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below.
 	</p>

        <div className="row">
          <style type="text/css">{`
            .col-xs-3 {margin-top: 10px;}
            .form-control-input {
              border: 1px solid #AAA;
              border-radius: 4px;
              padding: 6px;
            }
          `}</style>
          <div className="col-xs-3">
            <div>
              <label htmlFor="search-field">Search&nbsp; </label>
              <input
                className="form-control-input"
                id="search-field"
                type="search"
                size="30"
                value={filterValues.globalSearch}
                onChange={onFilter.bind(null, 'globalSearch')}
              />
             </div>
          </div>
          <style type="text/css">{`.col-xs-5 {margin-top: 10px;} `}</style>
          <div className="col-xs-5">
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
          <style type="text/css">{`.pagination {margin: 5px;} `}</style>
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
