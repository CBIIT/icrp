import React, { Component } from 'react';
import { Button } from 'react-bootstrap';

class ButtonComponent extends Component {

  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.props.clickHandler(this.props.nextTab);
  }

  render() {
    return (
      <Button onClick={this.handleClick} disabled={this.props.disabled} className={this.props.className}>{this.props.title}</Button>
    );
  }
}

export default ButtonComponent;