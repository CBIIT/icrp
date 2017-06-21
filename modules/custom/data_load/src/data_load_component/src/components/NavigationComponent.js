import React, { Component } from 'react';
import {
    Form,
    Col,
    FormGroup,
    Row,
    ButtonToolbar,
    Button
} from 'react-bootstrap';

import ButtonComponent from './ButtonComponent';

class NavigationComponent extends Component {

    render() {
        const hasBackButton = this.props.hasBackButton;
        const hasNextButton = this.props.hasNextButton;
        const nextDisabled = this.props.nextDisabled;
        const thisTabId = this.props.thisTabId;

        let navigationButtons = null;
        if (hasBackButton && hasNextButton) {
            /** Can navigate back and forward */
            navigationButtons =
                <ButtonToolbar className="pull-right">
                    <ButtonComponent title='Back' disabled={false} clickHandler={this.props.clickHandler} nextTab={thisTabId - 1} />
                    <ButtonComponent title='Next' disabled={nextDisabled} clickHandler={this.props.clickHandler} nextTab={thisTabId - 1} />
                </ButtonToolbar>;
        } else {
            if (hasBackButton) {
                /** Can navigate back only */
                navigationButtons = <ButtonComponent title='Back' disabled={false} className="pull-right" clickHandler={this.props.clickHandler} nextTab={thisTabId - 1} />;
            } else {
                /** Can navigate forward only */
                navigationButtons = <ButtonComponent title='Next' disabled={nextDisabled} className="pull-right" clickHandler={this.props.clickHandler} nextTab={thisTabId + 1} />;
            }
        }

        return (

            <Form className="top-border">
                <Row>
                    <Col xs={6}><FormGroup>
                        {/*<ButtonToolbar className="pull-right">*/}
                        {navigationButtons}
                        {/*</ButtonToolbar>*/}
                    </FormGroup></Col>
                    <Col xs={6}><FormGroup><Button href={this.props.cancelUrl} title='Cancel' disabled={false} className="pull-right">Cancel</Button></FormGroup></Col>
                </Row>
            </Form>
        );
    }

}

export default NavigationComponent;