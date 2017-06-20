import React from 'react';
import { Button, Checkbox, Col, Form, FormGroup, Grid, Radio, ControlLabel, FormControl, Row } from 'react-bootstrap';

let Asterisk = () =>
<span className="margin-right red">*</span>

const FundingOrganizationForm = ({form, fields, controlRefs, changeCallback}) =>
<div>

  <Grid>

    <Row className="bordered padding-top margin-bottom">
      <Form inline>
        <Col md={6} className="margin-bottom">
          <FormGroup controlId="selectPartner" bsSize="small">
            <ControlLabel className="margin-right">Partner <Asterisk /></ControlLabel>
            <FormControl
              componentClass="select"
              placeholder="Select Partner Organization"
              value={form.partner}
              onChange={event => changeCallback('partner', event.target.value)}>
              <option className="disabled" key={0} hidden>Select a Partner</option>
              {
                fields.partners.map((field, index) =>
                  <option key={`${index}_${field.value}`} value={field.value}>
                    {field.label}
                  </option>
                )
              }
            </FormControl>
          </FormGroup>
        </Col>

        <Col md={6} className="margin-bottom">
          <Row>

            <Col md={4}>
              <ControlLabel className="margin-right">Member Type <Asterisk /></ControlLabel>
            </Col>

            <Col md={3}>
              <Radio
                name="memberType"
                value="Partner"
                checked={form.memberType === 'Partner'}
                onChange={event => changeCallback(event.target.name, event.target.value)}
                inline>
                Partner
              </Radio>
            </Col>

            <Col md={3}>
              <Radio
                name="memberType"
                value="Associate"
                checked={form.memberType === 'Associate'}
                onChange={event => changeCallback(event.target.name, event.target.value)}
                inline>
                Associate
              </Radio>
            </Col>
          </Row>

        </Col>
      </Form>
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small">
          <ControlLabel className="margin-right">Name <Asterisk /></ControlLabel>
          <FormControl
            type="text"
            value={form.name}
            onChange={event => changeCallback('name', event.target.value)}
            placeholder="Enter name of funding organization" />
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small">
          <ControlLabel className="margin-right">Abbreviation <Asterisk /></ControlLabel>
          <FormControl
            type="text"
            value={form.abbreviation}
            onChange={event => changeCallback('abbreviation', event.target.value)}
            placeholder="Enter abbreviation for funding organization" />
        </FormGroup>
      </Col>
    </Row>


    <Row>
      <Col md={6} className="margin-bottom">
          <FormGroup controlId="selectOrganizationType" bsSize="small">
            <ControlLabel className="margin-right">Organization Type <Asterisk /></ControlLabel>
            <FormControl
              componentClass="select"
              placeholder="Select Partner Organization Type"
              value={form.organizationType}
              onChange={event => changeCallback('organizationType', event.target.value)}>
              <option className="disabled" key={0} hidden>Select Organization Type</option>
              {
                fields.organizationTypes.map((field, index) =>
                  <option key={`${index}_${field}`} value={field}>
                    {field}
                  </option>
                )
              }
            </FormControl>
          </FormGroup>

      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small">
          <ControlLabel className="visible-responsive">{' '}</ControlLabel>

          <Checkbox
            checked={form.annualizedFunding}
            onChange={event => changeCallback('annualizedFunding', event.target.checked)}>
            <b>Annualized Funding</b> <Asterisk />
          </Checkbox>
        </FormGroup>
      </Col>
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup controlId="selectCountry" bsSize="small">
          <ControlLabel className="margin-right">Country <Asterisk /></ControlLabel>
          <FormControl
            componentClass="select"
            placeholder="Select a Country"
            value={form.country}
            onChange={event => changeCallback('country', event.target.value)}>
            <option className="disabled" key={0} hidden>Select a Country</option>
            {
              fields.countries.map((field, index) =>
                <option key={`${index}_${field.value}`} value={field.value}>
                  {field.label}
                </option>
              )
            }
          </FormControl>
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup controlId="selectCurrency" bsSize="small">
          <ControlLabel className="margin-right">Currency <Asterisk /></ControlLabel>
          <FormControl
            componentClass="select"
            placeholder="Select Currency Type"
            value={form.currency}
            onChange={event => changeCallback('currency', event.target.value)}>
            <option className="disabled" key={0} hidden>Select a Currency</option>
            {
              fields.currencies.map((field, index) =>
                <option key={`${index}_${field.value}`} value={field.value}>
                  {field.label}
                </option>
              )
            }
          </FormControl>
        </FormGroup>
      </Col>
    </Row>

    <FormGroup bsSize="small">
      <ControlLabel className="margin-right">Note</ControlLabel>
      <FormControl
        componentClass="textarea"
        placeholder="Enter notes"
        value={form.note}
        onChange={event => changeCallback('note', event.target.value)}
      />
    </FormGroup>

    <div className="text-center">
      <Button bsStyle="primary" className="margin-right">Save</Button>
      <Button>Cancel</Button>
    </div>

  </Grid>


</div>

export default FundingOrganizationForm;
