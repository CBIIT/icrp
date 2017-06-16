import React, { Component } from 'react';
import {
    Table
} from 'react-bootstrap';
const uuidV4 = require('uuid/v4');

class TableHeader extends Component {
    render() {
        return (
            <tr>
                <th>Award Code</th>
                <th>Alt Award Code</th>
                <th>Budget Start Date</th>
                <th>Budget End Date</th>
                <th>CSO Codes</th>
                <th>CSO Rel</th>
                <th>Site Codes</th>
                <th>Site Rel</th>
            </tr>
        );
    }
}

class DataRow extends Component {
    render() {
        return (
            <tr>
                <td>{this.props.awardCode}</td>
                <td>{this.props.altAwardDate}</td>
                <td>{this.props.budgetStartDate}</td>
                <td>{this.props.budgetEndDate}</td>
                <td>{this.props.csoCodes}</td>
                <td>{this.props.csoRel}</td>
                <td>{this.props.siteCodes}</td>
                <td>{this.props.siteRel}</td>
            </tr>

        );
    }
}

class DataTableComponent extends Component {

    render() {
        let rows = [];
        this.props.details.forEach(row => {
            rows.push(<DataRow
                awardCode={row.AwardCode}
                source={row.AltAwardCode}
                budgetStartDate={row.BudgetStartDate}
                budgetEndDate={row.BudgetEndDate}
                csoCodes={row.CSOCodes}
                csoRel={row.CSORel}
                siteCodes={row.SiteCodes}
                siteRel={row.SiteRel}
                key={uuidV4()} />)
        });
        return (
            <div>
                < Table striped responsive bordered condensed hover>
                    <thead>
                        <TableHeader />
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