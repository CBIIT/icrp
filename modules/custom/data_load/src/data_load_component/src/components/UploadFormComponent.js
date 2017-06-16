import React, { Component } from 'react';

import {
    Form,
    Button,
    Col,
    Panel,
    FormGroup,
    Radio,
    ControlLabel,
    FormControl,
    ButtonToolbar,
    HelpBlock
} from 'react-bootstrap';
import DatePicker from 'react-datepicker';
import moment from 'moment';
const uuidV4 = require('uuid/v4');

class UploadFormComponent extends Component {

    constructor(props) {
        super(props);

        this.upload = this.upload.bind(this);
        this.updateSubmissionEnabled = this.updateSubmissionEnabled.bind(this);
        this.validateInput = this.validateInput.bind(this);
        this.handleSubmissionDateChange = this.handleSubmissionDateChange.bind(this);
        this.handleInputChange = this.handleInputChange.bind(this);
        this.handleReset = this.handleReset.bind(this);
        this.updateParent = this.updateParent.bind(this);
        this.resetParent = this.resetParent.bind(this);
        this.state = { uploadType: 'new', sponsorCode: '', sponsorCodeValid: true, submissionDate: '', submissionDateValid: true, submitDisabled: true }
    }

    /** Sends the response up to the parent */
    updateParent(stats, columns, projects) {
        this.props.onFileUploadSuccess(stats, columns, projects);
    }

    resetParent() {
        this.props.onReset();
    }

    /** Submission date change handler */
    async handleSubmissionDateChange(date) {
        await this.setState({ submissionDate: date });
        await this.validateInput('submissionDate');
        this.updateSubmissionEnabled();
    }

    /** Generic input change handler */
    async handleInputChange(event) {
        const target = event.target;
        const type = target.type;
        var value = '';
        switch (type) {
            case 'file':
                value = target.files[0];
                break;
            case 'checkbox':
                value = target.checked;
                break;
            default:
                value = target.value;
        }
        const name = target.name;
        await this.setState({ [name]: value });
        await this.validateInput(name);
        this.updateSubmissionEnabled();
    }

    /** Input validator function */
    validateInput(name) {
        switch (name) {
            case 'sponsorCode':
                this.setState({ sponsorCodeValid: (this.state.sponsorCode && this.state.sponsorCode.length <= 25) || false });
                break;
            case 'submissionDate':
                this.setState({ submissionDateValid: (this.state.submissionDate && this.state.submissionDate <= moment()) || false });
                break;
            default:

        }
    }

    /** Enables/Disables form submission */
    updateSubmissionEnabled() {
        if (this.state.uploadType && this.state.sponsorCode && this.state.sponsorCodeValid && this.state.fileId && this.state.submissionDate && this.state.submissionDateValid) {
            this.setState({ submitDisabled: false });
        } else {
            this.setState({ submitDisabled: true });
        }
    }

    /** Resets the form */
    handleReset() {
        this.setState({ uploadType: 'new', sponsorCode: '', sponsorCodeValid: true, submissionDate: '', submissionDateValid: true, fileId: '', submitDisabled: true });
        document.getElementById("fileId").value = null;
        this.resetParent();
    }

    /** Form upload */
    async upload() {
        this.props.onLoadingStart();
        var data = new FormData();
        var fileData = this.state.fileId;// document.getElementById("fileId").files[0];
        data.append("data", fileData, uuidV4() + '.csv');
        data.append("uploadType", this.state.uploadType);
        var that = this;
        let response = await fetch('http://icrp-dataload/loaddata_mssql/', { method: 'POST', body: data });

        if (response.ok) {
            let result = await response.json();
            const totalRows = result.rowCount;
            const columns = result.columns;
            const projects = result.projects;
            const totalPages = Math.ceil(totalRows / 25);

            const stats = {
                totalRows: totalRows,

                totalPages: totalPages,
                showingFrom: 1,
                showingTo: 25
            }
            that.updateParent(stats, columns, projects);
        } else {
            // response.status, response.statusText
            let message = await response.text();
            alert("Oops! " + message);
        }
    }

    render() {
        return (
            <Panel onClick={this.handleClick}>
                <Form horizontal>
                    {/* Left Panel */}
                    <Col lg={4} md={5} xs={12}>
                        <FormGroup>
                            {/*Upload Type*/}
                            <Col componentClass={ControlLabel} xs={4}>
                                Upload Type
                          </Col>

                            <Col xs={8}>
                                <Radio name="uploadType" inline value="new" onChange={this.handleInputChange} checked={this.state.uploadType === 'new'}>New</Radio>
                                {' '}
                                <Radio name="uploadType" inline value="update" onChange={this.handleInputChange} checked={this.state.uploadType === 'update'}>Update</Radio>
                            </Col>
                        </FormGroup>

                        <FormGroup validationState={this.state.sponsorCodeValid ? null : 'error'}>
                            {/* Sponsor Code */}
                            <Col componentClass={ControlLabel} xs={4}>
                                Sponsor Code
                        </Col>
                            <Col xs={8}>
                                <FormControl type="text" name="sponsorCode" placeholder="Enter sponsor code" value={this.state.sponsorCode} onChange={this.handleInputChange} />
                                {!this.state.sponsorCodeValid ? <HelpBlock>Sponsor Code is required and must be &le; 25 characters</HelpBlock> : null}
                            </Col>

                        </FormGroup>
                    </Col>

                    {/* Middle Panel */}
                    <Col lg={6} md={7} xs={12} className="responsive-border">
                        <FormGroup>
                            {/*Workbook selector*/}
                            <Col componentClass={ControlLabel} xs={4}>
                                Workbook File (.csv)
                        </Col>
                            <Col xs={8}>
                                <FormControl id="fileId" name="fileId" type="file" className="control-label" onChange={this.handleInputChange} />
                            </Col>
                        </FormGroup>

                        <FormGroup validationState={this.state.submissionDateValid ? null : 'error'}>
                            {/* Submission Date */}
                            <Col componentClass={ControlLabel} xs={4}>
                                Submission Date
                        </Col>
                            <Col xs={8}>
                                <DatePicker
                                    selected={this.state.submissionDate}
                                    onChange={this.handleSubmissionDateChange}
                                    placeholderText="Click to select a date"
                                />
                                {!this.state.submissionDateValid ? <HelpBlock>Submission Date must be &le; today's date</HelpBlock> : null}

                            </Col>
                        </FormGroup>
                    </Col>

                    {/* Right Panel */}
                    <Col lg={2} xs={12} className="responsive-border-right">
                        <FormGroup className="lower-buttons-45">
                            <Col lg={12} lgOffset={0} md={3} mdOffset={4} xs={8} xsOffset={4}>
                                <ButtonToolbar>
                                    <Button onClick={this.upload} disabled={this.state.submitDisabled}>Load</Button>
                                    <Button onClick={this.handleReset}>Reset</Button>
                                </ButtonToolbar>
                            </Col>
                        </FormGroup>
                    </Col>
                </Form>

            </Panel>
        );
    }
}

export default UploadFormComponent;