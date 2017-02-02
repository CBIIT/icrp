import React, { Component } from 'react';
import enableResizableColumns from './EnableResizableColumns'
import './DataTable.css'

class DataTable extends Component {

  componentDidMount() {
    enableResizableColumns(this.refs.table);
  }

  render() {
    return (
      <div className='table-responsive'>
        <table ref='table' className='data-table table-nowrap'>
          <thead>
            <tr>
              {
                this.props.columns.map((column, columnIndex) => 
                  <th key={ columnIndex }>
                    { column.label }
                  </th>
                )
              }
            </tr>
          </thead>
          <tbody>
          {
            this.props.data.map((row, rowIndex) =>
              <tr key={rowIndex}>
              {
                this.props.columns.map((column, columnIndex) => 
                <td key={columnIndex}>
                  <span>
                  {
                    (
                      row[column.link]
                      ? <a href={row[column.link]}>
                          { row[column.value] }
                        </a>
                      : row[column.value]
                    ) || ''
                  }
                  </span>
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