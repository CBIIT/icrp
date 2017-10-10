import React, {
  Component
} from 'react';
import enableResizableColumns from './EnableResizableColumns';

class DataTable extends Component {

  state = {
    collapsed: true
  };

  /** @type {any[]} */
  data = [];

  /** @type {{'label': string, 'value': string|number, 'link'?: string}[]} */
  columns = [];

  componentDidMount() {
    enableResizableColumns(this.refs.table);
    window['jQuery']('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    })
  }

  render() {
    return (
      <div>
        <div className='table-responsive'>
          <table ref='table' className='table table-bordered table-striped table-condensed table-hover table-narrow table-nowrap'>
            <thead>
              <tr>
                {
                  this.props.columns.map((column, columnIndex) =>
                    <th key={columnIndex} title={column.tooltip} data-toggle='tooltip' data-placement='top'>
                      <span>{column.label}</span>
                    </th>
                  )
                }
              </tr>
            </thead>
            <tbody>
            {
              this.props.data
              .filter((row, rowIndex) =>
                !this.state.collapsed ||
                (this.state.collapsed && rowIndex < this.props.limit))
              .map((row, rowIndex) =>
                <tr key={rowIndex}>
                {
                  this.props.columns.map((column, columnIndex) =>
                  <td key={columnIndex}>
                    <span>
                    {
                      (
                        row[column.link]
                        ? <a href={ row[column.link] } target={ column.external ? '_blank' : '_self' }  >
                            { row[column.value] }
                          </a>
                        : row[column.value]
                      ) || ''
                    }
                    {
                      column.imageSrc && row[column[column.imageFlag]]
                      ? <img style={{marginLeft: 4}} src={column.imageSrc} alt="ORCID logo" />
                      : null
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

        {
          this.props.data.length > this.props.limit &&
          <div className='form-group'>
            <button className='btn btn-default btn-sm'
              onClick={ e => {
                  this.setState({collapsed: !this.state.collapsed});
                  window.setTimeout(f => enableResizableColumns(this.refs.table), 0);
              }}>
              { this.state.collapsed
              ? 'Show All'
              : 'Show Less' }
            </button>
          </div>
        }
      </div>
    );
  }
}

export default DataTable;