

/**
 * Sets the styles of an element
 * @function setStyles
 * @param {HTMLElement} el The element to apply the styles to
 * @param {Object} styles An object where keys and values correspond to properties and declarations
 */
function setStyles(el, styles) {
  for(let key in styles) {
    if (key && styles[key]) {
      el.style[key] = styles[key];
    }
  }
}

/**
 * Creates a div to be used as a resize handle
 * @function createHandle
 * @return {HTMLDivElement} A div used as a resize handle
 */
function createHandle() {
  /** @type {HTMLDivElement} */
  let handle = document.createElement('div');

  setStyles(handle, {
    position: 'absolute',
    width: '7px',
    marginLeft: '-2px',
    zIndex: '2',
    cursor: 'ew-resize',
  })
  
  return handle;
}

/**
 * Aligns resize handles to table column headers
 * @param {HTMLTableElement} table The target html table
 * @param {HTMLDivElement} overlay The overlay element containing resize handles
 */
function updateHandlePositions(table, overlay) {

  /** @type {HTMLCollection} */
  let handles = overlay.children;

  /** @type {HTMLCollectionOf<HTMLTableCellElement} */
  let headers = table.tHead.children[0].children;

  // only apply these changes to inner resize handlers
  for (let i = 0; i < headers.length - 1; i++) {
    
    /** @type {HTMLTableCellElement} */
    let header = headers[i];

    /** @type {HTMLDivElement} */
    let handle = handles[i] || overlay.appendChild(createHandle());

    /** @type number */
    let offset = header.offsetLeft + header.clientWidth;
    
    // apply the correct offset to each handle
    setStyles(handle, {
      left: offset + 'px',
      height: table.clientHeight + 'px'
    });
  }

  overlay.style.width = table.clientWidth + 'px';
}


/**
 * Sets the width of an element
 * @param {HTMLElement} el The element to apply the width to
 * @param {number} width The new width of the element
 */
function setWidth(el, width) {

  /** @type {{ width: string, maxWidth: string, minWidth: string }} */
  let styles = {
    width: width + 'px',
    maxWidth: width + 'px',
    minWidth: width + 'px',
  }

  setStyles(el, styles);
}

/**
 * Sets the width of a table column
 * @param {HTMLTableElement} table The target html table
 * @param {number} column The index of the column to resize
 * @param {number} width The new width of the column
 */
function setColumnWidth(table, column, width) {

  // sets the width of the header element of the column
  setWidth(table.tHead.children[0].children[column], width);

  /** @type {HTMLCollectionOf<HTMLTableRowElement>} */
  let rows = table.tBodies[0].children;

  // sets the width of the appropriate cell in each row
  Array.from(rows).forEach(row => setWidth(row.children[column], width));
}


/**
 * Sets the width of each column to its clientWidth
 * @param {HTMLTableElement} table The target html table
 */
function initializeColumnWidths(table) {

  /** @type {HTMLCollectionOf<HTMLTableCellElement>} */
  let headers = table.tHead.children[0].children;
  
  // sets the width of each table column
  for (let k = 0; k < headers.length; k ++) {
    setColumnWidth(table, k, headers[k].clientWidth);
  }
}

/**
 * Enables resizable columns on an HTML table element
 * @param {HTMLTableElement} table The target html table
 */
export default function enableResizableColumns(table) {

  // initialize the width of the table
  initializeColumnWidths(table);

  // sets the initial resize state
  let state = {
    resizing: false,
    initial: {
      cursorOffset: null,
      leftColumnIndex: null,
      leftCellWidth: null,
      rightCellWidth: null,
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

    let leftEl = table.tHead.children[0].children[index];
    let rightEl = table.tHead.children[0].children[index + 1];
    let leftColumnIndex = +handle.dataset.index;
    let leftCellWidth = leftEl.clientWidth;
    let rightCellWidth = rightEl.clientWidth;

    state = {
      resizing: true,
      initial: {
        cursorOffset: e.pageX,
        leftColumnIndex: leftColumnIndex,
        leftCellWidth: leftCellWidth,
        rightCellWidth: rightCellWidth
      },
    }
  }

  // mousemove events will update column sizes
  document.onmousemove = e => {
    if (state.resizing) {
      let offset = e.pageX - state.initial.cursorOffset;
      let index = state.initial.leftColumnIndex;

      let leftCellWidth = state.initial.leftCellWidth + offset + 1;
      let rightCellWidth = state.initial.rightCellWidth - offset + 1;
      
      if (leftCellWidth > 15 && rightCellWidth > 15) {
        setColumnWidth(table, index, leftCellWidth);
        setColumnWidth(table, index + 1, rightCellWidth);
      }

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