import React, { Component } from 'react';

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
          <table className="table table-bordered table-striped table-condensed table-hover table-narrow table-nowrap">
            <thead>
              <tr>
                {
                  this.props.columns.map((column, columnIndex) => 
                    <th key={columnIndex} title={column.tooltip} data-toggle="tooltip" data-placement="top">{column.label}</th>
                  )
                }
              </tr>
            </thead>
            <tbody>
              {this.props.data.map((row, rowIndex) =>
                (
                  !this.state.collapsed ||
                  (this.state.collapsed && rowIndex < this.props.limit) 
                ) &&
                <tr key={rowIndex}>
                  {this.props.columns.map((column, columnIndex) => 
                    <td key={columnIndex}>
                      {
                        (
                          row[column.link]
                          ? <a href={row[column.link]} target="_blank">
                              { row[column.value] }
                            </a>
                          : row[column.value]
                        ) || ''
                      }
                    </td>
                  )}
                </tr>)}
            </tbody>
          </table>
          { window['enableResizableTableColumns']() }
          { window['enableTooltips']() }
        </div>
        
        {this.props.data.length > this.props.limit &&
        <div className="form-group">
          <button className="btn btn-default btn-sm"
            onClick={e => this.setState({collapsed: !this.state.collapsed})}>
            {this.state.collapsed
            ? 'Show All'
            : 'Show Less'}
          </button>
        </div>
        }  
      </div>
    );
  }    
}

export default DataTable;