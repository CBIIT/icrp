import React from 'react';
import { Alert, Button, Checkbox, Col, ControlLabel, DropdownButton, InputGroup, Form, FormControl, FormGroup, Grid, HelpBlock, MenuItem, Row } from 'react-bootstrap';
import DatePicker from 'react-datepicker';
import DisabledOverlay from '../DisabledOverlay/';
import 'react-datepicker/dist/react-datepicker.css';
import './PartnerForm.css';

const Asterisk = () => <span className='margin-right red'>*</span>

const PartnerForm = ({context, form, changeCallback, submitCallback, resetCallback, dismissMessageCallback}) =>
<div>
  <div className='form-group'>
    {
      form && form.fields && form.fields.partners && form.fields.partners.length > 0
      ? 'Select a completed application to add as an ICRP partner.'
      : 'There are no completed applications available in the database.'
    }
  </div>

  <Grid>
    {
      form && form.messages.map((message, index) =>
        <Row key={index}>
          { message.ERROR && <Alert bsStyle='danger' onDismiss={dismissMessageCallback.bind(context, index)}>{message.ERROR}</Alert> }
          { message.SUCCESS &&
            <Alert bsStyle='success' onDismiss={dismissMessageCallback.bind(context, index)}>
              This partner has been successfully saved. You can go to <a
                target='_blank'
                rel='noopener noreferrer'
                href={`${window.location.protocol}//${window.location.hostname}/current_partners`}
              >Current Partners</a> to view a list of current ICRP partners.
            </Alert> }
        </Row>
      )
    }

    <Row>
      <Col md={6} className='margin-bottom'>
        <FormGroup controlId='select-partner' bsSize='small' validationState={form.validationErrors.partner && form.validationErrors.partner.required ? 'error' : null}>
          <ControlLabel className='margin-right'>Partner <Asterisk /></ControlLabel>
          <FormControl
            componentClass='select'
            placeholder='Select a Partner'
            value={form.values.partner}
            onChange={event => changeCallback('partner', event.target['value'])}>
            <option className='disabled' key={0} value='' hidden>Select a partner</option>
            {
              form.fields.partners.map((field, index) =>
                <option key={`${index}_${field.partner_name}`} value={field.partner_name}>
                  {field.partner_name}
                </option>
              )
            }
          </FormControl>
        { form.validationErrors.partner && form.validationErrors.partner.required && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>

      <Col md={6} className='margin-bottom'>
        <FormGroup bsSize='small' validationState={form.validationErrors.joinedDate && (form.validationErrors.joinedDate.required || form.validationErrors.joinedDate.format) ? 'error' : null}>
          <ControlLabel className='margin-right'>Joined Date <Asterisk /></ControlLabel>
          <div className='display-flex'>
            <DatePicker
              className='form-control form-control-group'
              dateFormat='YYYY-MM-DD'
              selected={form.values.joinedDate}
              onChange={changeCallback.bind(context, 'joinedDate')}
              onChangeRaw={changeCallback.bind(context, 'joinedDate', null)}
            />
            <div className='form-group-addon-sm'>
              { '\uD83D\uDCC5' }
            </div>
          </div>
          { form.validationErrors.joinedDate && form.validationErrors.joinedDate.required && <HelpBlock>This field is required.</HelpBlock> }
          { form.validationErrors.joinedDate && form.validationErrors.joinedDate.format && <HelpBlock>Please ensure this field is in the proper format.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>


    <Row>
      <Col md={6} className='margin-bottom'>
        <FormGroup controlId='selectCountry' bsSize='small' validationState={form.validationErrors.country && form.validationErrors.country.required ? 'error' : null}>
          <ControlLabel className='margin-right'>Country <Asterisk /></ControlLabel>
          <FormControl
            componentClass='select'
            placeholder='Select a Country'
            value={form.values.country}
            onChange={event => changeCallback('country', event.target['value'])}>
            <option className='disabled' key={0} hidden>Select a country</option>
            {
              form.fields.countries.map((field, index) =>
                <option key={`${index}_${field.value}`} value={field.value}>
                  {field.label}
                </option>
              )
            }
          </FormControl>
        { form.validationErrors.country && form.validationErrors.country.required && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>

      <Col md={6} className='margin-bottom'>
        <FormGroup  controlId='selectEmail' bsSize='small' validationState={form.validationErrors.email && (form.validationErrors.email.required || form.validationErrors.email.format) ? 'error' : null}>
          <ControlLabel className='margin-right'>Email <Asterisk /></ControlLabel>
          <FormControl
            type='email'
            value={form.values.email}
            maxLength={250}
            onChange={event => changeCallback('email', event.target['value'])}
            placeholder='Enter email for funding organization' />
          <FormControl.Feedback />
          { form.validationErrors.email && form.validationErrors.email.required && <HelpBlock>This field is required.</HelpBlock> }
          { form.validationErrors.email && form.validationErrors.email.format && <HelpBlock>Please ensure this field is in the proper format.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>

    <Row>
      <Col md={12} className='margin-bottom'>
        <FormGroup controlId='partner-description' bsSize='small' validationState={form.validationErrors.description && form.validationErrors.description.required ? 'error' : null}>
          <ControlLabel className='margin-right'>Description <Asterisk /></ControlLabel>
          <FormControl
            componentClass='textarea'
            value={form.values.description}
            maxLength={8000}
            onChange={event => changeCallback('description', event.target['value'])}
            placeholder='Enter description' />
          <FormControl.Feedback />
          { form.validationErrors.description && form.validationErrors.description.required && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>
    </Row>

    <Row>
      <Col md={6} className='margin-bottom'>
        <FormGroup  controlId='partner-sponsor-code' bsSize='small' validationState={form.validationErrors.sponsorCode && form.validationErrors.sponsorCode.required ? 'error' : null}>
          <ControlLabel className='margin-right'>Sponsor Code <Asterisk /></ControlLabel>
          <FormControl
            type='text'
            value={form.values.sponsorCode}
            maxLength={15}
            onChange={event => changeCallback('sponsorCode', event.target['value'])}
            placeholder='Enter sponsor code' />
          <FormControl.Feedback />
          { form.validationErrors.sponsorCode && form.validationErrors.sponsorCode.required && <HelpBlock>This field is required.</HelpBlock> }
        </FormGroup>
      </Col>


      <Col md={6} className='margin-bottom'>
        <FormGroup  controlId='partner-website' bsSize='small' validationState={null}>
          <ControlLabel className='margin-right'>Website</ControlLabel>
          <div className='display-flex'>
            <span className='display-flex'>
              <DropdownButton
                className='form-group-addon-left-sm'
                title={form.values.urlProtocol}
                id='select-website-protocol'
              >
                {
                  form.fields.urlProtocols.map((field, index) =>
                    <MenuItem
                      onClick={event => changeCallback('urlProtocol', field.value)}
                      key={field.value}
                      value={field.value}>
                        {field.label}
                      </MenuItem>
                  )
                }
              </DropdownButton>
            </span>
              <FormControl
                className='form-group-addon-right-sm'
                type='text'
                value={form.values.website}
                maxLength={100}
                onChange={event => changeCallback('website', event.target['value'])}
                placeholder='Enter website' />
            </div>
          <FormControl.Feedback />
        </FormGroup>
      </Col>
    </Row>



    <Row className='margin-bottom'>
      <Col md={6} >
        <ControlLabel className='margin-right'>Map Coordinates <Asterisk /></ControlLabel>

        <Row>
          <Col md={6} className="form-group-sm">
            <input
              type="number"
              className="form-control form-control-sm"
              value={form.values.latitude}
              onChange={event => changeCallback('latitude', event.target['value'])}
              max="90"
              min="-90"
              placeholder='Enter latitude'
              title="Latitude"
            />
          </Col>

          <Col md={6} className="form-group-sm">
            <input
              type="number"
              className="form-control form-control-sm"
              value={form.values.longitude}
              onChange={event => changeCallback('longitude', event.target['value'])}
              max="180"
              min="-180"
              placeholder='Enter longitude'
              title="Longitude"
            />
          </Col>
        </Row>

        {
          ((form.validationErrors.latitude && form.validationErrors.latitude.required) ||
          (form.validationErrors.longitude && form.validationErrors.longitude.required)) &&
          <div className="help-block">
            Both latitude and longitude should be provided.
          </div>
        }

        {
          form.validationErrors.latitude &&
          ( form.validationErrors.latitude.min ||
            form.validationErrors.latitude.max) &&
          <div className="help-block">
            The latitude should be provided as a decimal number between -90 and 90.
          </div>
        }

        {
          form.validationErrors.longitude &&
          ( form.validationErrors.longitude.min ||
            form.validationErrors.longitude.max) &&
          <div className="help-block">
            The longitude should be provided as a decimal number between -180 and 180.
          </div>
        }
      </Col>


      <Col md={6} className='margin-bottom'>
        <FormGroup  controlId='partner-logo-file' bsSize='small' validationState={null}>
          <ControlLabel className='margin-right'>Logo File</ControlLabel>
          <i>(jpg, png or gif)</i>

            <label className='block normal-weight'>
              <div className='display-flex'>
                <div className='cursor-text form-control form-control-group'>
                  {form.values.logoFile ? form.values.logoFile.name : <span className='placeholder'>Select file</span> }
                </div>

                <span className='pointer form-group-addon-sm'>Browse...</span>
                <input
                  type='file'
                  name='logo-file'
                  id='logo-file'
                  className='logo-file'
                  accept='image/x-png,image/gif,image/jpeg'
                  onChange={event => changeCallback('logoFile', event.target['files'][0])}
                />
              </div>
            </label>

          <FormControl.Feedback />
        </FormGroup>
      </Col>
    </Row>

     <FormGroup controlId='partner-note' bsSize='small'>
      <ControlLabel>Note</ControlLabel>
      <FormControl
        componentClass='textarea'
        value={form.values.note}
        maxLength={8000}
        onChange={event => changeCallback('note', event.target['value'])}
        placeholder='Enter note' />
    </FormGroup>

      <FormGroup  className='no-margin' controlId='partner-terms-and-conditions' bsSize='small' validationState={null}>
        <Checkbox
          checked={form.values.agreeToTerms}
          onChange={event => changeCallback('agreeToTerms', event.target['checked'])}>
          <span className='semibold margin-right'>Agreed to Terms and Conditions</span>
        </Checkbox>
      </FormGroup>

    <FormGroup className='no-margin' controlId='partner-funding-organization' bsSize='small' validationState={null}>
      <div className='flex-inline'>
        <Checkbox
          checked={form.values.isFundingOrganization}
          onChange={event => changeCallback('isFundingOrganization', event.target['checked'])}>
          <span className='semibold'>Add as a Partner Funding Organization</span>
        </Checkbox>
      </div>

      <FormControl.Feedback />
    </FormGroup>

    <div className='bordered padding-top margin-bottom margin-top position-relative clearfix'>
      <DisabledOverlay active={!form.values.isFundingOrganization} />
      <Form inline>
        <Col md={6} className='margin-bottom'>
          <FormGroup controlId='selectOrganizationType' bsSize='small' validationState={form.validationErrors.organizationType && form.validationErrors.organizationType.required ? 'error' : null}>
            <ControlLabel className='margin-right'>Organization Type <Asterisk /></ControlLabel>
            <FormControl
              componentClass='select'
              placeholder='Select organization type'
              value={form.values.organizationType}
              onChange={event => changeCallback('organizationType', event.target['value'])}>
              <option className='disabled' key={0} hidden>Select organization type</option>
              {
                form.fields.organizationTypes.map((field, index) =>
                  <option key={`${index}_${field}`} value={field.value}>
                    {field.label}
                  </option>
                )
              }
            </FormControl>
            { form.validationErrors.organizationType && form.validationErrors.organizationType.required && <HelpBlock>This field is required.</HelpBlock> }
          </FormGroup>
        </Col>

        <Col md={6} className='margin-bottom'>
          <FormGroup controlId='selectCurrency' bsSize='small' validationState={form.validationErrors.currency && form.validationErrors.currency.required ? 'error' : null}>
            <ControlLabel className='margin-right'>Currency <Asterisk /></ControlLabel>
            <FormControl
              componentClass='select'
              placeholder='Select Currency Type'
              value={form.values.currency}
              onChange={event => changeCallback('currency', event.target['value'])}>
              <option className='disabled' key={0} hidden>Select currency</option>
              {
                form.fields.currencies.map((field, index) =>
                  <option key={`${index}_${field.value}`} value={field.value}>
                    {field.value}
                  </option>
                )
              }
            </FormControl>
            { form.validationErrors.currency && form.validationErrors.currency.required && <HelpBlock>This field is required.</HelpBlock> }
          </FormGroup>
        </Col>
      </Form>
      <Col md={12} className='margin-bottom'>
        <FormGroup className='no-margin' controlId='partner-funding-is-annualized' bsSize='small' validationState={null}>
          <div className='flex-inline'>
            <Checkbox
              checked={form.values.isAnnualized}
              onChange={event => changeCallback('isAnnualized', event.target['checked'])}>
              <b>Annualized Funding</b>
            </Checkbox>
          </div>
        </FormGroup>
      </Col>
    </div>

    <div className='text-center'>
      <Button bsStyle='primary' className='margin-right' onClick={submitCallback}>Save</Button>
      <Button onClick={resetCallback}>Cancel</Button>
    </div>

  </Grid>
</div>

export default PartnerForm;
