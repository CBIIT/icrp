import React, {PropTypes, Component} from 'react';

const simpleGet = key => data => data[key];
const keyGetter = keys => data => keys.map(key => data[key]);

const isEmpty = value => value == null || value === '';

const getCellValue =
  ({prop, defaultContent, render}, row) =>
    // Return `defaultContent` if the value is empty.
    !isEmpty(prop) && isEmpty(row[prop]) ? defaultContent :
      // Use the render function for the value.
      render ? render(row[prop], row) :
      // Otherwise just return the value.
      row[prop];

const getCellClass =
  ({prop, className}, row) =>
    !isEmpty(prop) && isEmpty(row[prop]) ? 'empty-cell' :
      typeof className == 'function' ? className(row[prop], row) :
      className;

function buildSortProps(col, sortBy, onSort) {
  const order = sortBy && sortBy.prop === col.prop ? sortBy.order : 'none';
  const nextOrder = order === 'ascending' ? 'descending' : 'ascending';
  const sortEvent = onSort.bind(null, { prop: col.prop, order: nextOrder });

  return {
    'onClick': sortEvent,
    // Fire the sort event on enter.
    'onKeyDown': e => { if (e.keyCode === 13) sortEvent(); },
    // Prevents selection with mouse.
    'onMouseDown': e => e.preventDefault(),
    'tabIndex': 0,
    'aria-sort': order,
    'aria-label': `${col.title}: activate to sort column ${nextOrder}`,
  };
}

export default class Table extends Component {
  _headers = [];

  static propTypes = {
    keys: PropTypes.oneOfType([
      PropTypes.arrayOf(PropTypes.string),
      PropTypes.string,
    ]).isRequired,

    columns: PropTypes.arrayOf(PropTypes.shape({
      title: PropTypes.string.isRequired,
      tooltip: PropTypes.string.isRequired,
      prop: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.number,
      ]),
      render: PropTypes.func,
      sortable: PropTypes.bool,
      defaultContent: PropTypes.string,
      width: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.number,
      ]),
      className: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.func,
      ]),
    })).isRequired,

    dataArray: PropTypes.arrayOf(PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.object,
    ])).isRequired,

    buildRowOptions: PropTypes.func,

    sortBy: PropTypes.shape({
      prop: PropTypes.oneOfType([
        PropTypes.string,
        PropTypes.number,
      ]),
      order: PropTypes.oneOf([ 'ascending', 'descending' ]),
    }),

    onSort: PropTypes.func,
  };

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
    // If no width was specified, then set the width that the browser applied
    // initially to avoid recalculating width between pages.
    this._headers.forEach(header => {
      if (!header.style.width) {
        header.style.width = `${header.offsetWidth}px`;
      }
    });
    this.enableResizableColumns(this.refs.table);
    window['jQuery']('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    })
  }
  componentDidUpdate() {
    this.enableResizableColumns(this.refs.table);
    window['jQuery']('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    })
  }

  render() {
    const {
      columns, keys, buildRowOptions, sortBy,
      onSort, dataArray, ...otherProps,
    } = this.props;

    const headers = columns.map((col, idx) => {
      let sortProps, order;
      // Only add sorting events if the column has a property and is sortable.
      if (onSort && col.sortable !== false && 'prop' in col) {
        sortProps = buildSortProps(col, sortBy, onSort);
        order = sortProps['aria-sort'];
      }

      return (
        <th
          ref={c => this._headers[idx] = c}
          key={idx}
          style={{width: col.width}}
          role="columnheader"
          scope="col"
          {...sortProps}
          title={col.tooltip} 
          data-toggle='tooltip' 
          data-placement='top'>
          <span>{col.title}</span>
          {!order ? null :
            <span className={`sort-icon sort-${order}`} aria-hidden="true" />}
        </th>
      );
    });

    const getKeys = Array.isArray(keys) ? keyGetter(keys) : simpleGet(keys);
    const rows = dataArray.map(row => {
      const trProps = buildRowOptions ? buildRowOptions(row) : {};

      return (
        <tr key={getKeys(row)} {...trProps}>
          {columns.map((col, i) =>
            <td key={i} className={getCellClass(col, row)}>
              {getCellValue(col, row)}
            </td>
          )}
        </tr>
      );
    });

    return (
      <table ref='table' {...otherProps}>
        {!sortBy ? null :
          <caption className="sr-only" role="alert" aria-live="polite">
            {`Sorted by ${sortBy.prop}: ${sortBy.order} order`}
          </caption>}
        <thead>
          <tr>
            {headers}
          </tr>
        </thead>
        <tbody>
          {rows.length ? rows :
            <tr>
              <td colSpan={columns.length} className="text-center">No data</td>
            </tr>}
        </tbody>
      </table>
    );
  }

}
