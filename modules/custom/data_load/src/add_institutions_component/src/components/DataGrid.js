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
        .map(column => ({
          key: column,
          name: column,
          sortDirection: 'NONE',
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

        <Table striped bordered condensed hover>
          <thead>
            <tr>
              {
                columns.map(column =>
                  <td >
                    <span>{column.name}</span>
                    {/* <span style={{
                      display: column.sortDirection === 'NONE' ? 'none' : 'inline-block',
                      transform: {
                        ASC: 'rotate(-45)',
                        DESC: 'rotate(45)',
                      }[column.sortDirection]
                    }}></span> */}
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
                  <td title={row[column.key]}>{row[column.key]}</td>
                )
              }</tr>
            )
          }
          </tbody>
        </Table>

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


