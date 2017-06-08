import React, { Component } from 'react';
import {
    Form,
    Col,
    FormGroup,
    Row,
    ButtonToolbar
} from 'react-bootstrap';

import ButtonComponent from './ButtonComponent';

class NavigationComponent extends Component {

    render() {
        const hasBackButton = this.props.hasBackButton;
        const hasNextButton = this.props.hasNextButton;
        const nextDisabled = this.props.nextDisabled;

        let navigationButtons = null;
        if (hasBackButton && hasNextButton) {
            /** Can navigate back and forward */
            navigationButtons = <ButtonToolbar className="pull-right"> <ButtonComponent title='Back' disabled={false} />
                <ButtonComponent title='Next' disabled={nextDisabled} />  </ButtonToolbar>;
        } else {
            if (hasBackButton) {
                /** Can navigate back only */
                navigationButtons = <ButtonComponent title='Back' disabled={false} className="pull-right" />;
            } else {
                /** Can navigate forward only */
                navigationButtons = <ButtonComponent title='Next' disabled={nextDisabled} className="pull-right" />;
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
                    <Col xs={6}><FormGroup><ButtonComponent title='Cancel' disabled={false} className="pull-right" /></FormGroup></Col>
                </Row>
            </Form>
        );
    }

}

export default NavigationComponent;