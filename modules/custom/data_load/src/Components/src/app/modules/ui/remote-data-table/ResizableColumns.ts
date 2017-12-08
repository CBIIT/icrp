
type StringMap = {[key: string]: string};

interface Configuration {
  preserveWidth: boolean;
}


/**
 * Sets the styles of an element
 * @function setStyles
 * @param {HTMLElement} el The element to apply the styles to
 * @param {Object} styles An object where keys and values correspond to properties and declarations
 */
function setStyles(el: HTMLElement, styles: StringMap) {
  for(let key in styles) {
    if (key && styles[key]) {
      el.style[key] = styles[key];
    }
  }
}


/**
 * Sets the width of an element
 * @param {HTMLElement} el The element to apply the width to
 * @param {number} width The new width of the element
 */
function setWidth(el: HTMLElement, width: number) {
  setStyles(el, {
    width: `${width}px`,
    maxWidth: `${width}px`,
    minWidth: `${width}px`,
  });
}

/**
 * Creates a div to be used as a resize handle
 * @function createHandle
 * @return {HTMLDivElement} A div used as a resize handle
 */
function createHandle() {
  let handle: HTMLDivElement = document.createElement('div');

  setStyles(handle, {
    position: 'absolute',
    width: '7px',
    marginLeft: '-2px',
    zIndex: '2',
    cursor: 'ew-resize',
  });

  return handle;
}

/**
 * Aligns resize handles to table column headers
 * @param {HTMLTableElement} table The target html table
 * @param {HTMLDivElement} overlay The overlay element containing resize handles
 */
function updateHandles(table: HTMLTableElement, overlay: HTMLDivElement, config?: Configuration) {
  let handles = overlay.children as HTMLCollectionOf<HTMLDivElement>;
  let headers = table.tHead.children[0].children as HTMLCollectionOf<HTMLTableHeaderCellElement>;

  for (let i = 0; i < headers.length - 1; i++) {
    let header: HTMLTableHeaderCellElement = headers[i];
    let handle: HTMLDivElement = handles[i] || overlay.appendChild(createHandle());

    // determine offset of handle relative to the left side of the nearest positioned parent (the table container)
    let offset: number = header.offsetLeft + header.clientWidth;

    // apply the correct offset to each handle
    setStyles(handle, {
      left: `${offset}px`,
      height: `${table.clientHeight}px`
    });
  }

  setStyles(overlay, {
    width: `${table.clientWidth}px`
  });
}



/**
 * Sets the width of a table column
 * @param {HTMLTableElement} table The target html table
 * @param {number} column The index of the column to resize
 * @param {number} width The new width of the column
 */
function setColumnWidth(table: HTMLTableElement, columnIndex: number, width: number) {

  // sets the width of the header element of the column
  setWidth(table.tHead.children[0].children[columnIndex] as HTMLElement, width);

  /** @type {HTMLCollectionOf<HTMLTableRowElement>} */
  let rows = table.tBodies[0].children;

  // sets the width of the appropriate cell in each row
  Array.from(rows).forEach((row: HTMLElement) =>
    setWidth(row.children[columnIndex] as HTMLElement, width));
}


/**
 * Sets the width of each column to its clientWidth
 * @param {HTMLTableElement} table The target html table
 */
function initializeColumnWidths(table: HTMLTableElement) {

  let headers = table.tHead.children[0].children as HTMLCollectionOf<HTMLTableHeaderCellElement>;

  // sets the width of each table column
  for (let i = 0; i < headers.length; i ++) {
    setColumnWidth(table, i, headers[i].clientWidth + 1);
  }
}

/**
 * Enables resizable columns on an HTML table element
 * @param {HTMLTableElement} table The target html table
 */
export function enableResizableColumns(table: HTMLTableElement, config?: Configuration) {

  // initialize the width of the table
  initializeColumnWidths(table);

  // sets the initial resize state
  let state = {
    resizing: false,
    initial: {
      tableWidth: 0,
      cursorOffset: null,
      leftColumnIndex: null,
      leftCellWidth: null,
      rightCellWidth: null,
    },
  };

  // initialize resize overlay
  let overlay = document.createElement('div');
  table.parentElement.insertBefore(overlay, table);

  setStyles(overlay, {
    position: 'relative',
    width: `${table.clientWidth - 2}px`
  });

  setWidth(table, table.clientWidth - 2);

  // populate overlay div with resize handles
  updateHandles(table, overlay, config);

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
    let tableWidth = table.clientWidth;

    state = {
      resizing: true,
      initial: {
        cursorOffset: e.pageX,
        leftColumnIndex: leftColumnIndex,
        leftCellWidth: leftCellWidth,
        rightCellWidth: rightCellWidth,
        tableWidth: tableWidth,
      },
    }
  }

  // mousemove events will update column sizes
  document.onmousemove = e => {
    if (state.resizing) {
      let offset = e.pageX - state.initial.cursorOffset;
      let index = state.initial.leftColumnIndex;

      let leftCellWidth = state.initial.leftCellWidth + offset + 1;

      // update the sizes of both columns
      if (config && config.preserveWidth) {
        let rightCellWidth = state.initial.rightCellWidth - offset + 1;

        if (leftCellWidth > 15 && rightCellWidth > 15) {
          setColumnWidth(table, index, leftCellWidth);
          setColumnWidth(table, index + 1, rightCellWidth);
        }
      }

      // only update the size of the left column
      else {
        if (leftCellWidth > 15) {
          setColumnWidth(table, index, leftCellWidth);
        }
        setWidth(table, state.initial.tableWidth + offset);
      }

      updateHandles(table, overlay);
    }
  }

  // mouseup events will stop resizing
  document.onmouseup = () => state.resizing = false;

  for (let i = 0; i < overlay.children.length; i ++) {
    overlay.children[i]['dataset'].index = (i).toString();
    overlay.children[i]['onmousedown'] = startResizing;
  }
};