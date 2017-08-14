import React, { Component } from 'react';
import {
    Button,
    Panel,
    Checkbox,
    Collapse
} from 'react-bootstrap';
import Spinner from './SpinnerComponent';
import PanelHeader from './PanelHeader';
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
            <Checkbox name={this.props.item.id} defaultChecked={this.props.item.checked} disabled={this.props.item.required} onChange={this.onChange}>
                <div className="nowrap">{this.props.item.name}</div>
            </Checkbox>
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
            <div className="panel panel-default category-panel">
                <div className="panel-heading">
                    {header}
                </div>
                <div className="category-panel-list">
                    {validationItems}
                </div>
            </div>
        );
    }
}

class ValidationConfiguratorComponent extends Component {

    constructor(props) {
        super(props);

        this.checkIntegrity = this.checkIntegrity.bind(this);
        this.updateParent = this.updateParent.bind(this);
        this.toggleCheck = this.toggleCheck.bind(this);
        this.state = { validationRules: [], open: true };
    }

    componentWillMount() {
        let protocol = window.location.protocol;
        let hostname = window.location.hostname;
        let pathname = 'DataUploadTool/getValidationRuleDefinitions';
        if (hostname === 'localhost') {
            protocol = 'http:';
            //hostname = 'icrp-dataload';
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
        this.setState({ loading: true });
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
            //hostname = 'icrp-dataload';
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
            that.setState({ loading: false });
            that.updateParent(results);
        } else {
            let message = await response.text();
            alert("Oops! " + message);
        }
    }

    render() {
        const awardCategory = {
            header: 'Award',
            items: this.state.validationRules.filter(rule => rule.category === 'Award' && rule.active)
        }

        const cancerTypeCategory = {
            header: 'Cancer Type',
            items: this.state.validationRules.filter(rule => rule.category === 'Cancer Type' && rule.active)
        }

        const institutionCategory = {
            header: 'Organization',
            items: this.state.validationRules.filter(rule => rule.category === 'Organization' && rule.active)
        }

        const csoCategory = {
            header: 'CSO',
            items: this.state.validationRules.filter(rule => rule.category === 'CSO' && rule.active)
        }

        const generalCategory = {
            header: 'General',
            items: this.state.validationRules.filter(rule => rule.category === 'General' && rule.active)
        }

        return (
            <div>
                <PanelHeader onClick={() => this.setState({ open: !this.state.open })} title="Validation Rules" isOpen={this.state.open} />
                <Spinner message="Performing Check..." visible={this.state.loading} />
                <Spinner message="Generating Export..." visible={this.props.loadingExport} />

                <Collapse in={this.state.open}>
                    <Panel>

                        <div className="flex-stretch">
                            <div>
                                <ValidationCategory validationCategory={generalCategory} onCheck={this.toggleCheck} />
                                <ValidationCategory validationCategory={institutionCategory} onCheck={this.toggleCheck} />
                            </div>
                            <ValidationCategory validationCategory={awardCategory} onCheck={this.toggleCheck} />
                            <ValidationCategory validationCategory={cancerTypeCategory} onCheck={this.toggleCheck} />
                            <div style={{'margin-bottom': '21px', 'display': 'flex'}}>
                                <ValidationCategory validationCategory={csoCategory} onCheck={this.toggleCheck} />
                            </div>

                        </div>
                        <div className="text-center padding-top">
                            <Button onClick={this.checkIntegrity}>Perform Check</Button>
                            <Button onClick={this.props.onExport} disabled={this.props.exportDisabled} style={{'margin-left': '10px'}}>Export Results</Button>                            
                        </div>
                    </Panel>
                </Collapse>
            </div >
        );
    }

}

export default ValidationConfiguratorComponent;