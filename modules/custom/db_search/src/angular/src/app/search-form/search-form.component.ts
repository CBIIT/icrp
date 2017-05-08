import {
  AfterViewInit,
  Component,
  Inject,
  Input,
  EventEmitter,
  OnChanges,
  SimpleChanges,
  OnInit,
  Output
} from '@angular/core';

import {
  Validators,
  FormBuilder,
  FormGroup
} from '@angular/forms';

import { Http } from '@angular/http';
import { SearchFields } from './search-form.fields';
import { Fields } from './fields'
import { TreeNode } from '../ui-treeview/treenode';

@Component({
  selector: 'app-search-form',
  templateUrl: './search-form.component.html',
  styleUrls: ['./search-form.component.css'],
})
export class SearchFormComponent implements OnChanges, AfterViewInit {

  @Output()
  mappedSearch: EventEmitter<{
    search_terms?: string,
    search_type?: string,
    years?: string[],

    institution?: string,
    pi_first_name?: string,
    pi_orcid?: string,
    award_code?: string,

    countries?: string[],
    states?: string[],
    cities?: string[],

    funding_organizations?: string[],
    funding_organization_types?: string[],
    cancer_types?: string[],
    is_childhood_cancer?: string,
    project_types?: string[],
    cso_research_areas?: string[]
  }>;

  @Output()
  search: EventEmitter<{
    search_terms?: string,
    search_type?: string,
    years?: string,

    institution?: string,
    pi_first_name?: string,
    pi_orcid?: string,
    award_code?: string,

    countries?: string,
    states?: string,
    cities?: string,

    funding_organizations?: string,
    funding_organization_types?: string,
    cancer_types?: string,
    is_childhood_cancer?: string,
    project_types?: string,
    cso_research_areas?: string
  }>;

  @Output()
  requestInitialParameters: EventEmitter<any>;

  @Input()
  initialSearchParameters: any;


  searchInitialized: boolean = false;

  funding_organizations: TreeNode;
  cso_research_areas: TreeNode;

  fields: Fields;
  form: FormGroup;

  constructor(
    @Inject(FormBuilder) private formbuilder: FormBuilder,
    @Inject(Http) private http: Http,
    @Inject('api_root') private apiRoot: string) {

    this.search = new EventEmitter<{
      search_terms?: string,
      search_type?: string,
      years?: string,

      institution?: string,
      pi_first_name?: string,
      pi_orcid?: string,
      award_code?: string,

      countries?: string,
      states?: string,
      cities?: string,

      funding_organizations?: string,
      funding_organization_types?: string,
      cancer_types?: string,
      is_childhood_cancer?: string,
      project_types?: string,
      cso_research_areas?: string
    }>();

    this.mappedSearch = new EventEmitter<{
      search_terms?: string,
      search_type?: string,
      years?: string[],

      institution?: string,
      pi_first_name?: string,
      pi_orcid?: string,
      award_code?: string,

      countries?: string[],
      states?: string[],
      cities?: string[],

      funding_organizations?: string[],
      funding_organization_types?: string[],
      cancer_types?: string[],
      is_childhood_cancer?: string,
      project_types?: string[],
      cso_research_areas?: string[]
    }>();

    this.requestInitialParameters = new EventEmitter<any>();

    this.form = formbuilder.group({
      search_terms: [''],
      search_type: [''],
      years: [],

      institution: [''],
      pi_first_name: [''],
      pi_last_name: [''],
      pi_orcid: [''],
      award_code: [''],

      countries: [''],
      states: [''],
      cities: [''],

      funding_organizations: [''],
      funding_organization_types: [''],
      cancer_types: [''],
      is_childhood_cancer: [''],
      project_types: [''],
      cso_research_areas: [''],
    })

    this.fields = {
      years: [],
      cities: [],
      states: [],
      countries: [],
      funding_organizations: [],
      funding_organization_types: [],
      cancer_types: [],
      is_childhood_cancer: [],
      project_types: [],
      cso_research_areas: []
    }

    this.funding_organizations = null;
    this.cso_research_areas = null;
  }

  submit(event?) {

    if (event) {
      event.preventDefault();
    }

    let years = this.form.controls['years'].value;

    if(years && years.indexOf('All Years') > -1) {
      years = this.fields.years.map(year => year.value).slice(1);
    }

    let parameters = {

      search_terms: this.form.controls['search_terms'].value,
      search_type: this.form.controls['search_type'].value,
      years: years,

      institution: this.form.controls['institution'].value,
      pi_first_name: this.form.controls['pi_first_name'].value,
      pi_last_name: this.form.controls['pi_last_name'].value,
      pi_orcid: this.form.controls['pi_orcid'].value,
      award_code: this.form.controls['award_code'].value,

      countries: this.form.controls['countries'].value,
      states: this.form.controls['states'].value,
      cities: this.form.controls['cities'].value,

      funding_organization_types: this.form.controls['funding_organization_types'].value,
      funding_organizations: this.form.controls['funding_organizations'].value,
      cancer_types: this.form.controls['cancer_types'].value,
      is_childhood_cancer: this.form.controls['is_childhood_cancer'].value,
      project_types: this.form.controls['project_types'].value,
      cso_research_areas: this.form.controls['cso_research_areas'].value,
    };

    // remove unused parameters
    for (let key in parameters) {
      if (!parameters[key] || parameters[key].length === 0) {
        delete parameters[key];
      }
    }

    if (!parameters['search_terms'] || !parameters['search_type']) {
      delete parameters['search_terms'];
      delete parameters['search_type'];
    }

    if (parameters['funding_organizations']) {
      parameters['funding_organizations'] =
        parameters['funding_organizations']
        .filter(value => !isNaN(value))
    }

    if (parameters['cso_research_areas']) {
      parameters['cso_research_areas'] =
        parameters['cso_research_areas']
        .filter(value => !isNaN(value))
    }


    this.search.emit(parameters)
    this.mappedSearch.emit(this.mapSearch(parameters))
  }

  mapSearch(parameters): any {

    let mappedParameters = {}

    for (let key in parameters) {
      mappedParameters[key] = parameters[key]
    }

    /*
        for (let parameterType of [
          'years',
          'countries',
          'states',
          'cities',
          'funding_organizations',
          'cancer_types',
          'project_types',
          'cso_research_areas']) {
          if (mappedParameters[parameterType])
            mappedParameters[parameterType] = mappedParameters[parameterType].split(',');
        }
    */
    for (let parameterType of ['funding_organizations', 'cancer_types', 'cso_research_areas']) {
      if (mappedParameters[parameterType])
        mappedParameters[parameterType] = this.mapValue(parameterType, mappedParameters[parameterType])
    }

    if (mappedParameters['is_childhood_cancer']) {
      mappedParameters['is_childhood_cancer'] = +mappedParameters['is_childhood_cancer'] === 1 ? 'Yes' : 'No'
    }

    return mappedParameters;
  }

  mapValue(key: string, groups: string[]): string[] {
    return this.fields[key]
      .filter(group => groups.indexOf(group.value) > -1)
      .map(group => group.label)
      .sort();
  }

  filterStates(states: { "value": string, "label": string, "group": string }[], countries: string[]) {
    return states.filter(state => countries.indexOf(state.group) > -1 || !countries.length);
  }

  filterCities(
    cities: { "value": string, "label": string, "group": string, "supergroup": string }[],
    states: string[],
    countries: string[]) {
    return cities
      .filter(city => countries.map(c => c.trim()).indexOf(city.supergroup) > -1 || !countries.length)
      .filter(city => states.map(s => s.trim()).indexOf(city.group) > -1 || !states.length);
  }

  addTreeNode(
    parent: TreeNode,
    child: TreeNode
  ) {
    if (!parent.children) {
      parent.children = [];
    }

    parent.children.push(child);
    return child;
  }

  createTreeNode(
    items: {
      "value": number,
      "label": string,
      "group": string,
      "supergroup": string }[], type: string): TreeNode {

    let root: TreeNode = null;
    let supergroups: TreeNode[] = [];
    let groups: TreeNode[] = [];

    // initialize all groups
    items.forEach(item => {

      if (!supergroups.find(sgItem => sgItem.value == item.supergroup)) {

        let label = item.supergroup;
        if (type === 'funding_organizations') {
          label = `All ${item.supergroup} organizations`
        }

        supergroups.push({
          value: item.supergroup,
          label: label,
          children: []
        })
      }

      if (!groups.find(gItem => gItem.value == item.group)) {

       let label = item.group;
        if (type === 'funding_organizations') {
          label = `All ${item.group} organizations`
        }

        groups.push({
          value: item.group,
          label: label,
          children: []
        })
      }
    });

    // add groups to supergroups
    items.forEach(item => {
      let supergroup = supergroups.find(sgItem => sgItem.value == item.supergroup);
      let group = groups.find(gItem => gItem.value == item.group);

      if (!supergroup.children.find(sgChild => sgChild.value == group.value)) {
        this.addTreeNode(supergroup, group);
      }

      this.addTreeNode(group, {
        value: (item.value).toString(),
        label: item.label
      })
    })

    // if supergroups or groups only have one child, replace the parent node with the child
    for (let i = 0; i < groups.length; i ++) {
      let group = groups[i];

      if (group.children && group.children.length == 1) {
        let child = group.children[0];

        group.label = child.label;
        group.value = child.value;
        delete group.children;
      }
    }

    // move groups with multiple children to the front
    let sortfn = (a: TreeNode, b: TreeNode) => {

      if (type === 'funding_organizations') {
        if (a.children && b.children) {
          return a.children.length - b.children.length;
        }

        return a.label.localeCompare(b.label)
      }

      else if (type === 'cso_research_areas') {
        if (b.value == '0') return -999;
        return 0; // use server-side sorted list
//        return a.value.toString().localeCompare(b.value.toString());
      }
    }

    for (let i = 0; i < supergroups.length; i ++) {
      let supergroup = supergroups[i];
      supergroup.children.sort(sortfn);

      for (let j = 0; j < supergroup.children.length; j ++) {
        let group = supergroup.children[j];
        if (group.children)
          group.children.sort(sortfn)
      }
    }

    // funding_organizations US only - create 'All Other US organizations group'

    let label = 'All';
    if (type === 'funding_organizations') {
      label = `All organizations`
    }

    if (supergroups.length == 1) {

      root = {
        value: supergroups[0].value,
        label: supergroups[0].label,
        children: supergroups[0].children
      }
    }

    else {
      root = {
        value: null,
        label: label,
        children: supergroups
      }

    }

    return root;
  }



 getInitialParameters() {
 }

 resetForm() {
  this.form.reset();
  // set last two years
  let years = this.fields.years.filter((field, index) => {
    if (index === 1 || index === 2)
      return field;
  }).map(field => field.value);
  this.form.controls['years'].patchValue(years);
 }

 clearLocations() {
  this.form.controls['states'].patchValue([]);
  this.form.controls['cities'].patchValue([]);
 }


 ngOnChanges(changes: SimpleChanges) {

  let params = changes['initialSearchParameters'].currentValue;
  let useSearchID = window.location.search && window.location.search.includes('sid')

   if (!this.searchInitialized && useSearchID && changes['initialSearchParameters'] && params) {
    console.log('calling onchanges for getting initial parameters');

    this.searchInitialized = true;
    this.form.reset();

    for (let key in params) {
      let value = params[key];

      if (value instanceof Array)
        value = value.filter(e => e.length);

      if (value && value.length > 0) {
        this.form.controls[key].patchValue(value)
      }
    }
    window.setTimeout(f => this.submit(), 0);
   }
 }


 ngAfterViewInit(this) {
    new SearchFields(this.http, this.apiRoot).getFields()
      .subscribe(response => {
        this.fields = response;

        this.fields['is_childhood_cancer'] = [
          { label: 'All', value: null },
          { label: 'Yes', value: '1' },
          { label: 'No', value: '0' },
        ];

        this.funding_organizations = this.createTreeNode(this.fields.funding_organizations, 'funding_organizations');
        this.cso_research_areas = this.createTreeNode(this.fields.cso_research_areas, 'cso_research_areas');

        setTimeout(e => {
          // set last five years
          let years = this.fields.years.filter((field, index) => {
            if (index < 2)
              return field;
          }).map(field => field.value);

          let allYears = this.fields.years.map(v => v.value).join(',');
          this.fields.years.unshift({label: 'All Years', value: 'All Years'})
          this.form.controls['years'].patchValue(years);

          let useSearchID = window.location.search && window.location.search.includes('sid')

          if (useSearchID) {
            this.requestInitialParameters.emit();
          }

          else {
            this.submit();
          }
        }, 0);
      });
 }

  ngOnInit() {
  }

}
