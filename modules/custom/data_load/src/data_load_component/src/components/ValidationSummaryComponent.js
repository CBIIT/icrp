import React, { Component } from 'react';
import {
    ListGroup,
    Modal,
    Button
} from 'react-bootstrap';
import ListGroupItemComponent from './ListGroupItemComponent';
import DataTableComponent from './DataTableComponent';

class ValidationSummaryComponent extends Component {

    constructor(props) {
        super(props);
        this.state = { showModal: false };
        this.closeModal = this.closeModal.bind(this);
        this.openModal = this.openModal.bind(this);
        this.updateParent = this.updateParent.bind(this);
    }

    closeModal() {
        this.setState({ showModal: false, modalDetails: [] });
    }

    updateParent(validationDetailsResults) {
        this.props.onValidationDetailsResults(validationDetailsResults);
    }

    async openModal(ruleId) {
        // this.props.onLoadingStart();
        var data = new FormData();
        data.append('ruleId', ruleId);
        var that = this;
        let response = await fetch('http://icrp-dataload/dataload/integrity_check_details_mssql/', { method: 'POST', body: data });
        // this.props.onLoadingEnd();

        if (response.ok) {
            let results = await response.json();
            // filter result type Summary
            // results = results['results'].filter(result =>
            // { return result.Type === 'Rule'; }).map(result => {
            //     return { name: result.Description, validationResult: (parseInt(result.Count, 10) === 0 ? 'Pass' : 'Failed') };
            // });

            // that.updateParent(results['results']);

            await that.setState({ modalDetails: results['results'] });
            // that.updateParent(results);
            // that.props.onLoadingEnd();
            that.setState({ showModal: true });
        } else {
            let message = await response.text();
            alert("Oops! " + message);
        }
    }

    render() {
        debugger;
        if (this.props.validationResults.length === 0)
            return null;

        let validationResults = [];
        let ruleId = 0;
        this.props.validationResults.forEach(result => {
            const _bsStyle = result.validationResult === 'Failed' ? "danger" : "default";
            validationResults.push(
                <ListGroupItemComponent bsStyle={_bsStyle} result={result} ruleId={++ruleId} clickHandler={this.openModal} />
            )
        });
        
        // let showModal = this.props.validationDetailsResults.length !== 0 ? true : false;

        return (

            <div>
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