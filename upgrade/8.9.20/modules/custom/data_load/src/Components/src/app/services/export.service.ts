import { Injectable } from '@angular/core';
import { saveAs } from 'file-saver';
import { Workbook } from 'exceljs/dist/es5/exceljs.browser';

export interface Sheet {
  title: string;
  rows: any[][];
}

@Injectable()
export class ExportService {
  async exportAsExcel(sheets: Sheet[], filename: string = 'Data_Export.xlsx') {
    const workbook = new Workbook();

    sheets.forEach(sheet => workbook
      .addWorksheet(sheet.title)
      .addRows(sheet.rows));

    const buffer = await workbook.xlsx.writeBuffer({base64: true});
    const blob = new Blob([buffer], {type: 'application/octet-stream'});

    saveAs(blob, filename);
  }
}