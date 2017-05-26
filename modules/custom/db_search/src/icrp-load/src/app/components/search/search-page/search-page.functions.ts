export function getSearchID() {
  let query: any = parseQuery(window.location.search);
  return (query && query.sid) || null;
}


export function parseQuery(queryString: string) {
  return (queryString[0] === '?' ? queryString.substring(1) : queryString)
    .split('&')
    .map(q => q.split('='))
    .reduce((acc, curr) => {
      acc[curr[0]] = curr[1];
      return acc;
    }, {});
}

export function range(start, end, step = 1) {
  let r = [];

  for (var i = start; i < end || i > end && step < 0; i += step)
    r.push(i);

  return r;
}

export function asLabelValuePair(obj) {
  return {
    label: obj.toString(),
    value: obj
  }
}

export function deepCopy(obj) {
  return JSON.parse(JSON.stringify(obj));
}

export function removeEmptyProperties(obj) {
  let object = {};

  for (let key in obj) {
    if (obj[key] != null)
      object[key] = deepCopy(obj[key]);
  }

  return object;
}