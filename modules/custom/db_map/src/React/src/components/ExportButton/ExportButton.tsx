import * as React from 'react';
import { ComponentBase } from 'resub';
import { locations } from '../../stores/Locations';
import { searchCriteria } from '../../stores/SearchCriteria';
import { locationFilters } from '../../stores/LocationFilters';

import { excelExport } from '../../services/ExportService';
import { Location, ViewLevel } from '../../services/DataService';

interface ExportButtonState {
  locations: Location[];
  searchCriteria: (string|number)[][];
  searchCriteriaSummary: string;
  viewLevel: ViewLevel;
}

export default class ExportButton extends ComponentBase<{}, ExportButtonState> {
  _buildState(): ExportButtonState {
    return {
      locations: locations.get(),
      searchCriteria: searchCriteria.get(),
      searchCriteriaSummary: searchCriteria.getSummary(),
      viewLevel: locationFilters.getViewLevel(),
    }
  }

  export() {
    const {
      locations,
      searchCriteria,
      searchCriteriaSummary,
      viewLevel
    } = this.state;

    const type = {
      regions: 'Region',
      countries: 'Country',
      cities: 'City',
    }[viewLevel || 'regions'];

    excelExport({
      searchCriteria: {
        summary: searchCriteriaSummary,
        table: searchCriteria
      },
      locations: locations,
      type: type
    })
  }

  render() {
    return (
      <button
        className="btn btn-default btn-sm margin-top margin-bottom"
        onClick={event => this.export()}
      >
        <div className="display-flex align-items-center">
          <svg width="12px" height="12px" viewBox="0 0 16 16">
            <g stroke="none" strokeWidth="1" fillRule="evenodd" fill="#000000">
              <path d="M4,6 L7,6 L7,0 L9,0 L9,6 L12,6 L8,10 L4,6 L4,6 Z M15,2 L11,2 L11,3 L15,3 L15,11 L1,11 L1,3 L5,3 L5,2 L1,2 C0.45,2 0,2.45 0,3 L0,12 C0,12.55 0.45,13 1,13 L6.34,13 C6.09,13.61 5.48,14.39 4,15 L12,15 C10.52,14.39 9.91,13.61 9.66,13 L15,13 C15.55,13 16,12.55 16,12 L16,3 C16,2.45 15.55,2 15,2 L15,2 Z" id="Shape"></path>
            </g>
          </svg>
          <span className="margin-left">
            Export
          </span>
        </div>
      </button>
    );
  }
}