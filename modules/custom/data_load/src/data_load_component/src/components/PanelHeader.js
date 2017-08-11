import React from 'react';
import '../css/PanelHeader.css';

const PanelHeader = ({title, isOpen, onClick, isActive = true}) =>
<div className="component-panel-header" onClick={event => isActive && onClick()}>
    <div className="component-panel-title">{title}</div>
    <div className={isOpen ? 'rotate-45' : 'rotate-225'}>{'\u25E2'}</div>
</div>

export default PanelHeader;