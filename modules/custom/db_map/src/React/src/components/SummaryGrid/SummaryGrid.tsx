import * as React from 'react';
import { Location, MapLevelInterface } from '../../services/DataService';


interface SummaryGridProps {
  searchId: number;
  locations: Location[];
  type: string;
  onSelect: (props: MapLevelInterface) => void;
}

const SummaryGrid = ({locations, type, onSelect, searchId}: SummaryGridProps) =>
  !locations || !locations.length ? null :
  <div className="table-responsive">
    <table className="table table-bordered table-striped table-hover table-nowrap">
      <thead>
        <tr>
          <th>{type}</th>
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
                onClick={event => onSelect({
                  searchId: searchId,
                  region: parseInt(row.value.toString())
                })}
              >
                {row.label}
              </a>
            </td>
            <td>{row.data.relatedProjects}</td>
            <td>{row.data.primaryInvestigators}</td>
            <td>{row.data.collaborators}</td>
          </tr>
        )
      }
      </tbody>
    </table>
  </div>

export default SummaryGrid;