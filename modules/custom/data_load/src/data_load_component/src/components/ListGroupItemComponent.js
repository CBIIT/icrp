import React, { Component } from 'react';
import { ListGroupItem, Row, Col } from 'react-bootstrap';
import { bootstrapUtils } from 'react-bootstrap/lib/utils';

bootstrapUtils.addStyle(ListGroupItem, 'custom');

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
            <div>
                <style type="text/css">{`
                .list-group-item-custom {
                    background-color: white;
                    color: #3C763D;
                }
                `}</style>

                <ListGroupItem bsStyle={this.props.bsStyle} onClick={this.props.result.validationResult === 'Failed' ? this.handleClick : null}>
                    <Row>
                        <Col xs={6}>{this.props.result.name}</Col>
                        <Col xs={2} >{this.props.result.validationResult}</Col>
                    </Row>
                </ListGroupItem>
            </div>
        );
    }
}

export default ListGroupItemComponent;