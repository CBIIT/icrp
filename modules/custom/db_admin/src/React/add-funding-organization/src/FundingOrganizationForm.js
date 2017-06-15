import React from 'react';
import { Button, Checkbox, Col, Form, FormGroup, Grid, Radio, ControlLabel, FormControl, Row } from 'react-bootstrap';

let Asterisk = () =>
<span className="margin-right red">*</span>

const FundingOrganizationForm = ({state, changeCallback, validationCallback}) =>
<div>

  <Grid>

    <Row className="bordered padding-top margin-bottom">
      <Form inline>
        <Col md={6} className="margin-bottom">
          <FormGroup controlId="partnerSelect" bsSize="small">
            <ControlLabel className="margin-right">Partner <Asterisk /></ControlLabel>
            <FormControl componentClass="select" placeholder="Select Partner Organization">
              <option value="one">1</option>
              <option value="two">2</option>
              <option value="three">2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three  </option>
            </FormControl>
          </FormGroup>
        </Col>

        <Col md={6} className="margin-bottom">
          <Row>

            <Col md={4}>
              <ControlLabel className="margin-right">Member Type <Asterisk /></ControlLabel>
            </Col>


            <Col md={3}>
              <Radio name="memberType"  inline>
                Partner
              </Radio>
            </Col>

            <Col md={3}>
              <Radio name="memberType" inline>
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
          <FormControl type="text" placeholder="Enter name of funding organization" />
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small">
          <ControlLabel className="margin-right">Abbreviation <Asterisk /></ControlLabel>
          <FormControl type="text" placeholder="Enter abbreviation for funding organization" />
        </FormGroup>
      </Col>
    </Row>


    <Row>
      <Col md={6} className="margin-bottom">
          <FormGroup controlId="partnerSelect" bsSize="small">
            <ControlLabel className="margin-right">Organization Type <Asterisk /></ControlLabel>
            <FormControl componentClass="select" placeholder="Select Partner Organization">
              <option value="one">1</option>
              <option value="two">2</option>
              <option value="three">2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three  </option>
            </FormControl>
          </FormGroup>

      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup bsSize="small">
          <ControlLabel className="visible-responsive">{' '}</ControlLabel>

          <Checkbox>
            <b>Annualized Funding</b> <Asterisk />
          </Checkbox>
        </FormGroup>
      </Col>
    </Row>

    <Row>
      <Col md={6} className="margin-bottom">
        <FormGroup controlId="partnerSelect" bsSize="small">
          <ControlLabel className="margin-right">Country <Asterisk /></ControlLabel>
          <FormControl componentClass="select" placeholder="Select Partner Organization">
            <option value="one">1</option>
            <option value="two">2</option>
            <option value="three">2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three  </option>
          </FormControl>
        </FormGroup>
      </Col>

      <Col md={6} className="margin-bottom">
        <FormGroup controlId="partnerSelect" bsSize="small">
          <ControlLabel className="margin-right">Currency <Asterisk /></ControlLabel>
          <FormControl componentClass="select" placeholder="Select Partner Organization">
            <option value="one">1</option>
            <option value="two">2</option>
            <option value="three">2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three 2 three  </option>
          </FormControl>
        </FormGroup>
      </Col>
    </Row>

    <FormGroup bsSize="small">
      <ControlLabel className="margin-right">Note</ControlLabel>
      <FormControl componentClass="textarea" placeholder="Enter name of funding organization" />
    </FormGroup>

    <div className="text-center">
      <Button bsStyle="primary" className="margin-right">Save</Button>
      <Button>Cancel</Button>
    </div>

  </Grid>


</div>

export default FundingOrganizationForm;
