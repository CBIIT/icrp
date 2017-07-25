import React, { Component } from 'react';
import {
    Table
} from 'react-bootstrap';
const uuidV4 = require('uuid/v4');

const TableHeader = ({ headers }) =>
    <tr>
        {Object.values(headers).map(header => <th>{header}</th>)}
    </tr>

const DataRow = ({ object }) =>
    <tr>
        {Object.values(object).map(value => <td>{value}</td>)}
    </tr>

class DataTableComponent extends Component {

    render() {
        let keys = this.props.details.length > 0 ? Object.keys(this.props.details[0]) : [];

        let rows = [];
        this.props.details.forEach(row => {
            rows.push(<DataRow object={row} key={uuidV4()} />)
        });
        return (
            <div>
                < Table striped responsive bordered condensed hover>
                    <thead>
                        <TableHeader headers={keys} />
                    </thead>
                    <tbody>
                        {rows}
                    </tbody>
                </Table >
            </div>
        );
    }
}

export default DataTableComponent;