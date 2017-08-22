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
    const { onLoad, onReset } = this.props;

    return (
      <Row className="form-group">
        <Col sm={6}>
          <label className="m-l-5">Institution File (.csv) *</label>
          <input
            type="file"
            className="m-l-5"
            ref={fileInput => this.elements.fileInput = fileInput}
            onChange={event => this.readFile(event.target.files[0])}
          />
        </Col>

        <Col sm={6} className="text-right">
          <Button
            className="m-t-5 m-r-5"
            onClick={event => onLoad(this.state)}
            disabled={!this.elements.fileInput || !this.elements.fileInput.value}>
            Load
          </Button>

          <Button
            className="m-t-5 m-r-5"
            onClick={event => onReset(this.elements)}>
            Reset
          </Button>
        </Col>
      </Row>
    );
  }
}