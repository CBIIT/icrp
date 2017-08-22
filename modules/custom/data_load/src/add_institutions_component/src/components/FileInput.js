import React, { Component } from 'react';
import { Button, Col, Row } from 'react-bootstrap';
import { parse } from '../services/ParseCSV';

export default class FileInput extends Component {

  elements = {
    fileInput: null
  }

  state = {
    headers: [],
    institutions: [],
  }

  async readFile(file) {
    let csv = await parse(file);

    this.setState({
      institutions: csv.data,
      headers: csv.meta.fields,
    });
  }

  render() {
    const { onLoad, onReset, disabled } = this.props;

    return (
      <Row className="m-b-10 m-t-10">
        <Col sm={6}>
          <label className="m-l-10">Institution File (.csv) *</label>
          <input
            type="file"
            className="m-l-10"
            ref={fileInput => this.elements.fileInput = fileInput}
            onChange={event => this.readFile(event.target.files[0])}
            disabled={disabled}
          />
        </Col>

        <Col sm={6} className="text-right">
          <Button
            className="m-t-10 m-r-10"
            onClick={event => onLoad(this.state)}
            disabled={!this.elements.fileInput || !this.elements.fileInput.value || disabled}>
            Load
          </Button>

          <Button
            className="m-t-10 m-r-10"
            onClick={event => onReset(this.elements)}>
            Reset
          </Button>
        </Col>
      </Row>
    );
  }
}