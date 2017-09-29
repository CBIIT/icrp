import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import { ViewLevel, LocationFilters } from '../../services/DataService';
import './LocationSelector.css';

interface ViewLevelTag {
  location?: Location;
  viewLevel: ViewLevel;
  label: string;
  value: string;
}

interface ViewLevelSelectorState {
  locationFilters: LocationFilters;
}

const ViewLevelTag = ({label}: ViewLevelTag) =>
<span className="position-relative">
  <div className="bg-chevron">
    {label}
  </div>
</span>

export default class ViewLevelSelector extends ComponentBase<{}, ViewLevelSelectorState> {

  _buildState(): ViewLevelSelectorState {
    return {
      locationFilters: store.getLocationFilters()
    };
  }

  buildTags(): ViewLevelTag[] {
    const viewLevelTags: ViewLevelTag[] = [
      {
        viewLevel: 'regions',
        label: 'All Regions',
        value: '0',
      }
    ];

    return viewLevelTags
  }

  render() {
    return (
      <div className="display-flex align-items-center">
      </div>
    )
  }
}