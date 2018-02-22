(function () {
    /**
     * Sets the styles of an element
     * @function setStyles
     * @param {HTMLElement} el The element to apply the styles to
     * @param {Object} styles An object where keys and values correspond to properties and declarations
     */
    function setStyles(el, styles) {
        for (var key in styles) {
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
    function setWidth(el, width) {
        setStyles(el, {
            width: width + "px",
            maxWidth: width + "px",
            minWidth: width + "px"
        });
    }
    /**
     * Creates a div to be used as a resize handle
     * @function createHandle
     * @return {HTMLDivElement} A div used as a resize handle
     */
    function createHandle() {
        var handle = document.createElement('div');
        setStyles(handle, {
            position: 'absolute',
            width: '7px',
            marginLeft: '-2px',
            zIndex: '2',
            cursor: 'ew-resize'
        });
        return handle;
    }
    /**
     * Aligns resize handles to table column headers
     * @param {HTMLTableElement} table The target html table
     * @param {HTMLDivElement} overlay The overlay element containing resize handles
     */
    function updateHandles(table, overlay, config) {
        var handles = overlay.children;
        var headers = table.tHead.children[0].children;
        for (var i = 0; i < headers.length - 1; i++) {
            var header = headers[i];
            var handle = handles[i] || overlay.appendChild(createHandle());
            // determine offset of handle relative to the left side of the nearest
            // positioned parent (the table container)
            var offset = header.offsetLeft + header.clientWidth;
            // apply the correct offset to each handle
            setStyles(handle, {
                left: offset + "px",
                height: table.clientHeight + "px"
            });
        }
        setStyles(overlay, {
            width: table.clientWidth + "px"
        });
    }
    /**
     * Sets the width of a table column
     * @param {HTMLTableElement} table The target html table
     * @param {number} column The index of the column to resize
     * @param {number} width The new width of the column
     */
    function setColumnWidth(table, columnIndex, width) {
        // sets the width of the header element of the column
        setWidth(table.tHead.children[0].children[columnIndex], width);
        /** @type {HTMLCollectionOf<HTMLTableRowElement>} */
        var rows = table.tBodies[0].children;
        // sets the width of the appropriate cell in each row

        for (var i = 0; i < rows.length; i++)
            setWidth(rows[i].children[columnIndex], width);
        }
    /**
     * Sets the width of each column to its clientWidth
     * @param {HTMLTableElement} table The target html table
     */
    function initializeColumnWidths(table, config) {
        var headers = table.tHead.children[0].children;
        // sets the width of each table column
        for (var i = 0; i < headers.length; i++) {
            var columnWidth = headers[i].clientWidth + 1;
            setColumnWidth(table, i, columnWidth);
        }
    }
    function disableResizableColumns(table) {
        var parent = table.parentElement;
        var siblings = parent.children;
        for (var i = 0; i < siblings.length; i++) {
            if (siblings[i].getAttribute('data-type') === 'overlay') {
                parent.removeChild(siblings[i]);
            }
        }
    }

    /**
     * Enables resizable columns on an HTML table element
     * @param {HTMLTableElement} table The target html table
     */
    function enableResizableColumns(table, config) {
        // initialize the width of the table
        initializeColumnWidths(table, config);
        // sets the initial resize state
        var state = {
            resizing: false,
            initial: {
                tableWidth: 0,
                cursorOffset: null,
                leftColumnIndex: null,
                leftCellWidth: null,
                rightCellWidth: null
            }
        };
        // initialize resize overlay
        var overlay = document.createElement('div');
        overlay.setAttribute('data-type', 'overlay');
        table
            .parentElement
            .insertBefore(overlay, table);
        setStyles(overlay, {
            position: 'relative',
            width: table.clientWidth - 2 + "px"
        });
        setWidth(table, overlay.clientWidth);
        // populate overlay div with resize handles
        updateHandles(table, overlay, config);
        // mousedown events will start the resize event
        var startResizing = function (e) {
            e.preventDefault();
            var handle = e.target;
            var index = +handle.dataset.index;
            var leftEl = table.tHead.children[0].children[index];
            var rightEl = table.tHead.children[0].children[index + 1];
            var leftColumnIndex = +handle.dataset.index;
            var leftCellWidth = leftEl.clientWidth;
            var rightCellWidth = rightEl.clientWidth;
            var tableWidth = table.clientWidth;
            state = {
                resizing: true,
                initial: {
                    cursorOffset: e.pageX,
                    leftColumnIndex: leftColumnIndex,
                    leftCellWidth: leftCellWidth,
                    rightCellWidth: rightCellWidth,
                    tableWidth: tableWidth
                }
            };
        };
        // mousemove events will update column sizes
        document.onmousemove = function (e) {

            var dataTableConstant = 0;
            if (window.jQuery.fn.dataTable) {
                dataTableConstant = 27;
            }

            if (state.resizing) {
                var offset = e.pageX - state.initial.cursorOffset;
                var index = state.initial.leftColumnIndex;
                var leftCellWidth = state.initial.leftCellWidth + offset + 1;
                // update the sizes of both columns
                if (config && config.preserveWidth) {
                    var rightCellWidth = state.initial.rightCellWidth - offset + 1;
                    if (leftCellWidth > 15 && rightCellWidth > 15) {
                        setColumnWidth(table, index, leftCellWidth - dataTableConstant);
                        setColumnWidth(table, index + 1, rightCellWidth - dataTableConstant);
                    }
                } else {
                    if (leftCellWidth > 15) {
                        setColumnWidth(table, index, leftCellWidth - dataTableConstant);
                    }
                    setWidth(table, state.initial.tableWidth + offset);
                }
                updateHandles(table, overlay);
            }
        };
        // mouseup events will stop resizing
        document.onmouseup = function () {
            state.resizing = false
        };

        // ensure that handles are in correct positions
        table.onmouseover = function () {
            updateHandles(table, overlay)
        };
        var headers = table.querySelectorAll('th');
        for (var i = 0; i < headers.length; i++)
            headers[i].onmouseout = function () {
                updateHandles(table, overlay)
            };

        for (var i = 0; i < overlay.children.length; i++) {
            overlay.children[i]['dataset'].index = (i).toString();
            overlay.children[i]['onmousedown'] = startResizing;
        }
    }

    window.disableResizableColumns = disableResizableColumns;
    window.enableResizableColumns = enableResizableColumns;

    if (window.jQuery) {
        window.jQuery.fn.enableResizableColumns = function (config) {
            for (var i = 0; i < this.length; i++) {
                enableResizableColumns(this[i], config);
            }
        }

        window.jQuery.fn.disableResizableColumns = function () {
            for (var i = 0; i < this.length; i++) {
                disableResizableColumns(this[i]);
            }
        }
    }
})();
