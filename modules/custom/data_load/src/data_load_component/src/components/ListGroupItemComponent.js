import React, { Component } from 'react';
import { ListGroupItem, Row, Col } from 'react-bootstrap';

class ListGroupItemComponent extends Component {
    constructor(props) {
        super(props);
        this.handleClick = this.handleClick.bind(this);
    }


    handleClick() {
        this.props.clickHandler(this.props.ruleId);
    }

    render() {
        return (
            <ListGroupItem bsStyle={this.props.bsStyle} onClick={this.props.result.validationResult === 'Failed' ? this.handleClick : null}>
                <Row>
                    <Col xs={6}>{this.props.result.name}</Col>
                    <Col xs={2}>{this.props.result.validationResult}</Col>
                </Row>
            </ListGroupItem>
        );
    }

}

export default ListGroupItemComponent;