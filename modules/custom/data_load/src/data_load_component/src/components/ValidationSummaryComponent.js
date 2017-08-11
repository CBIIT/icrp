import React, { Component } from 'react';
import {
    ListGroup,
    Modal,
    Button
} from 'react-bootstrap';
import ListGroupItemComponent from './ListGroupItemComponent';
import DataTableComponent from './DataTableComponent';
import Spinner from './SpinnerComponent';
import PanelHeader from './PanelHeader';
import { ListGroupItem, Row, Col, Collapse } from 'react-bootstrap';

const SummaryItem = ({ object }) =>
    <ListGroupItem>
        <Row className="standard-font-size">
            <Col xs={6}>{object.name}</Col>
            <Col xs={2}>{object.count.toLocaleString()}</Col>
        </Row>
    </ListGroupItem>

class ValidationSummaryComponent extends Component {

    constructor(props) {
        super(props);
        this.state = { showModal: false, loading: false };
        this.closeModal = this.closeModal.bind(this);
        this.openModal = this.openModal.bind(this);
    }

    closeModal() {
        this.setState({ showModal: false, modalDetails: [] });
    }

    async openModal(ruleId, ruleName, failureCount) {
        this.setState({ loading: true });
        var data = new FormData();
        data.append('ruleId', ruleId);
        data.append('partnerCode', this.props.sponsorCode);
        var that = this;
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/integrity_check_details_mssql';
        if (hostname === 'localhost') {
            protocol = 'http:';
            hostname = 'icrp-dataload';
        }

        let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'POST', body: data, credentials: 'same-origin' });

        if (response.ok) {
            let results = await response.json();
            that.setState({ modalDetails: results['results'], modalRule: ruleName, modalFailureCount: failureCount, loading: false, showModal: true });
        } else {
            let message = await response.text();
            alert("Oops! " + message);
        }
    }

    render() {

        let validationRules = this.props.validationRules;

        let validationSummary = [];
        this.props.validationResults.filter(result => result.id === '0').forEach(result => {
            validationSummary.push(
                <SummaryItem object={result} />
            )
        });
        let validationResults = [];
        this.props.validationResults.filter(result => result.id !== '0').forEach(result => {
            const resultId = parseInt(result.id, 10);
            const validationRule = validationRules.find(rule => rule.id === resultId);
            const isChecked = validationRule.checked;
            const isActive = validationRule.active;

            if (isChecked && isActive) {
                let validationResult = result.validationResult;
                const validationStyle = validationResult === 'Failed' ? "danger-list-item" : "success-list-item";
                validationResults.push(
                    <ListGroupItemComponent validationStyle={validationStyle} result={result} ruleId={resultId} clickHandler={this.openModal} />
                )
            }
        });

        return (

            <div>
                <Spinner message="Loading Details..." visible={this.state.loading} />

                <PanelHeader
                    onClick={this.props.summaryToggleHandler}
                    title="Data Integrity Check Summary"
                    isOpen={this.props.openSummary}
                />
                <Collapse in={this.props.openSummary}>
                    <ListGroup>
                        {validationSummary}
                    </ListGroup>
                </Collapse>

                <PanelHeader
                    onClick={this.props.detailsToggleHandler}
                    title="Data Integrity Check Results"
                    isOpen={this.props.openDetails}
                    
                />
                <Collapse in={this.props.openDetails}>
                    <ListGroup>
                        {validationResults}
                    </ListGroup>
                </Collapse>

                <Modal show={this.state.showModal} onHide={this.closeModal} bsSize="large">
                    <Modal.Header closeButton>
                        <Modal.Title>Data Integrity Check Details</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        {this.state.modalRule} - <span className="red-text">{this.state.modalFailureCount} Failed</span>
                        <DataTableComponent details={this.state.modalDetails} />
                    </Modal.Body>
                    <Modal.Footer>
                        <Button onClick={this.closeModal}>Close</Button>
                    </Modal.Footer>
                </Modal>

            </div>
        );
    }
}

export default ValidationSummaryComponent;