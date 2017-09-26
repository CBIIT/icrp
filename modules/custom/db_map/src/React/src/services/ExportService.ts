


import { BASE_URL, Location, getExcelExport } from './DataService';

export interface ExcelSheet {
  title: string;
  rows: (number|string)[][];
}

interface ExcelExportParameters {
  searchCriteria: {
    summary: string;
    table: (string | number)[][];
  };

  locations: Location[],
  type: 'region' | 'country' | 'city';
}

export const excelExport = async ({searchCriteria, locations, type}: ExcelExportParameters) => {

  let sheets: ExcelSheet[] = [

    {
      title: 'Search Criteria',
      rows: [
        ['Search Criteria: ', searchCriteria.summary],
        ...searchCriteria.table
      ]
    },

    {
      title: 'Data',
      rows: [
        [`${type[0].toLocaleUpperCase()}${type.substr(1)}`, 'Total Projects', 'Total PIs', 'Total Collaborators'],
        ...locations.map(row => [
          row.label,
          row.data.relatedProjects,
          row.data.primaryInvestigators,
          row.data.collaborators,
        ])
      ]
    }

  ];

  let uri = `${BASE_URL}/${await getExcelExport(sheets)}`;
  window.document.location.href = uri;
}