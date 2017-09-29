import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import './LoadingSpinner.css';

interface SpinnerState {
  message: string;
  visible: boolean;
}

export default class LoadingSpinner extends ComponentBase<{}, SpinnerState> {

  _buildState(): SpinnerState {
    return {
      visible: store.isLoading(),
      message: store.getLoadingMessage(),
    };
  }

  render() {
    let { visible, message } = this.state;
    return !visible ? null : (
      <div className="fullscreen-overlay">
        <div className="text-center">
          <svg version="2.0" className="spinner" width="25" height="25">
            <circle cx="12.5" cy="12.5" r="10" fill="transparent" stroke="#ccc" strokeWidth="2.5" />
            <path fill="transparent" stroke="#666" strokeWidth="2.5" d="M 12.5 2.5 a 10 10 0 0 1 10 10" />
          </svg>
          <br />
          { message || 'Loading ...'}
        </div>
      </div>
    );
  }
}
