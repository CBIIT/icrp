import React from 'react';
import { Alert, Button, Checkbox, Col, ControlLabel, Form, FormControl, FormGroup, Grid, HelpBlock, Row } from 'react-bootstrap';
import DatePicker from 'react-datepicker';
import Spinner from '../Spinner/';

import 'react-datepicker/dist/react-datepicker.css';
import './PartnerForm.css';

let Asterisk = () =>
<span className="margin-right red">*</span>

let DisabledOverlay = ({active}) =>
  active
  ? <div className="disabled-overlay"></div>
  : null

const PartnerForm = ({context, form, fields, validation, changeCallback, submitCallback, cancelCallback, loading, message, dismissMessage}) =>
<div>
  <Spinner message="Loading..." visible={loading} />

  <Grid>
    <Row>
      { message.ERROR && <Alert bsStyle="danger" onDismiss={dismissMessage}>{message.ERROR}</Alert> }
      { message.SUCCESS && <Alert bsStyle="success" onDismiss={dismissMessage}>{message.SUCCESS}</Alert> }
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup controlId="select-partner" bsSize="small" validationState={validation.partner === false ? 'error' : null}>
          <ControlLabel className="margin-right">Partner <Asterisk /></ControlLabel>
          <FormControl
            componentClass="select"
            placeholder="Select a Partner"
            value={form.partner}
            onChange={event => changeCallback('partner', event.target['value'])}>
            <option className="disabled" key={0} value="" hidden>Select a partner</option>
            {
              fields.partners.map((field, index) =>
                <option key={`${index}_${field.partner_name}`} value={field.partner_name}>
                  {field.partner_name}
                </option>
              )
            }
          </FormControl>
        { validation.partner === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small" validationState={validation.joinedDate === false ? 'error' : null}>
          <ControlLabel className="margin-right">Joined Date <Asterisk /></ControlLabel>
          <div className="display-flex">
            <DatePicker
              className="form-control form-control-group"
              dateFormat="YYYY-MM-DD"
              selected={form.joinedDate}
              onChange={changeCallback.bind(context, 'joinedDate')}
              onChangeRaw={changeCallback.bind(context, 'joinedDate', null)}
            />
            <div className="form-group-addon-sm">
              { '\uD83D\uDCC5' }
            </div>
          </div>
          { validation.joinedDate === false && <HelpBlock>This field is required.</HelpBlock> }
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
        <FormGroup  controlId="selectEmail" bsSize="small" validationState={validation.email === false ? 'error' : null}>
          <ControlLabel className="margin-right">Email <Asterisk /></ControlLabel>
          <FormControl
            type="email"
            value={form.email}
            maxLength={250}
            onChange={event => changeCallback('email', event.target['value'])}
            placeholder="Enter email for funding organization" />
          <FormControl.Feedback />
          { validation.email === false && <HelpBlock>This field is required.</HelpBlock> }
          { validation.emailFormat === false && <HelpBlock>Please ensure this field is in the proper format.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>

    <Row>
      <Col md={12} className="margin-bottom">
        <FormGroup controlId="partner-description" bsSize="small">
          <ControlLabel className="margin-right">Description <Asterisk /></ControlLabel>
          <div className="padded bordered description">{ form.description }</div>
        </FormGroup>
      </Col>
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup  controlId="partner-sponsor-code" bsSize="small" validationState={validation.sponsorCode === false ? 'error' : null}>
          <ControlLabel className="margin-right">Sponsor Code <Asterisk /></ControlLabel>
          <FormControl
            type="text"
            value={form.sponsorCode}
            maxLength={15}
            onChange={event => changeCallback('sponsorCode', event.target['value'])}
            placeholder="Enter sponsor code" />
          <FormControl.Feedback />
          { validation.sponsorCode === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup  controlId="partner-website" bsSize="small" validationState={null}>
          <ControlLabel className="margin-right">Website</ControlLabel>
          <FormControl
            type="text"
            value={form.website}
            maxLength={100}
            onChange={event => changeCallback('website', event.target['value'])}
            placeholder="Enter website" />
          <FormControl.Feedback />
          { validation.abbreviation === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>



    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup  controlId="partner-map-coordinates" bsSize="small" validationState={null}>
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


      <Col md={6} className="margin-bottom">
        <FormGroup  controlId="partner-logo-file" bsSize="small" validationState={null}>
          <ControlLabel className="margin-right">Logo File</ControlLabel>

            <label className="block normal-weight">
              <div className="display-flex">
                <div className="cursor-text form-control form-control-group">
                  {form.logoFile ? form.logoFile.name : <span className="placeholder">Select a file</span> }
                </div>

                <span className="pointer form-group-addon-sm">Browse...</span>
                <input
                  type="file"
                  name="logo-file"
                  id="logo-file"
                  className="logo-file"
                  onChange={event => changeCallback('logoFile', event.target['files'][0])}
                />
              </div>
            </label>

          <FormControl.Feedback />
          { validation.abbreviation === false && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>

     <FormGroup controlId="partner-note" bsSize="small">
      <ControlLabel>Note</ControlLabel>
      <FormControl
        componentClass="textarea"
        value={form.note}
        maxLength={8000}
        onChange={event => changeCallback('note', event.target['value'])}
        placeholder="Enter note" />
    </FormGroup>


      <FormGroup  className="no-margin" controlId="partner-terms-and-conditions" bsSize="small" validationState={validation.agreeToTerms === false ? 'error' : null}>
        <Checkbox
          checked={form.agreeToTerms}
          onChange={event => changeCallback('agreeToTerms', event.target['checked'])}>
          <span className="semibold margin-right">Agreed to Terms and Conditions</span>
          <Asterisk />
        </Checkbox>
        { validation.agreeToTerms === false && <HelpBlock>This field is required.</HelpBlock> }
      </FormGroup>



    <FormGroup className="no-margin" controlId="partner-funding-organization" bsSize="small" validationState={null}>
      <div className="flex-inline">
        <Checkbox
          checked={form.isFundingOrganization}
          onChange={event => changeCallback('isFundingOrganization', event.target['checked'])}>
          <span className="semibold">Add as a Partner Funding Organization</span>
        </Checkbox>
      </div>

      <FormControl.Feedback />
      { validation.isFundingOrganization === false && <HelpBlock>This field is required.</HelpBlock> }
    </FormGroup>

    <div className="bordered padding-top margin-bottom margin-top position-relative clearfix">
      <DisabledOverlay active={!form.isFundingOrganization} />
      <Form inline>
        <Col md={6} className="margin-bottom">
          <FormGroup controlId="selectOrganizationType" bsSize="small" validationState={validation.organizationType === false ? 'error' : null}>
            <ControlLabel className="margin-right">Organization Type <Asterisk /></ControlLabel>
            <FormControl
              componentClass="select"
              placeholder="Select organization type"
              value={form.organizationType}
              onChange={event => changeCallback('organizationType', event.target['value'])}>
              <option className="disabled" key={0} hidden>Select Organization Type</option>
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
      </Form>

        <Col md={6} className="margin-bottom m-t-4 ">
          <FormGroup className="no-margin" controlId="partner-funding-is-annualized" bsSize="small" validationState={null}>
            <div className="flex-inline">
              <Checkbox
                checked={form.isAnnualized}
                onChange={event => changeCallback('isAnnualized', event.target['checked'])}>
                <b>Annualized Funding</b>
              </Checkbox>
            </div>
          </FormGroup>
        </Col>

    </div>

    <div className="text-center">
      <Button bsStyle="primary" className="margin-right" onClick={submitCallback}>Save</Button>
      <Button onClick={cancelCallback}>Cancel</Button>
    </div>

  </Grid>
</div>

export default PartnerForm;
