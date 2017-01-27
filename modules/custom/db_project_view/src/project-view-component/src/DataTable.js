import React, { Component } from 'react';

class DataTable extends Component {

  state = {
    collapsed: true
  };

  refs = {

  };

  /** @type {any[]} */
  data = [];

  /** @type {{'label': string, 'value': string|number, 'link'?: string}[]} */
  columns = [];

  enableResizableColumns(table, tableResizeOverlay) {

    let state = {
      resizing: false,
      handles: [],

      width: table.clientWidth - 1,
      height: table.clientHeight,

      initial: {
        cursorOffset: null,
        tableWidth: null,
        cellWidth: null,
        columnIndex: null,
        handleOffsets: [],
      },
    }

    // initialize resize overlay
    tableResizeOverlay.style.width = `${state.width}px`;
    table.style.width = `${state.width}px`

    // populate overlay div with resize handles
    let headerRow = table.tHead.children[0];

    for (var i = 0; i < headerRow.children.length; ++i) {

      let th = headerRow.children[i];
      th.style.width = `${th.clientWidth}px`;

      // create a handle for each table header
      let handle = document.createElement('div');
      handle.style.position = 'absolute';
      handle.style.left = `${th.offsetLeft + th.clientWidth}px`;
      handle.style.height = `${state.height}px`;
      handle.style.width = '7px';
      
      handle.style.cursor = 'ew-resize';
      handle.style.marginLeft = '-3px';
      handle.style.zIndex = '2';
      handle.dataset.index = i;
      state.handles.push(handle);

      // mousedown events will start the resize event
      handle.onmousedown = e => {
        state.resizing = true;
        state.initial.cursorOffset = e.pageX;
        state.initial.tableWidth = table.clientWidth;        
        state.initial.cellWidth = th.clientWidth;
        state.initial.columnIndex = handle.dataset.index;
        state.initial.handleOffsets = state.handles.map(handle => handle.offsetLeft)
        handle.focus()
      };

      // mousemove events will resize table headers
      document.onmousemove = e => {
        if (state.resizing) {
          let index = state.initial.columnIndex;
          let offset = e.pageX - state.initial.cursorOffset;

          let cell = headerRow.children[index];
          cell.style.width = `${state.initial.cellWidth + offset}px`

          let width = state.initial.tableWidth + offset;
          state.width = `${width}px`
          table.style.width = `${width}px`
          tableResizeOverlay.style.width = `${width}px`

          for (let j = 0; j < state.handles.length; j ++) {
            let header = headerRow.children[j];
            let handleOffset = header.offsetLeft + header.clientWidth;
            state.handles[j].style.left = `${handleOffset}px`;
          }
        }
      }

      // mouseup events will stop resizing
      document.onmouseup = e => {
        state.resizing = false;
      }


      tableResizeOverlay.appendChild(handle);
    }
  }

  componentDidMount() {
    this.enableResizableColumns(this.refs.table, this.refs.tableResizeOverlay);
  }

  render() {
    return (
      <div>
        <div className='table-responsive'>
          <div ref='tableResizeOverlay'  style={{ position: 'relative', zIndex: 2, height: '100%' }} />
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
              {this.props.data.map((row, rowIndex) =>
                (
                  !this.state.collapsed ||
                  (this.state.collapsed && rowIndex < this.props.limit) 
                ) &&
                <tr key={rowIndex}>
                  {this.props.columns.map((column, columnIndex) => 
                    <td key={columnIndex}>
                      <span>
                      {
                        (
                          row[column.link]
                          ? <a href={row[column.link]} target='_blank'>
                              { row[column.value] }
                            </a>
                          : row[column.value]
                        ) || ''
                      }
                      </span>
                    </td>
                  )}
                </tr>)}
            </tbody>
          </table>
          {/* window['enableResizableTableColumns']() */}
          { window['enableTooltips']() }
        </div>
        
        {this.props.data.length > this.props.limit &&
        <div className='form-group'>
          <button className='btn btn-default btn-sm'
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