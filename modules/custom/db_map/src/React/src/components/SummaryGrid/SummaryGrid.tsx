import * as React from 'react';
import { ComponentBase  } from 'resub';
import { store } from '../../services/Store';
import { DataGrid } from './DataGrid';
import { Location, ViewLevel, LocationFilters, parseViewLevel, getNextLocationFilters } from '../../services/DataService';

interface SummaryGridProps {
  onSelect: (locationFilters: LocationFilters) => void | Promise<void>;
  children?: JSX.Element;
}

interface SummaryGridState {
  locations: Location[];
  locationFilters: LocationFilters;
  viewLevel: ViewLevel;
}

export default class SummaryGrid extends ComponentBase<SummaryGridProps & React.Props<any>, SummaryGridState> {
  _buildState(): SummaryGridState {
    return {
      locations: store.getLocations(),
      viewLevel: store.getViewLevel(),
      locationFilters: store.getLocationFilters(),
    }
  }

  render() {
    const { onSelect, children } = this.props;
    const { locations, viewLevel, locationFilters } = this.state;

    if (!locations || !viewLevel || !locationFilters) {
      return null;
    }

    const headers = [

      {
        label: parseViewLevel(viewLevel),
        value: 'location',
        sortDirection: 'none',
        callback: (name: string, index: number) => {
          let location = locations.find(loc => loc.label === name);
          onSelect(getNextLocationFilters(location as Location, locationFilters));
        },
        width: '40%',
      },

      {
        label: 'Total Projects',
        value: 'projects',
        tooltip: `Total projects with PI or collaborators in this ${parseViewLevel(viewLevel).toLowerCase()}`,
        sortDirection: 'desc',
        width: '20%',
      },

      {
        label: 'Projects with PI',
        value: 'primaryInvestigators',
        tooltip: `Projects with PI in this ${parseViewLevel(viewLevel).toLowerCase()}`,
        sortDirection: 'none',
        width: '20%',
      },

      {
        label: 'Projects with Collaborators',
        value: 'collaborators',
        tooltip: `Projects with collaborator(s) in this ${parseViewLevel(viewLevel).toLowerCase()}`,
        sortDirection: 'none',
        width: '20%',
      },
    ];

    let data = locations.map(row => ({
      location: row.label,
      projects: row.counts.projects,
      primaryInvestigators: row.counts.primaryInvestigators,
      collaborators: row.counts.collaborators,
    }));

    return (
      <DataGrid
        headers={headers}
        data={data}>
        {children}
      </DataGrid>
    );


// projects.toLocaleString()}</td>
//                     <td>{location.counts.primaryInvestigators.toLocaleString()}</td>
//                     <td>{location.counts.collaborators.toLoc
//     return !locations || !locations.length ? null : (
//       <div>
//         <div className="margin-top pagination-container">

//           {showPagination &&
//             <div className="pagination-select-container">
//               <div style={{marginRight: '100px'}}>
//                 {'Show '}
//                 <select value={tablePageSize} onChange={event => this.handlePageSizeChange(+event.target.value)}>
//                   <option value={25}>25</option>
//                   <option value={50}>50</option>
//                   <option value={100}>100</option>
//                   <option value={150}>150</option>
//                   <option value={200}>200</option>
//                   <option value={250}>250</option>
//                   <option value={300}>300</option>
//                 </select>

//                 {` out of `}
//                 <b>{locations && locations.length}</b>
//                 {` entries`}
//               </div>

//               <Pagination
//                 bsSize="small"
//                 items={numItems}
//                 activePage={tablePage}
//                 onSelect={this.handleSelect}
//                 boundaryLinks={true}
//                 ellipsis={true}
//                 maxButtons={5}
//                 prev
//                 next
//               />
//             </div>
//           }

//           <div style={{marginBottom: '5px'}}>{ children }</div>
//         </div>
//         <div className="table-responsive">
//           <table className="table table-bordered table-striped table-hover table-nowrap">
//             <thead>
//               <tr>
//                 <th>{parseViewLevel(viewLevel)}</th>
//                 <th>
//                   <OverlayTrigger placement="top" overlay={
//                     <Tooltip id="total-projects">
//                       Total projects with PI or collaborators in this {parseViewLevel(viewLevel).toLowerCase()}
//                     </Tooltip>
//                   }>
//                     <div>Total Projects</div>
//                   </OverlayTrigger>
//                 </th>
//                 <th>
//                   <OverlayTrigger placement="top" overlay={
//                     <Tooltip id="projects-with-pi">
//                       Projects with PI in this {parseViewLevel(viewLevel).toLowerCase()}
//                     </Tooltip>
//                   }>
//                     <div>Projects with PI</div>
//                   </OverlayTrigger>
//                 </th>
//                 <th>
//                   <OverlayTrigger placement="top" overlay={
//                     <Tooltip id="projects-with-collaborators">
//                       Projects with collaborator(s) in this {parseViewLevel(viewLevel).toLowerCase()}
//                     </Tooltip>
//                   }>
//                     <div>Projects with Collaborators</div>
//                   </OverlayTrigger>
//                 </th>
//               </tr>
//             </thead>
//             <tbody>
//             {
//               locations.map((location: Location, index: number) =>
//                 (!(index >= (tablePage - 1) * tablePageSize && index < tablePage * tablePageSize) ? null :
//                   <tr key={index}>
//                     <td>
//                       <a className="cursor-pointer"
//                         onClick={event => onSelect(
//                           getNextLocationFilters(location, locationFilters)
//                         )}>
//                         {location.label}
//                       </a>
//                     </td>
//                     <td>{location.counts.projects.toLocaleString()}</td>
//                     <td>{location.counts.primaryInvestigators.toLocaleString()}</td>
//                     <td>{location.counts.collaborators.toLocaleString()}</td>
//                   </tr>
//                 )
//               )
//             }
//             </tbody>
//           </table>
//         </div>


//           {showPagination &&
//             <div className="pagination-select-container">
//               <div style={{marginRight: '100px'}}>
//                 {'Show '}
//                 <select value={tablePageSize} onChange={event => this.handlePageSizeChange(+event.target.value)}>
//                   <option value={25}>25</option>
//                   <option value={50}>50</option>
//                   <option value={100}>100</option>
//                   <option value={150}>150</option>
//                   <option value={200}>200</option>
//                   <option value={250}>250</option>
//                   <option value={300}>300</option>
//                 </select>

//                 {` out of `}
//                 <b>{locations && locations.length}</b>
//                 {` entries`}
//               </div>

//               <Pagination
//                 bsSize="small"
//                 items={numItems}
//                 activePage={tablePage}
//                 onSelect={this.handleSelect}
//                 boundaryLinks={true}
//                 ellipsis={true}
//                 maxButtons={5}
//                 prev
//                 next
//               />
//             </div>
//           }
//       </div>
//     );
  }
}
