import React, { Component } from 'react';
import { Tooltip, OverlayTrigger } from 'react-bootstrap'
import enableResizableColumns from './EnableResizableColumns'
import './DataTable.css'

class DataTable extends Component {

  constructor(props) {
    super(props);
    
    this.state = {
      columns: props.columns.slice(0),
      data: props.data.slice(0),
      sortAscending: props.columns.map(c => false),
      sortColumn: -1
    }
  }

  componentDidMount() {
    enableResizableColumns(this.refs.table);
  }

  sort(columnIndex) {
    let key = this.props.columns[+columnIndex].value;
    let sortAscending = this.state.sortAscending.slice(0);
    sortAscending[columnIndex] = !sortAscending[columnIndex];
    
    let sortAscFn = (a, b) =>
      isNaN(a[key]) || isNaN(b[key])
      ? a[key].localeCompare(b[key])
      : +a[key] - +b[key];

    let sortDescFn = (a, b) =>
      isNaN(a[key]) || isNaN(b[key])
      ? b[key].localeCompare(a[key])
      : +b[key] - +a[key];

    let sortedData = this.props.data.sort(
      sortAscending[columnIndex] ? sortAscFn : sortDescFn
    );

    this.setState({
      sortColumn: columnIndex,
      sortAscending: sortAscending,
      data: sortedData,
    });
  }


  tooltip(text) {
    return <Tooltip id={ text.split().join('-') }>{ text }</Tooltip>
  }

  sortArrow(isAscending) {
    let style = {
      display: 'inline-block',
      transform: isAscending ? 'rotate(-135deg)' : 'rotate(45deg)'
    }

    return <span className='pull-right' style={style}>&#9698;</span>
  }

  tableCell(contents, link) {
    return <div> {
      link 
      ? <a href={ link }>{ contents }</a>
      : contents || ''
    } </div>
  }


  render() {
    return (
      <div className='table-responsive noscroll'>
        <table ref='table' className='data-table table table-bordered table-striped table-condensed table-hover table-narrow table-nowrap'>
          <thead>
            <tr>
              {
                this.state.columns.map((column, columnIndex) => 
                  <th key={ columnIndex }>
                    <OverlayTrigger placement='top' overlay={this.tooltip(column.tooltip)}>                   
                      <div style={{cursor: 'pointer', display: 'flex', justifyContent: 'space-between'}} onClick={this.sort.bind(this, columnIndex)}>
                        { column.label }
                        { this.state.sortColumn === columnIndex && this.sortArrow(this.state.sortAscending[columnIndex]) }
                      </div>
                    </OverlayTrigger>
                  </th>
                )
              }
            </tr>
          </thead>
          <tbody>
          {
            this.state.data.map((row, rowIndex) =>
              <tr key={rowIndex}>
              {
                this.state.columns.map((column, columnIndex) => 
                <td key={columnIndex}>

                  { column.contentTooltip 
                    ? <OverlayTrigger placement='top' overlay={column.contentTooltip ? this.tooltip(row[column.value]) : <div />}>
                        { this.tableCell(row[column.value], row[column.link]) }
                      </OverlayTrigger>
                    : this.tableCell(row[column.value], row[column.link])
                  }
                </td>
                )
              }
              </tr>
            )
          }
          </tbody>
        </table>
      </div>
    );
  }
}

export default DataTable;