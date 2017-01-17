import React, { Component } from 'react';
import './DataTable.css'

class DataTable extends Component {

  state = {
    collapsed: true
  };



  /** @type {any[]} */
  data = [];

  /** @type {{"label": string, "value": string|number, "link"?: string}[]} */
  columns = [];

  render() {
    return (
      <div>
        <div className="table-responsive">
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
                ((this.state.collapsed 
                  && rowIndex < this.props.limit) 
                  || !this.state.collapsed) 
                &&
                <tr key={rowIndex}>
                  {this.props.columns.map((column, columnIndex) => 
                    <td key={columnIndex}>
                      { (row[column.link]
                        ? <a href={row[column.link]} target="_blank">
                            {row[column.value]}
                          </a>
                        : row[column.value]) || 'Not Specified'}
                    </td>
                  )}
                </tr>)}
            </tbody>
          </table>
        </div>
        
        {this.props.data.length > this.props.limit &&
        <div className="text-center margin-top">
          <button className="btn btn-default"
            onClick={e => this.setState({collapsed: !this.state.collapsed})}>
            {this.state.collapsed
            ? 'Show All Projects'
            : 'Limit to Top 5 Projects'}
          </button>
        </div>
        }  
      </div>
    );
  }    
}

export default DataTable;