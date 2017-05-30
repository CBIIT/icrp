/** @flow */
import orderBy from 'lodash/orderBy';
import some from 'lodash/some';
import type {SortBy, AppData, Value, Filters} from './types';

export function sort({prop, order}: SortBy, data: AppData) {
  let datareturn = orderBy(
    data,
    row => {
      let item = row[prop];

      if (item === undefined) {
        console.log('undefined for ', prop, 'in ', row);
      }

      return isNaN(row[prop])
        ? row[prop].toString().toLowerCase()
        : row[prop]
    }
,
      order === 'descending' ? 'desc' : 'asc');

    let ind = 1;
    for (let item of datareturn) {
        item['index'] = ind;
        ind += 1;
    }
  return datareturn;
}

export function filter(filters: Filters, filterValues, data: AppData) {
  const filterAndVals = {};
  for (let key in filterValues) {
   if (filterValues.hasOwnProperty(key)) {
    filterAndVals[key] = {
      value: filterValues[key],
      filter: filters[key].filter,
      prop: filters[key].prop,
    };
   }
  }

  return data.filter((row) => some(
    filterAndVals,
    ({filter, value, prop}) =>
      !prop ? some(row, filter.bind(null, value)) : filter(value, row.key)
  ));
}

export function containsIgnoreCase(a: Value, b: Value) {
  a = String(a).toLowerCase().trim();
  b = String(b).toLowerCase().trim();
  return b.indexOf(a) >= 0;
}
