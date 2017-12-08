import React from 'react';
import { Pagination, OverlayTrigger, Tooltip } from 'react-bootstrap';
import './DataGrid.css';

export interface DataGridHeader {
  value: string;
  label: string;
  tooltip?: string;
  sortDirection?: string; // 'asc', 'desc', or 'none'
  callback?: (value: any, index: number) => any;
}

export interface DataGridProps {
  headers: (string | DataGridHeader)[];
  data: any[];
}

interface DataGridState {
  _headers: DataGridHeader[];
  _originalData: any[];
  _data: any[];
  _page: number;
  _pageSize: number;
}

export class DataGrid extends React.Component<DataGridProps, DataGridState> {
  state = {
    _headers: [],
    _originalData: [],
    _data: [],
    _page: 1,
    _pageSize: 25,
  }

  constructor(props: DataGridProps) {
    super(props);
  }

  componentWillReceiveProps(props: DataGridProps) {
    if (props.headers) {
      const _headers = props.headers.map(header =>
        typeof header === "string" ? {
          value: header,
          label: header,
          tooltip: header,
          sortDirection: 'none'
        } : header
      );

      this.setState({_headers})
    }

    if (props.data) {
      this.setState({
        _data: [...props.data],
        _originalData: [...props.data],
      })
    }

    else {
      this.setState({
        _data: [],
        _originalData: [],
      })
    }
  }

  sort(headerIndex: number) {

    const headers = this.state._headers;
    const header: DataGridHeader = headers[headerIndex];
    const nextSortDirection: string = {
      none: 'asc',
      asc: 'desc',
      desc: 'asc'
    }[header.sortDirection || 'none'];

    headers.forEach((header: DataGridHeader, index: number) =>
      header.sortDirection = index === headerIndex
        ? nextSortDirection : 'none');

    if (header.sortDirection === 'none') {
      this.setState(state => ({
        _headers: headers,
        _data: state._originalData
      }))
    }

    else {
      const sortFn = (objA: any, objB: any) => {
        const a = objA[header.value];
        const b = objB[header.value];

        switch (header.sortDirection) {
          case 'asc':
            return isNaN(a) || isNaN(b)
              ? a.localeCompare(b)
              : +a - +b;

          case 'desc':
            return isNaN(a) || isNaN(b)
              ? b.localeCompare(a)
              : +b - +a;
        }
      };

      const data = this.state._data.sort(sortFn);
      this.setState({
        _data: data,
        _headers: headers,
      });
    }
  }

  setPage(page: number) {
    this.setState({
      _page: page
    });
  }

  setPageSize(pageSize: number) {
    this.setState({
      _page: 1,
      _pageSize: pageSize,
    });
  }

  render() {

    const {_data, _headers, _page, _pageSize} = this.state;

    return (
      <div className="table-responsive">
      {
        _data.length <= _pageSize ?
        <div className="margin-top pagination-container">
          <span>
            {`Total `}
            <b>{_data && _data.length}</b>
            {` entries`}
          </span>
          <div style={{marginBottom: '5px'}}>{ this.props.children }</div>
        </div> :
        <div className="margin-top pagination-container">
          <div className="pagination-select-container">
            <div style={{marginRight: '100px'}}>
              {'Show '}
              <select value={_pageSize} onChange={event => this.setPageSize(+event.target.value)}>
                <option value={25}>25</option>
                <option value={50}>50</option>
                <option value={100}>100</option>
                <option value={150}>150</option>
                <option value={200}>200</option>
                <option value={250}>250</option>
                <option value={300}>300</option>
              </select>

              {` out of `}
              <b>{_data && _data.length}</b>
              {` entries`}
            </div>

            <Pagination
              bsSize="small"
              items={Math.ceil(_data.length/_pageSize)}
              activePage={_page}
              onSelect={(page: any) => this.setPage(page as number)}
              boundaryLinks={true}
              ellipsis={true}
              maxButtons={5}
              prev
              next
            />
          </div>

          <div style={{marginBottom: '5px'}}>{ this.props.children }</div>
        </div>
      }

        <table className="table table-striped table-hover table-nowrap">
          <thead>
            <tr>
            {_headers.map((header: DataGridHeader, index: number) =>
              <th key={header.value}>
                  <OverlayTrigger placement="top" overlay={
                    <Tooltip id={header.value}>
                      {header.tooltip || header.label}
                    </Tooltip>
                  }>

                  <div className="sortable-header noselect" onClick={event => this.sort(index)}>
                    <span>{header.label}</span>
                    <span style={{
                      visibility: header.sortDirection === 'none' ? 'hidden' : 'visible',
                      transform: `rotate(${
                        {asc: 45, desc: 225, none: 0}
                        [header.sortDirection || 'asc']}deg)`,
                    }}>
                      &#9700;
                    </span>

                  </div>
                </OverlayTrigger>
              </th>)}
            </tr>
          </thead>

          <tbody>
            {_data.map((row: any[], rowIndex: number) =>
              (!(rowIndex >= (_page - 1) * _pageSize && rowIndex < _page * _pageSize) ? null :
              <tr key={rowIndex}>
                {_headers.map((header: DataGridHeader, columnIndex: number) =>
                  <td key={`${rowIndex}_${columnIndex}`}>
                    <span
                      className={header.callback ? 'callback-link' : ''}
                      onClick={ev => header.callback && header.callback(row[header.value], rowIndex)}>
                      {row[header.value].toLocaleString()}
                    </span>
                  </td>
                )}
              </tr>
            ))}
          </tbody>
        </table>
        {
          _data.length > _pageSize &&
          <div className="margin-top pagination-container">
            <div className="pagination-select-container">
              <div style={{marginRight: '100px'}}>
                {'Show '}
                <select value={_pageSize} onChange={event => this.setPageSize(+event.target.value)}>
                  <option value={25}>25</option>
                  <option value={50}>50</option>
                  <option value={100}>100</option>
                  <option value={150}>150</option>
                  <option value={200}>200</option>
                  <option value={250}>250</option>
                  <option value={300}>300</option>
                </select>

                {` out of `}
                <b>{_data && _data.length}</b>
                {` entries`}
              </div>

              <Pagination
                bsSize="small"
                items={Math.ceil(_data.length/_pageSize)}
                activePage={_page}
                onSelect={(page: any) => this.setPage(page as number)}
                boundaryLinks={true}
                ellipsis={true}
                maxButtons={5}
                prev
                next
              />
            </div>

          </div>
        }

      </div>
    );
  }
}