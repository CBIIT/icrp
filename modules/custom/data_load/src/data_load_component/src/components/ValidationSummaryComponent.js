import React, { Component } from 'react';
import {
    ListGroup,
    Modal,
    Button
} from 'react-bootstrap';
import ListGroupItemComponent from './ListGroupItemComponent';
import DataTableComponent from './DataTableComponent';
import Spinner from './SpinnerComponent'

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

    updateParent(validationDetailsResults) {
        this.props.onValidationDetailsResults(validationDetailsResults);
    }

    async openModal(ruleId) {
        this.setState({ loading: true });
        var data = new FormData();
        data.append('ruleId', ruleId);
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
        if (this.props.validationResults.length === 0)
            return null;

        let validationRules = this.props.validationRules;
        let validationResults = [];
        this.props.validationResults.forEach(result => {
            const resultId = parseInt(result.id, 10);
            const isChecked = validationRules.find(rule => rule.id === resultId).checked;
            if (isChecked) {
                let validationResult = result.validationResult;
                const _bsStyle = validationResult === 'Failed' ? "danger" : "default";
                validationResults.push(
                    <ListGroupItemComponent bsStyle={_bsStyle} result={result} ruleId={resultId} clickHandler={this.openModal} />
                )
            }
        });

        return (

            <div>
                <Spinner message="Loading Content..." visible={this.state.loading} />
                <h3>Data Integrity Check Summary:</h3>
                <ListGroup>
                    {validationResults}
                </ListGroup>

                <Modal show={this.state.showModal} onHide={this.closeModal}>
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