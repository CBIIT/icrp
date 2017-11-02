import React, { Component } from 'react';

import {
    Alert,
    Form,
    Button,
    Col,
    Panel,
    FormGroup,
    Radio,
    ControlLabel,
    FormControl,
    HelpBlock
} from 'react-bootstrap';
import Spinner from './SpinnerComponent';
import DatePicker from 'react-datepicker';
import moment from 'moment';
// import 'moment/locale/en-gb';

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
        this.state = {
            uploadType: 'New',
            sponsorCodes: [],
            sponsorCode: '',
            sponsorCodeValid: true,
            submissionDate: '',
            submissionDateValid: true,
            submitDisabled: true,
            loading: false,
            locales: [{ code: 'en-US', text: 'United States (mm/dd/yyyy)' }, { code: 'en-GB', text: 'United Kingdom (dd/mm/yyyy)' }],
            chosenLocale: 'en-US'
        }
        this.getSponsorCodes();
    }

    /** Sends the response up to the parent */
    updateParent(stats, columns, projects) {
        this.props.onFileUploadSuccess(stats, columns, projects, this.state.sponsorCode, this.state.uploadType, this.state.originalFileName, this.state.submissionDate.format("YYYY-MM-DD"));
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

    async getSponsorCodes() {
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/getSponsorCodes';
        if (hostname === 'localhost') {
            protocol = 'http:';
            //hostname = 'icrp-dataload';
        }
        let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'GET', credentials: 'same-origin' });

        this.setState({
            sponsorCodes: await response.json()
        });
    }

    /** Generic input change handler */
    async handleInputChange(event) {
        const target = event.target;
        const type = target.type;
        var value = '';
        switch (type) {
            case 'file':
                console.log(target.files[0].name);
                value = target.files[0];
                await this.setState({ originalFileName: target.files[0].name });
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
        this.setState({ uploadType: 'New', sponsorCode: '', sponsorCodeValid: true, submissionDate: '', submissionDateValid: true, fileId: '', submitDisabled: true, controlsDisabled: false, errorMessage: null, chosenLocale: 'en-US' });
        document.getElementById("fileId").value = null;
        this.resetParent();
    }

    /** Form upload */
    async upload() {
        this.props.onLoadingStart();
        this.setState({ loading: true });
        var data = new FormData();
        var fileData = this.state.fileId;
        data.append('data', fileData, uuidV4() + '.csv');
        data.append("originalFileName", this.state.originalFileName);
        data.append('uploadType', this.state.uploadType);
        data.append('sponsorCode', this.state.sponsorCode);
        data.append('locale', this.state.chosenLocale);
        var that = this;
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/loaddata_mssql';
        if (hostname === 'localhost') {
            protocol = 'http:';
            //hostname = 'icrp-dataload';
        }
        let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'POST', body: data, credentials: 'same-origin' });

        if (response.ok) {
            let result = await response.json();
            const totalRows = result.rowCount;
            const columns = result.columns;
            const projects = result.projects;
            const totalPages = Math.ceil(totalRows / 25);

            const stats = {
                totalRows: totalRows,
                totalPages: totalPages
            }
            that.setState({ controlsDisabled: true, submitDisabled: true, loading: false, errorMessage: null });
            that.updateParent(stats, columns, projects);
        } else {
            // response.status, response.statusText
            let message = await response.text();
            //that.handleReset();
            this.setState({ loading: false, errorMessage: message });
        }
    }

    render() {
        return (
            <div>
                {this.state.errorMessage &&
                    <Alert
                        bsStyle="danger"
                        onDismiss={ev => this.setState({ errorMessage: null })}>
                        {this.state.errorMessage}
                    </Alert>}
                <Spinner message="Loading Workbook..." visible={this.state.loading} />
                <Panel onClick={this.handleClick}>
                    <Form horizontal>
                        {/* Left Panel */}
                        <Col lg={3} xs={12}>
                            <FormGroup>
                                {/*Upload Type*/}
                                <Col componentClass={ControlLabel} xs={12} sm={4} lg={5}>
                                    <div className="no-wrap">Upload Type</div>
                                </Col>

                                <Col xs={12} sm={8} lg={7}>
                                    <Radio name="uploadType" inline value="New" onChange={this.handleInputChange} checked={this.state.uploadType === 'New'} disabled={this.state.controlsDisabled}>New</Radio>

                                    <Radio name="uploadType" inline value="Update" onChange={this.handleInputChange} checked={this.state.uploadType === 'Update'} disabled={true /*this.state.controlsDisabled*/}>Update</Radio>
                                </Col>
                            </FormGroup>

                            <FormGroup validationState={this.state.sponsorCodeValid ? null : 'error'}>
                                {/* Sponsor Code */}
                                <Col componentClass={ControlLabel} xs={12} sm={4} lg={5}>
                                    <div className="no-wrap">Sponsor Code <span className="red-text">*</span></div>
                                </Col>
                                <Col xs={12} sm={8} lg={7}>
                                    <FormControl
                                        name="sponsorCode"
                                        title="Please select a sponsor code in the list"
                                        componentClass="select"
                                        value={this.state.sponsorCode}
                                        onChange={this.handleInputChange}
                                        disabled={this.state.controlsDisabled}
                                        required
                                        className="small-padding-right">
                                        <option value="" disabled hidden>Sponsor code</option>
                                        {
                                            this.state.sponsorCodes.map(code => <option value={code}>{code}</option>)
                                        }
                                    </FormControl>

                                    {!this.state.sponsorCodeValid ? <HelpBlock>Sponsor Code is required.</HelpBlock> : null}
                                </Col>

                            </FormGroup>
                        </Col>

                        {/* Middle Panel */}
                        <Col lg={4} xs={12}>
                            <FormGroup validationState={this.state.submissionDateValid ? null : 'error'}>
                                {/* Submission Date */}
                                <Col componentClass={ControlLabel} xs={12} sm={4} lg={5}>
                                    <div className="no-wrap">Submission Date <span className="red-text">*</span></div>
                                </Col>
                                <Col xs={12} sm={8} lg={7}>
                                    <DatePicker
                                        selected={this.state.submissionDate}
                                        onChange={this.handleSubmissionDateChange}
                                        placeholderText="Click to select a date"
                                        disabled={this.state.controlsDisabled}
                                        className="form-control"
                                    />
                                    {!this.state.submissionDateValid ? <HelpBlock>Submission Date must be on or before today's date</HelpBlock> : null}

                                </Col>

                            </FormGroup>

                            <FormGroup>
                                {/*Workbook selector*/}
                                <Col componentClass={ControlLabel} xs={12} sm={4} lg={5}>
                                    <div className="no-wrap">Workbook File (.csv) <span className="red-text">*</span></div>
                                </Col>
                                <Col xs={12} sm={8} lg={7}>
                                    <FormControl id="fileId" name="fileId" accept=".csv" type="file" className="control-label" onChange={this.handleInputChange} disabled={this.state.controlsDisabled} />
                                </Col>
                            </FormGroup>

                        </Col>

                        {/* Right Panel */}
                        <Col lg={5} xs={12}>

                            <FormGroup>
                                <Col componentClass={ControlLabel} xs={12} sm={4} lg={4}>
                                    <div className="no-wrap">CSV Date Format   </div>
                                </Col>
                                <Col xs={12} sm={8} lg={8}>
                                    <FormControl
                                        name="chosenLocale"
                                        title="Please select the date format used in the workbook"
                                        componentClass="select"
                                        value={this.state.chosenLocale}
                                        onChange={this.handleInputChange}
                                        disabled={this.state.controlsDisabled}
                                        required>
                                        {
                                            this.state.locales.map(locale => <option value={locale.code} selected={this.state.chosenLocale === locale.code}>{locale.text}</option>)
                                        }
                                    </FormControl>
                                </Col>
                            </FormGroup>

                            <FormGroup>
                                <Col lg={12} xs={12}>
                                    <div className="right-aligned">
                                        <Button className="horizontal-margin" onClick={this.upload} disabled={this.state.submitDisabled}>Load</Button>
                                        <Button className="horizontal-margin" onClick={this.handleReset}>Reset</Button>
                                    </div>
                                </Col>
                            </FormGroup>

                        </Col>

                        {/* Button Row */}

                    </Form>

                </Panel>
            </div>
        );
    }
}

export default UploadFormComponent;