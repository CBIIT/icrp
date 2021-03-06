import React, {PropTypes, Component} from 'react';
import enableResizableColumns from './EnableResizableColumns';

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

  componentDidMount() {
    // If no width was specified, then set the width that the browser applied
    // initially to avoid recalculating width between pages.
    this._headers.forEach(header => {
      if (!header.style.width) {
        header.style.width = `${header.offsetWidth}px`;
      }
    });

    enableResizableColumns(this.refs.table);
    window['jQuery']('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    })
  }

  componentDidUpdate() {
    enableResizableColumns(this.refs.table);
    window['jQuery']('[data-toggle="tooltip"]').tooltip({
      container: 'body'
    })
  }

  
  sortArrow(isAscending) {
    let style = {
      display: 'inline-block',
      transform: isAscending ? 'rotate(-135deg)' : 'rotate(45deg)'
    }

    return <span style={style}>&#9698;</span>
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
          style={{width: col.width, whiteSpace: 'nowrap' }}
          role="columnheader"
          scope="col"
          {...sortProps}
          title={col.tooltip} 
          data-toggle='tooltip' 
          data-placement='top'>
          
          <div style={{cursor: 'pointer', display: 'flex', justifyContent: 'space-between'}}>
            <span style={{display: 'inline-block', paddingRight: '4px'}}>{col.title}</span>
            { ['ascending', 'descending'].indexOf(order) > -1 && this.sortArrow(order === 'ascending') }
          </div>
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
