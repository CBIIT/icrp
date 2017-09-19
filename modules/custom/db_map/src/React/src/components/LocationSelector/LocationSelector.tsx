import * as React from 'react';
import './LocationSelector.css';


export interface SampleProps {

}

interface LocationSelectorProps {


}

interface Filter {
  label: string;
  value: string;
}

interface LocationSelectorTagInterface {
  text: string;
  first?: boolean,
}


const LocationSelectorTag = (props: LocationSelectorTagInterface) =>
  <span className="position-relative">
    <div className={props.first ? 'bg-chevron first' : 'bg-chevron'}>
      {props.text}
    </div>
  </span>

export default class LocationSelector extends React.Component<LocationSelectorProps, {filters: Filter[]}> {

  state: {filters: Filter[]} = {
    filters: [
      {
        label: 'All Regions',
        value: ''
      },
      // {
      //   label: 'North America',
      //   value: ''
      // }

    ]
  }

  constructor(props: LocationSelectorProps) {
    super(props);

  }



  render() {
    return (
      <div className="display-flex align-items-center">
      {
        this.state.filters.map((filter, index) =>
          <LocationSelectorTag text={filter.label} first={index === 0} />
        )
      }
      </div>

    )
  }
}