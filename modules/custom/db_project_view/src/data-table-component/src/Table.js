import React from 'react';
import { Table as BootstrapTable, Tooltip, OverlayTrigger } from 'react-bootstrap';

export const Table = ({headers, data, enableSorting, sortState, sortCallback}) => 
  <BootstrapTable responsive condensed hover striped>
    <thead>
      <tr>
        {
          headers.map((header, columnIndex) => 
            <th 
              key={`column_${columnIndex}`} 
              onClick={ () => 
                enableSorting
                && sortCallback.constructor === Function 
                && sortCallback(header.key, sortState) }>

              <OverlayTrigger 
                placement="top" 
                overlay={ <Tooltip id={`tooltip`}>{ header.tooltip }</Tooltip> }>
                <div className="header">
                  <span>
                    {
                      header.title
                    }
                  </span>

                  {
                    enableSorting
                    && header.key === sortState.column 
                    && <span className="rotate-45">{ sortState.direction === 'ascending' ? '\u25E4' : '\u25E2' }</span>
                  }
                </div>
              </OverlayTrigger>
            </th>
          )
        }
      </tr>
    </thead>
    <tbody>
      { 
        data && data.constructor === Array && data.map((row, rowIndex) => 
          <tr key={`row_${rowIndex}`}>
            {
              headers.map((header, columnIndex) => 
                <td key={`row_${rowIndex}_column_${columnIndex}`}>
                  { row[header.key] }
                </td>
              ) 
            }
          </tr>
        )
      }
    </tbody>
  </BootstrapTable>
