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
        <Row>
            <Col xs={6}>{object.name}</Col>
            <Col xs={2}>{object.count}</Col>
        </Row>
    </ListGroupItem>

class ValidationSummaryComponent extends Component {

    constructor(props) {
        super(props);
        this.state = { showModal: false, loading: false, openSummary: false, openDetails: false };
        this.closeModal = this.closeModal.bind(this);
        this.openModal = this.openModal.bind(this);
    }

    closeModal() {
        this.setState({ showModal: false, modalDetails: [] });
    }

    updateParent(validationDetailsResults) {
        this.props.onValidationDetailsResults(validationDetailsResults);
    }

    async openModal(ruleId) {
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
            that.setState({ modalDetails: results['results'], loading: false, showModal: true });
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
            const isChecked = validationRules.find(rule => rule.id === resultId).checked;
            if (isChecked) {
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
                        onClick={() => this.setState({ openSummary: !this.state.openSummary })} 
                        title="Data Integrity Check Summary" 
                        isOpen={this.state.openSummary}
                />
                <Collapse in={this.state.openSummary}>
                    <ListGroup>
                        {validationSummary}
                    </ListGroup>
                </Collapse>

                <PanelHeader 
                        onClick={() => this.setState({ openDetails: !this.state.openDetails })} 
                        title="Data Integrity Check Results" 
                        isOpen={this.state.openDetails}
                />
                <Collapse in={this.state.openDetails}>
                    <ListGroup>
                        {validationResults}
                    </ListGroup>
                </Collapse>

                <Modal show={this.state.showModal} onHide={this.closeModal} bsSize="large">
                    <Modal.Header closeButton>
                        <Modal.Title>Details</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
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