import React from 'react';
import { Alert, Button, Checkbox, Col, Form, FormGroup, Grid, Radio, ControlLabel, FormControl, Row, HelpBlock } from 'react-bootstrap';
import Spinner from '../Spinner/';
import './FundingOrganizationForm.css';

let Asterisk = () =>
<span className="margin-right red">*</span>

const FundingOrganizationForm = ({form, fields, validation, changeCallback, submitCallback, cancelCallback, loading, message, dismissMessage}) =>
<div>
  <Spinner message="Loading..." visible={loading} />

  <Grid>
    <Row>
      { message.ERROR && <Alert bsStyle="danger" onDismiss={dismissMessage}>{message.ERROR}</Alert> }
      { message.SUCCESS && <Alert bsStyle="success" onDismiss={dismissMessage}>{message.SUCCESS}</Alert> }
    </Row>

    <Row className="bordered padding-top margin-bottom">
      <Form inline>
        <Col md={6} className="margin-bottom">
          <FormGroup controlId="selectPartner" bsSize="small" validationState={validation.partner === false ? 'error' : null}>
            <ControlLabel className="margin-right">Partner <Asterisk /></ControlLabel>
            <FormControl
              componentClass="select"
              placeholder="Select Partner Organization"
              value={form.partner}
              onChange={event => changeCallback('partner', event.target['value'])}>
              <option className="disabled" key={0} hidden>Select a Partner</option>
              {
                fields.partners.map((field, index) =>
                  <option key={`${index}_${field.value}`} value={field.value}>
                    {field.label}
                  </option>
                )
              }
            </FormControl>
            { validation.partner === false && <HelpBlock>This field is required.</HelpBlock> }
          </FormGroup>
        </Col>

        <Col md={6} className="margin-bottom">
          <Row className="m-t-3">

            <Col md={4}>
              <ControlLabel className="margin-right">Member Type <Asterisk /></ControlLabel>
            </Col>

            <Col md={3}>
              <Radio
                name="memberType"
                value="Partner"
                checked={form.memberType === 'Partner'}
                onChange={event => changeCallback(event.target['name'], event.target['value'])}
                inline>
                Partner
              </Radio>
            </Col>

            <Col md={3}>
              <Radio
                name="memberType"
                value="Associate"
                checked={form.memberType === 'Associate'}
                onChange={event => changeCallback(event.target['name'], event.target['value'])}
                inline>
                Associate
              </Radio>
            </Col>
          </Row>
          { validation.memberType === false && <HelpBlock>This field is required.</HelpBlock> }

        </Col>
      </Form>
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small" validationState={validation.name === false ? 'error' : null}>
          <ControlLabel className="margin-right">Name <Asterisk /></ControlLabel>
          <FormControl
            type="text"
            value={form.name}
            maxLength={100}
            onChange={event => changeCallback('name', event.target['value'])}
            placeholder="Enter name of funding organization"
          />
          <FormControl.Feedback />
          { validation.name === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small" validationState={validation.abbreviation === false ? 'error' : null}>
          <ControlLabel className="margin-right">Abbreviation <Asterisk /></ControlLabel>
          <FormControl
            type="text"
            value={form.abbreviation}
            maxLength={15}
            onChange={event => changeCallback('abbreviation', event.target['value'])}
            placeholder="Enter abbreviation for funding organization" />
          <FormControl.Feedback />
          { validation.abbreviation === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>


    <Row>
      <Col md={6} className="margin-bottom">
          <FormGroup controlId="selectOrganizationType" bsSize="small" validationState={validation.organizationType === false ? 'error' : null}>
            <ControlLabel className="margin-right">Organization Type <Asterisk /></ControlLabel>
            <FormControl
              componentClass="select"
              placeholder="Select Partner Organization Type"
              value={form.organizationType}
              onChange={event => changeCallback('organizationType', event.target['value'])}>
              <option className="disabled" key={0} hidden>Select organization type</option>
              {
                fields.organizationTypes.map((field, index) =>
                  <option key={`${index}_${field}`} value={field}>
                    {field}
                  </option>
                )
              }
            </FormControl>
            { validation.organizationType === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>

      </Col>

      <Col md={6} className="margin-bottom">

        <FormGroup bsSize="small" validationState={validation.mapCoordinates === false ? 'error' : null}>
          <ControlLabel className="margin-right">Map Coordinates</ControlLabel>
          <FormControl
            type="text"
            value={form.mapCoordinates}
            maxLength={50}
            onChange={event => changeCallback('mapCoordinates', event.target['value'])}
            placeholder="Enter map coordinates" />
          <FormControl.Feedback />
          { validation.mapCoordinates === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>

      </Col>
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup controlId="selectCountry" bsSize="small" validationState={validation.country === false ? 'error' : null}>
          <ControlLabel className="margin-right">Country <Asterisk /></ControlLabel>
          <FormControl
            componentClass="select"
            placeholder="Select a Country"
            value={form.country}
            onChange={event => changeCallback('country', event.target['value'])}>
            <option className="disabled" key={0} hidden>Select a country</option>
            {
              fields.countries.map((field, index) =>
                <option key={`${index}_${field.value}`} value={field.value}>
                  {field.label}
                </option>
              )
            }
          </FormControl>
        { validation.country === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup controlId="selectCurrency" bsSize="small" validationState={validation.currency === false ? 'error' : null}>
          <ControlLabel className="margin-right">Currency <Asterisk /></ControlLabel>
          <FormControl
            componentClass="select"
            placeholder="Select Currency Type"
            value={form.currency}
            onChange={event => changeCallback('currency', event.target['value'])}>
            <option className="disabled" key={0} hidden>Select a currency</option>
            {
              fields.currencies.map((field, index) =>
                <option key={`${index}_${field.value}`} value={field.value}>
                  {field.label}
                </option>
              )
            }
          </FormControl>
          { validation.currency === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>

    <FormGroup bsSize="small">
      <ControlLabel className="margin-right">Note</ControlLabel>
      <FormControl
        componentClass="textarea"
        placeholder="Enter notes"
        maxLength={8000}
        value={form.note}
        onChange={event => changeCallback('note', event.target['value'])}
      />
    </FormGroup>

    <FormGroup bsSize="small">
      <Checkbox
        checked={form.annualizedFunding}
        onChange={event => changeCallback('annualizedFunding', event.target['checked'])}>
        <b>Annualized Funding</b>
      </Checkbox>
    </FormGroup>


    <div className="text-center">
      <Button bsStyle="primary" className="margin-right" onClick={submitCallback}>Save</Button>
      <Button onClick={cancelCallback}>Cancel</Button>
    </div>

  </Grid>
</div>

export default FundingOrganizationForm;
