import React, { Component } from 'react';
import './DataTable.css'

class DataTable extends Component {

  /** @type {any[]} */
  data = [];

  /** @type {{"label": string, "value": string|number, "link"?: string}[]} */
  columns = [];

  render() {
    return (
      <table className="data-table">
        <thead>
          <tr>
            {this.props.columns.map((column, columnIndex) => 
              <th key={columnIndex}>{column.label}</th>
            )}
          </tr>
        </thead>
        <tbody>
          {this.props.data.map((row, rowIndex) =>
            <tr key={rowIndex}>
              {this.props.columns.map((column, columnIndex) => 
                <td key={columnIndex}>
                  {row[column.link]
                    ? <a href={row[column.link]} target="_blank">
                        {row[column.value]}
                      </a>
                    : row[column.value]}
                </td>
              )}
            </tr>)}
        </tbody>
      </table>
    );
  }    
}

export default DataTable;