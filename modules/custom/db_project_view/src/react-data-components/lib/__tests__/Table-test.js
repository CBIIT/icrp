'use strict';

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactAddonsTestUtils = require('react-addons-test-utils');

var _reactAddonsTestUtils2 = _interopRequireDefault(_reactAddonsTestUtils);

var _Table = require('../Table');

var _Table2 = _interopRequireDefault(_Table);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

describe('Table', function () {

  it('shows message when no data', function () {
    var columns = [{ title: 'Test', prop: 'test' }];
    var shallowRenderer = _reactAddonsTestUtils2.default.createRenderer();
    shallowRenderer.render(_react2.default.createElement(_Table2.default, {
      columns: columns,
      dataArray: [],
      keys: 'test'
    }));

    var result = shallowRenderer.getRenderOutput();

    expect(result.props.children[2]).toEqual(_react2.default.createElement(
      'tbody',
      null,
      _react2.default.createElement(
        'tr',
        null,
        _react2.default.createElement(
          'td',
          { colSpan: 1, className: 'text-center' },
          'No data'
        )
      )
    ));
  });

  it('render simple', function () {
    var columns = [{ title: 'Test', prop: 'test' }];
    var shallowRenderer = _reactAddonsTestUtils2.default.createRenderer();
    shallowRenderer.render(_react2.default.createElement(_Table2.default, {
      columns: columns,
      dataArray: [{ test: 'Foo' }],
      keys: 'test'
    }));

    var result = shallowRenderer.getRenderOutput();

    expect(result.props.children[2]).toEqual(_react2.default.createElement(
      'tbody',
      null,
      [_react2.default.createElement(
        'tr',
        { key: 'Foo', className: undefined },
        [_react2.default.createElement(
          'td',
          { key: 0, className: undefined },
          'Foo'
        )]
      )]
    ));
  });
});