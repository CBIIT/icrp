import * as React from 'react';
import { Location } from '../../services/DataService';


interface SummaryGridProps {
  locations: Location[];
}

const SummaryGrid = ({locations}: SummaryGridProps) =>
  !locations || !locations.length ? null :
  <div className="table-responsive">
    <table className="table table-bordered table-striped table-hover table-nowrap">
      <thead>
        <tr>
          <th>Region</th>
          <th>Total Projects</th>
          <th>Total PIs</th>
          <th>Total Collaborators</th>
        </tr>
      </thead>
      <tbody>
      {
        locations.map((row, index) =>
          <tr key={index}>
            <td>{row.label}</td>
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