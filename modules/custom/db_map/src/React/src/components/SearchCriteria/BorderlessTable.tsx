import * as React from 'react';

interface BorderlessTableProps {
  rows: any[][];
}

export const BorderlessTable = ({rows}: BorderlessTableProps) => (
  <table>
    <tbody>
    {rows.map((row, rowIndex) =>
      <tr key={rowIndex}>
      {row.map((data, columnIndex) =>
        <td
          key={`${rowIndex}_${columnIndex}`}
          style={{
            padding: '4px 10px',
            fontWeight: columnIndex === 0 ? 'bold' : 'normal'
          }}>
          {data}
        </td>)}
      </tr>
    )}
    </tbody>
  </table>
);
