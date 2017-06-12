import React, { Component } from 'react';
import ReactDataGrid from 'react-data-grid';
import { Pagination } from 'react-bootstrap';


class TablePagination extends Component {

    constructor(props) {
        super(props);
        this.handlePageSelection = this.handlePageSelection.bind(this);
    }

    handlePageChange(page, projects) {
        this.props.onPageChange(page, projects);
    }

    async handlePageSelection(e) {
        let page = e;
        var data = new FormData();
        data.append('page', page);
        data.append('sortColumn', this.props.sortColumn);
        data.append('sortDirection', this.props.sortDirection);
        var that = this;
        let response = await fetch('http://icrp-dataload/getdata_mssql/', { method: 'POST', body: data });

        if (response.ok) {
            let result = await response.json();
            const projects = result.projects;
            that.handlePageChange(page, projects);
        } else {
            alert("Oops! ");
        }
    }


    render() {

        const totalPages = this.props.stats.totalPages;
        const page = this.props.stats.page;
        return (
            <Pagination
                bsSize="medium"
                prev
                next
                first
                last
                ellipsis={totalPages <= 4 ? false : true}
                boundaryLinks
                items={totalPages}
                maxButtons={4}
                activePage={page}
                onSelect={this.handlePageSelection} />
        );
    }
}


class NewTableComponent extends Component {

    constructor(props) {
        super(props);
        // this.state={sortColumn: 'InternalId', sortDirection: 'ASC'};
        this.rowGetter = this.rowGetter.bind(this);
        this.handleGridSort = this.handleGridSort.bind(this);
    }

    handleSortChange(sortColumn, sortDirection, projects) {
        this.props.onSortChange(sortColumn, sortDirection, projects);
    }


    rowGetter(i) {
        return this.props.projects[i];
    }

    async handleGridSort(sortColumn, sortDirection) {
        var data = new FormData();
        data.append('page', this.props.stats.page);
        data.append('sortColumn', sortColumn);
        data.append('sortDirection', sortDirection);
        var that = this;
        let response = await fetch('http://icrp-dataload/getdata_mssql/', { method: 'POST', body: data });

        if (response.ok) {
            let result = await response.json();
            const projects = result.projects;
            that.handleSortChange(sortColumn, sortDirection, projects);
        } else {
            alert("Oops! ");
        }

        // this.setState({ sortColumn: sortColumn, sortDirection: sortDirection });
    }

    render() {

        const columns = this.props.columns;
        const rowCount = this.props.projects.length;
        const totalPages = this.props.stats.totalPages;
        const page = this.props.stats.page;

        return (

            <div>
                Total Records: {this.props.stats.totalRows}
                <ReactDataGrid
                    onGridSort={this.handleGridSort}
                    columns={columns}
                    rowGetter={this.rowGetter}
                    rowsCount={rowCount}
                    minHeight={500} />
                Page {page} of {totalPages} (Showing {this.props.stats.showingFrom} - {this.props.stats.showingTo} of {this.props.stats.totalRows}) < br />
                <TablePagination stats={this.props.stats} sortColumn={this.props.sortColumn} sortDirection={this.props.sortDirection} onPageChange={this.props.onPageChange} />
            </div>
        );
    }

}

export default NewTableComponent;


