import React, { Component } from 'react';
import {
    Button,
    Col,
    Panel,
    FormGroup,
    ButtonToolbar,
    Checkbox,
} from 'react-bootstrap';
import Spinner from './SpinnerComponent';
const uuidV4 = require('uuid/v4');

class ValidationItem extends Component {

    constructor(props) {
        super(props);
        this.onChange = this.onChange.bind(this);
    }

    onChange(event) {
        const target = event.target;
        this.props.onCheck(target.name);
    }

    render() {

        const active = this.props.item.active;
        if (active) {
            return (
                <Checkbox name={this.props.item.id} defaultChecked={this.props.item.checked} disabled={this.props.item.required} onChange={this.onChange}>{this.props.item.name}</Checkbox>
            );
        } else {
            return (<br />);
        }
    }
}

class ValidationCategory extends Component {

    render() {
        let header = this.props.validationCategory.header;
        let validationItems = [];
        this.props.validationCategory.items.forEach(validationItem => {
            validationItems.push(
                <ValidationItem item={validationItem} onCheck={this.props.onCheck} key={uuidV4()} />
            );
        });

        return (
            <Panel header={header}>
                {validationItems}
            </Panel>
        );
    }
}

class ValidationConfiguratorComponent extends Component {

    constructor(props) {
        super(props);

        this.checkIntegrity = this.checkIntegrity.bind(this);
        this.updateParent = this.updateParent.bind(this);
        this.toggleCheck = this.toggleCheck.bind(this);
        this.state = { validationRules: [] };
    }

    componentWillMount() {
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/getValidationRuleDefinitions';
        if (hostname === 'localhost') {
            protocol = 'http:';
            hostname = 'icrp-dataload';
        }
        this.setState({ loading: true });
        fetch(`${protocol}//${hostname}/${pathname}`, { method: 'GET', credentials: 'same-origin' })
            .then(response => response.json())
            .then(response => {
                this.setState({
                    validationRules: response.results.map(result => {
                        return {
                            id: parseInt(result.lu_DataUploadIntegrityCheckRules_ID, 10),
                            name: result.Name,
                            category: result.Category,
                            required: result.IsRequired === '1',
                            active: result.IsActive === '1',
                            checked: true
                        }
                    }), loading: false
                })
            });

    }

    toggleCheck(id) {
        let validationRules = this.state.validationRules;
        let rule = validationRules.find(rule => rule.id === parseInt(id, 10));
        rule.checked = !rule.checked;
        this.setState({ validationRules: validationRules });
    }

    updateParent(results) {
        this.props.onValidationResults(results, this.state.validationRules);
    }

    async checkIntegrity() {
        this.props.onLoadingStart();
        var data = new FormData();
        data.append('type', this.props.uploadType);
        data.append('partnerCode', this.props.sponsorCode);
        var that = this;
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/integrity_check_mssql';
        if (hostname === 'localhost') {
            protocol = 'http:';
            hostname = 'icrp-dataload';
        }

        let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'POST', body: data, credentials: 'same-origin' });

        if (response.ok) {
            let results = await response.json();
            // filter result type Summary
            results = results['results'].map(result => {
                return {
                    id: result.ID,
                    name: result.Description,
                    validationResult: (parseInt(result.Count, 10) === 0 ? 'Pass' : 'Failed'),
                    count: parseInt(result.Count, 10),
                    key: uuidV4()
                };
            });
            that.updateParent(results);
        } else {
            let message = await response.text();
            alert("Oops! " + message);
        }
    }

    render() {
        const awardCategory = {
            header: 'Award',
            items: this.state.validationRules.filter(rule => rule.category === 'Award')
        }

        const cancerTypeCategory = {
            header: 'Cancer Type',
            items: this.state.validationRules.filter(rule => rule.category === 'Cancer Type')
        }

        const institutionCategory = {
            header: 'Institution / Funding Org',
            items: this.state.validationRules.filter(rule => rule.category === 'Funding Org / Institution')
        }

        const csoCategory = {
            header: 'CSO',
            items: this.state.validationRules.filter(rule => rule.category === 'CSO')
        }

        const generalCategory = {
            header: 'General',
            items: this.state.validationRules.filter(rule => rule.category === 'General')
        }

        return (
            <div>
                <Spinner message="Validating Workbook..." visible={this.state.loading} />
                <Panel>
                    <Col lg={3} md={4} sm={6} xs={12}>
                        <ValidationCategory validationCategory={generalCategory} onCheck={this.toggleCheck} />
                        <ValidationCategory validationCategory={institutionCategory} onCheck={this.toggleCheck} />
                    </Col>
                    <Col lg={3} md={4} sm={6} xs={12}>
                        <ValidationCategory validationCategory={awardCategory} onCheck={this.toggleCheck} />
                    </Col>
                    <Col lg={3} md={4} sm={6} xs={12}>
                        <ValidationCategory validationCategory={cancerTypeCategory} onCheck={this.toggleCheck} />
                    </Col>
                    <Col lg={3} md={4} sm={6} xs={12} >
                        <ValidationCategory validationCategory={csoCategory} onCheck={this.toggleCheck} />
                    </Col>
                    <Col lg={12} xs={12} className="centered-button-bar">
                        <FormGroup>
                            <Col lg={12} lgOffset={5} sm={2} smOffset={5} xs={2} xsOffset={4}>
                                <ButtonToolbar>
                                    <Button onClick={this.checkIntegrity}>Check Data</Button>
                                </ButtonToolbar>
                            </Col>
                        </FormGroup>
                    </Col>
                </Panel>

            </div>
        );
    }

}

export default ValidationConfiguratorComponent;