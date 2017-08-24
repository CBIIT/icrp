import React, {Component} from 'react';
import { Table, Pagination } from 'react-bootstrap';
import '../css/DataGrid.css';

export default class DataGrid extends Component {

  sortDirections = ['NONE', 'ASC', 'DESC'];

  state = {
    originalRows: [],
    rows: [],
    columns: [],
    activePage: 1,
    pageSize: 25,
    sortColumn: null,
    sortDirection: 'NONE',
  };


  componentWillReceiveProps(props) {

    let { rows, columns } = props;

    this.setState({
      activePage: 1,
      originalRows: rows,
      rows: rows.slice(0, this.state.pageSize),
      columns: columns
        .map((column, index) => ({
          key: column,
          name: column,
          sortDirection: 'NONE',
          width: index === 0 ? '400px' : '120px'
        })),
    });
  }

  handlePagination(activePage) {
    let { sortColumn, sortDirection } = this.state;

    const comparer = (a, b) => {
      if (sortDirection === 'ASC') {
        return (a[sortColumn] > b[sortColumn]) ? 1 : -1;
      } else if (sortDirection === 'DESC') {
        return (a[sortColumn] < b[sortColumn]) ? 1 : -1;
      }
    };

    let { pageSize } = this.state;

    const rows = (sortDirection === 'NONE'
      ? this.state.originalRows.slice(0)
      : this.state.originalRows.slice(0).sort(comparer)
    ).slice((activePage - 1) * pageSize, activePage * pageSize)

    this.setState({ rows, activePage});
  }

  handleGridSort(sortColumn, sortDirection) {
    const comparer = (a, b) => {
      if (sortDirection === 'ASC') {
        return (a[sortColumn] > b[sortColumn]) ? 1 : -1;
      } else if (sortDirection === 'DESC') {
        return (a[sortColumn] < b[sortColumn]) ? 1 : -1;
      }
    };

    console.log(sortColumn, sortDirection);

    let { activePage, pageSize } = this.state;

    const rows = (sortDirection === 'NONE'
      ? this.state.originalRows.slice(0)
      : this.state.originalRows.slice(0).sort(comparer)
    ).slice((activePage - 1) * pageSize, activePage * pageSize)

    this.setState({ rows, sortColumn, sortDirection });
  }

  render() {
    let {
      columns,
      originalRows,
      rows,
      activePage,
      pageSize,
      sortColumn,
      sortDirection,
    } = this.state;

    const showingFrom = Math.max(activePage * 25 - 24, 1);
    const showingTo = Math.min(activePage * pageSize, originalRows.length);

    return (
      !this.props.visible || rows.length === 0 || columns.length === 0 ? null :
      <div className={this.props.className}>
          <div style={{display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between', alignItems: 'center' }}>
            <div className="pagination">
              <b>Showing</b> {showingFrom.toLocaleString()} - {showingTo.toLocaleString()} of <b>{originalRows.length.toLocaleString()}</b> records
            </div>
            {
              originalRows.length > pageSize &&
              <Pagination
                prev
                next
                first
                last
                ellipsis
                boundaryLinks
                items={Math.ceil(originalRows.length / pageSize)}
                maxButtons={5}
                activePage={activePage}
                onSelect={page => this.handlePagination(page)}
            />
          }
          </div>

        <table className="table table-striped table-bordered table-hover">
          <thead>
            <tr>
              {
                columns.map(column =>
                  <td
                    style={{width: column.width || 'auto'}}
                    onClick={event => {
                      let index = (1 + this.sortDirections.indexOf(sortDirection)) % this.sortDirections.length;
                      console.log(index, this.sortDirections[index]);
                      this.handleGridSort(column.key, this.sortDirections[index])
                    }}>
                    <div className="table-header-flex">
                      <span>{column.name}</span>
                      {
                        column.key === sortColumn && sortDirection !== 'NONE' &&
                        <span className="rotate-45">
                        {
                          sortDirection === 'ASC'
                          ? '\u25E4'
                          : '\u25E2'
                        }
                        </span>
                      }
                    </div>
                  </td>
                )
              }
            </tr>
          </thead>
          <tbody>
          {
            rows.map(row =>
              <tr>{
                columns.map(column =>
                  <td
                    style={{width: column.width || 'auto'}}
                    title={row[column.key]}
                  >
                    {row[column.key]}
                  </td>
                )
              }</tr>
            )
          }
          </tbody>
        </table>

{/*
        <ReactDataGrid
          columns={columns}
          rowGetter={index => rows[index]}
          rowsCount={rows.length}
          onGridSort={(column, direction) => this.handleGridSort(column, direction)}
          minHeight={rows.length > pageSize
            ? 20 + (pageSize * 35)
            : 20 + ((rows.length + 1) * 35)}
        /> */}
      </div>
    );
  }
}


