import React, {Component} from 'react';
import Table from './Table';
import Pagination from './Pagination';

export default class PartialTable extends Component {
  onExportClick = (e) => {
    e.preventDefault();
    var $ = require('jquery');
    $.get({url:'/getFundingOrg'}).done(function(resp) {
      var exportObj = [{
        title: 'Funding Organizations',
        rows: [
          ['Name','Type','Abbreviation','Sponsor Code','Country','Currency','Annualized Funding','Last Import Date','Import Description']
        ]
      }];
      $.merge(exportObj[0].rows,resp.map(function(entry) {
        return [
          entry.Name,
          entry.Type,
          entry.Abbreviation,
          entry.SponsorCode,
          entry.Country,
          entry.Currency,
          entry.IsAnnualized,
          entry.LastImportDate,
          entry.LastImportDesc
        ];
      }));
      $.ajax({
        url: '/map/getExcelExport/',
        method: 'POST',
        data: JSON.stringify(exportObj)
      }).done(function(resp) {
        window.location = '/'+resp;
      });
    });
  };

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
        <p>ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below.</p>
        <div className="row">
          <style type="text/css">{`
            .col-xl-3 {
              height: 36px;
              line-height: 36px;
              margin-bottom: 5px;
            }
            .col-xl-3 + .col-xl-3 + .col-xl-3 + .col-xl-3 {
              text-align: right;
            }
          .form-control-input {
              border: 1px solid #AAA;
              border-radius: 4px;
              padding: 6px;
              height: 24px;
            }
            #funding_org_export {
              position: relative;
              top: -2px;
            }
            @media (min-width: 768px) {
              .col-xl-3 + .col-xl-3 {
                text-align: right;
              }
              .col-xl-3 + .col-xl-3 + .col-xl-3 {
                text-align: left;
              }
            }
            @media (min-width: 1200px) {
              .col-xl-3 + .col-xl-3 {
                text-align: center;
              }
              .col-xl-3 + .col-xl-3 + .col-xl-3 {
                text-align: right;
              }
            }
            @media (min-width: 1450px) {
              .col-xl-3 + .col-xl-3 + .col-xl-3 {
                text-align: center;
              }
              .col-xl-3 {
                width: 25%;
              }
            }
          `}</style>
          <div className="col-xs-12 col-sm-6 col-lg-4 col-xl-3">
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
          <div className="col-xs-12 col-sm-6 col-lg-4 col-xl-3">
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
          <div className="col-xs-12 col-sm-6 col-lg-4 col-xl-3">
            <style type="text/css">{`.pagination {margin: 5px;} `}</style>
            <Pagination
              className="pagination"
              currentPage={pageNumber}
              totalPages={totalPages}
              onChangePage={onPageNumberChange}
            />
          </div>
          <div className="col-xs-12 col-sm-6 col-lg-12 col-xl-3">
            <button id="funding_org_export" className="btn btn-default btn-sm" onClick={this.onExportClick}>
              <div>
                <svg width="12px" height="12px" viewBox="0 0 16 16">
                  <g stroke="none" stroke-width="1" fill-rule="evenodd" fill="#000000">
                    <path d="M4,6 L7,6 L7,0 L9,0 L9,6 L12,6 L8,10 L4,6 L4,6 Z M15,2 L11,2 L11,3 L15,3 L15,11 L1,11 L1,3 L5,3 L5,2 L1,2 C0.45,2 0,2.45 0,3 L0,12 C0,12.55 0.45,13 1,13 L6.34,13 C6.09,13.61 5.48,14.39 4,15 L12,15 C10.52,14.39 9.91,13.61 9.66,13 L15,13 C15.55,13 16,12.55 16,12 L16,3 C16,2.45 15.55,2 15,2 L15,2 Z" id="Shape"></path>
                  </g>
                </svg>
                <span className="margin-left">Export</span>
              </div>
            </button>
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
