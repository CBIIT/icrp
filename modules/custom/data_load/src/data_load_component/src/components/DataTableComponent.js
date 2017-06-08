import React, { Component } from 'react';
import {
    Table,
    Pagination,
} from 'react-bootstrap';
const uuidV4 = require('uuid/v4');

class TableHeader extends Component {
    render() {
        return (
            <tr>
                <th>Internal ID</th>
                <th>Award Code</th>
                <th>Award Start Date</th>
                <th>Award End Date</th>
                <th>Source</th>
                <th>Alt ID</th>
                <th>Award Title</th>
                <th>Category</th>
                <th>Award Type</th>
                <th>Childhood</th>
                <th>Budget Start Date</th>
                <th>Budget End Date</th>
                <th>CSO Codes</th>
                <th>CSO Rel</th>
                <th>Site COdes</th>
                <th>Site Rel</th>
                <th>Award Funding</th>
                <th>Annualized</th>
                <th>Funding Mechanism Code</th>
                <th>Funding Mechanism</th>
                <th>Funding Org Abbr</th>
                <th>Funding Div</th>
                <th>Funding Div Abbr</th>
                <th>Funding Contact</th>
                <th>PI Last Name</th>
                <th>PI First Name</th>
                <th>Submitted Institution</th>
                <th>City</th>
                <th>State</th>
                <th>Country</th>
                <th>Zip Code</th>
                <th>Institution ICRP</th>
                <th>Latitude</th>
                <th>Longitude</th>
                <th>GRID</th>
                <th>Tech Abstract</th>
                <th>Public Abstract</th>
                <th>Related Award Code</th>
                <th>Relationship Type</th>
                <th>ORCID</th>
                <th>Other Researcher ID</th>
                <th>Other Researcher ID Type</th>

            </tr>
        );
    }
}

class DataRow extends Component {
    render() {
        return (
            <tr>
                <td>{this.props.internalId}</td>
                <td>{this.props.awardCode}</td>
                <td>{this.props.awardStartDate}</td>
                <td>{this.props.awardEndDate}</td>
                <td>{this.props.source}</td>
                <td>{this.props.altId}</td>
                <td>{this.props.awardTitle}</td>
                <td>{this.props.category}</td>
                <td>{this.props.awardType}</td>
                <td>{this.props.childHood}</td>
                <td>{this.props.budgetStartDate}</td>
                <td>{this.props.budgetEndDate}</td>
                <td>{this.props.csoCodes}</td>
                <td>{this.props.csoRel}</td>
                <td>{this.props.siteCodes}</td>
                <td>{this.props.siteRel}</td>
                <td>{this.props.awardFunding}</td>
                <td>{this.props.isAnnualized}</td>
                <td>{this.props.fundingMechanismCode}</td>
                <td>{this.props.fundingMechanism}</td>
                <td>{this.props.fundingOrgAbbr}</td>
                <td>{this.props.fundingDiv}</td>
                <td>{this.props.fundingDivAbbr}</td>
                <td>{this.props.fundingContact}</td>
                <td>{this.props.piLastName}</td>
                <td>{this.props.piFirstName}</td>
                <td>{this.props.submittedInstitution}</td>
                <td>{this.props.city}</td>
                <td>{this.props.state}</td>
                <td>{this.props.country}</td>
                <td>{this.props.postalZipCode}</td>
                <td>{this.props.institutionICRP}</td>
                <td>{this.props.latitude}</td>
                <td>{this.props.longitude}</td>
                <td>{this.props.grid}</td>
                <td>{this.props.techAbstract}</td>
                <td>{this.props.publicAbstract}</td>
                <td>{this.props.relatedAwardCode}</td>
                <td>{this.props.relationshipType}</td>
                <td>{this.props.orcid}</td>
                <td>{this.props.otherResearcherId}</td>
                <td>{this.props.otherResearcherIdType}</td>
            </tr>

        );
    }
}

class TablePagination extends Component {

    constructor(props) {
        super(props);
        this.handlePageSelection = this.handlePageSelection.bind(this);
    }

    handlePageChange(page, projects) {
        this.props.onPageChange(page, projects);
    }

    async handlePageSelection(e) {
        let page = e;
        var data = new FormData();
        data.append("page", page);
        var that = this;
        let response = await fetch('http://icrp-dataload/getdata_mssql/', { method: 'POST', body: data });

        if (response.ok) {
            let result = await response.json();
            const projects = result.projects;
            that.handlePageChange(page, projects);
        } else {
            alert("Oops! ");
        }
    }

    render() {

        const totalPages = this.props.stats.totalPages;
        const page = this.props.stats.page;
        return (
            <Pagination
                bsSize="medium"
                prev
                next
                first
                last
                ellipsis={totalPages <= 4 ? false : true}
                boundaryLinks
                items={totalPages}
                maxButtons={4}
                activePage={page}
                onSelect={this.handlePageSelection} />
        );
    }
}


class DataTableComponent extends Component {

    render() {
        let rows = [];
        this.props.projects.forEach(row => {
            rows.push(<DataRow internalId={row.InternalId}
                awardCode={row.AwardCode}
                awardStartDate={row.AwardStartDate}
                awardEndDate={row.AwardEndDate}
                source={row.Aource}
                altId={row.AltId}
                awardTitle={row.AwardTitle}
                category={row.Category}
                awardType={row.AwardType}
                childHood={row.ChildHood}
                budgetStartDate={row.BudgetStartDate}
                budgetEndDate={row.BudgetEndDate}
                csoCodes={row.CSOCodes}
                csoRel={row.CSORel}
                siteCodes={row.SiteCodes}
                siteRel={row.SiteRel}
                awardFunding={row.AwardFunding}
                isAnnualized={row.IsAnnualized}
                fundingMechanismCode={row.FundingMechanismCode}
                fundingMechanism={row.FundingMechanism}
                fundingOrgAbbr={row.FundingOrgAbbr}
                fundingDiv={row.FundingDiv}
                fundingDivAbbr={row.FundingDivAbbr}
                fundingContact={row.FundingContact}
                piLastName={row.PILastName}
                piFirstName={row.PIFirstName}
                submittedInstitution={row.SubmittedInstitution}
                city={row.City}
                state={row.State}
                country={row.Country}
                postalZipCode={row.PostalZipCode}
                institutionICRP={row.InstitutionICRP}
                latitude={row.Latitute}
                longitude={row.Longitute}
                grid={row.GRID}
                techAbstract= 'details' //{row.TechAbstract}
                publicAbstract= 'details' //{row.PublicAbstract}
                relatedAwardCode={row.RelatedAwardCode}
                relationshipType={row.RelationshipType}
                orcid={row.ORCID}
                otherResearcherId={row.OtherResearcherID}
                otherResearcherIdType={row.OtherResearcherIDType}
                key={uuidV4()} />)
        });
        return (
            <div>
                Total Records: {this.props.stats.totalRows}
                < Table responsive striped bordered condensed hover>
                    <thead>
                        <TableHeader />
                    </thead>
                    <tbody>
                        {rows}
                    </tbody>
                </Table >
                Page {this.props.stats.page} of {this.props.stats.totalPages} (Showing {this.props.stats.showingFrom} - {this.props.stats.showingTo} of {this.props.stats.totalRows}) < br />
                <TablePagination stats={this.props.stats} onPageChange={this.props.onPageChange} />
            </div>
        );
    }
}

export default DataTableComponent;