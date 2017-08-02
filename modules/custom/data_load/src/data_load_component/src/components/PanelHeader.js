import React from 'react';
import '../css/PanelHeader.css';

const PanelHeader = ({title, isOpen, onClick}) =>
<div className="panel-header" onClick={onClick}>
    <div className="panel-title">{title}</div>
    <div className={isOpen ? 'rotate-45' : 'rotate-225'}>{'\u25E2'}</div>
</div>

export default PanelHeader;