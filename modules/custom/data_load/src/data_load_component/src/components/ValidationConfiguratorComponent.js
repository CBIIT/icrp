import React, { Component } from 'react';
import {
    Button,
    Col,
    Panel,
    FormGroup,
    ButtonToolbar,
    Checkbox,
} from 'react-bootstrap';
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
        return (
            <Checkbox name={this.props.item.id} defaultChecked={this.props.item.checked} onChange={this.onChange}>{this.props.item.name}</Checkbox>
        );
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

        this.state = {
            validationRules: [
                { id: 1, name: 'Check Duplicate AltAwardCodes', category: 'validation', checked: true },
                { id: 2, name: 'Check New AwardCodes with Missing Parent Category', category: 'validation', checked: true },
                { id: 3, name: 'Check Old AwardCode with Parent Category', category: 'validation', checked: true },
                { id: 4, name: 'Check Incorrect Award or Budget Duration', category: 'validation', checked: true },
                { id: 5, name: 'Check Incorrect Funding Amounts', category: 'validation', checked: true },
                { id: 9, name: 'Check Annulized Value', category: 'validation', checked: true },
                { id: 8, name: 'Check CancerType Codes/Relevance', category: 'cancertype', checked: true },
                { id: 10, name: 'Check FundingOrg Existance', category: 'institution', checked: true },
                { id: 11, name: 'Check FundingOrgDiv Existance', category: 'institution', checked: true },
                { id: 12, name: 'Check not-mapped Institution', category: 'institution', checked: true },
                { id: 6, name: 'Check Incorrect CSO Codes/Relevance', category: 'cso', checked: true },
                { id: 7, name: 'Check Historical CSO Codes', category: 'cso', checked: true }
            ]
        };
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
        data.append('type', 'new');
        var that = this;
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'dataload/integrity_check_mssql';
        if (hostname === 'localhost') {
            protocol = 'http:';
            hostname = 'icrp-dataload';
        }

        let response = await fetch(`${protocol}//${hostname}/${pathname}`, { method: 'POST', body: data });

        if (response.ok) {
            let results = await response.json();
            // filter result type Summary
            results = results['results'].filter(result =>
            { return result.Type === 'Rule'; }).map(result => {
                return {
                    id: result.ID,
                    name: result.Description,
                    validationResult: (parseInt(result.Count, 10) === 0 ? 'Pass' : 'Failed'),
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

        const validationCategory = {
            header: 'Validation',
            items: this.state.validationRules.filter(rule => rule.category === 'validation')
        }

        const cancerTypeCategory = {
            header: 'Cancer Type',
            items: this.state.validationRules.filter(rule => rule.category === 'cancertype')
        }

        const institutionCategory = {
            header: 'Institution',
            items: this.state.validationRules.filter(rule => rule.category === 'institution')
        }

        const csoCategory = {
            header: 'CSO',
            items: this.state.validationRules.filter(rule => rule.category === 'cso')
        }

        return (
            <Panel>
                <Col lg={3} md={4} sm={6} xs={12}>
                    <ValidationCategory validationCategory={validationCategory} onCheck={this.toggleCheck} />

                </Col>
                <Col lg={3} md={4} sm={6} xs={12}>
                    <ValidationCategory validationCategory={cancerTypeCategory} onCheck={this.toggleCheck} />
                    <ValidationCategory validationCategory={institutionCategory} onCheck={this.toggleCheck} />
                </Col>
                <Col lg={3} md={4} sm={6} xs={12} >
                    <ValidationCategory validationCategory={csoCategory} onCheck={this.toggleCheck} />
                </Col>
                <Col lg={3} xs={12} className="responsive-border-right">
                    <FormGroup className="lower-buttons-250">
                        <Col lg={12} lgOffset={0} sm={2} smOffset={5} xs={2} xsOffset={4}>
                            <ButtonToolbar>
                                <Button onClick={this.checkIntegrity}>Check Data</Button>
                            </ButtonToolbar>
                        </Col>
                    </FormGroup>
                </Col>
            </Panel>


        );
    }

}

export default ValidationConfiguratorComponent;