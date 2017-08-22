import React, {Component} from 'react';
import ReactDataGrid from 'react-data-grid';
import { Row, Col, Pagination } from 'react-bootstrap';

import PropTypes from 'prop-types';

class DataGrid extends Component {

  state = {
    originalRows: [],
    rows: [],
    columns: [],
    activePage: 1,
    pageSize: 25,
  };

  componentWillReceiveProps(props) {
    this.setState({
      activePage: 1,
      originalRows: props.rows,
      rows: props.rows,
      columns: props.columns
        .map(column => ({
          key: column,
          name: column,
          sortable: true,
          resizable: true,
          width: 140,
        })),
    });
  }

  handlePagination(event) {
    console.log(event);
  }

  handleGridSort(sortColumn, sortDirection) {
    const comparer = (a, b) => {
      if (sortDirection === 'ASC') {
        return (a[sortColumn] > b[sortColumn]) ? 1 : -1;
      } else if (sortDirection === 'DESC') {
        return (a[sortColumn] < b[sortColumn]) ? 1 : -1;
      }
    };

    const rows = sortDirection === 'NONE'
      ? this.state.originalRows.slice(0)
      : this.state.rows.sort(comparer);

    this.setState({ rows });
  }

  render() {
    console.log('rendering datagrid', this.state, this.props);
    let {
      columns,
      rows,
      activePage,
      pageSize,
    } = this.state;

    const showingFrom = Math.max(activePage * 25 - 24, 1);
    const showingTo = Math.min(activePage * pageSize, rows.length);

    return (
      !this.props.visible ? null :
      <div className={this.props.className}>
          <div style={{display: 'flex', flexWrap: 'wrap', justifyContent: 'space-between', alignItems: 'center' }}>
            <div className="pagination">
              <b>Showing</b> {showingFrom.toLocaleString()} - {showingTo.toLocaleString()} of <b>{rows.length.toLocaleString()}</b> records
            </div>
            {
              rows.length > pageSize &&
              <Pagination
              prev
              next
              first
              last
              ellipsis
              boundaryLinks
              items={Math.ceil(rows.length / pageSize)}
              maxButtons={5}
              activePage={activePage}
              onSelect={page => this.handlePagination(page)}
            />
          }
          </div>

        <ReactDataGrid
          columns={columns}
          rowGetter={index => rows[index]}
          rowsCount={rows.length}
          onGridSort={(column, direction) => this.handleGridSort(column, direction)}
          minHeight={rows.length > pageSize
            ? 20 + (pageSize * 35)
            : 20 + ((rows.length + 1) * 35)}
        />
      </div>
    );
  }
}

DataGrid.propTypes = {
  columns: PropTypes.array,
  rows: PropTypes.array,
  visible: PropTypes.bool,
}

export default DataGrid;