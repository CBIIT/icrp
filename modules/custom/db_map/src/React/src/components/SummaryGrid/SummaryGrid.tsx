import * as React from 'react';
import { Location, MapLevelInterface } from '../../services/DataService';


interface FilterProps {
  region?: number;
  country?: string;
  city?: string;
}

interface SummaryGridProps {
  searchId: number;
  locations: Location[];
  type: string;
  filters: FilterProps
  onSelect: (props: MapLevelInterface) => void;
}

const SummaryGrid = ({locations, type, onSelect, searchId, filters}: SummaryGridProps) =>
  !locations || !locations.length ? null :
  <div className="table-responsive">
    <table className="table table-bordered table-striped table-hover table-nowrap">
      <thead>
        <tr>
          <th>{type.toLocaleUpperCase()}</th>
          <th>Total Projects</th>
          <th>Total PIs</th>
          <th>Total Collaborators</th>
        </tr>
      </thead>
      <tbody>
      {
        locations.map((row, index) =>
          <tr key={index}>
            <td>
              <a
                className="cursor-pointer"
                onClick={event => {
                  let value = row.value.toString();
                  let parameters: {
                    searchId: number,
                  } & FilterProps = {
                    searchId: searchId,
                  };

                  if (type === 'regions') {
                    parameters.region = parseInt(value);
                    delete parameters.country;
                    delete parameters.city;
                  }

                  else if (type === 'countries') {
                    parameters.region = filters.region;
                    parameters.country = value;
                    delete parameters.city;
                  }

                  else if (type === 'cities') {
                    parameters.region = filters.region;
                    parameters.country = filters.country;
                    parameters.city = value;
                  }

                  onSelect(parameters);
                }}
              >
                {row.label}
              </a>
            </td>
            <td>{row.data.relatedProjects.toLocaleString()}</td>
            <td>{row.data.primaryInvestigators.toLocaleString()}</td>
            <td>{row.data.collaborators.toLocaleString()}</td>
          </tr>
        )
      }
      </tbody>
    </table>
  </div>

export default SummaryGrid;