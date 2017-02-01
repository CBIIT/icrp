

function setStyles(el, styles) { 
  Object.keys(styles).forEach(
    key => el.style[key] = styles[key])
}

function createHandle() {
  let handle = document.createElement('div');

  handle.style.position = 'absolute';
  handle.style.width = '7px';
  handle.style.marginLeft = '-3px';
  handle.style.zIndex = '2';
  handle.style.cursor = 'ew-resize';
  return handle;
}

// aligns resize handle positions with table columns
function updateHandlePositions(table, overlay) {

  let handles = overlay.children;
  let headers = table.tHead.children[0].children;

  for (let i = 0; i < headers.length; i++) {
    let header = headers[i];
    let handle = handles[i] || overlay.appendChild(createHandle());
    let offset = header.offsetLeft + header.clientWidth;
    
    setStyles(handle, {
      left: offset + 'px',
      height: table.clientHeight + 'px'
    });
  }

  overlay.style.width = table.clientWidth + 'px';
}

function setWidth(el, width) {

  let style = {
    width: width + 'px',
    maxWidth: width + 'px',
    minWidth: width + 'px',
  }

  setStyles(el, style);
}

function setColumnWidth(table, columnIndex, width) {

  setWidth(table.tHead.children[0].children[columnIndex], width);

  let rows = table.tBodies[0].children;
  for (let i = 0; i < rows.length; i ++) {
    let row = rows[i];
    setWidth(row.children[columnIndex], width);
  }
}


function initializeColumnWidths(table) {

  let headers = table.tHead.children[0].children;  
  for (let k = 0; k < headers.length; k ++) {
    setColumnWidth(table, k, headers[k].clientWidth);
  }

  setWidth(table, table.clientWidth);
}


export default function enableResizableColumns(table) {

  // initialize the width of the table
  initializeColumnWidths(table);

  let state = {
    resizing: false,
    initial: {
      cursorOffset: null,
      tableWidth: null,
      cellWidth: null,
      columnIndex: null,
    },
  };

  // initialize resize overlay
  let overlay = 
    document.getElementById('table-resize-overlay') ||
    document.createElement('div');

  overlay.innerHTML = '';
  overlay.id = 'table-resize-overlay';
  table.parentElement.insertBefore(overlay, table);

  setStyles(overlay, {
    position: 'relative',
    width: state.width + 'px'
  });

  // populate overlay div with resize handles
  updateHandlePositions(table, overlay);

  // mousedown events will start the resize event
  let startResizing = e => {
    e.preventDefault();

    let handle = e.target;
    let index = +handle.dataset.index;
    let el = table.tHead.children[0].children[index];
    let style = window.getComputedStyle(el);
    let padding = parseInt(style.paddingLeft, 10) + parseInt(style.paddingRight, 10);
    let width = el.clientWidth - padding;

    setColumnWidth(table, index, width);
    updateHandlePositions(table, overlay);

    state = {
      resizing: true,
      initial: {
        cursorOffset: e.pageX,
        tableWidth: table.clientWidth,
        cellWidth: width,
        columnIndex: index
      },
    }
  }

  // mousemove events will update column sizes
  document.onmousemove = e => {
    if (state.resizing) {

      let offset = e.pageX - state.initial.cursorOffset;
      let cellWidth = state.initial.cellWidth + offset;
      let tableWidth = state.initial.tableWidth + offset;
      let index = state.initial.columnIndex;

      setColumnWidth(table, index, cellWidth);
      setWidth(table, tableWidth);
      setWidth(overlay, tableWidth);
      updateHandlePositions(table, overlay);
    }
  }

  // mouseup events will stop resizing
  document.onmouseup = () => state.resizing = false;

  for (let i = 0; i < overlay.children.length; i ++) {
    overlay.children[i].dataset.index = (i).toString();
    overlay.children[i].onmousedown = startResizing;
  }  
};