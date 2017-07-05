import React from 'react';
import './DisabledOverlay.css';

const DisabledOverlay = ({active}) => active ? <div className='disabled-overlay'></div> : null;
export default DisabledOverlay;