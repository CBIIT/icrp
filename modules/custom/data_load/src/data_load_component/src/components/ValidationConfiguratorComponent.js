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
    render() {
        return (
            <Checkbox>{this.props.name}</Checkbox>
        );
    }
}

class ValidationCategory extends Component {

    render() {
        let header = this.props.validationCategory.header;
        let validationItems = [];
        this.props.validationCategory.items.forEach(validationItem => {
            validationItems.push(
                <ValidationItem name={validationItem.name} key={uuidV4()} />
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

    render() {

        const validationCategory = {
            header: 'Validation',
            items: [
                { name: 'Check Award Code Uniqueness' },
                { name: ' Check Project Dates' },
                { name: 'Check Budget Dates' },
                { name: 'Check Award Type' },
                { name: 'Check Funding Org' },
                { name: 'Check Funding Amounts > 0' },
                { name: 'Check Annualizes Values' }
            ]
        }

        const cancerTypeCategory = {
            header: 'Cancer Type',
            items: [
                { name: 'Check Cancer Type Codes' },
                { name: 'Check Cancer Type Relevances' }
            ]
        }

        const institutionCategory = {
            header: 'Institution',
            items: [
                { name: 'Check Institution' }
            ]
        }

        const csoCategory = {
            header: 'CSO',
            items: [
                { name: 'Check CSO Codes' },
                { name: 'Check CSO Relevances' },
                { name: 'Check CSO Historical CSO Codes' }
            ]
        }

        return (
            <Panel>
                <Col lg={3} md={4} sm={6} xs={12}>
                    <ValidationCategory validationCategory={validationCategory} />

                </Col>
                <Col lg={3} md={4} sm={6} xs={12}>
                    <ValidationCategory validationCategory={cancerTypeCategory} />
                    <ValidationCategory validationCategory={institutionCategory} />
                </Col>
                <Col lg={3} md={4} sm={6} xs={12} >
                    <ValidationCategory validationCategory={csoCategory} />
                </Col>
                <Col lg={3} xs={12} className="responsive-border-right">
                    <FormGroup className="lower-buttons-250">
                        <Col lg={12} lgOffset={0} sm={2} smOffset={5} xs={2} xsOffset={4}>
                            <ButtonToolbar>
                                <Button>Check Data</Button>
                            </ButtonToolbar>
                        </Col>
                    </FormGroup>
                </Col>
            </Panel>


        );
    }

}

export default ValidationConfiguratorComponent;