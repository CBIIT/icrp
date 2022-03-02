import * as React from 'react';
import { ComponentBase  } from 'resub';
import { OverlayTrigger, Tooltip } from 'react-bootstrap';
import { store } from '../../services/Store';
import { LocationFilters, getRegionFromId, getCountryFromAbbreviation, ViewLevel } from '../../services/DataService';
import './ViewLevelSelector.css';

interface ViewLevelTag {
  label: string;
  locationFilters: LocationFilters;
  tooltip?: string;
}

interface ViewLevelSelectorProps {
  onSelect: (LocationFilters: LocationFilters) => void;
}

interface ViewLevelSelectorState {
  viewLevel: ViewLevel;
  locationFilters: LocationFilters;
}

export default class ViewLevelSelector extends ComponentBase<ViewLevelSelectorProps & React.Props<any>, ViewLevelSelectorState> {

  _buildState(): ViewLevelSelectorState {

    return {
      locationFilters: store.getLocationFilters(),
      viewLevel: store.getViewLevel(),
    };
  }

  buildTags(): ViewLevelTag[] {
    let { viewLevel } = this.state;
    let locationFiltersRef = this.state.locationFilters;
    let locationFilters = {...locationFiltersRef};

    let allRegionsFilters: LocationFilters = {
      ...locationFilters,
      type: 'regions',
    };

    delete allRegionsFilters.region;
    delete allRegionsFilters.country;
    delete allRegionsFilters.city;
    delete allRegionsFilters.institution;

    const viewLevelTags: ViewLevelTag[] = [
      {
        label: 'All Regions',
        locationFilters: allRegionsFilters,
        tooltip: 'Click here to return to all regions.',
      }
    ];

    if (locationFilters.region  && viewLevel != 'regions') {
      let regionFilter: LocationFilters = {
        ...locationFilters,
        type: 'countries',
      };

      delete regionFilter.country;
      delete regionFilter.city;
      delete regionFilter.institution;


      let region = getRegionFromId(locationFilters.region);

      viewLevelTags.push({
        label: region,
        locationFilters: regionFilter,
        tooltip: `Click here to return to ${region}.`,
      })
    }


    if (locationFilters.country && viewLevel != 'regions' && viewLevel != 'countries') {
      let regionFilter: LocationFilters = {
        ...locationFilters,
        type: 'cities',
      };

      delete regionFilter.city;
      delete regionFilter.institution;

      let country = getCountryFromAbbreviation(locationFilters.country || 'Country');

      viewLevelTags.push({
        label: country,
        locationFilters: regionFilter,
        tooltip: `Click here to return to ${country}.`,
      })
    }

    if (locationFilters.city && viewLevel != 'regions' && viewLevel != 'countries' && viewLevel != 'cities') {
      let regionFilter: LocationFilters = {
        ...locationFilters,
        type: 'institutions',
      };

      delete regionFilter.institution;

      viewLevelTags.push({
        label: locationFilters.city || 'City',
        locationFilters: regionFilter,
        tooltip: `Click here to return to ${locationFilters.city}.`,
      })
    }



    return viewLevelTags
  }

  render() {
    let { onSelect } = this.props;


    return (
      <div className="display-flex align-items-center position-relative">
      {
        this.buildTags().map((tag, index) =>
          <span key={index} className="position-relative">

            <OverlayTrigger placement="top" overlay={
              <Tooltip id="tooltip">{tag.tooltip}</Tooltip>
            }>
              <div className="bg-chevron" onClick={event => onSelect(tag.locationFilters)}>
                {tag.label}
              </div>
            </OverlayTrigger>
          </span>
        )
      }
      </div>
    )
  }
}