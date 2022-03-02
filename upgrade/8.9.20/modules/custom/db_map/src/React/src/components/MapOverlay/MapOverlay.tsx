import * as React from 'react';
import './MapOverlay.css';

export interface MapOverlayProps {
  height?: number;
  backgroundColor?: string;
  children: JSX.Element;
};

const MapOverlay = ({children}: MapOverlayProps) =>
  <div id="icrp-map-overlay" className="position-relative">
    <div className="map-overlay position-absolute translucent" />
    <div className="map-overlay position-absolute">
      { children }
    </div>
  </div>

export default MapOverlay;