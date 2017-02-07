'use strict';

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactDom = require('react-dom');

var _reactDom2 = _interopRequireDefault(_reactDom);

var _DataTable = require('./DataTable');

var _DataTable2 = _interopRequireDefault(_DataTable);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function buildTable(data) {
  var renderMapUrl = function renderMapUrl(val, row) {
    return _react2.default.createElement(
      'a',
      { href: 'https://www.google.com/maps?q=' + row['lat'] + ',' + row['long'] },
      'Google Maps'
    );
  };

  var tableColumns = [{ title: 'Name', prop: 'name' }, { title: 'City', prop: 'city' }, { title: 'Street address', prop: 'street' }, { title: 'Phone', prop: 'phone', defaultContent: '<no phone>' }, { title: 'Map', render: renderMapUrl, className: 'text-center' }];

  return _react2.default.createElement(_DataTable2.default, {
    className: 'container',
    keys: 'id',
    columns: tableColumns,
    initialData: data,
    initialPageLength: 5,
    initialSortBy: { prop: 'city', order: 'descending' },
    pageLengthOptions: [5, 20, 50]
  });
}

fetch('/data.json').then(function (res) {
  return res.json();
}).then(function (rows) {
  _reactDom2.default.render(buildTable(rows), document.getElementById('root'));
});