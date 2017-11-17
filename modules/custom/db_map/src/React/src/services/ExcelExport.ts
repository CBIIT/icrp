import { BASE_URL, jsonRequest, parseViewLevel, summarizeCriteria, Location, ViewLevel } from './DataService';

export interface ExcelSheet {
  title: string;
  rows: any[][];
}

export interface ExportFields  {
  searchCriteria: any[][];
  locations: Location[],
  viewLevel: ViewLevel;
}

export const buildSheets = ({searchCriteria, locations, viewLevel}: ExportFields): ExcelSheet[] =>
  [
    {
      title: 'Search Criteria',
      rows: [
        ['Search Criteria: ', summarizeCriteria(searchCriteria)],
        ...searchCriteria
      ]
    },

    {
      title: 'Data',
      rows: [
        [parseViewLevel(viewLevel), 'Total Projects', 'Projects with PI', 'Projects with Collaborators'],
        ...locations.map(({label, counts})=> [
          label,
          counts.projects,
          counts.primaryInvestigators,
          counts.collaborators,
        ])
      ]
    }
  ]

export const getExcelExportUrl = async (sheets: ExcelSheet[]): Promise<string> => {
  const path = await jsonRequest(`${BASE_URL}/map/getExcelExport/`, {
    method: 'POST',
    body: JSON.stringify(sheets),
    credentials: 'same-origin'
  });

  return `${BASE_URL}/${path}`;
}
