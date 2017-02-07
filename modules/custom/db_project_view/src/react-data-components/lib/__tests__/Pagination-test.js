'use strict';

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _reactAddonsTestUtils = require('react-addons-test-utils');

var _reactAddonsTestUtils2 = _interopRequireDefault(_reactAddonsTestUtils);

var _Pagination = require('../Pagination');

var _Pagination2 = _interopRequireDefault(_Pagination);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

describe('Pagination', function () {

  var onChangePage = void 0;

  beforeEach(function () {
    onChangePage = jest.genMockFunction();
  });

  it('renders the correct buttons', function () {
    var showPages = 10;
    var currentPage = 5;
    var totalPages = 10;

    var shallowRenderer = _reactAddonsTestUtils2.default.createRenderer();
    shallowRenderer.render(_react2.default.createElement(_Pagination2.default, {
      totalPages: totalPages,
      currentPage: currentPage,
      onChangePage: onChangePage,
      showPages: showPages
    }));

    var result = shallowRenderer.getRenderOutput();

    // 4 buttons for first, prev, next and last
    expect(result.props.children.length).toBe(showPages + 4);
  });

  it('disables prev and first button when on first page', function () {
    var currentPage = 0;
    var totalPages = 10;

    var shallowRenderer = _reactAddonsTestUtils2.default.createRenderer();
    shallowRenderer.render(_react2.default.createElement(_Pagination2.default, {
      totalPages: totalPages,
      currentPage: currentPage,
      onChangePage: onChangePage
    }));

    var result = shallowRenderer.getRenderOutput();
    expect(result.props.children[0].props.className).toEqual('disabled');
    expect(result.props.children[1].props.className).toEqual('disabled');
    expect(onChangePage).not.toBeCalled();
  });

  it('disables next and last button when on last page', function () {
    var currentPage = 9;
    var totalPages = 10;

    var shallowRenderer = _reactAddonsTestUtils2.default.createRenderer();
    shallowRenderer.render(_react2.default.createElement(_Pagination2.default, {
      totalPages: totalPages,
      currentPage: currentPage,
      onChangePage: onChangePage
    }));

    var children = shallowRenderer.getRenderOutput().props.children;

    var totalChildren = children.length;

    expect(children[totalChildren - 2].props.className).toEqual('disabled');
    expect(children[totalChildren - 1].props.className).toEqual('disabled');
    expect(onChangePage).not.toBeCalled();
  });
});