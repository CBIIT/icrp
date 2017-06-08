import React, { Component } from 'react';
import {
  Col,
  Row,
  ListGroup,
  ListGroupItem
} from 'react-bootstrap';

class ValidationSummaryComponent extends Component {

    render() {
        return (

            <div>
                <h3>Data Integrity Check Summary:</h3>

                <ListGroup>
                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Award Code</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>
                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Project Dates</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>
                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Budget Dates</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>

                    </ListGroupItem>
                    <ListGroupItem bsStyle="danger" onClick={this.validationFailed}>
                        <Row>
                            <Col xs={6}>Check CSO Codes / Relevances</Col>
                            <Col xs={2}>Failed</Col>
                            <Col xs={1}>Details</Col>
                        </Row>
                    </ListGroupItem>
                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Cancer Type Codes</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>

                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Cancer Type Codes</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>

                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Cancer Type Relevances</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>

                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check CSO Historical CSO Codes</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>

                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Award Types</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>

                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Annulized Values</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>

                    <ListGroupItem>
                        <Row>
                            <Col xs={6}>Check Funding Or</Col>
                            <Col xs={2}>Pass</Col>
                        </Row>
                    </ListGroupItem>
                </ListGroup>
            </div>
        );
    }
}

export default ValidationSummaryComponent;