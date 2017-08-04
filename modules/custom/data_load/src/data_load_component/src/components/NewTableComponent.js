import React, { Component } from 'react';
import ReactDataGrid from 'react-data-grid';
import { Pagination } from 'react-bootstrap';

class TablePagination extends Component {

    constructor(props) {
        super(props);
        this.handlePageSelection = this.handlePageSelection.bind(this);
    }

    handlePageSelection(e) {
        let page = e;
        this.props.onPageChange(page);
    }


    render() {

        const totalPages = this.props.stats.totalPages;
        const page = this.props.page;
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
        this.rowGetter = this.rowGetter.bind(this);
        this.handleGridSort = this.handleGridSort.bind(this);
        this.handlePageChange = this.handlePageChange.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.handlePageOrSortChange = this.handlePageOrSortChange.bind(this);
    }

    handleSortChange(sortColumn, sortDirection, projects) {
        this.props.onSortChange(sortColumn, sortDirection, projects);
    }

    handlePageOrSortChange(page, sortColumn, sortDirection, projects) {
        this.props.onChange(page, sortColumn, sortDirection, projects);
    }

    handlePageChange(page) {
        this.handleChange(page, this.props.sortColumn, this.props.sortDirection);
    }

    handleGridSort(sortColumn, sortDirection) {
        this.handleChange(this.props.page, sortColumn, sortDirection);
    }

    async handleChange(page, sortColumn, sortDirection) {
        var data = new FormData();
        data.append('page', page);
        data.append('sortColumn', sortColumn);
        data.append('sortDirection', sortDirection);
        var that = this;
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/getdata_mssql';

        if (hostname === 'localhost') {
            protocol = 'http:';
            hostname = 'icrp-dataload';
        }

        let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'POST', body: data, credentials: 'same-origin' });

        if (response.ok) {
            let result = await response.json();
            const projects = result.projects;
            that.handlePageOrSortChange(page, sortColumn, sortDirection, projects);
        } else {
            alert("Oops! ");
        }
    }

    rowGetter(i) {
        return this.props.projects[i];
    }

    render() {

        if (!this.props.visible)
            return null;

        const columns = this.props.columns;
        const rowCount = this.props.projects.length;
        const page = this.props.page;
        const showingFrom = Math.max(page * 25 - 24, 1);
        const showingTo = Math.min(page * 25, this.props.stats.totalRows);

        return (
            <div>
                <div className='flex-center'>
                    <div>
                        <b>Show</b> {parseInt(showingFrom, 10).toLocaleString()} - {parseInt(showingTo, 10).toLocaleString()} of <b>{parseInt(this.props.stats.totalRows, 10).toLocaleString()}</b> records
                    </div>
                    
                    <TablePagination stats={this.props.stats} page={this.props.page} onPageChange={this.handlePageChange} />
                </div>
                                
                <ReactDataGrid
                    onGridSort={this.handleGridSort}
                    columns={columns}
                    rowGetter={this.rowGetter}
                    rowsCount={rowCount} 
                    minHeight={950} />  
               
            </div >
        );
    }

}

export default NewTableComponent;


