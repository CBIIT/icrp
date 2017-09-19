import * as React from 'react';
import './MapOverlay.css';

export interface MapOverlayProps {
  height?: number;
  backgroundColor?: string;
  children: JSX.Element;
};

const MapOverlay = (props: MapOverlayProps) =>
  <div>
    <div className="map-overlay position-absolute translucent" />
    <div className="map-overlay position-absolute">
      { props.children }
    </div>
  </div>

export default MapOverlay;