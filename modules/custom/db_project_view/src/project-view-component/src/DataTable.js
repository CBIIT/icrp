import React, {
  Component
} from 'react';

class DataTable extends Component {

  state = {
    collapsed: true
  };

  /** @type {any[]} */
  data = [];

  /** @type {{'label': string, 'value': string|number, 'link'?: string}[]} */
  columns = [];

  enableResizableColumns(table) {

    let state = {
      resizing: false,
      handles: [],

      width: table.clientWidth - 2,
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
    let tableResizeOverlay = document.getElementById('table-resize-overlay') ||
      document.createElement('div');

    tableResizeOverlay.innerHTML = '';
    tableResizeOverlay.id = 'table-resize-overlay';
    tableResizeOverlay.style.position = 'relative';
    tableResizeOverlay.style.width = `${state.width}px`;

    table.style.width = `${state.width}px`;
    table.style.maxWidth = `${state.width}px`;
    table.parentElement.insertBefore(tableResizeOverlay, table);

    // populate overlay div with resize handles
    let headerRow = table.tHead.children[0];

    let resetHandlePositions = () => {

      tableResizeOverlay.style.width = `${state.width}px`

      for (let j = 0; j < state.handles.length; j++) {
        let header = headerRow.children[j];
        let handleOffset = header.offsetLeft + header.clientWidth;
        state.handles[j].style.left = `${handleOffset}px`;
        state.handles[j].style.height = `${state.height}px`;
      }
    }

    // mousemove events will resize table headers
    let startResizeEvent = e => {
      e.preventDefault();

      let handle = e.target;

      state.resizing = true;
      state.initial.cursorOffset = e.pageX;
      state.initial.tableWidth = table.clientWidth;
      state.initial.columnIndex = handle.dataset.index;
      state.initial.cellWidth = headerRow.children[handle.dataset.index].clientWidth;
      state.initial.handleOffsets = state.handles.map(handle => handle.offsetLeft)
    }

    // mousedown events will start the resize event
    let handleResizeEvent = e => {
      if (state.resizing) {
        let index = state.initial.columnIndex;
        let offset = e.pageX - state.initial.cursorOffset;

        let cell = headerRow.children[index];
        let cellWidth = state.initial.cellWidth + offset;

        cell.style.width = `${cellWidth}px`
        cell.style.maxWidth = `${cellWidth}px`

        let width = state.initial.tableWidth + offset;
        state.width = `${width}px`
        table.style.width = `${width}px`
        table.style.maxWidth = `${width}px`;
        tableResizeOverlay.style.width = `${width}px`
        resetHandlePositions();
      }
    }

    // mouseup events will stop resizing
    let endResizeEvent = e => {
//      e.preventDefault();

      console.log(state);

      if (state.resizing) {
        state.resizing = false;

        for (let i = 0; i < headerRow.children.length; i ++) {
//           let th of headerRow.children) {
          let th = headerRow.children[i];
          th.style.width = `${th.clientWidth + 1}px`;
        }

        resetHandlePositions();
      }
    }

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

      handle.onmousedown = startResizeEvent;
      document.onmouseup = endResizeEvent;
      document.onmousemove = handleResizeEvent

      tableResizeOverlay.appendChild(handle);
    }
  }

  componentDidMount() {
    this.enableResizableColumns(this.refs.table);
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
                        ? <a href={row[column.link]} target='_blank'>
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
        
        {
          this.props.data.length > this.props.limit &&
          <div className='form-group'>
            <button className='btn btn-default btn-sm'
              onClick={ e => {
                  this.setState({collapsed: !this.state.collapsed});
                  window.setTimeout(f => this.enableResizableColumns(this.refs.table), 0);
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