import React, { Component } from 'react';
import { Button } from 'react-bootstrap';

class ButtonComponent extends Component {

  constructor(props) {
    super(props);
    this.state = {
      className: props.className,
      title: props.title,
      disabled: props.disabled
    }

    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    alert(this.state.title + ' button was clicked');
  }

  render() {
    return (
      <Button onClick={this.handleClick} disabled={this.props.disabled} className={this.props.className}>{this.props.title}</Button>
    );
  }
}

export default ButtonComponent;