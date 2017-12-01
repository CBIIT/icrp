import React, { Component } from 'react';
import {
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
            navigationButtons = [
                <ButtonComponent className="horizontal-margin" title='Back' disabled={false} clickHandler={this.props.clickHandler} nextTab={thisTabId - 1} />,

                <ButtonComponent className="horizontal-margin" title='Next' disabled={nextDisabled} clickHandler={this.props.clickHandler} nextTab={thisTabId + 1} />
            ]
        } else {
            if (hasBackButton) {
                /** Can navigate back only */
                navigationButtons = <ButtonComponent title='Back' disabled={false} className="horizontal-margin" clickHandler={this.props.clickHandler} nextTab={thisTabId - 1} />;
            } else {
                /** Can navigate forward only */
                navigationButtons = <ButtonComponent title='Next' disabled={nextDisabled} className="horizontal-margin" clickHandler={this.props.clickHandler} nextTab={thisTabId + 1} />;
            }
        }

        return (

            <div className="text-center padding-top">
                {navigationButtons}
                <Button href={this.props.cancelUrl} title='Cancel' disabled={false} className="horizontal-margin">Cancel</Button>
            </div>


        );
    }

}

export default NavigationComponent;