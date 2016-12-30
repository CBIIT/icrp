webpackJsonp([0,3],{

/***/ 400:
/***/ function(module, exports) {

function webpackEmptyContext(req) {
	throw new Error("Cannot find module '" + req + "'.");
}
webpackEmptyContext.keys = function() { return []; };
webpackEmptyContext.resolve = webpackEmptyContext;
module.exports = webpackEmptyContext;
webpackEmptyContext.id = 400;


/***/ },

/***/ 401:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__polyfills_ts__ = __webpack_require__(522);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__polyfills_ts___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0__polyfills_ts__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_platform_browser_dynamic__ = __webpack_require__(487);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__environments_environment__ = __webpack_require__(521);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__app_app_module__ = __webpack_require__(508);





if (__WEBPACK_IMPORTED_MODULE_3__environments_environment__["a" /* environment */].production) {
    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_2__angular_core__["_37" /* enableProdMode */])();
}
__webpack_require__.i(__WEBPACK_IMPORTED_MODULE_1__angular_platform_browser_dynamic__["a" /* platformBrowserDynamic */])().bootstrapModule(__WEBPACK_IMPORTED_MODULE_4__app_app_module__["a" /* AppModule */]);
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/main.js.map

/***/ },

/***/ 507:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return AppComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var AppComponent = (function () {
    function AppComponent() {
    }
    AppComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'icrp-root',
            template: __webpack_require__(685),
            styles: [__webpack_require__(676)]
        }), 
        __metadata('design:paramtypes', [])
    ], AppComponent);
    return AppComponent;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/app.component.js.map

/***/ },

/***/ 508:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__ = __webpack_require__(216);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__angular_forms__ = __webpack_require__(142);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3__angular_http__ = __webpack_require__(212);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__app_component__ = __webpack_require__(507);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__search_search_component__ = __webpack_require__(512);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6__search_form_search_form_component__ = __webpack_require__(509);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7__search_results_search_results_component__ = __webpack_require__(511);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8__ui_select_ui_select_component__ = __webpack_require__(517);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9__ui_panel_ui_panel_component__ = __webpack_require__(516);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10__ui_treeview_ui_treeview_component__ = __webpack_require__(520);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11__ui_table_ui_table_component__ = __webpack_require__(518);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12__ui_chart_ui_chart_component__ = __webpack_require__(513);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return AppModule; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};













var AppModule = (function () {
    function AppModule() {
    }
    AppModule = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_1__angular_core__["I" /* NgModule */])({
            declarations: [
                __WEBPACK_IMPORTED_MODULE_4__app_component__["a" /* AppComponent */],
                __WEBPACK_IMPORTED_MODULE_5__search_search_component__["a" /* SearchComponent */],
                __WEBPACK_IMPORTED_MODULE_6__search_form_search_form_component__["a" /* SearchFormComponent */],
                __WEBPACK_IMPORTED_MODULE_7__search_results_search_results_component__["a" /* SearchResultsComponent */],
                __WEBPACK_IMPORTED_MODULE_8__ui_select_ui_select_component__["a" /* UiSelectComponent */],
                __WEBPACK_IMPORTED_MODULE_9__ui_panel_ui_panel_component__["a" /* UiPanelComponent */],
                __WEBPACK_IMPORTED_MODULE_10__ui_treeview_ui_treeview_component__["a" /* UiTreeviewComponent */],
                __WEBPACK_IMPORTED_MODULE_11__ui_table_ui_table_component__["a" /* UiTableComponent */],
                __WEBPACK_IMPORTED_MODULE_12__ui_chart_ui_chart_component__["a" /* UiChartComponent */]
            ],
            imports: [
                __WEBPACK_IMPORTED_MODULE_0__angular_platform_browser__["b" /* BrowserModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["c" /* FormsModule */],
                __WEBPACK_IMPORTED_MODULE_2__angular_forms__["d" /* ReactiveFormsModule */],
                __WEBPACK_IMPORTED_MODULE_3__angular_http__["c" /* HttpModule */],
            ],
            providers: [],
            bootstrap: [__WEBPACK_IMPORTED_MODULE_4__app_component__["a" /* AppComponent */]]
        }), 
        __metadata('design:paramtypes', [])
    ], AppModule);
    return AppModule;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/app.module.js.map

/***/ },

/***/ 509:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_forms__ = __webpack_require__(142);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__search_form_fields__ = __webpack_require__(510);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return SearchFormComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};



var SearchFormComponent = (function () {
    function SearchFormComponent(fb) {
        this.search = new __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]();
        this.form = fb.group({
            search_terms: [''],
            search_term_filter: ['all'],
            years: [''],
            institution: [''],
            pi_first_name: [''],
            pi_last_name: [''],
            pi_orcid: [''],
            award_code: [''],
            countries: [''],
            states: [''],
            cities: [''],
            currency: [''],
            funding_organizations: [''],
            cancer_types: [''],
            project_types: [''],
            cso_research_areas: [''],
        });
        // initialize locations
        this.searchFields = new __WEBPACK_IMPORTED_MODULE_2__search_form_fields__["a" /* SearchFields */]();
        this.initializeFields();
        // initialize accordion
        this.displaySection = [];
        for (var i = 0; i < 5; i++)
            this.displaySection.push(false);
        this.displaySection[0] = true;
    }
    SearchFormComponent.prototype.submit = function () {
        var parameters = {
            search_terms: this.form.controls['search_terms'].value,
            search_type: this.form.controls['search_term_filter'].value,
            years: this.form.controls['years'].value,
            institution: this.form.controls['institution'].value,
            pi_first_name: this.form.controls['pi_first_name'].value,
            pi_last_name: this.form.controls['pi_last_name'].value,
            pi_orcid: this.form.controls['pi_orcid'].value,
            award_code: this.form.controls['award_code'].value,
            countries: this.form.controls['countries'].value,
            states: this.form.controls['states'].value,
            cities: this.form.controls['cities'].value,
            funding_organizations: this.form.controls['funding_organizations'].value,
            cancer_types: this.form.controls['cancer_types'].value,
            project_types: this.form.controls['project_types'].value,
            cso_codes: this.form.controls['cso_research_areas'].value,
        };
        for (var key in parameters) {
            if (!parameters[key]) {
                delete parameters[key];
            }
        }
        if (!parameters['search_terms'] || !parameters['search_term_filter']) {
            delete parameters['search_terms'];
            delete parameters['search_term_filter'];
        }
        this.search.emit(parameters);
    };
    SearchFormComponent.prototype.initializeFields = function () {
        this.fields = {
            years: this.searchFields.getYears(),
            countries: this.searchFields.getCountries(),
            states: this.searchFields.getStates([]),
            cities: this.searchFields.getCities([], []),
            currencies: this.searchFields.getCurrencies(),
            cancer_types: this.searchFields.getCancerTypes(),
            project_types: this.searchFields.getProjectTypes(),
            funding_organizations: this.searchFields.getFundingOrganizations(),
            cso_research_areas: this.searchFields.getCsoResearchAreas()
        };
    };
    SearchFormComponent.prototype.updateLocationSearch = function () {
        console.log('UPDATING SEARCH LOCATION', this.form.controls['countries'].value);
    };
    /*
      updateFilters(type: string, event: any) {
        console.log(type, event);
        this.locationFilters[type] = event;
        console.log(this.locationFilters);
    
        this.applyFilters()
      }
    
      applyFilters() {
        this.fields = {
          years: this.searchFields.getYears(),
          countries: this.searchFields.getCountries(),
          states: this.searchFields.getStates(this.locationFilters.countries),
          cities: this.searchFields.getCities(this.locationFilters.countries, this.locationFilters.states),
          currencies: this.searchFields.getCurrencies(),
          cancerSites: this.searchFields.getAllCancerSites(),
          projectTypes: this.searchFields.getAllProjectTypes(),
          fundingOrgs: this.searchFields.getFundingOrganizations(this.locationFilters.countries, null, null),
          csoAreas: this.searchFields.getCsoAreas(null)
        }
      }*/
    SearchFormComponent.prototype.toggleSection = function (index) {
        this.displaySection[index] = !this.displaySection[index];
    };
    SearchFormComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Output */])(), 
        __metadata('design:type', (typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]) === 'function' && _a) || Object)
    ], SearchFormComponent.prototype, "search", void 0);
    SearchFormComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'app-search-form',
            template: __webpack_require__(686),
            styles: [__webpack_require__(677)]
        }),
        __param(0, __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["y" /* Inject */])(__WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormBuilder */])), 
        __metadata('design:paramtypes', [(typeof (_b = typeof __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormBuilder */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_1__angular_forms__["a" /* FormBuilder */]) === 'function' && _b) || Object])
    ], SearchFormComponent);
    return SearchFormComponent;
    var _a, _b;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/search-form.component.js.map

/***/ },

/***/ 510:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return SearchFields; });
var SearchFields = (function () {
    function SearchFields() {
        this.form_variables = { "countries": [{ "value": "AF ", "label": "Afghanistan" }, { "value": "AX ", "label": "\u00c5land Island" }, { "value": "AL ", "label": "Albania" }, { "value": "DZ ", "label": "Algeria" }, { "value": "AS ", "label": "American Samoa" }, { "value": "AD ", "label": "Andorra" }, { "value": "AO ", "label": "Angola" }, { "value": "AI ", "label": "Anguilla" }, { "value": "AQ ", "label": "Antarctica" }, { "value": "AG ", "label": "Antigua and Barbuda" }, { "value": "AR ", "label": "Argentina" }, { "value": "AM ", "label": "Armenia" }, { "value": "AW ", "label": "Aruba" }, { "value": "AU ", "label": "Australia" }, { "value": "AT ", "label": "Austria" }, { "value": "AZ ", "label": "Azerbaijan" }, { "value": "BS ", "label": "Bahamas" }, { "value": "BH ", "label": "Bahrain" }, { "value": "BD ", "label": "Bangladesh" }, { "value": "BB ", "label": "Barbados" }, { "value": "BY ", "label": "Belarus" }, { "value": "BE ", "label": "Belgium" }, { "value": "BZ ", "label": "Belize" }, { "value": "BJ ", "label": "Benin" }, { "value": "BM ", "label": "Bermuda" }, { "value": "BT ", "label": "Bhutan" }, { "value": "BO ", "label": "Bolivia, Plurinational State Of" }, { "value": "BQ ", "label": "Bonaire, Sint Eustatius and Saba" }, { "value": "BA ", "label": "Bosnia and Herzegovina" }, { "value": "BW ", "label": "Botswana" }, { "value": "BV ", "label": "Bouvet Island" }, { "value": "BR ", "label": "Brazil" }, { "value": "IO ", "label": "British Indian Ocean Territory" }, { "value": "BN ", "label": "Brunei Darussalam" }, { "value": "BG ", "label": "Bulgaria" }, { "value": "BF ", "label": "Burkina Faso" }, { "value": "BI ", "label": "Burundi" }, { "value": "KH ", "label": "Cambodia" }, { "value": "CM ", "label": "Cameroon" }, { "value": "CA ", "label": "Canada" }, { "value": "CV ", "label": "Cape Verde" }, { "value": "KY ", "label": "Cayman Islands" }, { "value": "CF ", "label": "Central African Republic" }, { "value": "TD ", "label": "Chad" }, { "value": "CL ", "label": "Chile" }, { "value": "CN ", "label": "China" }, { "value": "CX ", "label": "Christmas Island" }, { "value": "CC ", "label": "Cocos (Keeling) Islands" }, { "value": "CO ", "label": "Colombia" }, { "value": "KM ", "label": "Comoros" }, { "value": "CG ", "label": "Congo" }, { "value": "CD ", "label": "Congo, The Democratic Republic Of The" }, { "value": "CK ", "label": "Cook Islands" }, { "value": "CR ", "label": "Costa Rica" }, { "value": "CI ", "label": "Cote d\u0027Ivoire" }, { "value": "HR ", "label": "Croatia" }, { "value": "CU ", "label": "Cuba" }, { "value": "CW ", "label": "Curacao" }, { "value": "CY ", "label": "Cyprus" }, { "value": "CZ ", "label": "Czech Republic" }, { "value": "DK ", "label": "Denmark" }, { "value": "DJ ", "label": "Djibouti" }, { "value": "DM ", "label": "Dominica" }, { "value": "DO ", "label": "Dominican Republic" }, { "value": "EC ", "label": "Ecuador" }, { "value": "EG ", "label": "Egypt" }, { "value": "SV ", "label": "El Salvador" }, { "value": "GQ ", "label": "Equatorial Guinea" }, { "value": "ER ", "label": "Eritrea" }, { "value": "EE ", "label": "Estonia" }, { "value": "ET ", "label": "Ethiopia" }, { "value": "FK ", "label": "Falkland Islands (Malvinas)" }, { "value": "FO ", "label": "Faroe Islands" }, { "value": "FJ ", "label": "Fiji" }, { "value": "FI ", "label": "Finland" }, { "value": "FR ", "label": "France" }, { "value": "GF ", "label": "French Guiana" }, { "value": "PF ", "label": "French Polynesia" }, { "value": "TF ", "label": "French Southern Territories" }, { "value": "GA ", "label": "Gabon" }, { "value": "GM ", "label": "Gambia" }, { "value": "GE ", "label": "Georgia" }, { "value": "DE ", "label": "Germany" }, { "value": "GH ", "label": "Ghana" }, { "value": "GI ", "label": "Gibraltar" }, { "value": "GR ", "label": "Greece" }, { "value": "GL ", "label": "Greenland" }, { "value": "GD ", "label": "Grenada" }, { "value": "GP ", "label": "Guadeloupe" }, { "value": "GU ", "label": "Guam" }, { "value": "GT ", "label": "Guatemala" }, { "value": "GG ", "label": "Guernsey" }, { "value": "GN ", "label": "Guinea" }, { "value": "GW ", "label": "Guinea-Bissau" }, { "value": "GY ", "label": "Guyana" }, { "value": "HT ", "label": "Haiti" }, { "value": "HM ", "label": "Heard Island and McDonald Islands" }, { "value": "VA ", "label": "Holy See (Vatican City State)" }, { "value": "HN ", "label": "Honduras" }, { "value": "HK ", "label": "Hong Kong" }, { "value": "HU ", "label": "Hungary" }, { "value": "IS ", "label": "Iceland" }, { "value": "IN ", "label": "India" }, { "value": "ID ", "label": "Indonesia" }, { "value": "IR ", "label": "Iran, Islamic Republic Of" }, { "value": "IQ ", "label": "Iraq" }, { "value": "IE ", "label": "Ireland" }, { "value": "IM ", "label": "Isle Of Man" }, { "value": "IL ", "label": "Israel" }, { "value": "IT ", "label": "Italy" }, { "value": "JM ", "label": "Jamaica" }, { "value": "JP ", "label": "Japan" }, { "value": "JE ", "label": "Jersey" }, { "value": "JO ", "label": "Jordan" }, { "value": "KZ ", "label": "Kazakhstan" }, { "value": "KE ", "label": "Kenya" }, { "value": "KI ", "label": "Kiribati" }, { "value": "KP ", "label": "Korea, Democratic People\u0027s Republic of" }, { "value": "KR ", "label": "Korea, Republic of" }, { "value": "KW ", "label": "Kuwait" }, { "value": "KG ", "label": "Kyrgyzstan" }, { "value": "LA ", "label": "Lao People\u0027s Democratic Republic" }, { "value": "LV ", "label": "Latvia" }, { "value": "LB ", "label": "Lebanon" }, { "value": "LS ", "label": "Lesotho" }, { "value": "LR ", "label": "Liberia" }, { "value": "LY ", "label": "Libyan Arab Jamahiriya" }, { "value": "LI ", "label": "Liechtenstein" }, { "value": "LT ", "label": "Lithuania" }, { "value": "LU ", "label": "Luxembourg" }, { "value": "MO ", "label": "Macao" }, { "value": "MK ", "label": "Macedonia, The Former Yugoslav Republic Of" }, { "value": "MG ", "label": "Madagascar" }, { "value": "MW ", "label": "Malawi" }, { "value": "MY ", "label": "Malaysia" }, { "value": "MV ", "label": "Maldives" }, { "value": "ML ", "label": "Mali" }, { "value": "MT ", "label": "Malta" }, { "value": "MH ", "label": "Marshall Islands" }, { "value": "MQ ", "label": "Martinique" }, { "value": "MR ", "label": "Mauritania" }, { "value": "MU ", "label": "Mauritius" }, { "value": "YT ", "label": "Mayotte" }, { "value": "MX ", "label": "Mexico" }, { "value": "FM ", "label": "Micronesia, Federated States Of" }, { "value": "MD ", "label": "Moldova, Republic Of" }, { "value": "MC ", "label": "Monaco" }, { "value": "MN ", "label": "Mongolia" }, { "value": "ME ", "label": "Montenegro" }, { "value": "MS ", "label": "Montserrat" }, { "value": "MA ", "label": "Morocco" }, { "value": "MZ ", "label": "Mozambique" }, { "value": "MM ", "label": "Myanmar" }, { "value": "NA ", "label": "Namibia" }, { "value": "NR ", "label": "Nauru" }, { "value": "NP ", "label": "Nepal" }, { "value": "NL ", "label": "Netherlands" }, { "value": "NC ", "label": "New Caledonia" }, { "value": "NZ ", "label": "New Zealand" }, { "value": "NI ", "label": "Nicaragua" }, { "value": "NE ", "label": "Niger" }, { "value": "NG ", "label": "Nigeria" }, { "value": "NU ", "label": "Niue" }, { "value": "NF ", "label": "Norfolk Island" }, { "value": "MP ", "label": "Northern Mariana Islands" }, { "value": "NO ", "label": "Norway" }, { "value": "OM ", "label": "Oman" }, { "value": "PK ", "label": "Pakistan" }, { "value": "PW ", "label": "Palau" }, { "value": "PS ", "label": "Palestinian Territory, Occupied" }, { "value": "PA ", "label": "Panama" }, { "value": "PG ", "label": "Papua New Guinea" }, { "value": "PY ", "label": "Paraguay" }, { "value": "PE ", "label": "Peru" }, { "value": "PH ", "label": "Philippines" }, { "value": "PN ", "label": "Pitcairn" }, { "value": "PL ", "label": "Poland" }, { "value": "PT ", "label": "Portugal" }, { "value": "PR ", "label": "Puerto Rico" }, { "value": "QA ", "label": "Qatar" }, { "value": "RE ", "label": "R\u00e9union" }, { "value": "RO ", "label": "Romania" }, { "value": "RU ", "label": "Russian Federation" }, { "value": "RW ", "label": "Rwanda" }, { "value": "BL ", "label": "Saint Barth\u00e9lemy" }, { "value": "SH ", "label": "Saint Helena, Ascension And Tristan Da Cunha" }, { "value": "KN ", "label": "Saint Kitts And Nevis" }, { "value": "LC ", "label": "Saint Lucia" }, { "value": "MF ", "label": "Saint Martin (French Part)" }, { "value": "PM ", "label": "Saint Pierre And Miquelon" }, { "value": "VC ", "label": "Saint Vincent And The Grenadines" }, { "value": "WS ", "label": "Samoa" }, { "value": "SM ", "label": "San Marino" }, { "value": "ST ", "label": "Sao Tome and Principe" }, { "value": "SA ", "label": "Saudi Arabia" }, { "value": "SN ", "label": "Senegal" }, { "value": "RS ", "label": "Serbia" }, { "value": "SC ", "label": "Seychelles" }, { "value": "SL ", "label": "Sierra Leone" }, { "value": "SG ", "label": "Singapore" }, { "value": "SX ", "label": "Sint Maarten (Dutch Part)" }, { "value": "SK ", "label": "Slovakia" }, { "value": "SI ", "label": "Slovenia" }, { "value": "SB ", "label": "Solomon Islands" }, { "value": "SO ", "label": "Somalia" }, { "value": "ZA ", "label": "South Africa" }, { "value": "GS ", "label": "South Georgia And The South Sandwich Islands" }, { "value": "SS ", "label": "South Sudan" }, { "value": "ES ", "label": "Spain" }, { "value": "LK ", "label": "Sri Lanka" }, { "value": "SD ", "label": "Sudan" }, { "value": "SR ", "label": "Suriname" }, { "value": "SJ ", "label": "Svalbard and Jan Mayen" }, { "value": "SZ ", "label": "Swaziland" }, { "value": "SE ", "label": "Sweden" }, { "value": "CH ", "label": "Switzerland" }, { "value": "SY ", "label": "Syrian Arab Republic" }, { "value": "TW ", "label": "Taiwan, Province Of China" }, { "value": "TJ ", "label": "Tajikistan" }, { "value": "TZ ", "label": "Tanzania, United Republic Of" }, { "value": "TH ", "label": "Thailand" }, { "value": "TL ", "label": "Timor-Leste" }, { "value": "TG ", "label": "Togo" }, { "value": "TK ", "label": "Tokelau" }, { "value": "TO ", "label": "Tonga" }, { "value": "TT ", "label": "Trinidad and Tobago" }, { "value": "TN ", "label": "Tunisia" }, { "value": "TR ", "label": "Turkey" }, { "value": "TM ", "label": "Turkmenistan" }, { "value": "TC ", "label": "Turks and Caicos Islands" }, { "value": "TV ", "label": "Tuvalu" }, { "value": "UG ", "label": "Uganda" }, { "value": "UA ", "label": "Ukraine" }, { "value": "AE ", "label": "United Arab Emirates" }, { "value": "GB ", "label": "United Kingdom" }, { "value": "US ", "label": "United States" }, { "value": "UM ", "label": "United States Minor Outlying Islands" }, { "value": "UY ", "label": "Uruguay" }, { "value": "UZ ", "label": "Uzbekistan" }, { "value": "VU ", "label": "Vanuatu" }, { "value": "VE ", "label": "Venezuela, Bolivarian Republic Of" }, { "value": "VN ", "label": "Viet Nam" }, { "value": "VG ", "label": "Virgin Islands, British" }, { "value": "VI ", "label": "Virgin Islands, U.S." }, { "value": "WF ", "label": "Wallis and Futuna" }, { "value": "EH ", "label": "Western Sahara" }, { "value": "YE ", "label": "Yemen" }, { "value": "ZM ", "label": "Zambia" }, { "value": "ZW ", "label": "Zimbabwe" }], "states": [{ "value": "AL", "label": "Alabama", "country": "US " }, { "value": "AK", "label": "Alaska", "country": "US " }, { "value": "AB", "label": "Alberta", "country": "CA " }, { "value": "AS", "label": "American Samoa", "country": "US " }, { "value": "AZ", "label": "Arizona", "country": "US " }, { "value": "AR", "label": "Arkansas", "country": "US " }, { "value": "BC", "label": "British Columbia", "country": "CA " }, { "value": "CA", "label": "California", "country": "US " }, { "value": "CO", "label": "Colorado", "country": "US " }, { "value": "CT", "label": "Connecticut", "country": "US " }, { "value": "DE", "label": "Delaware", "country": "US " }, { "value": "DC", "label": "District Of Columbia", "country": "US " }, { "value": "FL", "label": "Florida", "country": "US " }, { "value": "GA", "label": "Georgia", "country": "US " }, { "value": "GU", "label": "Guam", "country": "US " }, { "value": "HI", "label": "Hawaii", "country": "US " }, { "value": "ID", "label": "Idaho", "country": "US " }, { "value": "IL", "label": "Illinois", "country": "US " }, { "value": "IN", "label": "Indiana", "country": "US " }, { "value": "IA", "label": "Iowa", "country": "US " }, { "value": "JA", "label": "Jalisco", "country": "MX " }, { "value": "KS", "label": "Kansas", "country": "US " }, { "value": "KA", "label": "Karnataka ", "country": "IN " }, { "value": "KY", "label": "Kentucky", "country": "US " }, { "value": "LA", "label": "Louisiana", "country": "US " }, { "value": "ME", "label": "Maine", "country": "US " }, { "value": "MB", "label": "Manitoba", "country": "CA " }, { "value": "MD", "label": "Maryland", "country": "US " }, { "value": "MA", "label": "Massachusetts", "country": "US " }, { "value": "MI", "label": "Michigan", "country": "US " }, { "value": "MN", "label": "Minnesota", "country": "US " }, { "value": "MS", "label": "Mississippi", "country": "US " }, { "value": "MO", "label": "Missouri", "country": "US " }, { "value": "MT", "label": "Montana", "country": "US " }, { "value": "NE", "label": "Nebraska", "country": "US " }, { "value": "NV", "label": "Nevada", "country": "US " }, { "value": "NB", "label": "New Brunswick", "country": "CA " }, { "value": "NH", "label": "New Hampshire", "country": "US " }, { "value": "NJ", "label": "New Jersey", "country": "US " }, { "value": "NM", "label": "New Mexico", "country": "US " }, { "value": "NSW", "label": "New South Wales", "country": "AU " }, { "value": "NY", "label": "New York", "country": "US " }, { "value": "NL", "label": "Newfoundland and Labrador", "country": "CA " }, { "value": "NC", "label": "North Carolina", "country": "US " }, { "value": "ND", "label": "North Dakota", "country": "US " }, { "value": "NT", "label": "Northwest Territories", "country": "US " }, { "value": "NS", "label": "Nova Scotia", "country": "CA " }, { "value": "OH", "label": "Ohio", "country": "US " }, { "value": "OK", "label": "Oklahoma", "country": "US " }, { "value": "ON", "label": "Ontario", "country": "CA " }, { "value": "OR", "label": "Oregon", "country": "US " }, { "value": "PA", "label": "Pennsylvania", "country": "US " }, { "value": "PE", "label": "Prince Edward Island", "country": "CA " }, { "value": "PR", "label": "Puerto Rico", "country": "US " }, { "value": "QC", "label": "Quebec", "country": "CA " }, { "value": "PQ", "label": "Quebec", "country": "CA " }, { "value": "QLD", "label": "Queensland", "country": "AU " }, { "value": "RI", "label": "Rhode Island", "country": "US " }, { "value": "SK", "label": "Saskatchewan", "country": "CA " }, { "value": "SO", "label": "Sonora", "country": "MX " }, { "value": "SA", "label": "South Australia", "country": "AU " }, { "value": "SC", "label": "South Carolina", "country": "US " }, { "value": "SD", "label": "South Dakota", "country": "US " }, { "value": "TAS", "label": "Tasmania", "country": "AU " }, { "value": "TN", "label": "Tennessee", "country": "US " }, { "value": "TX", "label": "Texas", "country": "US " }, { "value": "UT", "label": "Utah", "country": "US " }, { "value": "VT", "label": "Vermont", "country": "US " }, { "value": "VIC", "label": "Victoria", "country": "AU " }, { "value": "VI", "label": "Virgin Islands", "country": "US " }, { "value": "VA", "label": "Virginia", "country": "US " }, { "value": "WA", "label": "Washington", "country": "US " }, { "value": "WV", "label": "West Virginia", "country": "US " }, { "value": "WI", "label": "Wisconsin", "country": "US " }, { "value": "WY", "label": "Wyoming", "country": "US " }, { "value": "YT", "label": "Yukon", "country": "CA " }], "cities": [{ "value": "\u0027S-Gravenhage", "label": "\u0027S-Gravenhage", "state": "", "country": "NL" }, { "value": "Abbotsford", "label": "Abbotsford", "state": "BC", "country": "CA" }, { "value": "Aberdeen", "label": "Aberdeen", "state": "", "country": "GB" }, { "value": "Aberystwyth", "label": "Aberystwyth", "state": "", "country": "GB" }, { "value": "Abilene", "label": "Abilene", "state": "TX", "country": "US" }, { "value": "Abuja", "label": "Abuja", "state": "", "country": "NG" }, { "value": "Acton", "label": "Acton", "state": "ACT", "country": "AU" }, { "value": "Acton", "label": "Acton", "state": "MA", "country": "US" }, { "value": "Adelaide", "label": "Adelaide", "state": "", "country": "AU" }, { "value": "Adelaide", "label": "Adelaide", "state": "NSW", "country": "AU" }, { "value": "Adelaide", "label": "Adelaide", "state": "SA", "country": "AU" }, { "value": "Agoura Hills", "label": "Agoura Hills", "state": "CA", "country": "US" }, { "value": "Akron", "label": "Akron", "state": "OH", "country": "US" }, { "value": "Alabaster", "label": "Alabaster", "state": "AL", "country": "US" }, { "value": "Alachua", "label": "Alachua", "state": "FL", "country": "US" }, { "value": "Alameda", "label": "Alameda", "state": "CA", "country": "US" }, { "value": "Albany", "label": "Albany", "state": "CA", "country": "US" }, { "value": "Albany", "label": "Albany", "state": "GA", "country": "US" }, { "value": "Albany", "label": "Albany", "state": "NY", "country": "US" }, { "value": "Albuquerque", "label": "Albuquerque", "state": "NM", "country": "US" }, { "value": "Alexandria", "label": "Alexandria", "state": "VA", "country": "US" }, { "value": "Alhambra", "label": "Alhambra", "state": "CA", "country": "US" }, { "value": "Altanta", "label": "Altanta", "state": "GA", "country": "US" }, { "value": "Amarillo", "label": "Amarillo", "state": "TX", "country": "US" }, { "value": "Ames", "label": "Ames", "state": "IA", "country": "US" }, { "value": "Ames", "label": "Ames", "state": "IL", "country": "US" }, { "value": "Amherst", "label": "Amherst", "state": "MA", "country": "US" }, { "value": "Amherst", "label": "Amherst", "state": "NY", "country": "US" }, { "value": "Amhert", "label": "Amhert", "state": "MA", "country": "US" }, { "value": "Amiens", "label": "Amiens", "state": "", "country": "FR" }, { "value": "Amsterdam", "label": "Amsterdam", "state": "", "country": "NL" }, { "value": "Amsterdam Zuidoost", "label": "Amsterdam Zuidoost", "state": "", "country": "NL" }, { "value": "Anchorage", "label": "Anchorage", "state": "AK", "country": "US" }, { "value": "Andover", "label": "Andover", "state": "MA", "country": "US" }, { "value": "Angers", "label": "Angers", "state": "", "country": "FR" }, { "value": "Angleton", "label": "Angleton", "state": "TX", "country": "US" }, { "value": "Ann Arbor", "label": "Ann Arbor", "state": "IL", "country": "US" }, { "value": "Ann Arbor", "label": "Ann Arbor", "state": "MI", "country": "US" }, { "value": "Ann Arbor", "label": "Ann Arbor", "state": "TX", "country": "US" }, { "value": "Annandale", "label": "Annandale", "state": "NJ", "country": "US" }, { "value": "Annapolis", "label": "Annapolis", "state": "MD", "country": "US" }, { "value": "Antigonish", "label": "Antigonish", "state": "NS", "country": "CA" }, { "value": "Apex", "label": "Apex", "state": "NC", "country": "US" }, { "value": "Arcadia", "label": "Arcadia", "state": "CA", "country": "US" }, { "value": "Arcata", "label": "Arcata", "state": "CA", "country": "US" }, { "value": "Arlington", "label": "Arlington", "state": "TX", "country": "US" }, { "value": "Arlington", "label": "Arlington", "state": "VA", "country": "US" }, { "value": "Arlington Heights", "label": "Arlington Heights", "state": "IL", "country": "US" }, { "value": "Arvada", "label": "Arvada", "state": "CO", "country": "US" }, { "value": "Ashburn", "label": "Ashburn", "state": "VA", "country": "US" }, { "value": "Asheville", "label": "Asheville", "state": "NC", "country": "US" }, { "value": "Ashland", "label": "Ashland", "state": "MA", "country": "US" }, { "value": "Aston", "label": "Aston", "state": "PA", "country": "US" }, { "value": "Athabasca", "label": "Athabasca", "state": "AB", "country": "CA" }, { "value": "Athens", "label": "Athens", "state": "", "country": "GR" }, { "value": "Athens", "label": "Athens", "state": "GA", "country": "US" }, { "value": "Athens", "label": "Athens", "state": "OH", "country": "US" }, { "value": "Atherton", "label": "Atherton", "state": "CA", "country": "US" }, { "value": "Atlanta", "label": "Atlanta", "state": "GA", "country": "US" }, { "value": "Attiki", "label": "Attiki", "state": "", "country": "GR" }, { "value": "Attleboro", "label": "Attleboro", "state": "MA", "country": "US" }, { "value": "Auburn", "label": "Auburn", "state": "AL", "country": "US" }, { "value": "Auburn", "label": "Auburn", "state": "WA", "country": "US" }, { "value": "Auburn University", "label": "Auburn University", "state": "AL", "country": "US" }, { "value": "Auburndale", "label": "Auburndale", "state": "MA", "country": "US" }, { "value": "Auchenflower", "label": "Auchenflower", "state": "QLD", "country": "AU" }, { "value": "Auckland", "label": "Auckland", "state": "", "country": "NZ" }, { "value": "Augusta", "label": "Augusta", "state": "GA", "country": "US" }, { "value": "Aurora", "label": "Aurora", "state": "CO", "country": "US" }, { "value": "Austin", "label": "Austin", "state": "MN", "country": "US" }, { "value": "Austin", "label": "Austin", "state": "NY", "country": "US" }, { "value": "Austin", "label": "Austin", "state": "TX", "country": "US" }, { "value": "Aventura", "label": "Aventura", "state": "FL", "country": "US" }, { "value": "Aviano", "label": "Aviano", "state": "", "country": "IL" }, { "value": "Aviano", "label": "Aviano", "state": "", "country": "IT" }, { "value": "Avon Lake", "label": "Avon Lake", "state": "OH", "country": "US" }, { "value": "Ayer", "label": "Ayer", "state": "MA", "country": "US" }, { "value": "Ayr", "label": "Ayr", "state": "", "country": "GB" }, { "value": "Azusa", "label": "Azusa", "state": "CA", "country": "US" }, { "value": "Babraham", "label": "Babraham", "state": "", "country": "GB" }, { "value": "Bainbridge Island", "label": "Bainbridge Island", "state": "WA", "country": "US" }, { "value": "Bala Cynwyd", "label": "Bala Cynwyd", "state": "PA", "country": "US" }, { "value": "Baltimore", "label": "Baltimore", "state": "", "country": "US" }, { "value": "Baltimore", "label": "Baltimore", "state": "MD", "country": "US" }, { "value": "Bangalore", "label": "Bangalore", "state": "", "country": "IN" }, { "value": "Bangalore", "label": "Bangalore", "state": "KA", "country": "IN" }, { "value": "Bangkok", "label": "Bangkok", "state": "", "country": "TH" }, { "value": "Bangor", "label": "Bangor", "state": "", "country": "GB" }, { "value": "Bangor", "label": "Bangor", "state": "ME", "country": "US" }, { "value": "Banjul", "label": "Banjul", "state": "", "country": "GM" }, { "value": "Bar Harbor", "label": "Bar Harbor", "state": "ME", "country": "US" }, { "value": "Barcelona", "label": "Barcelona", "state": "", "country": "ES" }, { "value": "Barrie", "label": "Barrie", "state": "ON", "country": "CA" }, { "value": "Bartlesville", "label": "Bartlesville", "state": "OK", "country": "US" }, { "value": "Basel", "label": "Basel", "state": "", "country": "CH" }, { "value": "Basel", "label": "Basel", "state": "", "country": "SZ" }, { "value": "Basking Ridge", "label": "Basking Ridge", "state": "NJ", "country": "US" }, { "value": "Bastrop", "label": "Bastrop", "state": "TX", "country": "US" }, { "value": "Bath", "label": "Bath", "state": "", "country": "GB" }, { "value": "Baton Rouge", "label": "Baton Rouge", "state": "LA", "country": "US" }, { "value": "Bayamon", "label": "Bayamon", "state": "", "country": "PR" }, { "value": "Bayamon", "label": "Bayamon", "state": "PR", "country": "US" }, { "value": "Beachwood", "label": "Beachwood", "state": "OH", "country": "US" }, { "value": "Bedford", "label": "Bedford", "state": "MA", "country": "US" }, { "value": "Bedford Park", "label": "Bedford Park", "state": "SA", "country": "AU" }, { "value": "Beer-Sheva", "label": "Beer-Sheva", "state": "", "country": "IL" }, { "value": "Beijing", "label": "Beijing", "state": "", "country": "CN" }, { "value": "Beijing", "label": "Beijing", "state": "MD", "country": "CN" }, { "value": "Belfast", "label": "Belfast", "state": "", "country": "GB" }, { "value": "Belfast", "label": "Belfast", "state": "", "country": "IE" }, { "value": "Bellaire", "label": "Bellaire", "state": "TX", "country": "US" }, { "value": "Bellefonte", "label": "Bellefonte", "state": "PA", "country": "US" }, { "value": "Belleville", "label": "Belleville", "state": "NJ", "country": "US" }, { "value": "Bellevue", "label": "Bellevue", "state": "WA", "country": "US" }, { "value": "Bellingham", "label": "Bellingham", "state": "WA", "country": "US" }, { "value": "Belmont", "label": "Belmont", "state": "MA", "country": "US" }, { "value": "Belo Horizonte", "label": "Belo Horizonte", "state": "", "country": "BR" }, { "value": "Belo Horizonte", "label": "Belo Horizonte", "state": "-", "country": "BR" }, { "value": "Beltsville", "label": "Beltsville", "state": "MD", "country": "US" }, { "value": "Belvedere", "label": "Belvedere", "state": "CA", "country": "US" }, { "value": "Bennington", "label": "Bennington", "state": "VT", "country": "US" }, { "value": "Bentivoglio", "label": "Bentivoglio", "state": "", "country": "IT" }, { "value": "Bentley", "label": "Bentley", "state": "WA", "country": "AU" }, { "value": "Berkeley", "label": "Berkeley", "state": "", "country": "US" }, { "value": "Berkeley", "label": "Berkeley", "state": "CA", "country": "US" }, { "value": "Berkley", "label": "Berkley", "state": "CA", "country": "US" }, { "value": "Berlin", "label": "Berlin", "state": "", "country": "DE" }, { "value": "Bern", "label": "Bern", "state": "", "country": "CH" }, { "value": "Bern", "label": "Bern", "state": "", "country": "SZ" }, { "value": "Bern", "label": "Bern", "state": "-", "country": "CH" }, { "value": "Bern", "label": "Bern", "state": "CH", "country": "US" }, { "value": "Berwyn", "label": "Berwyn", "state": "PA", "country": "US" }, { "value": "Besancon", "label": "Besancon", "state": "", "country": "FR" }, { "value": "Bethesda", "label": "Bethesda", "state": "MD", "country": "US" }, { "value": "Bethesda", "label": "Bethesda", "state": "ML", "country": "US" }, { "value": "Bethesda", "label": "Bethesda", "state": "NY", "country": "US" }, { "value": "Bethlehem", "label": "Bethlehem", "state": "PA", "country": "US" }, { "value": "Beverly", "label": "Beverly", "state": "MA", "country": "US" }, { "value": "Big Rapids", "label": "Big Rapids", "state": "MI", "country": "US" }, { "value": "Billerica", "label": "Billerica", "state": "MA", "country": "US" }, { "value": "Billings", "label": "Billings", "state": "MT", "country": "US" }, { "value": "Bilthoven", "label": "Bilthoven", "state": "", "country": "NL" }, { "value": "Binghamton", "label": "Binghamton", "state": "NY", "country": "US" }, { "value": "Birminagham", "label": "Birminagham", "state": "AL", "country": "US" }, { "value": "Birmingham", "label": "Birmingham", "state": "", "country": "GB" }, { "value": "Birmingham", "label": "Birmingham", "state": "AL", "country": "US" }, { "value": "Birmingham", "label": "Birmingham", "state": "MI", "country": "US" }, { "value": "Blacksburg", "label": "Blacksburg", "state": "VA", "country": "US" }, { "value": "Blantyre", "label": "Blantyre", "state": "-", "country": "MW" }, { "value": "Blantyre", "label": "Blantyre", "state": "MW", "country": "US" }, { "value": "Bloemfontein", "label": "Bloemfontein", "state": "", "country": "ZA" }, { "value": "Bloomfield Hills", "label": "Bloomfield Hills", "state": "MI", "country": "US" }, { "value": "Bloomington", "label": "Bloomington", "state": "IN", "country": "US" }, { "value": "Bloomington", "label": "Bloomington", "state": "MN", "country": "US" }, { "value": "Blue Bell", "label": "Blue Bell", "state": "PA", "country": "US" }, { "value": "Bluffton", "label": "Bluffton", "state": "SC", "country": "US" }, { "value": "Bobigny", "label": "Bobigny", "state": "", "country": "FR" }, { "value": "Boca Raton", "label": "Boca Raton", "state": "FL", "country": "US" }, { "value": "Bogart", "label": "Bogart", "state": "GA", "country": "US" }, { "value": "Boise", "label": "Boise", "state": "ID", "country": "US" }, { "value": "Bologna", "label": "Bologna", "state": "", "country": "IT" }, { "value": "Bombay", "label": "Bombay", "state": "", "country": "IN" }, { "value": "Bondy", "label": "Bondy", "state": "", "country": "FR" }, { "value": "Bonita Springs", "label": "Bonita Springs", "state": "FL", "country": "US" }, { "value": "Bordeaux", "label": "Bordeaux", "state": "", "country": "FR" }, { "value": "Bordentown", "label": "Bordentown", "state": "NJ", "country": "US" }, { "value": "Borehamwood", "label": "Borehamwood", "state": "", "country": "GB" }, { "value": "Boston", "label": "Boston", "state": "MA", "country": "US" }, { "value": "Boston", "label": "Boston", "state": "MD", "country": "US" }, { "value": "Bothell", "label": "Bothell", "state": "WA", "country": "US" }, { "value": "Boucherville", "label": "Boucherville", "state": "QC", "country": "CA" }, { "value": "Boulder", "label": "Boulder", "state": "CO", "country": "US" }, { "value": "Boulogne-Billancourt", "label": "Boulogne-Billancourt", "state": "", "country": "FR" }, { "value": "Bournemouth", "label": "Bournemouth", "state": "", "country": "GB" }, { "value": "Bowdoin", "label": "Bowdoin", "state": "ME", "country": "US" }, { "value": "Bowie", "label": "Bowie", "state": "MD", "country": "US" }, { "value": "Bowling Green", "label": "Bowling Green", "state": "OH", "country": "US" }, { "value": "Boyertown", "label": "Boyertown", "state": "PA", "country": "US" }, { "value": "Boys Town", "label": "Boys Town", "state": "NE", "country": "US" }, { "value": "Bozeman", "label": "Bozeman", "state": "MT", "country": "US" }, { "value": "Bradford", "label": "Bradford", "state": "", "country": "GB" }, { "value": "Branchburg", "label": "Branchburg", "state": "NJ", "country": "US" }, { "value": "Brandon", "label": "Brandon", "state": "MB", "country": "CA" }, { "value": "Brattleboro", "label": "Brattleboro", "state": "VT", "country": "US" }, { "value": "Brest", "label": "Brest", "state": "", "country": "FR" }, { "value": "Briarcliff Manor", "label": "Briarcliff Manor", "state": "NY", "country": "US" }, { "value": "Brick", "label": "Brick", "state": "NJ", "country": "US" }, { "value": "Bridgeport", "label": "Bridgeport", "state": "CT", "country": "US" }, { "value": "Bridgewater", "label": "Bridgewater", "state": "MA", "country": "US" }, { "value": "Brighton", "label": "Brighton", "state": "", "country": "GB" }, { "value": "Brisbane", "label": "Brisbane", "state": "", "country": "AU" }, { "value": "Brisbane", "label": "Brisbane", "state": "QLD", "country": "AU" }, { "value": "Bristol", "label": "Bristol", "state": "", "country": "GB" }, { "value": "Bristol", "label": "Bristol", "state": "PA", "country": "US" }, { "value": "Brno", "label": "Brno", "state": "", "country": "CZ" }, { "value": "Broadway", "label": "Broadway", "state": "", "country": "AU" }, { "value": "Brockport", "label": "Brockport", "state": "NY", "country": "US" }, { "value": "Bronx", "label": "Bronx", "state": "NY", "country": "US" }, { "value": "Brookfield", "label": "Brookfield", "state": "CT", "country": "US" }, { "value": "Brookings", "label": "Brookings", "state": "SD", "country": "US" }, { "value": "Brookline", "label": "Brookline", "state": "MA", "country": "US" }, { "value": "Brooklyn", "label": "Brooklyn", "state": "NY", "country": "US" }, { "value": "Broomall", "label": "Broomall", "state": "PA", "country": "US" }, { "value": "Brownsville", "label": "Brownsville", "state": "TX", "country": "US" }, { "value": "Brussels", "label": "Brussels", "state": "", "country": "BE" }, { "value": "Buda", "label": "Buda", "state": "TX", "country": "US" }, { "value": "Budapest", "label": "Budapest", "state": "", "country": "HU" }, { "value": "Buena", "label": "Buena", "state": "NJ", "country": "US" }, { "value": "Buenos Aires", "label": "Buenos Aires", "state": "", "country": "AR" }, { "value": "Buffalo", "label": "Buffalo", "state": "", "country": "US" }, { "value": "Buffalo", "label": "Buffalo", "state": "NY", "country": "US" }, { "value": "Buffalo Grove", "label": "Buffalo Grove", "state": "IL", "country": "US" }, { "value": "Bulffalo", "label": "Bulffalo", "state": "NY", "country": "US" }, { "value": "Bundoora", "label": "Bundoora", "state": "", "country": "AU" }, { "value": "Bunkyo-ku", "label": "Bunkyo-ku", "state": "13", "country": "JP" }, { "value": "Burke", "label": "Burke", "state": "VA", "country": "US" }, { "value": "Burlingame", "label": "Burlingame", "state": "CA", "country": "US" }, { "value": "Burlington", "label": "Burlington", "state": "MA", "country": "US" }, { "value": "Burlington", "label": "Burlington", "state": "ON", "country": "CA" }, { "value": "Burlington", "label": "Burlington", "state": "VT", "country": "US" }, { "value": "Burnaby", "label": "Burnaby", "state": "BC", "country": "CA" }, { "value": "Burnaby", "label": "Burnaby", "state": "BC", "country": "US" }, { "value": "Burnsville", "label": "Burnsville", "state": "MN", "country": "US" }, { "value": "Butte", "label": "Butte", "state": "MT", "country": "US" }, { "value": "Caen", "label": "Caen", "state": "", "country": "FR" }, { "value": "Cairo", "label": "Cairo", "state": "", "country": "EG" }, { "value": "Calabasas", "label": "Calabasas", "state": "CA", "country": "US" }, { "value": "Calgary", "label": "Calgary", "state": "", "country": "CA" }, { "value": "Calgary", "label": "Calgary", "state": "AB", "country": "CA" }, { "value": "Calverton", "label": "Calverton", "state": "MD", "country": "US" }, { "value": "Cambridge", "label": "Cambridge", "state": "", "country": "GB" }, { "value": "Cambridge", "label": "Cambridge", "state": "MA", "country": "GB" }, { "value": "Cambridge", "label": "Cambridge", "state": "MA", "country": "US" }, { "value": "Cambridge", "label": "Cambridge", "state": "ON", "country": "CA" }, { "value": "Camden", "label": "Camden", "state": "NJ", "country": "US" }, { "value": "Camp Springs", "label": "Camp Springs", "state": "MD", "country": "US" }, { "value": "Camperdown", "label": "Camperdown", "state": "", "country": "AU" }, { "value": "Camperdown", "label": "Camperdown", "state": "NSW", "country": "AU" }, { "value": "Canberra", "label": "Canberra", "state": "", "country": "AU" }, { "value": "Canberra", "label": "Canberra", "state": "ACT", "country": "AU" }, { "value": "Candiolo", "label": "Candiolo", "state": "", "country": "IT" }, { "value": "Candler", "label": "Candler", "state": "NC", "country": "US" }, { "value": "Canterbury", "label": "Canterbury", "state": "", "country": "GB" }, { "value": "Cape Town", "label": "Cape Town", "state": "", "country": "ZA" }, { "value": "Capital Federal", "label": "Capital Federal", "state": "", "country": "AR" }, { "value": "Carbondale", "label": "Carbondale", "state": "IL", "country": "US" }, { "value": "Cardiff", "label": "Cardiff", "state": "", "country": "GB" }, { "value": "Cardiff", "label": "Cardiff", "state": "CA", "country": "US" }, { "value": "Carlisle", "label": "Carlisle", "state": "PA", "country": "US" }, { "value": "Carlsbad", "label": "Carlsbad", "state": "", "country": "US" }, { "value": "Carlsbad", "label": "Carlsbad", "state": "CA", "country": "US" }, { "value": "Carlsbad", "label": "Carlsbad", "state": "PA", "country": "US" }, { "value": "Carlton", "label": "Carlton", "state": "VIC", "country": "AU" }, { "value": "Carrboro", "label": "Carrboro", "state": "NC", "country": "US" }, { "value": "Carrollton", "label": "Carrollton", "state": "GA", "country": "US" }, { "value": "Carrollton", "label": "Carrollton", "state": "TX", "country": "US" }, { "value": "Carson", "label": "Carson", "state": "CA", "country": "US" }, { "value": "Cartago", "label": "Cartago", "state": "", "country": "CR" }, { "value": "Cary", "label": "Cary", "state": "NC", "country": "US" }, { "value": "Casselberry", "label": "Casselberry", "state": "FL", "country": "US" }, { "value": "Catonsville", "label": "Catonsville", "state": "MD", "country": "US" }, { "value": "Cedar Rapids", "label": "Cedar Rapids", "state": "IA", "country": "US" }, { "value": "Ceredigion", "label": "Ceredigion", "state": "", "country": "GB" }, { "value": "Chalestown", "label": "Chalestown", "state": "MA", "country": "US" }, { "value": "Champaign", "label": "Champaign", "state": "IL", "country": "US" }, { "value": "Chandler", "label": "Chandler", "state": "AZ", "country": "US" }, { "value": "Chantilly", "label": "Chantilly", "state": "MD", "country": "US" }, { "value": "Chantilly", "label": "Chantilly", "state": "VA", "country": "US" }, { "value": "Chapel Hill", "label": "Chapel Hill", "state": "NC", "country": "US" }, { "value": "Chappaqua", "label": "Chappaqua", "state": "NY", "country": "US" }, { "value": "Charlesbourg", "label": "Charlesbourg", "state": "QC", "country": "CA" }, { "value": "Charleston", "label": "Charleston", "state": "IL", "country": "US" }, { "value": "Charleston", "label": "Charleston", "state": "SC", "country": "US" }, { "value": "Charlestown", "label": "Charlestown", "state": "MA", "country": "US" }, { "value": "Charlotte", "label": "Charlotte", "state": "NC", "country": "US" }, { "value": "Charlottesville", "label": "Charlottesville", "state": "VA", "country": "US" }, { "value": "Charlottetown", "label": "Charlottetown", "state": "PE", "country": "CA" }, { "value": "Charlottsville", "label": "Charlottsville", "state": "VA", "country": "US" }, { "value": "Chaska", "label": "Chaska", "state": "MN", "country": "US" }, { "value": "Chattanooga", "label": "Chattanooga", "state": "TN", "country": "US" }, { "value": "Chelmsford", "label": "Chelmsford", "state": "MA", "country": "US" }, { "value": "Chelyabinsk", "label": "Chelyabinsk", "state": "", "country": "RU" }, { "value": "Chennai", "label": "Chennai", "state": "", "country": "IN" }, { "value": "Chepstow", "label": "Chepstow", "state": "", "country": "GB" }, { "value": "Chester", "label": "Chester", "state": "", "country": "GB" }, { "value": "Chester", "label": "Chester", "state": "PA", "country": "US" }, { "value": "Chestnut Hill", "label": "Chestnut Hill", "state": "MA", "country": "US" }, { "value": "Chiba", "label": "Chiba", "state": "", "country": "JP" }, { "value": "Chiba", "label": "Chiba", "state": "12", "country": "JP" }, { "value": "Chicago", "label": "Chicago", "state": "IL", "country": "US" }, { "value": "Chicago", "label": "Chicago", "state": "MA", "country": "US" }, { "value": "Chicago", "label": "Chicago", "state": "MI", "country": "US" }, { "value": "Chiyoda-ku", "label": "Chiyoda-ku", "state": "13", "country": "JP" }, { "value": "Chuo-ku", "label": "Chuo-ku", "state": "13", "country": "JP" }, { "value": "Church Hill", "label": "Church Hill", "state": "MD", "country": "US" }, { "value": "Cincinnati", "label": "Cincinnati", "state": "", "country": "US" }, { "value": "Cincinnati", "label": "Cincinnati", "state": "OH", "country": "US" }, { "value": "Claremont", "label": "Claremont", "state": "CA", "country": "US" }, { "value": "Clarksville", "label": "Clarksville", "state": "MD", "country": "US" }, { "value": "Clayton", "label": "Clayton", "state": "", "country": "AU" }, { "value": "Clayton", "label": "Clayton", "state": "VIC", "country": "AU" }, { "value": "Clearwater", "label": "Clearwater", "state": "FL", "country": "US" }, { "value": "Clemson", "label": "Clemson", "state": "SC", "country": "US" }, { "value": "Clermont-Ferrand", "label": "Clermont-Ferrand", "state": "", "country": "FR" }, { "value": "Cleveland", "label": "Cleveland", "state": "OH", "country": "US" }, { "value": "Clichy", "label": "Clichy", "state": "", "country": "FR" }, { "value": "Clifton Park", "label": "Clifton Park", "state": "NY", "country": "US" }, { "value": "Clinton", "label": "Clinton", "state": "NY", "country": "US" }, { "value": "Cockeysville", "label": "Cockeysville", "state": "MD", "country": "US" }, { "value": "Coeur D\u0027 Alene", "label": "Coeur D\u0027 Alene", "state": "ID", "country": "US" }, { "value": "Colchester", "label": "Colchester", "state": "", "country": "GB" }, { "value": "Colchester", "label": "Colchester", "state": "VT", "country": "US" }, { "value": "Cold Spring", "label": "Cold Spring", "state": "NY", "country": "US" }, { "value": "Cold Spring Harbor", "label": "Cold Spring Harbor", "state": "DC", "country": "US" }, { "value": "Cold Spring Harbor", "label": "Cold Spring Harbor", "state": "NY", "country": "US" }, { "value": "Coleraine", "label": "Coleraine", "state": "", "country": "GB" }, { "value": "College Park", "label": "College Park", "state": "MD", "country": "US" }, { "value": "College Station", "label": "College Station", "state": "TX", "country": "US" }, { "value": "Collegeville", "label": "Collegeville", "state": "PA", "country": "US" }, { "value": "Colorado Springs", "label": "Colorado Springs", "state": "CO", "country": "US" }, { "value": "Columbia", "label": "Columbia", "state": "MD", "country": "US" }, { "value": "Columbia", "label": "Columbia", "state": "MO", "country": "US" }, { "value": "Columbia", "label": "Columbia", "state": "SC", "country": "US" }, { "value": "Columbia City", "label": "Columbia City", "state": "IN", "country": "US" }, { "value": "Columbus", "label": "Columbus", "state": "OH", "country": "US" }, { "value": "Columbus", "label": "Columbus", "state": "WA", "country": "US" }, { "value": "Columubus", "label": "Columubus", "state": "OH", "country": "US" }, { "value": "Concepci\u00f3n", "label": "Concepci\u00f3n", "state": "", "country": "CL" }, { "value": "Concepci\u00fdn", "label": "Concepci\u00fdn", "state": "", "country": "CL" }, { "value": "Concord", "label": "Concord", "state": "CA", "country": "US" }, { "value": "Concord", "label": "Concord", "state": "NSW", "country": "AU" }, { "value": "Conway", "label": "Conway", "state": "AR", "country": "US" }, { "value": "Cooperstown", "label": "Cooperstown", "state": "NY", "country": "US" }, { "value": "Copenhagen", "label": "Copenhagen", "state": "", "country": "DK" }, { "value": "Copenhagen", "label": "Copenhagen", "state": "MN", "country": "DK" }, { "value": "Coral Gables", "label": "Coral Gables", "state": "FL", "country": "US" }, { "value": "Coralville", "label": "Coralville", "state": "IA", "country": "US" }, { "value": "Cork", "label": "Cork", "state": "", "country": "IE" }, { "value": "Cornelius", "label": "Cornelius", "state": "NC", "country": "US" }, { "value": "Corvallis", "label": "Corvallis", "state": "OR", "country": "US" }, { "value": "Cosham", "label": "Cosham", "state": "", "country": "GB" }, { "value": "Cottingham", "label": "Cottingham", "state": "", "country": "GB" }, { "value": "Coventry", "label": "Coventry", "state": "", "country": "GB" }, { "value": "Covington", "label": "Covington", "state": "KY", "country": "US" }, { "value": "Cranberry Township", "label": "Cranberry Township", "state": "PA", "country": "US" }, { "value": "Cranfield", "label": "Cranfield", "state": "", "country": "GB" }, { "value": "Cranston", "label": "Cranston", "state": "RI", "country": "US" }, { "value": "Crawley", "label": "Crawley", "state": "", "country": "AU" }, { "value": "Crawley", "label": "Crawley", "state": "WA", "country": "AU" }, { "value": "Crete", "label": "Crete", "state": "", "country": "GR" }, { "value": "Creteil", "label": "Creteil", "state": "", "country": "FR" }, { "value": "Crofton", "label": "Crofton", "state": "MD", "country": "US" }, { "value": "Crookston", "label": "Crookston", "state": "MN", "country": "US" }, { "value": "Croton-On-Hudson", "label": "Croton-On-Hudson", "state": "NY", "country": "US" }, { "value": "Crown Point", "label": "Crown Point", "state": "IN", "country": "US" }, { "value": "Crozet", "label": "Crozet", "state": "VA", "country": "US" }, { "value": "Crystal Lake", "label": "Crystal Lake", "state": "IL", "country": "US" }, { "value": "Cuernavaca", "label": "Cuernavaca", "state": "", "country": "MX" }, { "value": "Culver City", "label": "Culver City", "state": "CA", "country": "US" }, { "value": "Cupertino", "label": "Cupertino", "state": "CA", "country": "US" }, { "value": "Dakar", "label": "Dakar", "state": "", "country": "SN" }, { "value": "Dallas", "label": "Dallas", "state": "TX", "country": "US" }, { "value": "Danbury", "label": "Danbury", "state": "CT", "country": "US" }, { "value": "Danvers", "label": "Danvers", "state": "MA", "country": "US" }, { "value": "Danville", "label": "Danville", "state": "PA", "country": "US" }, { "value": "Darlinghurst", "label": "Darlinghurst", "state": "", "country": "AU" }, { "value": "Darlinghurst", "label": "Darlinghurst", "state": "NSW", "country": "AU" }, { "value": "Davidson", "label": "Davidson", "state": "NC", "country": "US" }, { "value": "Davis", "label": "Davis", "state": "CA", "country": "US" }, { "value": "Dayton", "label": "Dayton", "state": "OH", "country": "US" }, { "value": "De Kalb", "label": "De Kalb", "state": "IL", "country": "US" }, { "value": "Decatur", "label": "Decatur", "state": "AL", "country": "US" }, { "value": "Decatur", "label": "Decatur", "state": "GA", "country": "US" }, { "value": "Decatur", "label": "Decatur", "state": "IL", "country": "US" }, { "value": "Deerfield", "label": "Deerfield", "state": "IL", "country": "US" }, { "value": "Dekalb", "label": "Dekalb", "state": "IL", "country": "US" }, { "value": "Del Mar", "label": "Del Mar", "state": "CA", "country": "US" }, { "value": "Denton", "label": "Denton", "state": "TX", "country": "US" }, { "value": "Denver", "label": "Denver", "state": "CO", "country": "US" }, { "value": "Derby", "label": "Derby", "state": "", "country": "GB" }, { "value": "Derby", "label": "Derby", "state": "CT", "country": "US" }, { "value": "Des Moines", "label": "Des Moines", "state": "IA", "country": "US" }, { "value": "Detriot", "label": "Detriot", "state": "MI", "country": "US" }, { "value": "Detroit", "label": "Detroit", "state": "MI", "country": "US" }, { "value": "Dickinson", "label": "Dickinson", "state": "TX", "country": "US" }, { "value": "Didcot", "label": "Didcot", "state": "", "country": "GB" }, { "value": "Dijon", "label": "Dijon", "state": "", "country": "FR" }, { "value": "Dixon", "label": "Dixon", "state": "CA", "country": "US" }, { "value": "Doncaster", "label": "Doncaster", "state": "", "country": "GB" }, { "value": "Dorchester", "label": "Dorchester", "state": "MA", "country": "US" }, { "value": "Dover", "label": "Dover", "state": "DE", "country": "US" }, { "value": "Downers Grove", "label": "Downers Grove", "state": "IL", "country": "US" }, { "value": "Doylestown", "label": "Doylestown", "state": "PA", "country": "US" }, { "value": "Duarte", "label": "Duarte", "state": "CA", "country": "US" }, { "value": "Dublin", "label": "Dublin", "state": "", "country": "IE" }, { "value": "Dublin", "label": "Dublin", "state": "CA", "country": "US" }, { "value": "Dublin", "label": "Dublin", "state": "OH", "country": "US" }, { "value": "Duluth", "label": "Duluth", "state": "MN", "country": "US" }, { "value": "Dundee", "label": "Dundee", "state": "", "country": "GB" }, { "value": "Durban", "label": "Durban", "state": "", "country": "ZA" }, { "value": "Durham", "label": "Durham", "state": "", "country": "GB" }, { "value": "Durham", "label": "Durham", "state": "NC", "country": "US" }, { "value": "Durham", "label": "Durham", "state": "NH", "country": "US" }, { "value": "Durham (Rtp)", "label": "Durham (Rtp)", "state": "NC", "country": "US" }, { "value": "Eagan", "label": "Eagan", "state": "MN", "country": "US" }, { "value": "East Amherst", "label": "East Amherst", "state": "NY", "country": "US" }, { "value": "East Falmouth", "label": "East Falmouth", "state": "MA", "country": "US" }, { "value": "East Grinstead", "label": "East Grinstead", "state": "", "country": "GB" }, { "value": "East Hartford", "label": "East Hartford", "state": "CT", "country": "US" }, { "value": "East Lansing", "label": "East Lansing", "state": "MI", "country": "US" }, { "value": "East Melbourne", "label": "East Melbourne", "state": "", "country": "AU" }, { "value": "East Melbourne", "label": "East Melbourne", "state": "VIC", "country": "AU" }, { "value": "East Providence", "label": "East Providence", "state": "RI", "country": "US" }, { "value": "East Setauket", "label": "East Setauket", "state": "NY", "country": "US" }, { "value": "East Syracuse", "label": "East Syracuse", "state": "NY", "country": "US" }, { "value": "Easton", "label": "Easton", "state": "PA", "country": "US" }, { "value": "Eden", "label": "Eden", "state": "NY", "country": "US" }, { "value": "Edinburg", "label": "Edinburg", "state": "TX", "country": "US" }, { "value": "Edinburgh", "label": "Edinburgh", "state": "", "country": "GB" }, { "value": "Edmond", "label": "Edmond", "state": "OK", "country": "US" }, { "value": "Edmonds", "label": "Edmonds", "state": "WA", "country": "US" }, { "value": "Edmonton", "label": "Edmonton", "state": "", "country": "CA" }, { "value": "Edmonton", "label": "Edmonton", "state": "AB", "country": "CA" }, { "value": "Egham", "label": "Egham", "state": "", "country": "GB" }, { "value": "Eindhoven", "label": "Eindhoven", "state": "", "country": "NL" }, { "value": "El Cajon", "label": "El Cajon", "state": "CA", "country": "US" }, { "value": "El Paso", "label": "El Paso", "state": "TX", "country": "US" }, { "value": "El Segundo", "label": "El Segundo", "state": "CA", "country": "US" }, { "value": "Elizabeth City", "label": "Elizabeth City", "state": "NC", "country": "US" }, { "value": "Elizabethtown", "label": "Elizabethtown", "state": "PA", "country": "US" }, { "value": "Elk Grove Village", "label": "Elk Grove Village", "state": "IL", "country": "US" }, { "value": "Elkridge", "label": "Elkridge", "state": "MD", "country": "US" }, { "value": "Ellicott City", "label": "Ellicott City", "state": "MD", "country": "US" }, { "value": "Elm Grove", "label": "Elm Grove", "state": "WI", "country": "US" }, { "value": "Elmira", "label": "Elmira", "state": "NY", "country": "US" }, { "value": "Elmwood Park", "label": "Elmwood Park", "state": "NJ", "country": "US" }, { "value": "Emeryville", "label": "Emeryville", "state": "CA", "country": "US" }, { "value": "Emporia", "label": "Emporia", "state": "KS", "country": "US" }, { "value": "Encinitas", "label": "Encinitas", "state": "CA", "country": "US" }, { "value": "Encino", "label": "Encino", "state": "CA", "country": "US" }, { "value": "Englewood", "label": "Englewood", "state": "NJ", "country": "US" }, { "value": "Enschede", "label": "Enschede", "state": "", "country": "NL" }, { "value": "Epalinges", "label": "Epalinges", "state": "", "country": "CH" }, { "value": "Escondido", "label": "Escondido", "state": "CA", "country": "US" }, { "value": "Essen", "label": "Essen", "state": "", "country": "DE" }, { "value": "Eugene", "label": "Eugene", "state": "OR", "country": "US" }, { "value": "Evanston", "label": "Evanston", "state": "", "country": "ES" }, { "value": "Evanston", "label": "Evanston", "state": "IL", "country": "US" }, { "value": "Evansville", "label": "Evansville", "state": "IN", "country": "US" }, { "value": "Ewing", "label": "Ewing", "state": "NJ", "country": "US" }, { "value": "Exeter", "label": "Exeter", "state": "", "country": "GB" }, { "value": "Exton", "label": "Exton", "state": "PA", "country": "US" }, { "value": "Fairfax", "label": "Fairfax", "state": "VA", "country": "US" }, { "value": "Fairfield", "label": "Fairfield", "state": "CA", "country": "US" }, { "value": "Fairfield", "label": "Fairfield", "state": "CT", "country": "US" }, { "value": "Fall River", "label": "Fall River", "state": "MA", "country": "US" }, { "value": "Falls Church", "label": "Falls Church", "state": "VA", "country": "US" }, { "value": "Fargo", "label": "Fargo", "state": "ND", "country": "US" }, { "value": "Farmington", "label": "Farmington", "state": "CT", "country": "US" }, { "value": "Farmington Hills", "label": "Farmington Hills", "state": "MI", "country": "US" }, { "value": "Fayetteville", "label": "Fayetteville", "state": "AR", "country": "US" }, { "value": "Fayetteville", "label": "Fayetteville", "state": "NC", "country": "US" }, { "value": "Ferndale", "label": "Ferndale", "state": "MI", "country": "US" }, { "value": "Finland", "label": "Finland", "state": "", "country": "FI" }, { "value": "Firenze", "label": "Firenze", "state": "", "country": "IT" }, { "value": "Fitzroy", "label": "Fitzroy", "state": "", "country": "AU" }, { "value": "Fitzroy", "label": "Fitzroy", "state": "VIC", "country": "AU" }, { "value": "Flagstaff", "label": "Flagstaff", "state": "AZ", "country": "US" }, { "value": "Flint", "label": "Flint", "state": "MI", "country": "US" }, { "value": "Flushing", "label": "Flushing", "state": "NY", "country": "US" }, { "value": "Folsom", "label": "Folsom", "state": "CA", "country": "US" }, { "value": "Fontenay-Aux-Roses", "label": "Fontenay-Aux-Roses", "state": "", "country": "FR" }, { "value": "Fort Collins", "label": "Fort Collins", "state": "CO", "country": "US" }, { "value": "Fort Pierce", "label": "Fort Pierce", "state": "FL", "country": "US" }, { "value": "Fort Worth", "label": "Fort Worth", "state": "TX", "country": "US" }, { "value": "Fountain Valley", "label": "Fountain Valley", "state": "CA", "country": "US" }, { "value": "Framingham", "label": "Framingham", "state": "MA", "country": "US" }, { "value": "Franklin", "label": "Franklin", "state": "MA", "country": "US" }, { "value": "Franklin", "label": "Franklin", "state": "TN", "country": "US" }, { "value": "Frederick", "label": "Frederick", "state": "", "country": "US" }, { "value": "Frederick", "label": "Frederick", "state": "MD", "country": "US" }, { "value": "Fredericton", "label": "Fredericton", "state": "NB", "country": "CA" }, { "value": "Fremont", "label": "Fremont", "state": "CA", "country": "US" }, { "value": "Fresno", "label": "Fresno", "state": "CA", "country": "US" }, { "value": "Ft. Detrick", "label": "Ft. Detrick", "state": "MD", "country": "US" }, { "value": "Fukuoka", "label": "Fukuoka", "state": "40", "country": "JP" }, { "value": "Fullerton", "label": "Fullerton", "state": "CA", "country": "US" }, { "value": "Gainesville", "label": "Gainesville", "state": "FL", "country": "US" }, { "value": "Gainsville", "label": "Gainsville", "state": "FL", "country": "US" }, { "value": "Gaithersburg", "label": "Gaithersburg", "state": "MD", "country": "US" }, { "value": "Galveston", "label": "Galveston", "state": "TX", "country": "US" }, { "value": "Galway", "label": "Galway", "state": "", "country": "IE" }, { "value": "Garden City", "label": "Garden City", "state": "NY", "country": "US" }, { "value": "Garden Grove", "label": "Garden Grove", "state": "CA", "country": "US" }, { "value": "Geneva", "label": "Geneva", "state": "", "country": "CH" }, { "value": "Geneva", "label": "Geneva", "state": "NY", "country": "US" }, { "value": "Genova", "label": "Genova", "state": "", "country": "IT" }, { "value": "Georgetown", "label": "Georgetown", "state": "DC", "country": "US" }, { "value": "Germantown", "label": "Germantown", "state": "MD", "country": "US" }, { "value": "Germantown", "label": "Germantown", "state": "NY", "country": "US" }, { "value": "Ghent", "label": "Ghent", "state": "", "country": "BE" }, { "value": "Giessen", "label": "Giessen", "state": "", "country": "DE" }, { "value": "Gig Harbor", "label": "Gig Harbor", "state": "WA", "country": "US" }, { "value": "Girona", "label": "Girona", "state": "", "country": "ES" }, { "value": "Glasgow", "label": "Glasgow", "state": "", "country": "GB" }, { "value": "Glassboro", "label": "Glassboro", "state": "NJ", "country": "US" }, { "value": "Glen Ellyn", "label": "Glen Ellyn", "state": "IL", "country": "US" }, { "value": "Glen Head", "label": "Glen Head", "state": "NY", "country": "US" }, { "value": "Glenside", "label": "Glenside", "state": "PA", "country": "US" }, { "value": "Glenview", "label": "Glenview", "state": "IL", "country": "US" }, { "value": "Gloucester", "label": "Gloucester", "state": "", "country": "GB" }, { "value": "Gold Coast", "label": "Gold Coast", "state": "", "country": "AU" }, { "value": "Golden", "label": "Golden", "state": "CO", "country": "US" }, { "value": "Goleta", "label": "Goleta", "state": "CA", "country": "US" }, { "value": "Gosselies", "label": "Gosselies", "state": "", "country": "BE" }, { "value": "Gothenburg", "label": "Gothenburg", "state": "", "country": "SE" }, { "value": "Gothenburg", "label": "Gothenburg", "state": "-", "country": "SE" }, { "value": "Granada", "label": "Granada", "state": "", "country": "ES" }, { "value": "Grand Forks", "label": "Grand Forks", "state": "ND", "country": "US" }, { "value": "Grand Junction", "label": "Grand Junction", "state": "CO", "country": "US" }, { "value": "Grand Rapids", "label": "Grand Rapids", "state": "MI", "country": "US" }, { "value": "Grass Valley", "label": "Grass Valley", "state": "CA", "country": "US" }, { "value": "Great Falls", "label": "Great Falls", "state": "VA", "country": "US" }, { "value": "Great Lakes", "label": "Great Lakes", "state": "IL", "country": "US" }, { "value": "Great Neck", "label": "Great Neck", "state": "NY", "country": "US" }, { "value": "Greeley", "label": "Greeley", "state": "CO", "country": "US" }, { "value": "Green Bay", "label": "Green Bay", "state": "WI", "country": "US" }, { "value": "Greenbrae", "label": "Greenbrae", "state": "CA", "country": "US" }, { "value": "Greenfield Park", "label": "Greenfield Park", "state": "QC", "country": "CA" }, { "value": "Greensboro", "label": "Greensboro", "state": "NC", "country": "US" }, { "value": "Greenvale", "label": "Greenvale", "state": "NY", "country": "US" }, { "value": "Greenville", "label": "Greenville", "state": "IN", "country": "US" }, { "value": "Greenville", "label": "Greenville", "state": "NC", "country": "US" }, { "value": "Greenville", "label": "Greenville", "state": "SC", "country": "US" }, { "value": "Greenwood", "label": "Greenwood", "state": "SC", "country": "US" }, { "value": "Grenoble", "label": "Grenoble", "state": "", "country": "FR" }, { "value": "Groningen", "label": "Groningen", "state": "", "country": "DE" }, { "value": "Groningen", "label": "Groningen", "state": "", "country": "NL" }, { "value": "Grosse Pointe Farms", "label": "Grosse Pointe Farms", "state": "MI", "country": "US" }, { "value": "Groton", "label": "Groton", "state": "CT", "country": "US" }, { "value": "Groton", "label": "Groton", "state": "MA", "country": "US" }, { "value": "Guadalajara", "label": "Guadalajara", "state": "JA", "country": "MX" }, { "value": "Guatemala City", "label": "Guatemala City", "state": "", "country": "GT" }, { "value": "Guelph", "label": "Guelph", "state": "ON", "country": "CA" }, { "value": "Guildford", "label": "Guildford", "state": "", "country": "GB" }, { "value": "Guilford", "label": "Guilford", "state": "CT", "country": "US" }, { "value": "Gwynedd", "label": "Gwynedd", "state": "", "country": "GB" }, { "value": "Hackensack", "label": "Hackensack", "state": "NJ", "country": "US" }, { "value": "Hagerstown", "label": "Hagerstown", "state": "MD", "country": "US" }, { "value": "Haifa", "label": "Haifa", "state": "", "country": "IL" }, { "value": "Haifa", "label": "Haifa", "state": "", "country": "IS" }, { "value": "Halifax", "label": "Halifax", "state": "NS", "country": "CA" }, { "value": "Hamburg", "label": "Hamburg", "state": "", "country": "DE" }, { "value": "Hamilton", "label": "Hamilton", "state": "", "country": "CA" }, { "value": "Hamilton", "label": "Hamilton", "state": "NJ", "country": "US" }, { "value": "Hamilton", "label": "Hamilton", "state": "ON", "country": "CA" }, { "value": "Hamlton", "label": "Hamlton", "state": "ON", "country": "CA" }, { "value": "Hampton", "label": "Hampton", "state": "VA", "country": "US" }, { "value": "Hannover", "label": "Hannover", "state": "", "country": "DE" }, { "value": "Hanover", "label": "Hanover", "state": "MD", "country": "US" }, { "value": "Hanover", "label": "Hanover", "state": "NH", "country": "US" }, { "value": "Harlingen", "label": "Harlingen", "state": "TX", "country": "US" }, { "value": "Harpenden", "label": "Harpenden", "state": "", "country": "GB" }, { "value": "Harrisburg", "label": "Harrisburg", "state": "PA", "country": "US" }, { "value": "Harrow", "label": "Harrow", "state": "", "country": "GB" }, { "value": "Hartford", "label": "Hartford", "state": "CT", "country": "US" }, { "value": "Hastings", "label": "Hastings", "state": "MI", "country": "US" }, { "value": "Hatfield", "label": "Hatfield", "state": "", "country": "GB" }, { "value": "Hattiesburg", "label": "Hattiesburg", "state": "MS", "country": "US" }, { "value": "Hauppauge", "label": "Hauppauge", "state": "NY", "country": "US" }, { "value": "Haverford", "label": "Haverford", "state": "PA", "country": "US" }, { "value": "Hayward", "label": "Hayward", "state": "CA", "country": "US" }, { "value": "Heerlen", "label": "Heerlen", "state": "", "country": "NL" }, { "value": "Heidelberg", "label": "Heidelberg", "state": "", "country": "AU" }, { "value": "Heidelberg", "label": "Heidelberg", "state": "", "country": "DE" }, { "value": "Heidelberg", "label": "Heidelberg", "state": "-", "country": "DE" }, { "value": "Heidelberg", "label": "Heidelberg", "state": "GR", "country": "GM" }, { "value": "Heidelberg", "label": "Heidelberg", "state": "VIC", "country": "AU" }, { "value": "Helsinki", "label": "Helsinki", "state": "", "country": "FI" }, { "value": "Henderson", "label": "Henderson", "state": "NV", "country": "US" }, { "value": "Henrietta", "label": "Henrietta", "state": "NY", "country": "US" }, { "value": "Heraklion", "label": "Heraklion", "state": "", "country": "GR" }, { "value": "Herndon", "label": "Herndon", "state": "VA", "country": "US" }, { "value": "Hershey", "label": "Hershey", "state": "PA", "country": "US" }, { "value": "Herston", "label": "Herston", "state": "", "country": "AU" }, { "value": "Herston", "label": "Herston", "state": "QLD", "country": "AU" }, { "value": "Heshey", "label": "Heshey", "state": "PA", "country": "US" }, { "value": "Higashi Osaka", "label": "Higashi Osaka", "state": "27", "country": "JP" }, { "value": "High Wycombe", "label": "High Wycombe", "state": "", "country": "GB" }, { "value": "Highland Heights", "label": "Highland Heights", "state": "KY", "country": "US" }, { "value": "Highland Park", "label": "Highland Park", "state": "NJ", "country": "US" }, { "value": "Hillsborough", "label": "Hillsborough", "state": "NC", "country": "US" }, { "value": "Hillsborough", "label": "Hillsborough", "state": "NJ", "country": "US" }, { "value": "Hillside", "label": "Hillside", "state": "NJ", "country": "US" }, { "value": "Hilo", "label": "Hilo", "state": "HI", "country": "US" }, { "value": "Hines", "label": "Hines", "state": "IL", "country": "US" }, { "value": "Hinxton", "label": "Hinxton", "state": "", "country": "GB" }, { "value": "Hobart", "label": "Hobart", "state": "Tas", "country": "AU" }, { "value": "Hoboken", "label": "Hoboken", "state": "NJ", "country": "US" }, { "value": "Holland", "label": "Holland", "state": "MI", "country": "US" }, { "value": "Hong Kong", "label": "Hong Kong", "state": "", "country": "HK" }, { "value": "Honolulu", "label": "Honolulu", "state": "HI", "country": "US" }, { "value": "Horsham", "label": "Horsham", "state": "PA", "country": "US" }, { "value": "Hospitalet de Llobregat", "label": "Hospitalet de Llobregat", "state": "", "country": "ES" }, { "value": "Houghton", "label": "Houghton", "state": "MI", "country": "US" }, { "value": "Houston", "label": "Houston", "state": "", "country": "US" }, { "value": "Houston", "label": "Houston", "state": "TX", "country": "US" }, { "value": "Huddersfield", "label": "Huddersfield", "state": "", "country": "GB" }, { "value": "Huddinge", "label": "Huddinge", "state": "", "country": "SE" }, { "value": "Hull", "label": "Hull", "state": "", "country": "GB" }, { "value": "Humacao", "label": "Humacao", "state": "PR", "country": "US" }, { "value": "Humble", "label": "Humble", "state": "TX", "country": "US" }, { "value": "Hummelstown", "label": "Hummelstown", "state": "PA", "country": "US" }, { "value": "Huntingdon Valley", "label": "Huntingdon Valley", "state": "PA", "country": "US" }, { "value": "Huntingon", "label": "Huntingon", "state": "WV", "country": "US" }, { "value": "Huntington", "label": "Huntington", "state": "WV", "country": "US" }, { "value": "Huntsville", "label": "Huntsville", "state": "AL", "country": "US" }, { "value": "Hyattsville", "label": "Hyattsville", "state": "MD", "country": "US" }, { "value": "IA City", "label": "IA City", "state": "IA", "country": "US" }, { "value": "Ijamsville", "label": "Ijamsville", "state": "MD", "country": "US" }, { "value": "Illkirch", "label": "Illkirch", "state": "", "country": "FR" }, { "value": "Illkirch-Graffenstaden", "label": "Illkirch-Graffenstaden", "state": "", "country": "FR" }, { "value": "Indianapolis", "label": "Indianapolis", "state": "IN", "country": "US" }, { "value": "Inglewood", "label": "Inglewood", "state": "CA", "country": "US" }, { "value": "Innsbruck", "label": "Innsbruck", "state": "", "country": "AT" }, { "value": "INpolis", "label": "INpolis", "state": "IN", "country": "US" }, { "value": "Iowa City", "label": "Iowa City", "state": "IA", "country": "US" }, { "value": "Irvine", "label": "Irvine", "state": "", "country": "GB" }, { "value": "Irvine", "label": "Irvine", "state": "CA", "country": "US" }, { "value": "Irvington", "label": "Irvington", "state": "NY", "country": "US" }, { "value": "Issaquah", "label": "Issaquah", "state": "WA", "country": "US" }, { "value": "Istanbul", "label": "Istanbul", "state": "", "country": "TR" }, { "value": "Ithaca", "label": "Ithaca", "state": "NY", "country": "US" }, { "value": "Jackson", "label": "Jackson", "state": "MS", "country": "US" }, { "value": "Jacksonville", "label": "Jacksonville", "state": "FL", "country": "US" }, { "value": "Jasper", "label": "Jasper", "state": "GA", "country": "US" }, { "value": "Jefferson", "label": "Jefferson", "state": "AR", "country": "US" }, { "value": "Jefferson City", "label": "Jefferson City", "state": "MO", "country": "US" }, { "value": "Jenkintown", "label": "Jenkintown", "state": "PA", "country": "US" }, { "value": "Jerusalem", "label": "Jerusalem", "state": "", "country": "IL" }, { "value": "Jerusalem", "label": "Jerusalem", "state": "", "country": "IS" }, { "value": "Jerusalem", "label": "Jerusalem", "state": "NE", "country": "IL" }, { "value": "Johns Creek", "label": "Johns Creek", "state": "GA", "country": "US" }, { "value": "Johnson City", "label": "Johnson City", "state": "TN", "country": "US" }, { "value": "Johnstown", "label": "Johnstown", "state": "PA", "country": "US" }, { "value": "Jordanstown", "label": "Jordanstown", "state": "", "country": "GB" }, { "value": "Jupiter", "label": "Jupiter", "state": "FL", "country": "US" }, { "value": "Kahnawake", "label": "Kahnawake", "state": "QC", "country": "CA" }, { "value": "Kalamazoo", "label": "Kalamazoo", "state": "MI", "country": "US" }, { "value": "Kampala", "label": "Kampala", "state": "", "country": "UG" }, { "value": "Kansas City", "label": "Kansas City", "state": "KS", "country": "US" }, { "value": "Kansas City", "label": "Kansas City", "state": "MO", "country": "US" }, { "value": "Karlsruhe", "label": "Karlsruhe", "state": "", "country": "DE" }, { "value": "Kashiwa", "label": "Kashiwa", "state": "12", "country": "JP" }, { "value": "Kawagoe", "label": "Kawagoe", "state": "11", "country": "JP" }, { "value": "Kearney", "label": "Kearney", "state": "NE", "country": "US" }, { "value": "Keele", "label": "Keele", "state": "", "country": "GB" }, { "value": "Keller", "label": "Keller", "state": "TX", "country": "US" }, { "value": "Kelowna", "label": "Kelowna", "state": "BC", "country": "CA" }, { "value": "Kelvin Grove", "label": "Kelvin Grove", "state": "QLD", "country": "AU" }, { "value": "Kenmore", "label": "Kenmore", "state": "WA", "country": "US" }, { "value": "Kensington", "label": "Kensington", "state": "MD", "country": "US" }, { "value": "Kent", "label": "Kent", "state": "", "country": "GB" }, { "value": "Kent", "label": "Kent", "state": "OH", "country": "US" }, { "value": "Kerrville", "label": "Kerrville", "state": "TX", "country": "US" }, { "value": "King of Prussia", "label": "King of Prussia", "state": "PA", "country": "US" }, { "value": "Kingston", "label": "Kingston", "state": "", "country": "CA" }, { "value": "Kingston", "label": "Kingston", "state": "ON", "country": "CA" }, { "value": "Kingston", "label": "Kingston", "state": "ON", "country": "US" }, { "value": "Kingston", "label": "Kingston", "state": "RI", "country": "US" }, { "value": "Kingston Upon Hull", "label": "Kingston Upon Hull", "state": "", "country": "GB" }, { "value": "Kingsville", "label": "Kingsville", "state": "TX", "country": "US" }, { "value": "Kirkland", "label": "Kirkland", "state": "QC", "country": "CA" }, { "value": "Kirksville", "label": "Kirksville", "state": "MO", "country": "US" }, { "value": "Kitchener", "label": "Kitchener", "state": "ON", "country": "CA" }, { "value": "Kittery", "label": "Kittery", "state": "ME", "country": "US" }, { "value": "Kittery Point", "label": "Kittery Point", "state": "ME", "country": "US" }, { "value": "Knoxville", "label": "Knoxville", "state": "TN", "country": "US" }, { "value": "Kogarah", "label": "Kogarah", "state": "", "country": "AU" }, { "value": "Kogarah", "label": "Kogarah", "state": "NSW", "country": "AU" }, { "value": "Kotlarska", "label": "Kotlarska", "state": "", "country": "CZ" }, { "value": "Kotlarska 2", "label": "Kotlarska 2", "state": "", "country": "CZ" }, { "value": "Koto-ku", "label": "Koto-ku", "state": "13", "country": "JP" }, { "value": "KS City", "label": "KS City", "state": "KS", "country": "US" }, { "value": "Kyoto", "label": "Kyoto", "state": "26", "country": "JP" }, { "value": "La Crescenta", "label": "La Crescenta", "state": "CA", "country": "US" }, { "value": "La Crosse", "label": "La Crosse", "state": "WI", "country": "US" }, { "value": "La Jolla", "label": "La Jolla", "state": "", "country": "US" }, { "value": "La Jolla", "label": "La Jolla", "state": "CA", "country": "US" }, { "value": "La Marque", "label": "La Marque", "state": "TX", "country": "US" }, { "value": "La Plata", "label": "La Plata", "state": "-", "country": "AR" }, { "value": "La Tronche", "label": "La Tronche", "state": "", "country": "FR" }, { "value": "La Verne", "label": "La Verne", "state": "CA", "country": "US" }, { "value": "Lafayette", "label": "Lafayette", "state": "CO", "country": "US" }, { "value": "Lafayette", "label": "Lafayette", "state": "IN", "country": "US" }, { "value": "Laguna Hills", "label": "Laguna Hills", "state": "CA", "country": "US" }, { "value": "Laguna Niguel", "label": "Laguna Niguel", "state": "CA", "country": "US" }, { "value": "Lajolla", "label": "Lajolla", "state": "CA", "country": "US" }, { "value": "Lake Placid", "label": "Lake Placid", "state": "NY", "country": "US" }, { "value": "Lakeland", "label": "Lakeland", "state": "FL", "country": "US" }, { "value": "Lakewood", "label": "Lakewood", "state": "CO", "country": "US" }, { "value": "Lambertville", "label": "Lambertville", "state": "NJ", "country": "US" }, { "value": "Lancaster", "label": "Lancaster", "state": "", "country": "GB" }, { "value": "Lancaster", "label": "Lancaster", "state": "CA", "country": "US" }, { "value": "Lancaster", "label": "Lancaster", "state": "PA", "country": "US" }, { "value": "Langhorne", "label": "Langhorne", "state": "PA", "country": "US" }, { "value": "Langley", "label": "Langley", "state": "BC", "country": "CA" }, { "value": "Lanham", "label": "Lanham", "state": "MD", "country": "US" }, { "value": "Lansing", "label": "Lansing", "state": "MI", "country": "US" }, { "value": "Laramie", "label": "Laramie", "state": "WY", "country": "US" }, { "value": "Laredo", "label": "Laredo", "state": "TX", "country": "US" }, { "value": "Largo", "label": "Largo", "state": "FL", "country": "US" }, { "value": "Las Cruces", "label": "Las Cruces", "state": "NM", "country": "US" }, { "value": "Las Vegas", "label": "Las Vegas", "state": "NV", "country": "US" }, { "value": "Laurel", "label": "Laurel", "state": "MD", "country": "US" }, { "value": "Lausanne", "label": "Lausanne", "state": "", "country": "CH" }, { "value": "Lausanne", "label": "Lausanne", "state": "", "country": "SZ" }, { "value": "Laval", "label": "Laval", "state": "QC", "country": "CA" }, { "value": "Lawrence", "label": "Lawrence", "state": "KS", "country": "US" }, { "value": "Lawrenceville", "label": "Lawrenceville", "state": "NJ", "country": "US" }, { "value": "Le Kremlin-Bicetre", "label": "Le Kremlin-Bicetre", "state": "", "country": "FR" }, { "value": "League City", "label": "League City", "state": "TX", "country": "US" }, { "value": "Leawood", "label": "Leawood", "state": "KS", "country": "US" }, { "value": "Lebanon", "label": "Lebanon", "state": "NH", "country": "US" }, { "value": "Leeds", "label": "Leeds", "state": "", "country": "GA" }, { "value": "Leeds", "label": "Leeds", "state": "", "country": "GB" }, { "value": "Leicester", "label": "Leicester", "state": "", "country": "GB" }, { "value": "Leiden", "label": "Leiden", "state": "", "country": "NL" }, { "value": "Leioa", "label": "Leioa", "state": "", "country": "ES" }, { "value": "Lethbridge", "label": "Lethbridge", "state": "AB", "country": "CA" }, { "value": "Leuven", "label": "Leuven", "state": "", "country": "BE" }, { "value": "L\u00e9vis", "label": "L\u00e9vis", "state": "QC", "country": "CA" }, { "value": "Lewisburg", "label": "Lewisburg", "state": "PA", "country": "US" }, { "value": "Lexington", "label": "Lexington", "state": "KY", "country": "US" }, { "value": "Lexington", "label": "Lexington", "state": "MA", "country": "US" }, { "value": "Lidcombe", "label": "Lidcombe", "state": "NSW", "country": "AU" }, { "value": "Lille", "label": "Lille", "state": "", "country": "FR" }, { "value": "Lima", "label": "Lima", "state": "", "country": "PE" }, { "value": "Limoges", "label": "Limoges", "state": "", "country": "FR" }, { "value": "Lincoln", "label": "Lincoln", "state": "NE", "country": "US" }, { "value": "Lincoln", "label": "Lincoln", "state": "RI", "country": "US" }, { "value": "Lincoln University", "label": "Lincoln University", "state": "PA", "country": "US" }, { "value": "Lincolnshire", "label": "Lincolnshire", "state": "IL", "country": "US" }, { "value": "Lincolnwood", "label": "Lincolnwood", "state": "IL", "country": "US" }, { "value": "Lindfield", "label": "Lindfield", "state": "NSW", "country": "AU" }, { "value": "Lindon", "label": "Lindon", "state": "UT", "country": "US" }, { "value": "Linthicum", "label": "Linthicum", "state": "MD", "country": "US" }, { "value": "Lisbon", "label": "Lisbon", "state": "", "country": "PT" }, { "value": "Lithia Springs", "label": "Lithia Springs", "state": "GA", "country": "US" }, { "value": "Little Rock", "label": "Little Rock", "state": "AR", "country": "US" }, { "value": "Littleton", "label": "Littleton", "state": "CO", "country": "US" }, { "value": "Livermore", "label": "Livermore", "state": "CA", "country": "US" }, { "value": "Liverpool", "label": "Liverpool", "state": "", "country": "GB" }, { "value": "Liverpool", "label": "Liverpool", "state": "NSW", "country": "AU" }, { "value": "Livingston", "label": "Livingston", "state": "NJ", "country": "US" }, { "value": "Llanelli", "label": "Llanelli", "state": "", "country": "GB" }, { "value": "Llobregat", "label": "Llobregat", "state": "", "country": "ES" }, { "value": "Logan", "label": "Logan", "state": "UT", "country": "US" }, { "value": "Loma Linda", "label": "Loma Linda", "state": "CA", "country": "US" }, { "value": "London", "label": "London", "state": "", "country": "CA" }, { "value": "London", "label": "London", "state": "", "country": "GB" }, { "value": "London", "label": "London", "state": "-", "country": "GB" }, { "value": "London", "label": "London", "state": "IL", "country": "GB" }, { "value": "London", "label": "London", "state": "ON", "country": "CA" }, { "value": "Londonderry", "label": "Londonderry", "state": "", "country": "GB" }, { "value": "Long Beach", "label": "Long Beach", "state": "CA", "country": "US" }, { "value": "Long Island City", "label": "Long Island City", "state": "NY", "country": "US" }, { "value": "Longmont", "label": "Longmont", "state": "CO", "country": "US" }, { "value": "Loos", "label": "Loos", "state": "", "country": "FR" }, { "value": "Lorton", "label": "Lorton", "state": "VA", "country": "US" }, { "value": "Los Alamos", "label": "Los Alamos", "state": "NM", "country": "US" }, { "value": "Los Altos Hills", "label": "Los Altos Hills", "state": "CA", "country": "US" }, { "value": "Los Angeles", "label": "Los Angeles", "state": "CA", "country": "US" }, { "value": "Los Angles", "label": "Los Angles", "state": "CA", "country": "US" }, { "value": "Loughborough", "label": "Loughborough", "state": "", "country": "GB" }, { "value": "Louisville", "label": "Louisville", "state": "KY", "country": "US" }, { "value": "Lowell", "label": "Lowell", "state": "MA", "country": "US" }, { "value": "Lubbock", "label": "Lubbock", "state": "TX", "country": "US" }, { "value": "Lule\u00e5", "label": "Lule\u00e5", "state": "", "country": "SE" }, { "value": "Lund", "label": "Lund", "state": "", "country": "CH" }, { "value": "Lund", "label": "Lund", "state": "", "country": "SE" }, { "value": "Lynden", "label": "Lynden", "state": "WA", "country": "US" }, { "value": "Lynwood", "label": "Lynwood", "state": "CA", "country": "US" }, { "value": "Lyon", "label": "Lyon", "state": "", "country": "FR" }, { "value": "Lyon", "label": "Lyon", "state": "-", "country": "FR" }, { "value": "L\u00fdvis", "label": "L\u00fdvis", "state": "QC", "country": "CA" }, { "value": "Maastricht", "label": "Maastricht", "state": "", "country": "NL" }, { "value": "Macomb", "label": "Macomb", "state": "IL", "country": "US" }, { "value": "Macon", "label": "Macon", "state": "GA", "country": "US" }, { "value": "Madison", "label": "Madison", "state": "CT", "country": "US" }, { "value": "Madison", "label": "Madison", "state": "WI", "country": "US" }, { "value": "Madrid", "label": "Madrid", "state": "", "country": "ES" }, { "value": "Maebashi", "label": "Maebashi", "state": "10", "country": "JP" }, { "value": "Malvern", "label": "Malvern", "state": "PA", "country": "US" }, { "value": "Manassas", "label": "Manassas", "state": "VA", "country": "US" }, { "value": "Manchester", "label": "Manchester", "state": "", "country": "GB" }, { "value": "Mangilao", "label": "Mangilao", "state": "GU", "country": "US" }, { "value": "Manhasset", "label": "Manhasset", "state": "NY", "country": "US" }, { "value": "Manhattan", "label": "Manhattan", "state": "KS", "country": "US" }, { "value": "Manhattan Beach", "label": "Manhattan Beach", "state": "CA", "country": "US" }, { "value": "Manlo Park", "label": "Manlo Park", "state": "CA", "country": "US" }, { "value": "Mannheim", "label": "Mannheim", "state": "", "country": "DE" }, { "value": "Mansfield", "label": "Mansfield", "state": "MA", "country": "US" }, { "value": "Manvel", "label": "Manvel", "state": "TX", "country": "US" }, { "value": "Maple Grove", "label": "Maple Grove", "state": "MN", "country": "US" }, { "value": "Mapleton", "label": "Mapleton", "state": "OR", "country": "US" }, { "value": "Marathon", "label": "Marathon", "state": "FL", "country": "US" }, { "value": "Marburg", "label": "Marburg", "state": "", "country": "DE" }, { "value": "Marietta", "label": "Marietta", "state": "GA", "country": "US" }, { "value": "Marin", "label": "Marin", "state": "CA", "country": "US" }, { "value": "Markham", "label": "Markham", "state": "ON", "country": "CA" }, { "value": "Marlborough", "label": "Marlborough", "state": "MA", "country": "US" }, { "value": "Marseille", "label": "Marseille", "state": "", "country": "FR" }, { "value": "Marshfield", "label": "Marshfield", "state": "WI", "country": "US" }, { "value": "Martinsried", "label": "Martinsried", "state": "", "country": "DE" }, { "value": "Mashantucket", "label": "Mashantucket", "state": "CT", "country": "US" }, { "value": "Massachusetts", "label": "Massachusetts", "state": "MA", "country": "US" }, { "value": "Matsuyama", "label": "Matsuyama", "state": "38", "country": "JP" }, { "value": "Mayaguez", "label": "Mayaguez", "state": "PR", "country": "US" }, { "value": "Maynard", "label": "Maynard", "state": "MA", "country": "US" }, { "value": "Maywood", "label": "Maywood", "state": "IL", "country": "US" }, { "value": "Maywood", "label": "Maywood", "state": "PR", "country": "US" }, { "value": "Mc Lean", "label": "Mc Lean", "state": "VA", "country": "US" }, { "value": "Mckeesport", "label": "Mckeesport", "state": "PA", "country": "US" }, { "value": "McLean", "label": "McLean", "state": "VA", "country": "US" }, { "value": "Medford", "label": "Medford", "state": "MA", "country": "US" }, { "value": "Media", "label": "Media", "state": "PA", "country": "US" }, { "value": "Melbourne", "label": "Melbourne", "state": "", "country": "AS" }, { "value": "Melbourne", "label": "Melbourne", "state": "", "country": "AU" }, { "value": "Melbourne", "label": "Melbourne", "state": "FL", "country": "US" }, { "value": "Melbourne", "label": "Melbourne", "state": "QLD", "country": "AU" }, { "value": "Melbourne", "label": "Melbourne", "state": "VIC", "country": "AU" }, { "value": "Melbourne, Victoria", "label": "Melbourne, Victoria", "state": "VIC", "country": "AU" }, { "value": "Memphis", "label": "Memphis", "state": "TN", "country": "US" }, { "value": "Menands", "label": "Menands", "state": "NY", "country": "US" }, { "value": "Mendocino", "label": "Mendocino", "state": "CA", "country": "US" }, { "value": "Menlo Park", "label": "Menlo Park", "state": "CA", "country": "US" }, { "value": "Merced", "label": "Merced", "state": "CA", "country": "US" }, { "value": "Mercer Island", "label": "Mercer Island", "state": "WA", "country": "US" }, { "value": "Mesa", "label": "Mesa", "state": "AZ", "country": "US" }, { "value": "Metamora", "label": "Metamora", "state": "MI", "country": "US" }, { "value": "Mexico City", "label": "Mexico City", "state": "", "country": "MX" }, { "value": "Meylan", "label": "Meylan", "state": "", "country": "FR" }, { "value": "Miami", "label": "Miami", "state": "FL", "country": "US" }, { "value": "Miami", "label": "Miami", "state": "NY", "country": "US" }, { "value": "Miami Beach", "label": "Miami Beach", "state": "FL", "country": "US" }, { "value": "Miami Shores", "label": "Miami Shores", "state": "FL", "country": "US" }, { "value": "Middlesbrough", "label": "Middlesbrough", "state": "", "country": "GB" }, { "value": "Middlesex", "label": "Middlesex", "state": "NJ", "country": "US" }, { "value": "Middleton", "label": "Middleton", "state": "WI", "country": "US" }, { "value": "Middletown", "label": "Middletown", "state": "CT", "country": "US" }, { "value": "Middletown", "label": "Middletown", "state": "OH", "country": "US" }, { "value": "Milan", "label": "Milan", "state": "", "country": "IT" }, { "value": "Milan", "label": "Milan", "state": "MD", "country": "IT" }, { "value": "Milano", "label": "Milano", "state": "", "country": "IT" }, { "value": "Milford", "label": "Milford", "state": "MA", "country": "US" }, { "value": "Millbrae", "label": "Millbrae", "state": "CA", "country": "US" }, { "value": "Milton", "label": "Milton", "state": "VT", "country": "US" }, { "value": "Milton Keynes", "label": "Milton Keynes", "state": "", "country": "GB" }, { "value": "Milwaukee", "label": "Milwaukee", "state": "WI", "country": "US" }, { "value": "Minato-ku", "label": "Minato-ku", "state": "13", "country": "JP" }, { "value": "Minneapolis", "label": "Minneapolis", "state": "MN", "country": "US" }, { "value": "Minnesota", "label": "Minnesota", "state": "MN", "country": "US" }, { "value": "Miramar", "label": "Miramar", "state": "FL", "country": "US" }, { "value": "Mission Hills", "label": "Mission Hills", "state": "CA", "country": "US" }, { "value": "Mississauga", "label": "Mississauga", "state": "ON", "country": "CA" }, { "value": "Mississippi State", "label": "Mississippi State", "state": "MS", "country": "US" }, { "value": "Missoula", "label": "Missoula", "state": "MT", "country": "US" }, { "value": "Mobile", "label": "Mobile", "state": "AL", "country": "US" }, { "value": "Moncton", "label": "Moncton", "state": "NB", "country": "CA" }, { "value": "Monmouth", "label": "Monmouth", "state": "IL", "country": "US" }, { "value": "Monmouth Junction", "label": "Monmouth Junction", "state": "NJ", "country": "US" }, { "value": "Monreal", "label": "Monreal", "state": "QC", "country": "CA" }, { "value": "Monroe", "label": "Monroe", "state": "LA", "country": "US" }, { "value": "Monrovia", "label": "Monrovia", "state": "CA", "country": "US" }, { "value": "Mont-Royal", "label": "Mont-Royal", "state": "QC", "country": "CA" }, { "value": "Montclair", "label": "Montclair", "state": "NJ", "country": "US" }, { "value": "Monterey", "label": "Monterey", "state": "CA", "country": "US" }, { "value": "Monterey Park", "label": "Monterey Park", "state": "CA", "country": "US" }, { "value": "Monterotondo-Scalo", "label": "Monterotondo-Scalo", "state": "", "country": "IT" }, { "value": "Monticello", "label": "Monticello", "state": "AR", "country": "US" }, { "value": "Montpellier", "label": "Montpellier", "state": "", "country": "FR" }, { "value": "Montreal", "label": "Montreal", "state": "", "country": "CA" }, { "value": "Montreal", "label": "Montreal", "state": "PQ", "country": "CA" }, { "value": "Montreal", "label": "Montreal", "state": "PQ", "country": "US" }, { "value": "Montreal", "label": "Montreal", "state": "QC", "country": "CA" }, { "value": "Montreal", "label": "Montreal", "state": "QC", "country": "US" }, { "value": "Montr\u00e9al", "label": "Montr\u00e9al", "state": "QC", "country": "CA" }, { "value": "Moon Township", "label": "Moon Township", "state": "PA", "country": "US" }, { "value": "Moorestown", "label": "Moorestown", "state": "NJ", "country": "US" }, { "value": "Moorhead", "label": "Moorhead", "state": "MN", "country": "US" }, { "value": "Moraga", "label": "Moraga", "state": "", "country": "US" }, { "value": "Moreno Valley", "label": "Moreno Valley", "state": "CA", "country": "US" }, { "value": "Morgantown", "label": "Morgantown", "state": "PA", "country": "US" }, { "value": "Morgantown", "label": "Morgantown", "state": "WV", "country": "US" }, { "value": "Morris Plains", "label": "Morris Plains", "state": "NJ", "country": "US" }, { "value": "Morrisville", "label": "Morrisville", "state": "NC", "country": "US" }, { "value": "Moscow", "label": "Moscow", "state": "ID", "country": "US" }, { "value": "Moss Beach", "label": "Moss Beach", "state": "CA", "country": "US" }, { "value": "Mount Pleasant", "label": "Mount Pleasant", "state": "MI", "country": "US" }, { "value": "Mount Pleasant", "label": "Mount Pleasant", "state": "SC", "country": "US" }, { "value": "Mountain View", "label": "Mountain View", "state": "CA", "country": "US" }, { "value": "Mountlake Terrace", "label": "Mountlake Terrace", "state": "WA", "country": "US" }, { "value": "Mukilteo", "label": "Mukilteo", "state": "WA", "country": "US" }, { "value": "Mumbai", "label": "Mumbai", "state": "", "country": "IN" }, { "value": "Muncie", "label": "Muncie", "state": "IN", "country": "US" }, { "value": "Munich", "label": "Munich", "state": "", "country": "DE" }, { "value": "N. Bethesda", "label": "N. Bethesda", "state": "MD", "country": "US" }, { "value": "Nacogdoches", "label": "Nacogdoches", "state": "TX", "country": "US" }, { "value": "Nagakute", "label": "Nagakute", "state": "23", "country": "JP" }, { "value": "Nagasaki", "label": "Nagasaki", "state": "42", "country": "JP" }, { "value": "Nagoya", "label": "Nagoya", "state": "", "country": "JP" }, { "value": "Nagoya", "label": "Nagoya", "state": "23", "country": "JP" }, { "value": "Nagoya City", "label": "Nagoya City", "state": "", "country": "JP" }, { "value": "Nancy", "label": "Nancy", "state": "", "country": "FR" }, { "value": "Nantes", "label": "Nantes", "state": "", "country": "FR" }, { "value": "Naples", "label": "Naples", "state": "", "country": "IT" }, { "value": "Nashua", "label": "Nashua", "state": "NH", "country": "US" }, { "value": "Nashville", "label": "Nashville", "state": "TN", "country": "US" }, { "value": "Natick", "label": "Natick", "state": "MA", "country": "US" }, { "value": "National City", "label": "National City", "state": "CA", "country": "US" }, { "value": "Needham", "label": "Needham", "state": "MA", "country": "US" }, { "value": "Needham Heights", "label": "Needham Heights", "state": "MA", "country": "US" }, { "value": "Neuherberg", "label": "Neuherberg", "state": "", "country": "DE" }, { "value": "Nevada City", "label": "Nevada City", "state": "CA", "country": "US" }, { "value": "New Brighton", "label": "New Brighton", "state": "MN", "country": "US" }, { "value": "New Brunswick", "label": "New Brunswick", "state": "NJ", "country": "US" }, { "value": "New Canaan", "label": "New Canaan", "state": "CT", "country": "US" }, { "value": "New City", "label": "New City", "state": "NY", "country": "US" }, { "value": "New Delhi", "label": "New Delhi", "state": "", "country": "IN" }, { "value": "New Delhi", "label": "New Delhi", "state": "-", "country": "IN" }, { "value": "New Haven", "label": "New Haven", "state": "CT", "country": "US" }, { "value": "New Hyde Park", "label": "New Hyde Park", "state": "NY", "country": "US" }, { "value": "New Jersey", "label": "New Jersey", "state": "NJ", "country": "US" }, { "value": "New London", "label": "New London", "state": "CT", "country": "US" }, { "value": "New Market", "label": "New Market", "state": "MD", "country": "US" }, { "value": "New Orleans", "label": "New Orleans", "state": "LA", "country": "US" }, { "value": "New Rochelle", "label": "New Rochelle", "state": "NY", "country": "US" }, { "value": "New York", "label": "New York", "state": "NY", "country": "US" }, { "value": "New York City", "label": "New York City", "state": "NY", "country": "US" }, { "value": "Newark", "label": "Newark", "state": "DE", "country": "US" }, { "value": "Newark", "label": "Newark", "state": "NJ", "country": "US" }, { "value": "Newark", "label": "Newark", "state": "OH", "country": "US" }, { "value": "Newburyport", "label": "Newburyport", "state": "MA", "country": "US" }, { "value": "Newcastle", "label": "Newcastle", "state": "NSW", "country": "AU" }, { "value": "Newcastle Upon Tyne", "label": "Newcastle Upon Tyne", "state": "", "country": "GB" }, { "value": "NewHaven", "label": "NewHaven", "state": "CT", "country": "US" }, { "value": "Newington", "label": "Newington", "state": "CT", "country": "US" }, { "value": "Newmarket", "label": "Newmarket", "state": "ON", "country": "CA" }, { "value": "Newport", "label": "Newport", "state": "KY", "country": "US" }, { "value": "Newport", "label": "Newport", "state": "NC", "country": "US" }, { "value": "Newscastle", "label": "Newscastle", "state": "NSW", "country": "AU" }, { "value": "Newton", "label": "Newton", "state": "MA", "country": "US" }, { "value": "Newtown", "label": "Newtown", "state": "PA", "country": "US" }, { "value": "Newtownabbey", "label": "Newtownabbey", "state": "", "country": "GB" }, { "value": "Niagara Falls", "label": "Niagara Falls", "state": "NY", "country": "US" }, { "value": "Niagara University", "label": "Niagara University", "state": "NY", "country": "US" }, { "value": "Nice", "label": "Nice", "state": "", "country": "FR" }, { "value": "Nijmegen", "label": "Nijmegen", "state": "", "country": "NL" }, { "value": "Nimes", "label": "Nimes", "state": "", "country": "FR" }, { "value": "Niskayuna", "label": "Niskayuna", "state": "NY", "country": "US" }, { "value": "Njmegen", "label": "Njmegen", "state": "", "country": "NL" }, { "value": "Norcross", "label": "Norcross", "state": "", "country": "US" }, { "value": "Norcross", "label": "Norcross", "state": "GA", "country": "US" }, { "value": "Norfolk", "label": "Norfolk", "state": "VA", "country": "US" }, { "value": "Normal", "label": "Normal", "state": "IL", "country": "US" }, { "value": "Norman", "label": "Norman", "state": "OK", "country": "US" }, { "value": "North Andover", "label": "North Andover", "state": "MA", "country": "US" }, { "value": "North Bay", "label": "North Bay", "state": "ON", "country": "CA" }, { "value": "North Brunswick", "label": "North Brunswick", "state": "NJ", "country": "US" }, { "value": "North Chicago", "label": "North Chicago", "state": "IL", "country": "US" }, { "value": "North Haven", "label": "North Haven", "state": "CT", "country": "US" }, { "value": "North Kingstown", "label": "North Kingstown", "state": "RI", "country": "US" }, { "value": "North Palm Beach", "label": "North Palm Beach", "state": "FL", "country": "US" }, { "value": "North Potomac", "label": "North Potomac", "state": "MD", "country": "US" }, { "value": "North Ryde", "label": "North Ryde", "state": "NSW", "country": "AU" }, { "value": "North Wollongong", "label": "North Wollongong", "state": "NSW", "country": "AU" }, { "value": "Northampton", "label": "Northampton", "state": "MA", "country": "US" }, { "value": "Northamton", "label": "Northamton", "state": "MA", "country": "US" }, { "value": "Northbrook", "label": "Northbrook", "state": "IL", "country": "US" }, { "value": "Northolt", "label": "Northolt", "state": "", "country": "GB" }, { "value": "Northport", "label": "Northport", "state": "NY", "country": "US" }, { "value": "Northridge", "label": "Northridge", "state": "CA", "country": "US" }, { "value": "Northwood", "label": "Northwood", "state": "", "country": "GB" }, { "value": "Northwood", "label": "Northwood", "state": "MI", "country": "US" }, { "value": "Norton", "label": "Norton", "state": "MA", "country": "US" }, { "value": "Norwich", "label": "Norwich", "state": "", "country": "GB" }, { "value": "Norwood", "label": "Norwood", "state": "MA", "country": "US" }, { "value": "Notre Dame", "label": "Notre Dame", "state": "IN", "country": "US" }, { "value": "Nottingham", "label": "Nottingham", "state": "", "country": "GB" }, { "value": "Novara", "label": "Novara", "state": "", "country": "IT" }, { "value": "Novato", "label": "Novato", "state": "CA", "country": "US" }, { "value": "NULL", "label": "NULL", "state": "PA", "country": "US" }, { "value": "Nw York", "label": "Nw York", "state": "NY", "country": "US" }, { "value": "NY", "label": "NY", "state": "NY", "country": "US" }, { "value": "NYC", "label": "NYC", "state": "NY", "country": "US" }, { "value": "Oak Brook", "label": "Oak Brook", "state": "IL", "country": "US" }, { "value": "Oak Park", "label": "Oak Park", "state": "IL", "country": "US" }, { "value": "Oak Ridge", "label": "Oak Ridge", "state": "TN", "country": "US" }, { "value": "Oakdale", "label": "Oakdale", "state": "NY", "country": "US" }, { "value": "Oakland", "label": "Oakland", "state": "CA", "country": "US" }, { "value": "Oakton", "label": "Oakton", "state": "VA", "country": "US" }, { "value": "Oakwood Village", "label": "Oakwood Village", "state": "OH", "country": "US" }, { "value": "Oberlin", "label": "Oberlin", "state": "OH", "country": "US" }, { "value": "Obregon", "label": "Obregon", "state": "SO", "country": "MX" }, { "value": "Oeiras", "label": "Oeiras", "state": "", "country": "PT" }, { "value": "Okayama", "label": "Okayama", "state": "33", "country": "JP" }, { "value": "Okemos", "label": "Okemos", "state": "MI", "country": "US" }, { "value": "Oklahoma", "label": "Oklahoma", "state": "OK", "country": "US" }, { "value": "Oklahoma City", "label": "Oklahoma City", "state": "OK", "country": "US" }, { "value": "Old Westbury", "label": "Old Westbury", "state": "NY", "country": "US" }, { "value": "Omaha", "label": "Omaha", "state": "NE", "country": "US" }, { "value": "Ontario", "label": "Ontario", "state": "", "country": "CA" }, { "value": "Orange", "label": "Orange", "state": "CA", "country": "US" }, { "value": "Orangeburg", "label": "Orangeburg", "state": "NY", "country": "US" }, { "value": "Orangeburg", "label": "Orangeburg", "state": "SC", "country": "US" }, { "value": "Orbassano Turin", "label": "Orbassano Turin", "state": "", "country": "IT" }, { "value": "Oriental", "label": "Oriental", "state": "NC", "country": "US" }, { "value": "Orlando", "label": "Orlando", "state": "FL", "country": "US" }, { "value": "Ormskirk", "label": "Ormskirk", "state": "", "country": "GB" }, { "value": "Orono", "label": "Orono", "state": "ME", "country": "US" }, { "value": "Orsay", "label": "Orsay", "state": "", "country": "FR" }, { "value": "Osaka", "label": "Osaka", "state": "27", "country": "JP" }, { "value": "Oshawa", "label": "Oshawa", "state": "ON", "country": "CA" }, { "value": "Otley", "label": "Otley", "state": "", "country": "GB" }, { "value": "Ottawa", "label": "Ottawa", "state": "ON", "country": "CA" }, { "value": "Oullins", "label": "Oullins", "state": "", "country": "FR" }, { "value": "Overland Park", "label": "Overland Park", "state": "KS", "country": "US" }, { "value": "Owego", "label": "Owego", "state": "NY", "country": "US" }, { "value": "Owings Mills", "label": "Owings Mills", "state": "MD", "country": "US" }, { "value": "Oxford", "label": "Oxford", "state": "", "country": "GB" }, { "value": "Oxford", "label": "Oxford", "state": "-", "country": "GB" }, { "value": "Oxford", "label": "Oxford", "state": "MS", "country": "US" }, { "value": "Oxford", "label": "Oxford", "state": "OH", "country": "US" }, { "value": "Oxnard", "label": "Oxnard", "state": "CA", "country": "US" }, { "value": "Oxted", "label": "Oxted", "state": "", "country": "GB" }, { "value": "Pacific Palisades", "label": "Pacific Palisades", "state": "CA", "country": "US" }, { "value": "Padova", "label": "Padova", "state": "", "country": "IT" }, { "value": "Pago Pago", "label": "Pago Pago", "state": "", "country": "AS" }, { "value": "Palmerston North", "label": "Palmerston North", "state": "", "country": "NZ" }, { "value": "Palo Alto", "label": "Palo Alto", "state": "CA", "country": "US" }, { "value": "Palos Verdes", "label": "Palos Verdes", "state": "CA", "country": "US" }, { "value": "Panorama City", "label": "Panorama City", "state": "CA", "country": "US" }, { "value": "Paoli", "label": "Paoli", "state": "PA", "country": "US" }, { "value": "Paris", "label": "Paris", "state": "", "country": "FR" }, { "value": "Park Ridge", "label": "Park Ridge", "state": "IL", "country": "US" }, { "value": "Parkville", "label": "Parkville", "state": "", "country": "AU" }, { "value": "Parkville", "label": "Parkville", "state": "NSW", "country": "AU" }, { "value": "Parkville", "label": "Parkville", "state": "VIC", "country": "AU" }, { "value": "Parma", "label": "Parma", "state": "", "country": "IT" }, { "value": "Pasadena", "label": "Pasadena", "state": "CA", "country": "US" }, { "value": "Pascagoula", "label": "Pascagoula", "state": "MS", "country": "US" }, { "value": "Patras", "label": "Patras", "state": "", "country": "GR" }, { "value": "Pavia", "label": "Pavia", "state": "", "country": "IT" }, { "value": "Pawtucket", "label": "Pawtucket", "state": "RI", "country": "US" }, { "value": "PChennai", "label": "PChennai", "state": "", "country": "IN" }, { "value": "Pecs", "label": "Pecs", "state": "", "country": "HU" }, { "value": "Pelotas", "label": "Pelotas", "state": "", "country": "BR" }, { "value": "Penarth", "label": "Penarth", "state": "", "country": "GB" }, { "value": "Pendleton", "label": "Pendleton", "state": "SC", "country": "US" }, { "value": "Penrith South Dc", "label": "Penrith South Dc", "state": "NSW", "country": "AU" }, { "value": "Pensacola", "label": "Pensacola", "state": "FL", "country": "US" }, { "value": "Peoria", "label": "Peoria", "state": "IL", "country": "US" }, { "value": "Perth", "label": "Perth", "state": "WA", "country": "AU" }, { "value": "Pessac", "label": "Pessac", "state": "", "country": "FR" }, { "value": "Pessac", "label": "Pessac", "state": "-", "country": "FR" }, { "value": "Pessac Cedex", "label": "Pessac Cedex", "state": "", "country": "FR" }, { "value": "Peterborough", "label": "Peterborough", "state": "ON", "country": "CA" }, { "value": "Philadelphia", "label": "Philadelphia", "state": "NC", "country": "US" }, { "value": "Philadelphia", "label": "Philadelphia", "state": "PA", "country": "US" }, { "value": "Phoenix", "label": "Phoenix", "state": "AZ", "country": "US" }, { "value": "Pierre-Benite", "label": "Pierre-Benite", "state": "", "country": "FR" }, { "value": "Pikesville", "label": "Pikesville", "state": "MD", "country": "US" }, { "value": "Pine", "label": "Pine", "state": "CO", "country": "US" }, { "value": "Pisa", "label": "Pisa", "state": "", "country": "IT" }, { "value": "Piscataway", "label": "Piscataway", "state": "NJ", "country": "US" }, { "value": "Pittsburg", "label": "Pittsburg", "state": "PA", "country": "US" }, { "value": "Pittsburgh", "label": "Pittsburgh", "state": "PA", "country": "US" }, { "value": "Pittsford", "label": "Pittsford", "state": "NY", "country": "US" }, { "value": "Plainsboro", "label": "Plainsboro", "state": "NJ", "country": "US" }, { "value": "Plano", "label": "Plano", "state": "TX", "country": "US" }, { "value": "Playa Del Rey", "label": "Playa Del Rey", "state": "CA", "country": "US" }, { "value": "Pleasant Hill", "label": "Pleasant Hill", "state": "CA", "country": "US" }, { "value": "Pleasanton", "label": "Pleasanton", "state": "CA", "country": "US" }, { "value": "Pleasantville", "label": "Pleasantville", "state": "NY", "country": "US" }, { "value": "Plymouth", "label": "Plymouth", "state": "", "country": "GB" }, { "value": "Plymouth", "label": "Plymouth", "state": "MI", "country": "US" }, { "value": "Plymouth", "label": "Plymouth", "state": "MN", "country": "US" }, { "value": "Pointe-A-Pitre", "label": "Pointe-A-Pitre", "state": "", "country": "FR" }, { "value": "Pointe-Claire", "label": "Pointe-Claire", "state": "QC", "country": "CA" }, { "value": "Poitiers", "label": "Poitiers", "state": "", "country": "FR" }, { "value": "PokFulam", "label": "PokFulam", "state": "", "country": "CN" }, { "value": "Pomona", "label": "Pomona", "state": "CA", "country": "US" }, { "value": "Ponce", "label": "Ponce", "state": "", "country": "PR" }, { "value": "Ponce", "label": "Ponce", "state": "PR", "country": "US" }, { "value": "Pontypridd", "label": "Pontypridd", "state": "", "country": "GB" }, { "value": "Port Hueneme", "label": "Port Hueneme", "state": "CA", "country": "US" }, { "value": "Port Orange", "label": "Port Orange", "state": "FL", "country": "US" }, { "value": "Port Saint Lucie", "label": "Port Saint Lucie", "state": "FL", "country": "US" }, { "value": "Port St. Lucie", "label": "Port St. Lucie", "state": "FL", "country": "US" }, { "value": "Portland", "label": "Portland", "state": "ME", "country": "US" }, { "value": "Portland", "label": "Portland", "state": "OR", "country": "US" }, { "value": "Porto", "label": "Porto", "state": "", "country": "PT" }, { "value": "Porto Alegre", "label": "Porto Alegre", "state": "", "country": "BR" }, { "value": "Portola Valley", "label": "Portola Valley", "state": "", "country": "US" }, { "value": "Portola Valley", "label": "Portola Valley", "state": "CA", "country": "US" }, { "value": "Portsmouth", "label": "Portsmouth", "state": "", "country": "GB" }, { "value": "Potomac", "label": "Potomac", "state": "", "country": "US" }, { "value": "Potomac", "label": "Potomac", "state": "MD", "country": "US" }, { "value": "Potsdam", "label": "Potsdam", "state": "NY", "country": "US" }, { "value": "Potters Bar", "label": "Potters Bar", "state": "", "country": "GB" }, { "value": "Poway", "label": "Poway", "state": "CA", "country": "US" }, { "value": "Prague", "label": "Prague", "state": "", "country": "CZ" }, { "value": "Prairie Village", "label": "Prairie Village", "state": "KS", "country": "US" }, { "value": "Preston", "label": "Preston", "state": "", "country": "GB" }, { "value": "Pretoria", "label": "Pretoria", "state": "", "country": "ZA" }, { "value": "Prince George", "label": "Prince George", "state": "BC", "country": "CA" }, { "value": "Princess Anne", "label": "Princess Anne", "state": "MD", "country": "US" }, { "value": "Princeton", "label": "Princeton", "state": "NJ", "country": "US" }, { "value": "Princeton", "label": "Princeton", "state": "NY", "country": "US" }, { "value": "Princeton Junction", "label": "Princeton Junction", "state": "NJ", "country": "US" }, { "value": "Prospect", "label": "Prospect", "state": "KY", "country": "US" }, { "value": "Providence", "label": "Providence", "state": "RI", "country": "US" }, { "value": "Provo", "label": "Provo", "state": "UT", "country": "US" }, { "value": "Pttsburgh", "label": "Pttsburgh", "state": "PA", "country": "US" }, { "value": "Pueblo", "label": "Pueblo", "state": "CO", "country": "US" }, { "value": "Pullman", "label": "Pullman", "state": "WA", "country": "US" }, { "value": "Pune", "label": "Pune", "state": "", "country": "IN" }, { "value": "Purchase", "label": "Purchase", "state": "NY", "country": "US" }, { "value": "Quebec", "label": "Quebec", "state": "QC", "country": "CA" }, { "value": "Qu\u00e9bec", "label": "Qu\u00e9bec", "state": "QC", "country": "CA" }, { "value": "Queens", "label": "Queens", "state": "NY", "country": "US" }, { "value": "Queensbury", "label": "Queensbury", "state": "NY", "country": "US" }, { "value": "Queensland", "label": "Queensland", "state": "", "country": "AU" }, { "value": "Quincy", "label": "Quincy", "state": "MA", "country": "US" }, { "value": "Raanana", "label": "Raanana", "state": "", "country": "IL" }, { "value": "Radford", "label": "Radford", "state": "VA", "country": "US" }, { "value": "Radnor", "label": "Radnor", "state": "PA", "country": "US" }, { "value": "Raleigh", "label": "Raleigh", "state": "NC", "country": "US" }, { "value": "Ramat Aviv", "label": "Ramat Aviv", "state": "", "country": "IL" }, { "value": "Ramat Gan", "label": "Ramat Gan", "state": "", "country": "IL" }, { "value": "Ramat-Gan", "label": "Ramat-Gan", "state": "", "country": "IS" }, { "value": "Rancho Dominguez", "label": "Rancho Dominguez", "state": "CA", "country": "US" }, { "value": "Randwick", "label": "Randwick", "state": "NSW", "country": "AU" }, { "value": "Rapid City", "label": "Rapid City", "state": "SD", "country": "US" }, { "value": "Reading", "label": "Reading", "state": "", "country": "GB" }, { "value": "Redlands", "label": "Redlands", "state": "CA", "country": "US" }, { "value": "Redmond", "label": "Redmond", "state": "WA", "country": "US" }, { "value": "Redwood City", "label": "Redwood City", "state": "CA", "country": "US" }, { "value": "Regina", "label": "Regina", "state": "SK", "country": "CA" }, { "value": "Rehovot", "label": "Rehovot", "state": "", "country": "IL" }, { "value": "Rehovot", "label": "Rehovot", "state": "", "country": "IS" }, { "value": "Rehovot", "label": "Rehovot", "state": "TX", "country": "IL" }, { "value": "Rehovot, Israel", "label": "Rehovot, Israel", "state": "", "country": "IL" }, { "value": "Reims", "label": "Reims", "state": "", "country": "FR" }, { "value": "Rennes", "label": "Rennes", "state": "", "country": "FR" }, { "value": "Reno", "label": "Reno", "state": "NV", "country": "US" }, { "value": "Rensselaer", "label": "Rensselaer", "state": "NY", "country": "US" }, { "value": "Research Triangle", "label": "Research Triangle", "state": "NC", "country": "US" }, { "value": "Research Triangle Pa", "label": "Research Triangle Pa", "state": "NC", "country": "US" }, { "value": "Research Triangle Park", "label": "Research Triangle Park", "state": "NC", "country": "US" }, { "value": "Reston", "label": "Reston", "state": "VA", "country": "US" }, { "value": "Reykjavik", "label": "Reykjavik", "state": "", "country": "IS" }, { "value": "Rhyl", "label": "Rhyl", "state": "", "country": "GB" }, { "value": "Richardson", "label": "Richardson", "state": "TX", "country": "US" }, { "value": "Richland", "label": "Richland", "state": "WA", "country": "US" }, { "value": "Richmond", "label": "Richmond", "state": "BC", "country": "CA" }, { "value": "Richmond", "label": "Richmond", "state": "CA", "country": "US" }, { "value": "Richmond", "label": "Richmond", "state": "VA", "country": "US" }, { "value": "Richmond Hill", "label": "Richmond Hill", "state": "ON", "country": "CA" }, { "value": "Rio Nido", "label": "Rio Nido", "state": "CA", "country": "US" }, { "value": "Rio Piedras", "label": "Rio Piedras", "state": "PR", "country": "US" }, { "value": "River Vale", "label": "River Vale", "state": "NJ", "country": "US" }, { "value": "Riverside", "label": "Riverside", "state": "CA", "country": "US" }, { "value": "Roanoke", "label": "Roanoke", "state": "VA", "country": "US" }, { "value": "Rochester", "label": "Rochester", "state": "MI", "country": "US" }, { "value": "Rochester", "label": "Rochester", "state": "MN", "country": "US" }, { "value": "Rochester", "label": "Rochester", "state": "NY", "country": "US" }, { "value": "Rochester Hills", "label": "Rochester Hills", "state": "MI", "country": "US" }, { "value": "Rochester, Mn", "label": "Rochester, Mn", "state": "MN", "country": "US" }, { "value": "Rock Hill", "label": "Rock Hill", "state": "SC", "country": "US" }, { "value": "Rockford", "label": "Rockford", "state": "MI", "country": "US" }, { "value": "Rockvile", "label": "Rockvile", "state": "MD", "country": "US" }, { "value": "Rockville", "label": "Rockville", "state": "MD", "country": "US" }, { "value": "Rockville", "label": "Rockville", "state": "NC", "country": "US" }, { "value": "Rocky Hill", "label": "Rocky Hill", "state": "CT", "country": "US" }, { "value": "Rolla", "label": "Rolla", "state": "MO", "country": "US" }, { "value": "Roma", "label": "Roma", "state": "", "country": "IT" }, { "value": "Rome", "label": "Rome", "state": "", "country": "IT" }, { "value": "Rondebosch", "label": "Rondebosch", "state": "", "country": "ZA" }, { "value": "Rootstown", "label": "Rootstown", "state": "OH", "country": "US" }, { "value": "Rosemont", "label": "Rosemont", "state": "IL", "country": "US" }, { "value": "Roseville", "label": "Roseville", "state": "MN", "country": "US" }, { "value": "Roslyn", "label": "Roslyn", "state": "NY", "country": "US" }, { "value": "Rotterdam", "label": "Rotterdam", "state": "", "country": "NL" }, { "value": "Rouen", "label": "Rouen", "state": "", "country": "FR" }, { "value": "Rouyn-Noranda", "label": "Rouyn-Noranda", "state": "QC", "country": "CA" }, { "value": "Rowlett", "label": "Rowlett", "state": "TX", "country": "US" }, { "value": "Roxbury", "label": "Roxbury", "state": "CT", "country": "US" }, { "value": "Royal Oak", "label": "Royal Oak", "state": "MI", "country": "US" }, { "value": "Rozzano", "label": "Rozzano", "state": "", "country": "IT" }, { "value": "Rtp", "label": "Rtp", "state": "NC", "country": "US" }, { "value": "Ruskin", "label": "Ruskin", "state": "FL", "country": "US" }, { "value": "Ruston", "label": "Ruston", "state": "LA", "country": "US" }, { "value": "Rutherford", "label": "Rutherford", "state": "NJ", "country": "US" }, { "value": "Ryde", "label": "Ryde", "state": "", "country": "AU" }, { "value": "Sackville", "label": "Sackville", "state": "NB", "country": "CA" }, { "value": "Sacramento", "label": "Sacramento", "state": "CA", "country": "US" }, { "value": "Saffron Walden", "label": "Saffron Walden", "state": "", "country": "GB" }, { "value": "Saint John", "label": "Saint John", "state": "NB", "country": "CA" }, { "value": "Saint Louis", "label": "Saint Louis", "state": "MO", "country": "US" }, { "value": "Saint Paul", "label": "Saint Paul", "state": "MN", "country": "US" }, { "value": "Saint-Cloud", "label": "Saint-Cloud", "state": "", "country": "FR" }, { "value": "Saint-Etienne", "label": "Saint-Etienne", "state": "", "country": "FR" }, { "value": "Saint-Herblain", "label": "Saint-Herblain", "state": "", "country": "FR" }, { "value": "Saint-Laurent", "label": "Saint-Laurent", "state": "QC", "country": "CA" }, { "value": "Saint-Leonard", "label": "Saint-Leonard", "state": "", "country": "CA" }, { "value": "Saint-Leonard", "label": "Saint-Leonard", "state": "QC", "country": "CA" }, { "value": "Saint-Pierre Ile De La R\u00e9union", "label": "Saint-Pierre Ile De La R\u00e9union", "state": "", "country": "FR" }, { "value": "Sainte-Anne-De-Bel", "label": "Sainte-Anne-De-Bel", "state": "QC", "country": "CA" }, { "value": "Sainte-Anne-De-Bellevue", "label": "Sainte-Anne-De-Bellevue", "state": "QC", "country": "CA" }, { "value": "Salamanca", "label": "Salamanca", "state": "", "country": "ES" }, { "value": "Salem", "label": "Salem", "state": "OR", "country": "US" }, { "value": "Salford", "label": "Salford", "state": "", "country": "GB" }, { "value": "Salinas", "label": "Salinas", "state": "CA", "country": "US" }, { "value": "Salisbury", "label": "Salisbury", "state": "", "country": "GB" }, { "value": "Salisbury", "label": "Salisbury", "state": "MD", "country": "US" }, { "value": "Salisbury Cove", "label": "Salisbury Cove", "state": "ME", "country": "US" }, { "value": "Salt lake", "label": "Salt lake", "state": "UT", "country": "US" }, { "value": "Salt Lake City", "label": "Salt Lake City", "state": "UT", "country": "US" }, { "value": "Salvador", "label": "Salvador", "state": "", "country": "BR" }, { "value": "Sammamish", "label": "Sammamish", "state": "WA", "country": "US" }, { "value": "San Antonio", "label": "San Antonio", "state": "TX", "country": "US" }, { "value": "San Carlos", "label": "San Carlos", "state": "CA", "country": "US" }, { "value": "San Diego", "label": "San Diego", "state": "", "country": "US" }, { "value": "San Diego", "label": "San Diego", "state": "CA", "country": "US" }, { "value": "San Francisco", "label": "San Francisco", "state": "CA", "country": "US" }, { "value": "San Francisco,", "label": "San Francisco,", "state": "CA", "country": "US" }, { "value": "San Francsico", "label": "San Francsico", "state": "CA", "country": "US" }, { "value": "San Jose", "label": "San Jose", "state": "CA", "country": "US" }, { "value": "San Juan", "label": "San Juan", "state": "PR", "country": "US" }, { "value": "San Leandro", "label": "San Leandro", "state": "CA", "country": "US" }, { "value": "San Marcos", "label": "San Marcos", "state": "CA", "country": "US" }, { "value": "San Marcos", "label": "San Marcos", "state": "TX", "country": "US" }, { "value": "San Marino", "label": "San Marino", "state": "CA", "country": "US" }, { "value": "San Mateo", "label": "San Mateo", "state": "CA", "country": "US" }, { "value": "San Rafael", "label": "San Rafael", "state": "CA", "country": "US" }, { "value": "San Ysidro", "label": "San Ysidro", "state": "CA", "country": "US" }, { "value": "Sandy", "label": "Sandy", "state": "UT", "country": "US" }, { "value": "Santa Ana", "label": "Santa Ana", "state": "CA", "country": "US" }, { "value": "Santa Babara", "label": "Santa Babara", "state": "CA", "country": "US" }, { "value": "Santa Barbara", "label": "Santa Barbara", "state": "CA", "country": "US" }, { "value": "Santa Clara", "label": "Santa Clara", "state": "CA", "country": "US" }, { "value": "Santa Cruz", "label": "Santa Cruz", "state": "CA", "country": "US" }, { "value": "Santa Fe", "label": "Santa Fe", "state": "NM", "country": "US" }, { "value": "Santa Fe Springs", "label": "Santa Fe Springs", "state": "CA", "country": "US" }, { "value": "Santa Monica", "label": "Santa Monica", "state": "CA", "country": "US" }, { "value": "Santa Rosa", "label": "Santa Rosa", "state": "CA", "country": "US" }, { "value": "Santiago", "label": "Santiago", "state": "", "country": "CL" }, { "value": "Sapporo", "label": "Sapporo", "state": "01", "country": "JP" }, { "value": "Saranac Lake", "label": "Saranac Lake", "state": "NY", "country": "US" }, { "value": "Sarasota", "label": "Sarasota", "state": "FL", "country": "US" }, { "value": "Saskatoon", "label": "Saskatoon", "state": "SK", "country": "CA" }, { "value": "Sault Ste Marie", "label": "Sault Ste Marie", "state": "ON", "country": "CA" }, { "value": "Sault Ste. Marie", "label": "Sault Ste. Marie", "state": "MI", "country": "US" }, { "value": "Savage", "label": "Savage", "state": "MD", "country": "US" }, { "value": "Savannah", "label": "Savannah", "state": "GA", "country": "US" }, { "value": "Savoy", "label": "Savoy", "state": "IL", "country": "US" }, { "value": "Saybrook Manor", "label": "Saybrook Manor", "state": "CT", "country": "US" }, { "value": "Sayre", "label": "Sayre", "state": "PA", "country": "US" }, { "value": "Scarborough", "label": "Scarborough", "state": "", "country": "GB" }, { "value": "Scarborough", "label": "Scarborough", "state": "ME", "country": "US" }, { "value": "Schaumburg", "label": "Schaumburg", "state": "IL", "country": "US" }, { "value": "Schenectady", "label": "Schenectady", "state": "NY", "country": "US" }, { "value": "Scotland", "label": "Scotland", "state": "", "country": "GB" }, { "value": "Scottsdale", "label": "Scottsdale", "state": "AZ", "country": "US" }, { "value": "Scranton", "label": "Scranton", "state": "PA", "country": "US" }, { "value": "Seattle", "label": "Seattle", "state": "WA", "country": "US" }, { "value": "Sebastopol", "label": "Sebastopol", "state": "CA", "country": "US" }, { "value": "Sejong", "label": "Sejong", "state": "", "country": "KR" }, { "value": "Seoul", "label": "Seoul", "state": "", "country": "KR" }, { "value": "Sepulveda", "label": "Sepulveda", "state": "CA", "country": "US" }, { "value": "Setauket", "label": "Setauket", "state": "NY", "country": "US" }, { "value": "Severna Park", "label": "Severna Park", "state": "MD", "country": "US" }, { "value": "Shanghai", "label": "Shanghai", "state": "", "country": "CN" }, { "value": "Shanghai", "label": "Shanghai", "state": "CH", "country": "CN" }, { "value": "Sheffield", "label": "Sheffield", "state": "", "country": "GB" }, { "value": "Shelby Township", "label": "Shelby Township", "state": "MI", "country": "US" }, { "value": "Sherbrooke", "label": "Sherbrooke", "state": "QC", "country": "CA" }, { "value": "Shinagawa-ku", "label": "Shinagawa-ku", "state": "13", "country": "JP" }, { "value": "Shinjuku-ku", "label": "Shinjuku-ku", "state": "13", "country": "JP" }, { "value": "Shiprock", "label": "Shiprock", "state": "NM", "country": "US" }, { "value": "Shizuoka", "label": "Shizuoka", "state": "22", "country": "JP" }, { "value": "Shoreline", "label": "Shoreline", "state": "WA", "country": "US" }, { "value": "Shreveport", "label": "Shreveport", "state": "LA", "country": "US" }, { "value": "Shrewsbury", "label": "Shrewsbury", "state": "MA", "country": "US" }, { "value": "Sillery", "label": "Sillery", "state": "QC", "country": "CA" }, { "value": "Silsoe", "label": "Silsoe", "state": "", "country": "GB" }, { "value": "Silver Spring", "label": "Silver Spring", "state": "MD", "country": "US" }, { "value": "Silverthorne", "label": "Silverthorne", "state": "CO", "country": "US" }, { "value": "Singapore", "label": "Singapore", "state": "", "country": "SG" }, { "value": "Sioux Center", "label": "Sioux Center", "state": "IA", "country": "US" }, { "value": "Sioux Falls", "label": "Sioux Falls", "state": "SD", "country": "US" }, { "value": "Skillman", "label": "Skillman", "state": "NJ", "country": "US" }, { "value": "Slidell", "label": "Slidell", "state": "LA", "country": "US" }, { "value": "Smithville", "label": "Smithville", "state": "TX", "country": "US" }, { "value": "Snyder", "label": "Snyder", "state": "NY", "country": "US" }, { "value": "Socorro", "label": "Socorro", "state": "NM", "country": "US" }, { "value": "Solon", "label": "Solon", "state": "OH", "country": "US" }, { "value": "Somerset", "label": "Somerset", "state": "NJ", "country": "US" }, { "value": "Somerville", "label": "Somerville", "state": "MA", "country": "US" }, { "value": "Sonora", "label": "Sonora", "state": "SO", "country": "MX" }, { "value": "South Bend", "label": "South Bend", "state": "IN", "country": "US" }, { "value": "South Brisbane", "label": "South Brisbane", "state": "QLD", "country": "AU" }, { "value": "South Dartmouth", "label": "South Dartmouth", "state": "MA", "country": "US" }, { "value": "South Lyon", "label": "South Lyon", "state": "MI", "country": "US" }, { "value": "South Mimms", "label": "South Mimms", "state": "", "country": "GB" }, { "value": "South Orange", "label": "South Orange", "state": "NJ", "country": "US" }, { "value": "South Plainfield", "label": "South Plainfield", "state": "NJ", "country": "US" }, { "value": "South Portland", "label": "South Portland", "state": "ME", "country": "US" }, { "value": "South San Francisco", "label": "South San Francisco", "state": "CA", "country": "US" }, { "value": "South Shields", "label": "South Shields", "state": "", "country": "GB" }, { "value": "Southampton", "label": "Southampton", "state": "", "country": "GB" }, { "value": "Southbridge", "label": "Southbridge", "state": "MA", "country": "US" }, { "value": "Southfield", "label": "Southfield", "state": "MI", "country": "US" }, { "value": "Southport", "label": "Southport", "state": "QLD", "country": "AU" }, { "value": "Spartanburg", "label": "Spartanburg", "state": "SC", "country": "US" }, { "value": "Spinnerstown", "label": "Spinnerstown", "state": "PA", "country": "US" }, { "value": "Spokane", "label": "Spokane", "state": "WA", "country": "US" }, { "value": "Springdale", "label": "Springdale", "state": "AR", "country": "US" }, { "value": "Springfield", "label": "Springfield", "state": "IL", "country": "US" }, { "value": "Springfield", "label": "Springfield", "state": "MA", "country": "US" }, { "value": "Springfield", "label": "Springfield", "state": "MO", "country": "US" }, { "value": "Springfield", "label": "Springfield", "state": "VA", "country": "US" }, { "value": "St Albans", "label": "St Albans", "state": "", "country": "GB" }, { "value": "St Andrews", "label": "St Andrews", "state": "", "country": "GB" }, { "value": "St Catharines", "label": "St Catharines", "state": "ON", "country": "CA" }, { "value": "St Leonards", "label": "St Leonards", "state": "", "country": "AU" }, { "value": "St Leonards", "label": "St Leonards", "state": "NSW", "country": "AU" }, { "value": "St Louis", "label": "St Louis", "state": "MO", "country": "US" }, { "value": "St Lucia", "label": "St Lucia", "state": "QLD", "country": "AU" }, { "value": "St Paul", "label": "St Paul", "state": "MN", "country": "US" }, { "value": "St. Andrews", "label": "St. Andrews", "state": "", "country": "GB" }, { "value": "St. Catharines", "label": "St. Catharines", "state": "ON", "country": "CA" }, { "value": "St. John\u0027s", "label": "St. John\u0027s", "state": "NL", "country": "CA" }, { "value": "St. Joseph", "label": "St. Joseph", "state": "MI", "country": "US" }, { "value": "St. Joseph", "label": "St. Joseph", "state": "MO", "country": "US" }, { "value": "St. Leonards", "label": "St. Leonards", "state": "", "country": "AU" }, { "value": "St. Louis", "label": "St. Louis", "state": "MN", "country": "US" }, { "value": "St. Louis", "label": "St. Louis", "state": "MO", "country": "US" }, { "value": "St. Louis", "label": "St. Louis", "state": "WA", "country": "US" }, { "value": "St. Louis Park", "label": "St. Louis Park", "state": "MN", "country": "US" }, { "value": "St. Paul", "label": "St. Paul", "state": "MN", "country": "US" }, { "value": "St. Rose", "label": "St. Rose", "state": "LA", "country": "US" }, { "value": "Stanford", "label": "Stanford", "state": "CA", "country": "US" }, { "value": "Stanford", "label": "Stanford", "state": "NY", "country": "US" }, { "value": "State College", "label": "State College", "state": "PA", "country": "US" }, { "value": "Staten Island", "label": "Staten Island", "state": "NY", "country": "US" }, { "value": "Statesboro", "label": "Statesboro", "state": "GA", "country": "US" }, { "value": "Sterling", "label": "Sterling", "state": "VA", "country": "US" }, { "value": "Stillwater", "label": "Stillwater", "state": "MN", "country": "US" }, { "value": "Stillwater", "label": "Stillwater", "state": "OK", "country": "US" }, { "value": "Stirling", "label": "Stirling", "state": "", "country": "GB" }, { "value": "Stockholm", "label": "Stockholm", "state": "", "country": "SE" }, { "value": "Stockholm", "label": "Stockholm", "state": "-", "country": "SE" }, { "value": "Stockport", "label": "Stockport", "state": "", "country": "GB" }, { "value": "Stockton", "label": "Stockton", "state": "CA", "country": "US" }, { "value": "Stoke On Trent", "label": "Stoke On Trent", "state": "", "country": "GB" }, { "value": "Stony Brook", "label": "Stony Brook", "state": "NY", "country": "US" }, { "value": "Storrs", "label": "Storrs", "state": "CT", "country": "US" }, { "value": "Storrs-Mansfield", "label": "Storrs-Mansfield", "state": "CT", "country": "US" }, { "value": "Strafford", "label": "Strafford", "state": "PA", "country": "US" }, { "value": "Strasbourg", "label": "Strasbourg", "state": "", "country": "FR" }, { "value": "Stratford", "label": "Stratford", "state": "NJ", "country": "US" }, { "value": "Strawberry Hills", "label": "Strawberry Hills", "state": "NSW", "country": "AU" }, { "value": "Subiaco", "label": "Subiaco", "state": "", "country": "AU" }, { "value": "Subiaco", "label": "Subiaco", "state": "WA", "country": "AU" }, { "value": "Sudbury", "label": "Sudbury", "state": "ON", "country": "CA" }, { "value": "Sugar Land", "label": "Sugar Land", "state": "TX", "country": "US" }, { "value": "Sunderland", "label": "Sunderland", "state": "", "country": "GB" }, { "value": "Sunnybrook", "label": "Sunnybrook", "state": "NY", "country": "US" }, { "value": "Sunnyvale", "label": "Sunnyvale", "state": "CA", "country": "US" }, { "value": "Sunto-gun", "label": "Sunto-gun", "state": "22", "country": "JP" }, { "value": "Surrey", "label": "Surrey", "state": "", "country": "GB" }, { "value": "Surrey", "label": "Surrey", "state": "BC", "country": "CA" }, { "value": "Surry Hills", "label": "Surry Hills", "state": "NSW", "country": "AU" }, { "value": "Sussex", "label": "Sussex", "state": "", "country": "GB" }, { "value": "Sutton", "label": "Sutton", "state": "", "country": "GB" }, { "value": "Swansea", "label": "Swansea", "state": "", "country": "GB" }, { "value": "Swarthmore", "label": "Swarthmore", "state": "PA", "country": "US" }, { "value": "Swindon", "label": "Swindon", "state": "", "country": "GB" }, { "value": "Sydney", "label": "Sydney", "state": "", "country": "AS" }, { "value": "Sydney", "label": "Sydney", "state": "", "country": "AU" }, { "value": "Sydney", "label": "Sydney", "state": "NS", "country": "CA" }, { "value": "Sydney", "label": "Sydney", "state": "NSW", "country": "AU" }, { "value": "Sylvania", "label": "Sylvania", "state": "OH", "country": "US" }, { "value": "Syracuse", "label": "Syracuse", "state": "NY", "country": "US" }, { "value": "Tacoma", "label": "Tacoma", "state": "WA", "country": "US" }, { "value": "Tahlequah", "label": "Tahlequah", "state": "OK", "country": "US" }, { "value": "Tainan", "label": "Tainan", "state": "", "country": "TW" }, { "value": "Taipei", "label": "Taipei", "state": "", "country": "TW" }, { "value": "Taiyuan", "label": "Taiyuan", "state": "", "country": "CN" }, { "value": "Talence", "label": "Talence", "state": "", "country": "FR" }, { "value": "Tallahassee", "label": "Tallahassee", "state": "FL", "country": "US" }, { "value": "Tallin", "label": "Tallin", "state": "", "country": "EE" }, { "value": "Tampa", "label": "Tampa", "state": "FL", "country": "US" }, { "value": "Tarrytown", "label": "Tarrytown", "state": "NY", "country": "US" }, { "value": "Tartu", "label": "Tartu", "state": "", "country": "EE" }, { "value": "Tarzana", "label": "Tarzana", "state": "CA", "country": "US" }, { "value": "Taunton", "label": "Taunton", "state": "", "country": "GB" }, { "value": "Tel Aviv", "label": "Tel Aviv", "state": "", "country": "IL" }, { "value": "Tel Hashomer", "label": "Tel Hashomer", "state": "", "country": "IL" }, { "value": "Temecula", "label": "Temecula", "state": "CA", "country": "US" }, { "value": "Tempe", "label": "Tempe", "state": "AZ", "country": "US" }, { "value": "Temple", "label": "Temple", "state": "TX", "country": "US" }, { "value": "Temple Terrace", "label": "Temple Terrace", "state": "FL", "country": "US" }, { "value": "Terre Haute", "label": "Terre Haute", "state": "IN", "country": "US" }, { "value": "The Woodlands", "label": "The Woodlands", "state": "TX", "country": "US" }, { "value": "Thousand Oaks", "label": "Thousand Oaks", "state": "CA", "country": "US" }, { "value": "Thunder Bay", "label": "Thunder Bay", "state": "ON", "country": "CA" }, { "value": "Tianjin", "label": "Tianjin", "state": "", "country": "CN" }, { "value": "Tigard", "label": "Tigard", "state": "OR", "country": "US" }, { "value": "Tilburg", "label": "Tilburg", "state": "", "country": "NL" }, { "value": "Tokyo", "label": "Tokyo", "state": "", "country": "JP" }, { "value": "Toledo", "label": "Toledo", "state": "OH", "country": "US" }, { "value": "Toluca Lake", "label": "Toluca Lake", "state": "CA", "country": "US" }, { "value": "Toms River", "label": "Toms River", "state": "NJ", "country": "US" }, { "value": "Toowoomba", "label": "Toowoomba", "state": "QLD", "country": "AU" }, { "value": "Torino", "label": "Torino", "state": "", "country": "IT" }, { "value": "Toronto", "label": "Toronto", "state": "", "country": "CA" }, { "value": "Toronto", "label": "Toronto", "state": "ON", "country": "CA" }, { "value": "Toronto", "label": "Toronto", "state": "ON", "country": "US" }, { "value": "Torrance", "label": "Torrance", "state": "CA", "country": "US" }, { "value": "Toulouse", "label": "Toulouse", "state": "", "country": "FR" }, { "value": "Tours", "label": "Tours", "state": "", "country": "FR" }, { "value": "Towson", "label": "Towson", "state": "MD", "country": "US" }, { "value": "Trento", "label": "Trento", "state": "", "country": "IT" }, { "value": "Trenton", "label": "Trenton", "state": "NJ", "country": "US" }, { "value": "Triangle Park", "label": "Triangle Park", "state": "NC", "country": "US" }, { "value": "Trieste", "label": "Trieste", "state": "", "country": "IT" }, { "value": "Trois-Rivieres", "label": "Trois-Rivieres", "state": "QC", "country": "CA" }, { "value": "Trois-Rivi\u00e8res", "label": "Trois-Rivi\u00e8res", "state": "QC", "country": "CA" }, { "value": "Trois-Rivi\u00fdres", "label": "Trois-Rivi\u00fdres", "state": "QC", "country": "CA" }, { "value": "Troy", "label": "Troy", "state": "MI", "country": "US" }, { "value": "Troy", "label": "Troy", "state": "NY", "country": "US" }, { "value": "Trumbull", "label": "Trumbull", "state": "CT", "country": "US" }, { "value": "Truro", "label": "Truro", "state": "", "country": "GB" }, { "value": "Tsaile", "label": "Tsaile", "state": "AZ", "country": "US" }, { "value": "Tucker", "label": "Tucker", "state": "GA", "country": "US" }, { "value": "Tucon", "label": "Tucon", "state": "AZ", "country": "US" }, { "value": "Tucson", "label": "Tucson", "state": "AZ", "country": "" }, { "value": "Tucson", "label": "Tucson", "state": "AZ", "country": "US" }, { "value": "Tullahoma", "label": "Tullahoma", "state": "TN", "country": "US" }, { "value": "Tulsa", "label": "Tulsa", "state": "OK", "country": "US" }, { "value": "Turin", "label": "Turin", "state": "", "country": "IT" }, { "value": "Turku", "label": "Turku", "state": "", "country": "FI" }, { "value": "Turun", "label": "Turun", "state": "", "country": "FI" }, { "value": "Tuscaloosa", "label": "Tuscaloosa", "state": "AL", "country": "US" }, { "value": "Tuskegee", "label": "Tuskegee", "state": "AL", "country": "US" }, { "value": "Tuxedo", "label": "Tuxedo", "state": "NY", "country": "US" }, { "value": "Tyler", "label": "Tyler", "state": "TX", "country": "US" }, { "value": "Ulm", "label": "Ulm", "state": "", "country": "DE" }, { "value": "Ume\u0026#229;", "label": "Ume\u0026#229;", "state": "", "country": "SE" }, { "value": "Umea", "label": "Umea", "state": "", "country": "SE" }, { "value": "Ume\u00e5", "label": "Ume\u00e5", "state": "", "country": "SE" }, { "value": "Union City", "label": "Union City", "state": "CA", "country": "US" }, { "value": "University", "label": "University", "state": "MS", "country": "US" }, { "value": "University Park", "label": "University Park", "state": "PA", "country": "US" }, { "value": "Upper Marlboro", "label": "Upper Marlboro", "state": "MD", "country": "US" }, { "value": "Uppsala", "label": "Uppsala", "state": "", "country": "SE" }, { "value": "Upsula", "label": "Upsula", "state": "", "country": "SE" }, { "value": "Upton", "label": "Upton", "state": "NY", "country": "US" }, { "value": "Urbana", "label": "Urbana", "state": "IL", "country": "US" }, { "value": "Urbandale", "label": "Urbandale", "state": "IA", "country": "US" }, { "value": "Utrecht", "label": "Utrecht", "state": "", "country": "NL" }, { "value": "Utsunomiya", "label": "Utsunomiya", "state": "09", "country": "JP" }, { "value": "Uxbridge", "label": "Uxbridge", "state": "", "country": "GB" }, { "value": "Valbonne", "label": "Valbonne", "state": "", "country": "FR" }, { "value": "Valbonne", "label": "Valbonne", "state": "-", "country": "FR" }, { "value": "Valhalla", "label": "Valhalla", "state": "NY", "country": "US" }, { "value": "Vallejo", "label": "Vallejo", "state": "CA", "country": "US" }, { "value": "Vancouver", "label": "Vancouver", "state": "", "country": "CA" }, { "value": "Vancouver", "label": "Vancouver", "state": "BC", "country": "CA" }, { "value": "Vancouver", "label": "Vancouver", "state": "BC", "country": "US" }, { "value": "Vancouver", "label": "Vancouver", "state": "WA", "country": "US" }, { "value": "Vandoeuvre-Les-Nancy", "label": "Vandoeuvre-Les-Nancy", "state": "", "country": "FR" }, { "value": "Vari", "label": "Vari", "state": "", "country": "GR" }, { "value": "Varkiza", "label": "Varkiza", "state": "", "country": "GR" }, { "value": "Vermillion", "label": "Vermillion", "state": "SD", "country": "US" }, { "value": "Verona", "label": "Verona", "state": "", "country": "IT" }, { "value": "Verona", "label": "Verona", "state": "WI", "country": "US" }, { "value": "Vestavia Hills", "label": "Vestavia Hills", "state": "AL", "country": "US" }, { "value": "Victoria", "label": "Victoria", "state": "", "country": "AU" }, { "value": "Victoria", "label": "Victoria", "state": "", "country": "CA" }, { "value": "Victoria", "label": "Victoria", "state": "BC", "country": "CA" }, { "value": "Vienna", "label": "Vienna", "state": "", "country": "AT" }, { "value": "Villanova", "label": "Villanova", "state": "PA", "country": "US" }, { "value": "Villanova University", "label": "Villanova University", "state": "PA", "country": "US" }, { "value": "Villejuif", "label": "Villejuif", "state": "", "country": "FR" }, { "value": "Villeurbanne", "label": "Villeurbanne", "state": "", "country": "FR" }, { "value": "Vista", "label": "Vista", "state": "CA", "country": "US" }, { "value": "Waban", "label": "Waban", "state": "MA", "country": "US" }, { "value": "Waco", "label": "Waco", "state": "TX", "country": "US" }, { "value": "Wageningen", "label": "Wageningen", "state": "", "country": "NL" }, { "value": "Wakefield", "label": "Wakefield", "state": "", "country": "GB" }, { "value": "Wakefield", "label": "Wakefield", "state": "MA", "country": "US" }, { "value": "Walnut", "label": "Walnut", "state": "CA", "country": "US" }, { "value": "Walnut Creek", "label": "Walnut Creek", "state": "CA", "country": "US" }, { "value": "Waltham", "label": "Waltham", "state": "MA", "country": "US" }, { "value": "Warsaw", "label": "Warsaw", "state": "", "country": "PL" }, { "value": "Warwick", "label": "Warwick", "state": "", "country": "GB" }, { "value": "Warwick", "label": "Warwick", "state": "RI", "country": "US" }, { "value": "Washington", "label": "Washington", "state": "", "country": "US" }, { "value": "Washington", "label": "Washington", "state": "DC", "country": "US" }, { "value": "Washington", "label": "Washington", "state": "VA", "country": "US" }, { "value": "Washington Crossing", "label": "Washington Crossing", "state": "PA", "country": "US" }, { "value": "Washington Dc", "label": "Washington Dc", "state": "DC", "country": "US" }, { "value": "Waterloo", "label": "Waterloo", "state": "", "country": "CA" }, { "value": "Waterloo", "label": "Waterloo", "state": "ON", "country": "CA" }, { "value": "Waterloo", "label": "Waterloo", "state": "ON", "country": "US" }, { "value": "Waterton", "label": "Waterton", "state": "MA", "country": "US" }, { "value": "Watertown", "label": "Watertown", "state": "MA", "country": "US" }, { "value": "Waterville", "label": "Waterville", "state": "ME", "country": "US" }, { "value": "Waunakee", "label": "Waunakee", "state": "WI", "country": "US" }, { "value": "Wauwatosa", "label": "Wauwatosa", "state": "WI", "country": "US" }, { "value": "Wellesley", "label": "Wellesley", "state": "MA", "country": "US" }, { "value": "Wellesley Hills", "label": "Wellesley Hills", "state": "MA", "country": "US" }, { "value": "Wellington Point", "label": "Wellington Point", "state": "QLD", "country": "AU" }, { "value": "Welwyn Garden City", "label": "Welwyn Garden City", "state": "", "country": "GB" }, { "value": "Wentworthville", "label": "Wentworthville", "state": "", "country": "AU" }, { "value": "West Chester", "label": "West Chester", "state": "PA", "country": "US" }, { "value": "West Des Moines", "label": "West Des Moines", "state": "IA", "country": "US" }, { "value": "West Haven", "label": "West Haven", "state": "CT", "country": "US" }, { "value": "West Henrietta", "label": "West Henrietta", "state": "NY", "country": "US" }, { "value": "West Kingston", "label": "West Kingston", "state": "RI", "country": "US" }, { "value": "West Lafayette", "label": "West Lafayette", "state": "IN", "country": "US" }, { "value": "West Lin", "label": "West Lin", "state": "OR", "country": "US" }, { "value": "West Orange", "label": "West Orange", "state": "NJ", "country": "US" }, { "value": "West Palm Beach", "label": "West Palm Beach", "state": "FL", "country": "US" }, { "value": "West Roxbury", "label": "West Roxbury", "state": "MA", "country": "US" }, { "value": "West Valley City", "label": "West Valley City", "state": "UT", "country": "US" }, { "value": "Westborough", "label": "Westborough", "state": "MA", "country": "US" }, { "value": "Westlake Village", "label": "Westlake Village", "state": "CA", "country": "US" }, { "value": "Westmead", "label": "Westmead", "state": "NSW", "country": "AU" }, { "value": "Weston", "label": "Weston", "state": "MA", "country": "US" }, { "value": "Westport", "label": "Westport", "state": "CT", "country": "US" }, { "value": "Wheat Ridge", "label": "Wheat Ridge", "state": "CO", "country": "US" }, { "value": "Wheeling", "label": "Wheeling", "state": "IL", "country": "US" }, { "value": "White Plains", "label": "White Plains", "state": "NY", "country": "US" }, { "value": "White River Junction", "label": "White River Junction", "state": "NH", "country": "US" }, { "value": "White River Junction", "label": "White River Junction", "state": "VT", "country": "US" }, { "value": "Whitehorse", "label": "Whitehorse", "state": "YK", "country": "CA" }, { "value": "Whitewater", "label": "Whitewater", "state": "WI", "country": "US" }, { "value": "Wichita", "label": "Wichita", "state": "KS", "country": "US" }, { "value": "Wien", "label": "Wien", "state": "", "country": "AT" }, { "value": "Williamsburg", "label": "Williamsburg", "state": "VA", "country": "US" }, { "value": "Williamstown", "label": "Williamstown", "state": "MA", "country": "US" }, { "value": "Williamsville", "label": "Williamsville", "state": "NY", "country": "US" }, { "value": "Wilmette", "label": "Wilmette", "state": "IL", "country": "US" }, { "value": "Wilmington", "label": "Wilmington", "state": "DE", "country": "US" }, { "value": "Wilmington", "label": "Wilmington", "state": "MA", "country": "US" }, { "value": "Wilmington", "label": "Wilmington", "state": "NC", "country": "US" }, { "value": "Windber", "label": "Windber", "state": "PA", "country": "US" }, { "value": "Windsor", "label": "Windsor", "state": "", "country": "GB" }, { "value": "Windsor", "label": "Windsor", "state": "ON", "country": "CA" }, { "value": "Winnipeg", "label": "Winnipeg", "state": "MB", "country": "CA" }, { "value": "Winston Salem", "label": "Winston Salem", "state": "NC", "country": "US" }, { "value": "Winston-Salem", "label": "Winston-Salem", "state": "NC", "country": "US" }, { "value": "Wirral", "label": "Wirral", "state": "", "country": "GB" }, { "value": "Woburn", "label": "Woburn", "state": "MA", "country": "US" }, { "value": "Wolfville", "label": "Wolfville", "state": "NS", "country": "CA" }, { "value": "Wollongong", "label": "Wollongong", "state": "NSW", "country": "AU" }, { "value": "Wolverhampton", "label": "Wolverhampton", "state": "", "country": "GB" }, { "value": "Woodbury", "label": "Woodbury", "state": "NY", "country": "US" }, { "value": "Woodinville", "label": "Woodinville", "state": "WA", "country": "US" }, { "value": "Woods Hole", "label": "Woods Hole", "state": "MA", "country": "US" }, { "value": "Woodside", "label": "Woodside", "state": "CA", "country": "US" }, { "value": "Woodville", "label": "Woodville", "state": "SA", "country": "AU" }, { "value": "Woolwich", "label": "Woolwich", "state": "ME", "country": "US" }, { "value": "Worcester", "label": "Worcester", "state": "MA", "country": "US" }, { "value": "Worchester", "label": "Worchester", "state": "MA", "country": "US" }, { "value": "Worthing", "label": "Worthing", "state": "", "country": "GB" }, { "value": "Wotton-Under-Edge", "label": "Wotton-Under-Edge", "state": "", "country": "GB" }, { "value": "Wrexham", "label": "Wrexham", "state": "", "country": "GB" }, { "value": "Wuerzburg", "label": "Wuerzburg", "state": "", "country": "DE" }, { "value": "Wynantskill", "label": "Wynantskill", "state": "NY", "country": "US" }, { "value": "Wynnewood", "label": "Wynnewood", "state": "PA", "country": "US" }, { "value": "Yaphank", "label": "Yaphank", "state": "NY", "country": "US" }, { "value": "Yardley", "label": "Yardley", "state": "PA", "country": "US" }, { "value": "Yateley", "label": "Yateley", "state": "", "country": "GB" }, { "value": "Yeovil", "label": "Yeovil", "state": "", "country": "GB" }, { "value": "York", "label": "York", "state": "", "country": "GB" }, { "value": "York", "label": "York", "state": "PA", "country": "US" }, { "value": "Ypsilanti", "label": "Ypsilanti", "state": "MI", "country": "US" }, { "value": "Zionsville", "label": "Zionsville", "state": "IN", "country": "US" }, { "value": "Zurich", "label": "Zurich", "state": "", "country": "CH" }, { "value": "Z\u00fcrich", "label": "Z\u00fcrich", "state": "", "country": "CH" }], "funding_organizations": [{ "value": 1, "label": "National Cancer Institute", "country": "US", "sponsor_code": "NIH" }, { "value": 2, "label": "U. S. Department of Defense, CDMRP", "country": "US", "sponsor_code": "CDMRP" }, { "value": 3, "label": "Cancer Research UK", "country": "GB", "sponsor_code": "NCRI" }, { "value": 5, "label": "Northern Ireland Health \u0026 Social Care - R \u0026 D Office", "country": "GB", "sponsor_code": "NCRI" }, { "value": 6, "label": "Scottish Government Health Directorates - Chief Scientist Office", "country": "GB", "sponsor_code": "NCRI" }, { "value": 7, "label": "Welsh Assembly Government - Office of R \u0026 D", "country": "GB", "sponsor_code": "NCRI" }, { "value": 8, "label": "Association for International Cancer Research", "country": "GB", "sponsor_code": "NCRI" }, { "value": 9, "label": "Tenovus", "country": "GB", "sponsor_code": "NCRI" }, { "value": 10, "label": "Biotechnology \u0026 Biological Sciences Research Council", "country": "GB", "sponsor_code": "NCRI" }, { "value": 11, "label": "Medical Research Council", "country": "GB", "sponsor_code": "NCRI" }, { "value": 12, "label": "Department of Health", "country": "GB", "sponsor_code": "NCRI" }, { "value": 13, "label": "Marie Curie Cancer Care", "country": "GB", "sponsor_code": "NCRI" }, { "value": 14, "label": "Macmillan Cancer Support", "country": "GB", "sponsor_code": "NCRI" }, { "value": 15, "label": "Yorkshire Cancer Research", "country": "GB", "sponsor_code": "NCRI" }, { "value": 16, "label": "Breakthrough Breast Cancer", "country": "GB", "sponsor_code": "NCRI" }, { "value": 17, "label": "Leukaemia and Lymphoma Research", "country": "GB", "sponsor_code": "NCRI" }, { "value": 18, "label": "Breast Cancer Campaign", "country": "GB", "sponsor_code": "NCRI" }, { "value": 19, "label": "Roy Castle Lung Cancer Foundation", "country": "GB", "sponsor_code": "NCRI" }, { "value": 20, "label": "Wellcome Trust", "country": "GB", "sponsor_code": "NCRI" }, { "value": 21, "label": "Economic and Social Research Council", "country": "GB", "sponsor_code": "NCRI" }, { "value": 22, "label": "Alberta Cancer Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "value": 23, "label": "Alberta Innovates - Health Solutions", "country": "CA", "sponsor_code": "CCRA" }, { "value": 25, "label": "Canadian Breast Cancer Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "value": 26, "label": "Canadian Breast Cancer Research Alliance", "country": "CA", "sponsor_code": "CCRA" }, { "value": 27, "label": "Canadian Institutes of Health Research", "country": "CA", "sponsor_code": "CCRA" }, { "value": 28, "label": "Canadian Prostate Cancer Research Initiative", "country": "CA", "sponsor_code": "CCRA" }, { "value": 29, "label": "Canadian Tobacco Control Research Initiative", "country": "CA", "sponsor_code": "CCRA" }, { "value": 30, "label": "CancerCare Manitoba", "country": "CA", "sponsor_code": "CCRA" }, { "value": 31, "label": "Cancer Care Nova Scotia", "country": "CA", "sponsor_code": "CCRA" }, { "value": 32, "label": "Cancer Care Ontario", "country": "CA", "sponsor_code": "CCRA" }, { "value": 33, "label": "Foundation du cancer du sein du Qu\u00e9bec \/ Quebec Breast Cancer Foundation ", "country": "CA", "sponsor_code": "CCRA" }, { "value": 34, "label": "Fonds de la recherche du Qu\u00e9bec \u2013 Sant\u00e9", "country": "CA", "sponsor_code": "CCRA" }, { "value": 35, "label": "Michael Smith Foundation for Health Research", "country": "CA", "sponsor_code": "CCRA" }, { "value": 37, "label": "National Research Council of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 38, "label": "Ontario Institute for Cancer Research", "country": "CA", "sponsor_code": "CCRA" }, { "value": 39, "label": "Saskatchewan Cancer Agency", "country": "CA", "sponsor_code": "CCRA" }, { "value": 40, "label": "Cancer Research Society", "country": "CA", "sponsor_code": "CCRA" }, { "value": 41, "label": "Canadian Cancer Society", "country": "CA", "sponsor_code": "CCRA" }, { "value": 42, "label": "The Terry Fox Research Institute", "country": "CA", "sponsor_code": "CCRA" }, { "value": 43, "label": "Genome Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 44, "label": "Prostate Cancer Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 51, "label": "California Breast Cancer Research Program", "country": "US", "sponsor_code": "CBCRP" }, { "value": 52, "label": "Susan G. Komen for the Cure", "country": "US", "sponsor_code": "KOMEN" }, { "value": 53, "label": "Oncology Nursing Society Foundation", "country": "US", "sponsor_code": "ONS" }, { "value": 54, "label": "American Cancer Society", "country": "US", "sponsor_code": "ACS" }, { "value": 55, "label": "Children with CANCER UK", "country": "GB", "sponsor_code": "NCRI" }, { "value": 56, "label": "KWF Kankerbestrijding \/ Dutch Cancer Society", "country": "NL", "sponsor_code": "KWF" }, { "value": 57, "label": "Avon Foundation for Women", "country": "US", "sponsor_code": "AVONFDN" }, { "value": 58, "label": "Pancreatic Cancer Action Network", "country": "US", "sponsor_code": "PanCAN" }, { "value": 70, "label": "Institut National du Cancer", "country": "FR", "sponsor_code": "INCa" }, { "value": 71, "label": "DGOS-Minist\u00e8re de la Sant\u00e9", "country": "FR", "sponsor_code": "INCa" }, { "value": 76, "label": "Prostate Cancer UK", "country": "GB", "sponsor_code": "NCRI" }, { "value": 78, "label": "Canadian Partnership Against Cancer", "country": "CA", "sponsor_code": "CCRA" }, { "value": 79, "label": "American Institute for Cancer Research", "country": "US", "sponsor_code": "AICR (USA)" }, { "value": 81, "label": "National Pancreas Foundation", "country": "US", "sponsor_code": "NPF" }, { "value": 82, "label": "National Breast Cancer Foundation", "country": "AU", "sponsor_code": "NBCF" }, { "value": 83, "label": "National Institute on Alcohol Abuse and Alcoholism", "country": "US", "sponsor_code": "NIH" }, { "value": 84, "label": "National Institute on Aging", "country": "US", "sponsor_code": "NIH" }, { "value": 85, "label": "National Institute of Allergy and Infectious Diseases", "country": "US", "sponsor_code": "NIH" }, { "value": 86, "label": "National Institute of Arthritis and Musculoskeletal and Skin Diseases", "country": "US", "sponsor_code": "NIH" }, { "value": 87, "label": "National Center for Complementary and Alternative Medicine", "country": "US", "sponsor_code": "NIH" }, { "value": 88, "label": "National Institute on Drug Abuse", "country": "US", "sponsor_code": "NIH" }, { "value": 89, "label": "National Institute on Deafness and Other Communication Disorders", "country": "US", "sponsor_code": "NIH" }, { "value": 90, "label": "National Institute of Dental and Craniofacial Research", "country": "US", "sponsor_code": "NIH" }, { "value": 91, "label": "National Institute of Diabetes and Digestive and Kidney Diseases", "country": "US", "sponsor_code": "NIH" }, { "value": 92, "label": "National Institute of Biomedical Imaging and Bioengineering", "country": "US", "sponsor_code": "NIH" }, { "value": 93, "label": "National Institute of Environmental Health Sciences", "country": "US", "sponsor_code": "NIH" }, { "value": 94, "label": "National Eye Institute", "country": "US", "sponsor_code": "NIH" }, { "value": 95, "label": "National Institute of General Medical Sciences", "country": "US", "sponsor_code": "NIH" }, { "value": 96, "label": "Eunice Kennedy Shriver National Institute of Child Health and Human Development", "country": "US", "sponsor_code": "NIH" }, { "value": 97, "label": "National Human Genome Research Institute", "country": "US", "sponsor_code": "NIH" }, { "value": 98, "label": "National Heart, Lung and Blood Institute", "country": "US", "sponsor_code": "NIH" }, { "value": 99, "label": "National Library of Medicine", "country": "US", "sponsor_code": "NIH" }, { "value": 100, "label": "National Institute on Minority Health and Health Disparities", "country": "US", "sponsor_code": "NIH" }, { "value": 101, "label": "National Institute of Mental Health", "country": "US", "sponsor_code": "NIH" }, { "value": 102, "label": "National Institute of Nursing Research", "country": "US", "sponsor_code": "NIH" }, { "value": 103, "label": "National Institute of Neurological Disorders and Stroke", "country": "US", "sponsor_code": "NIH" }, { "value": 104, "label": "Office of the Director", "country": "US", "sponsor_code": "NIH" }, { "value": 105, "label": "National Center for Research Resources", "country": "US", "sponsor_code": "NIH" }, { "value": 106, "label": "Fogarty International Center", "country": "US", "sponsor_code": "NIH" }, { "value": 107, "label": "National Cancer Center, Japan", "country": "JP", "sponsor_code": "NCC" }, { "value": 108, "label": "Brain Tumour Foundation of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 109, "label": "C17 Research Network", "country": "CA", "sponsor_code": "CCRA" }, { "value": 110, "label": "Canadian Association of Radiation Oncology", "country": "CA", "sponsor_code": "CCRA" }, { "value": 111, "label": "The Kidney Foundation of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 113, "label": "The Leukemia \u0026 Lymphoma Society of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 114, "label": "Research Manitoba", "country": "CA", "sponsor_code": "CCRA" }, { "value": 115, "label": "New Brunswick Health Research Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "value": 116, "label": "Newfoundland and Labrador Centre for Applied Health Research", "country": "CA", "sponsor_code": "CCRA" }, { "value": 117, "label": "Natural Sciences and Engineering Research Council", "country": "CA", "sponsor_code": "CCRA" }, { "value": 118, "label": "Nova Scotia Health Research Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "value": 119, "label": "Ovarian Cancer Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 120, "label": "Pancreatic Cancer Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 121, "label": "Pediatric Oncology Group of Ontario", "country": "CA", "sponsor_code": "CCRA" }, { "value": 122, "label": "PROCURE", "country": "CA", "sponsor_code": "CCRA" }, { "value": 123, "label": "Saskatchewan Health Research Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "value": 125, "label": "National Center for Advancing Translational Sciences", "country": "US", "sponsor_code": "NIH" }, { "value": 126, "label": "Coalition Against Childhood Cancer", "country": "US", "sponsor_code": "CAC2" }, { "value": 127, "label": "Alex\u0027s Lemonade Stand Foundation", "country": "US", "sponsor_code": "CAC2" }, { "value": 128, "label": "Bradens\u0027 Hope For Childhood Cancer", "country": "US", "sponsor_code": "CAC2" }, { "value": 129, "label": "Luck2Tuck", "country": "US", "sponsor_code": "CAC2" }, { "value": 130, "label": "Steven G Aya foundation", "country": "US", "sponsor_code": "CAC2" }, { "value": 131, "label": "Team Connor", "country": "US", "sponsor_code": "CAC2" }, { "value": 132, "label": "TayBandz", "country": "US", "sponsor_code": "CAC2" }, { "value": 133, "label": "CSCN Alliance", "country": "US", "sponsor_code": "CAC2" }, { "value": 134, "label": "Sammy\u0027s Superheroes", "country": "US", "sponsor_code": "CAC2" }, { "value": 135, "label": "The Pediatric Brain Tumor Foundation", "country": "US", "sponsor_code": "CAC2" }, { "value": 136, "label": "Noah\u0027s Light", "country": "US", "sponsor_code": "CAC2" }, { "value": 137, "label": "Breast Cancer Society of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "value": 138, "label": "Cancer Australia", "country": "AU", "sponsor_code": "CancerAust" }], "cancer_types": [{ "value": 0, "label": "Adrenocortical Cancer" }, { "value": 2, "label": "Not Site-Specific Cancer" }, { "value": 3, "label": "Bladder Cancer" }, { "value": 4, "label": "Bone Cancer, Osteosarcoma \/ Malignant Fibrous Histiocytoma" }, { "value": 5, "label": "Bone Marrow Transplantation" }, { "value": 6, "label": "Brain Tumor" }, { "value": 7, "label": "Breast Cancer" }, { "value": 8, "label": "Heart Cancer" }, { "value": 8, "label": "Heart Cancer \/ Cardiotoxicity" }, { "value": 9, "label": "Cervical Cancer" }, { "value": 10, "label": "Ear Cancer" }, { "value": 11, "label": "Endometrial Cancer" }, { "value": 12, "label": "Esophageal \/ Oesophageal Cancer" }, { "value": 12, "label": "Oesophageal \/ Esophageal Cancer" }, { "value": 13, "label": "Eye Cancer" }, { "value": 14, "label": "Gallbladder Cancer" }, { "value": 15, "label": "Gastrointestinal Tract" }, { "value": 17, "label": "Genital System, Female" }, { "value": 19, "label": "Genital System, Male" }, { "value": 21, "label": "Head and Neck Cancer" }, { "value": 23, "label": "Liver Cancer" }, { "value": 24, "label": "Hodgkin\u0027s Disease" }, { "value": 25, "label": "Kidney Cancer" }, { "value": 26, "label": "Laryngeal Cancer" }, { "value": 27, "label": "Leukemia \/ Leukaemia" }, { "value": 28, "label": "Lung Cancer" }, { "value": 29, "label": "Melanoma" }, { "value": 30, "label": "Myeloma" }, { "value": 31, "label": "Nasal Cavity and Paranasal Sinus Cancer" }, { "value": 32, "label": "Neuroblastoma" }, { "value": 33, "label": "Nervous System" }, { "value": 35, "label": "Non-Hodgkin\u0027s Lymphoma" }, { "value": 36, "label": "Oral Cavity and Lip Cancer" }, { "value": 37, "label": "Pancreatic Cancer" }, { "value": 38, "label": "Parathyroid Cancer" }, { "value": 39, "label": "Penile Cancer" }, { "value": 40, "label": "Pituitary Tumor" }, { "value": 42, "label": "Prostate Cancer" }, { "value": 43, "label": "Respiratory System" }, { "value": 45, "label": "Retinoblastoma" }, { "value": 46, "label": "Kaposi\u0027s Sarcoma" }, { "value": 47, "label": "Sarcoma, Rhabdomyosarcoma, Childhood" }, { "value": 48, "label": "Sarcoma, Soft Tissue" }, { "value": 49, "label": "Skin Cancer" }, { "value": 50, "label": "Small Intestine Cancer" }, { "value": 51, "label": "Stomach Cancer" }, { "value": 52, "label": "Testicular Cancer" }, { "value": 53, "label": "Thymoma, Malignant" }, { "value": 54, "label": "Thyroid Cancer" }, { "value": 55, "label": "Urinary System" }, { "value": 57, "label": "Vaginal Cancer" }, { "value": 58, "label": "Vascular System" }, { "value": 60, "label": "Wilms\u0027 Tumor" }, { "value": 61, "label": "Pharyngeal Cancer" }, { "value": 63, "label": "Salivary Gland Cancer" }, { "value": 64, "label": "Colon and Rectal Cancer" }, { "value": 66, "label": "Ovarian Cancer" }, { "value": 67, "label": "Blood Cancer" }, { "value": 99, "label": "Uncoded" }, { "value": 101, "label": "Vulva Cancer" }, { "value": 102, "label": "Primary of Unknown Origin" }, { "value": 103, "label": "Anal Cancer" }, { "value": 104, "label": "Primary CNS Lymphoma" }, { "value": 105, "label": "Sarcoma" }], "project_types": [{ "value": "Clinical Trial", "label": "Clinical Trial" }, { "value": "Research", "label": "Research" }, { "value": "Training", "label": "Training" }], "cso_research_areas": [{ "value": "0", "label": "Uncoded", "category": "Uncoded" }, { "value": "1.1", "label": "Normal Functioning", "category": "Biology" }, { "value": "1.2", "label": "Cancer Initiation:  Alterations in Chromosomes", "category": "Biology" }, { "value": "1.3", "label": "Cancer Initiation:  Oncogenes and Tumor Suppressor Genes", "category": "Biology" }, { "value": "1.4", "label": "Cancer Progression and Metastasis", "category": "Biology" }, { "value": "1.5", "label": "Resources and Infrastructure Related to Biology", "category": "Biology" }, { "value": "1.6", "label": "Cancer Related Biology", "category": "Biology" }, { "value": "2.1", "label": "Exogenous Factors in the Origin and Cause of Cancer", "category": "Causes of Cancer\/Etiology" }, { "value": "2.2", "label": "Endogenous Factors in the Origin and Cause of Cancer", "category": "Causes of Cancer\/Etiology" }, { "value": "2.3", "label": "Interactions of Genes and\/or Genetic Polymorphisms with Exogenous and\/or Endogenous Factors", "category": "Causes of Cancer\/Etiology" }, { "value": "2.4", "label": "Resources and Infrastructure Related to Etiology", "category": "Causes of Cancer\/Etiology" }, { "value": "3.1", "label": "Interventions to Prevent Cancer: Personal Behaviors that Affect Cancer Risk", "category": "Prevention" }, { "value": "3.2", "label": "Nutritional Science in Cancer Prevention", "category": "Prevention" }, { "value": "3.3", "label": "Chemoprevention", "category": "Prevention" }, { "value": "3.4", "label": "Vaccines", "category": "Prevention" }, { "value": "3.5", "label": "Complementary and Alternative Prevention Approaches", "category": "Prevention" }, { "value": "3.6", "label": "Resources and Infrastructure Related to Prevention", "category": "Prevention" }, { "value": "4.1", "label": "Technology Development and\/or Marker Discovery", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": "4.2", "label": "Technology and\/or Marker Evaluation with Respect to Fundamental Parameters of Method", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": "4.3", "label": "Technology and\/or Marker Testing in a Clinical Setting", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": "4.4", "label": "Resources and Infrastructure Related to Early Detection, Diagnosis or Prognosis", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": "5.1", "label": "Localized Therapies - Discovery and Development", "category": "Treatment" }, { "value": "5.2", "label": "Localized Therapies - Clinical Applications", "category": "Treatment" }, { "value": "5.3", "label": "Systemic Therapies - Discovery and Development", "category": "Treatment" }, { "value": "5.4", "label": "Systemic Therapies - Clinical Applications", "category": "Treatment" }, { "value": "5.5", "label": "Combinations of Localized and Systemic Therapies", "category": "Treatment" }, { "value": "5.6", "label": "Complementary and Alternative Treatment Approaches", "category": "Treatment" }, { "value": "5.7", "label": "Resources and Infrastructure Related to Treatment", "category": "Treatment" }, { "value": "6.1", "label": "Patient Care and Survivorship Issues", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.2", "label": "Surveillance", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.3", "label": "Behavior Related to Cancer Control", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.4", "label": "Cost Analyses and Health Care Delivery", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.5", "label": "Education and Communication", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.6", "label": "End-of-Life Care", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.7", "label": "Ethics and Confidentiality in Cancer Research", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.8", "label": "Complementary and Alternative Approaches for Supportive Care of Patients and Survivors", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "6.9", "label": "Resources and Infrastructure Related to Cancer Control, Survivorship, and Outcomes Research", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": "7.1", "label": "Development and Characterization of Model Systems", "category": "Scientific Model Systems" }, { "value": "7.2", "label": " Application of Model Systems", "category": "Scientific Model Systems" }, { "value": "7.3", "label": "Resources and Infrastructure Related to Scientific Model Systems", "category": "Scientific Model Systems" }], "years": [{ "value": 2000, "label": "2000" }, { "value": 2001, "label": "2001" }, { "value": 2002, "label": "2002" }, { "value": 2003, "label": "2003" }, { "value": 2004, "label": "2004" }, { "value": 2005, "label": "2005" }, { "value": 2006, "label": "2006" }, { "value": 2007, "label": "2007" }, { "value": 2008, "label": "2008" }, { "value": 2009, "label": "2009" }, { "value": 2010, "label": "2010" }, { "value": 2011, "label": "2011" }, { "value": 2012, "label": "2012" }, { "value": 2013, "label": "2013" }, { "value": 2014, "label": "2014" }, { "value": 2015, "label": "2015" }, { "value": 2016, "label": "2016" }] };
        this.csoAreas = {
            label: 'All CSO Research Areas',
            value: null,
            children: [
                {
                    "label": "Biology",
                    "value": null,
                    "children": [
                        {
                            "label": "Normal Functioning",
                            "value": "1.1"
                        },
                        {
                            "label": "Cancer Initiation:  Alterations in Chromosomes",
                            "value": "1.2"
                        },
                        {
                            "label": "Cancer Initiation:  Oncogenes and Tumor Suppressor Genes",
                            "value": "1.3"
                        },
                        {
                            "label": "Cancer Progression and Metastasis",
                            "value": "1.4"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Biology",
                            "value": "1.5"
                        },
                        {
                            "label": "Cancer Related Biology",
                            "value": "1.6"
                        }
                    ]
                },
                {
                    "label": "Causes of Cancer/Etiology",
                    "value": null,
                    "children": [
                        {
                            "label": "Exogenous Factors in the Origin and Cause of Cancer",
                            "value": "2.1"
                        },
                        {
                            "label": "Endogenous Factors in the Origin and Cause of Cancer",
                            "value": "2.2"
                        },
                        {
                            "label": "Interactions of Genes and/or Genetic Polymorphisms with Exogenous and/or Endogenous Factors",
                            "value": "2.3"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Etiology",
                            "value": "2.4"
                        }
                    ]
                },
                {
                    "label": "Prevention",
                    "value": null,
                    "children": [
                        {
                            "label": "Interventions to Prevent Cancer: Personal Behaviors that Affect Cancer Risk",
                            "value": "3.1"
                        },
                        {
                            "label": "Nutritional Science in Cancer Prevention",
                            "value": "3.2"
                        },
                        {
                            "label": "Chemoprevention",
                            "value": "3.3"
                        },
                        {
                            "label": "Vaccines",
                            "value": "3.4"
                        },
                        {
                            "label": "Complementary and Alternative Prevention Approaches",
                            "value": "3.5"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Prevention",
                            "value": "3.6"
                        }
                    ]
                },
                {
                    "label": "Early Detection, Diagnosis, and Prognosis",
                    "value": null,
                    "children": [
                        {
                            "label": "Technology Development and/or Marker Discovery",
                            "value": "4.1"
                        },
                        {
                            "label": "Technology and/or Marker Evaluation with Respect to Fundamental Parameters of Method",
                            "value": "4.2"
                        },
                        {
                            "label": "Technology and/or Marker Testing in a Clinical Setting",
                            "value": "4.3"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Early Detection, Diagnosis or Prognosis",
                            "value": "4.4"
                        }
                    ]
                },
                {
                    "label": "Treatment",
                    "value": null,
                    "children": [
                        {
                            "label": "Localized Therapies - Discovery and Development",
                            "value": "5.1"
                        },
                        {
                            "label": "Localized Therapies - Clinical Applications",
                            "value": "5.2"
                        },
                        {
                            "label": "Systemic Therapies - Discovery and Development",
                            "value": "5.3"
                        },
                        {
                            "label": "Systemic Therapies - Clinical Applications",
                            "value": "5.4"
                        },
                        {
                            "label": "Combinations of Localized and Systemic Therapies",
                            "value": "5.5"
                        },
                        {
                            "label": "Complementary and Alternative Treatment Approaches",
                            "value": "5.6"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Treatment",
                            "value": "5.7"
                        }
                    ]
                },
                {
                    "label": "Cancer Control, Survivorship and Outcomes Research",
                    "value": null,
                    "children": [
                        {
                            "label": "Patient Care and Survivorship Issues",
                            "value": "6.1"
                        },
                        {
                            "label": "Surveillance",
                            "value": "6.2"
                        },
                        {
                            "label": "Behavior Related to Cancer Control",
                            "value": "6.3"
                        },
                        {
                            "label": "Cost Analyses and Health Care Delivery",
                            "value": "6.4"
                        },
                        {
                            "label": "Education and Communication",
                            "value": "6.5"
                        },
                        {
                            "label": "End-of-Life Care",
                            "value": "6.6"
                        },
                        {
                            "label": "Ethics and Confidentiality in Cancer Research",
                            "value": "6.7"
                        },
                        {
                            "label": "Complementary and Alternative Approaches for Supportive Care of Patients and Survivors",
                            "value": "6.8"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Cancer Control, Survivorship, and Outcomes Research",
                            "value": "6.9"
                        }
                    ]
                },
                {
                    "label": "Scientific Model Systems",
                    "value": null,
                    "children": [
                        {
                            "label": "Development and Characterization of Model Systems",
                            "value": "7.1"
                        },
                        {
                            "label": " Application of Model Systems",
                            "value": "7.2"
                        },
                        {
                            "label": "Resources and Infrastructure Related to Scientific Model Systems",
                            "value": "7.3"
                        }
                    ]
                },
                {
                    "label": "Uncoded",
                    "value": '0'
                },
            ]
        };
        this.fundingOrgs = {
            label: 'All Funding Organizations',
            value: null,
            children: [
                {
                    label: 'All US Organizations',
                    value: null,
                    children: [
                        {
                            label: 'All CAC2 Organizations',
                            value: null,
                            children: [{ "value": 127, "label": "Alex's Lemonade Stand Foundation" }, { "value": 128, "label": "Bradens' Hope For Childhood Cancer" }, { "value": 126, "label": "Coalition Against Childhood Cancer" }, { "value": 133, "label": "CSCN Alliance" }, { "value": 129, "label": "Luck2Tuck" }, { "value": 136, "label": "Noah's Light" }, { "value": 134, "label": "Sammy's Superheroes" }, { "value": 130, "label": "Steven G Aya foundation" }, { "value": 132, "label": "TayBandz" }, { "value": 131, "label": "Team Connor" }, { "value": 135, "label": "The Pediatric Brain Tumor Foundation" }]
                        },
                        {
                            label: 'All NIH Organizations',
                            value: null,
                            children: [{ "value": 96, "label": "Eunice Kennedy Shriver National Institute of Child Health and Human Development" }, { "value": 106, "label": "Fogarty International Center" }, { "value": 1, "label": "National Cancer Institute" }, { "value": 125, "label": "National Center for Advancing Translational Sciences" }, { "value": 87, "label": "National Center for Complementary and Alternative Medicine" }, { "value": 105, "label": "National Center for Research Resources" }, { "value": 94, "label": "National Eye Institute" }, { "value": 98, "label": "National Heart, Lung and Blood Institute" }, { "value": 97, "label": "National Human Genome Research Institute" }, { "value": 85, "label": "National Institute of Allergy and Infectious Diseases" }, { "value": 86, "label": "National Institute of Arthritis and Musculoskeletal and Skin Diseases" }, { "value": 92, "label": "National Institute of Biomedical Imaging and Bioengineering" }, { "value": 90, "label": "National Institute of Dental and Craniofacial Research" }, { "value": 91, "label": "National Institute of Diabetes and Digestive and Kidney Diseases" }, { "value": 93, "label": "National Institute of Environmental Health Sciences" }, { "value": 95, "label": "National Institute of General Medical Sciences" }, { "value": 101, "label": "National Institute of Mental Health" }, { "value": 103, "label": "National Institute of Neurological Disorders and Stroke" }, { "value": 102, "label": "National Institute of Nursing Research" }, { "value": 84, "label": "National Institute on Aging" }, { "value": 83, "label": "National Institute on Alcohol Abuse and Alcoholism" }, { "value": 89, "label": "National Institute on Deafness and Other Communication Disorders" }, { "value": 88, "label": "National Institute on Drug Abuse" }, { "value": 100, "label": "National Institute on Minority Health and Health Disparities" }, { "value": 99, "label": "National Library of Medicine" }, { "value": 104, "label": "Office of the Director" }]
                        },
                        {
                            label: 'All Other US Organizations',
                            value: null,
                            children: [{ "value": 54, "label": "American Cancer Society" }, { "value": 79, "label": "American Institute for Cancer Research" }, { "value": 57, "label": "Avon Foundation for Women" }, { "value": 51, "label": "California Breast Cancer Research Program" }, { "value": 81, "label": "National Pancreas Foundation" }, { "value": 53, "label": "Oncology Nursing Society Foundation" }, { "value": 58, "label": "Pancreatic Cancer Action Network" }, { "value": 52, "label": "Susan G. Komen for the Cure" }, { "value": 2, "label": "U. S. Department of Defense, CDMRP" }]
                        }
                    ]
                },
                {
                    label: 'All UK Organizations',
                    value: null,
                    children: [{ "value": 8, "label": "Association for International Cancer Research" }, { "value": 10, "label": "Biotechnology & Biological Sciences Research Council" }, { "value": 16, "label": "Breakthrough Breast Cancer" }, { "value": 18, "label": "Breast Cancer Campaign" }, { "value": 3, "label": "Cancer Research UK" }, { "value": 55, "label": "Children with CANCER UK" }, { "value": 12, "label": "Department of Health" }, { "value": 21, "label": "Economic and Social Research Council" }, { "value": 17, "label": "Leukaemia and Lymphoma Research" }, { "value": 14, "label": "Macmillan Cancer Support" }, { "value": 13, "label": "Marie Curie Cancer Care" }, { "value": 11, "label": "Medical Research Council" }, { "value": 5, "label": "Northern Ireland Health & Social Care - R & D Office" }, { "value": 76, "label": "Prostate Cancer UK" }, { "value": 19, "label": "Roy Castle Lung Cancer Foundation" }, { "value": 6, "label": "Scottish Government Health Directorates - Chief Scientist Office" }, { "value": 9, "label": "Tenovus" }, { "value": 20, "label": "Wellcome Trust" }, { "value": 7, "label": "Welsh Assembly Government - Office of R & D" }, { "value": 15, "label": "Yorkshire Cancer Research" }]
                },
                {
                    label: 'All CA Organizations',
                    value: null,
                    children: [{ "value": 22, "label": "Alberta Cancer Foundation" }, { "value": 23, "label": "Alberta Innovates - Health Solutions" }, { "value": 108, "label": "Brain Tumour Foundation of Canada" }, { "value": 137, "label": "Breast Cancer Society of Canada" }, { "value": 109, "label": "C17 Research Network" }, { "value": 110, "label": "Canadian Association of Radiation Oncology" }, { "value": 25, "label": "Canadian Breast Cancer Foundation" }, { "value": 26, "label": "Canadian Breast Cancer Research Alliance" }, { "value": 41, "label": "Canadian Cancer Society" }, { "value": 27, "label": "Canadian Institutes of Health Research" }, { "value": 78, "label": "Canadian Partnership Against Cancer" }, { "value": 28, "label": "Canadian Prostate Cancer Research Initiative" }, { "value": 29, "label": "Canadian Tobacco Control Research Initiative" }, { "value": 31, "label": "Cancer Care Nova Scotia" }, { "value": 32, "label": "Cancer Care Ontario" }, { "value": 40, "label": "Cancer Research Society" }, { "value": 30, "label": "CancerCare Manitoba" }, { "value": 34, "label": "Fonds de la recherche du Québec – Santé" }, { "value": 33, "label": "Foundation du cancer du sein du Québec / Quebec Breast Cancer Foundation " }, { "value": 43, "label": "Genome Canada" }, { "value": 35, "label": "Michael Smith Foundation for Health Research" }, { "value": 37, "label": "National Research Council of Canada" }, { "value": 117, "label": "Natural Sciences and Engineering Research Council" }, { "value": 115, "label": "New Brunswick Health Research Foundation" }, { "value": 116, "label": "Newfoundland and Labrador Centre for Applied Health Research" }, { "value": 118, "label": "Nova Scotia Health Research Foundation" }, { "value": 38, "label": "Ontario Institute for Cancer Research" }, { "value": 119, "label": "Ovarian Cancer Canada" }, { "value": 120, "label": "Pancreatic Cancer Canada" }, { "value": 121, "label": "Pediatric Oncology Group of Ontario" }, { "value": 122, "label": "PROCURE" }, { "value": 44, "label": "Prostate Cancer Canada" }, { "value": 114, "label": "Research Manitoba" }, { "value": 39, "label": "Saskatchewan Cancer Agency" }, { "value": 123, "label": "Saskatchewan Health Research Foundation" }, { "value": 111, "label": "The Kidney Foundation of Canada" }, { "value": 113, "label": "The Leukemia & Lymphoma Society of Canada" }, { "value": 42, "label": "The Terry Fox Research Institute" }]
                },
                {
                    label: 'All FR Organizations',
                    value: null,
                    children: [{ "value": 71, "label": "DGOS-Ministère de la Santé" }, { "value": 70, "label": "Institut National du Cancer" }]
                },
                {
                    label: 'All NL Organizations',
                    value: null,
                    children: [{ "value": 56, "label": "KWF Kankerbestrijding / Dutch Cancer Society" }]
                },
                {
                    label: 'All AU Organizations',
                    value: null,
                    children: [{ "value": 138, "label": "Cancer Australia" }, { "value": 82, "label": "National Breast Cancer Foundation" }]
                },
                {
                    label: 'All JP Organizations',
                    value: null,
                    children: [{ "value": 107, "label": "National Cancer Center, Japan" }]
                }
            ]
        };
        this.currencies = [{ "value": 1, "abbreviation": "USD", "label": "United States Dollars" }, { "value": 2, "abbreviation": "GBP", "label": "United Kingdom Pounds" }, { "value": 3, "abbreviation": "CAD", "label": "Canada Dollars" }, { "value": 4, "abbreviation": "EUR", "label": "Euro" }, { "value": 5, "abbreviation": "AUD", "label": "Australia Dollars" }, { "value": 6, "abbreviation": "JPY", "label": "Japan Yen " }, { "value": 7, "abbreviation": "INR", "label": "India Rupees" }, { "value": 8, "abbreviation": "NZD", "label": "New Zealand Dollars" }, { "value": 9, "abbreviation": "CHF", "label": "Switzerland Francs" }, { "value": 10, "abbreviation": "ZAR", "label": "South Africa Rand" }, { "value": 11, "abbreviation": "AFN", "label": "Afghanistan Afghanis" }, { "value": 12, "abbreviation": "ALL", "label": "Albania Leke" }, { "value": 13, "abbreviation": "DZD", "label": "Algeria Dinars" }, { "value": 14, "abbreviation": "ARS", "label": "Argentina Pesos" }, { "value": 15, "abbreviation": "ATS", "label": "Austria Schillings*" }, { "value": 16, "abbreviation": "BSD", "label": "Bahamas Dollars" }, { "value": 17, "abbreviation": "BHD", "label": "Bahrain Dinars" }, { "value": 18, "abbreviation": "BDT", "label": "Bangladesh Taka" }, { "value": 19, "abbreviation": "BBD", "label": "Barbados Dollars" }, { "value": 20, "abbreviation": "BEF", "label": "Belgium Francs*" }, { "value": 21, "abbreviation": "BMD", "label": "Bermuda Dollars" }, { "value": 22, "abbreviation": "BRL", "label": "Brazil Reais" }, { "value": 23, "abbreviation": "BGN", "label": "Bulgaria Leva" }, { "value": 24, "abbreviation": "XOF", "label": "CFA BCEAO Francs" }, { "value": 25, "abbreviation": "XAF", "label": "CFA BEAC Francs" }, { "value": 26, "abbreviation": "CLP", "label": "Chile Pesos" }, { "value": 27, "abbreviation": "CNY", "label": "China Yuan Renminbi" }, { "value": 28, "abbreviation": "COP", "label": "Colombia Pesos" }, { "value": 29, "abbreviation": "XPF", "label": "CFP Francs" }, { "value": 30, "abbreviation": "CRC", "label": "Costa Rica Colones" }, { "value": 31, "abbreviation": "HRK", "label": "Croatia Kuna" }, { "value": 32, "abbreviation": "CYP", "label": "Cyprus Pounds*" }, { "value": 33, "abbreviation": "CZK", "label": "Czech Republic Koruny" }, { "value": 34, "abbreviation": "DKK", "label": "Denmark Kroner" }, { "value": 35, "abbreviation": "DEM", "label": "Deutsche (Germany) Marks*" }, { "value": 36, "abbreviation": "DOP", "label": "Dominican Republic Pesos" }, { "value": 37, "abbreviation": "NLG", "label": "Dutch (Netherlands) Guilders*" }, { "value": 38, "abbreviation": "XCD", "label": "Eastern Caribbean Dollars" }, { "value": 39, "abbreviation": "EGP", "label": "Egypt Pounds" }, { "value": 40, "abbreviation": "EEK", "label": "Estonia Krooni" }, { "value": 41, "abbreviation": "FJD", "label": "Fiji Dollars" }, { "value": 42, "abbreviation": "FIM", "label": "Finland Markkaa*" }, { "value": 43, "abbreviation": "FRF", "label": "France Francs*" }, { "value": 44, "abbreviation": "XAU", "label": "Gold Ounces" }, { "value": 45, "abbreviation": "GRD", "label": "Greece Drachmae*" }, { "value": 46, "abbreviation": "HKD", "label": "Hong Kong Dollars" }, { "value": 47, "abbreviation": "HUF", "label": "Hungary Forint" }, { "value": 48, "abbreviation": "ISK", "label": "Iceland Kronur" }, { "value": 49, "abbreviation": "XDR", "label": "IMF Special Drawing Right" }, { "value": 50, "abbreviation": "IDR", "label": "Indonesia Rupiahs" }, { "value": 51, "abbreviation": "IRR", "label": "Iran Rials" }, { "value": 52, "abbreviation": "IQD", "label": "Iraq Dinars" }, { "value": 53, "abbreviation": "IEP", "label": "Ireland Pounds*" }, { "value": 54, "abbreviation": "ILS", "label": "Israel New Shekels" }, { "value": 55, "abbreviation": "ITL", "label": "Italy Lire*" }, { "value": 56, "abbreviation": "JMD", "label": "Jamaica Dollars" }, { "value": 57, "abbreviation": "JOD", "label": "Jordan Dinars" }, { "value": 58, "abbreviation": "KES", "label": "Kenya Shillings" }, { "value": 59, "abbreviation": "KRW", "label": "Korea (South) Won" }, { "value": 60, "abbreviation": "KWD", "label": "Kuwait Dinars" }, { "value": 61, "abbreviation": "LBP", "label": "Lebanon Pounds" }, { "value": 62, "abbreviation": "LUF", "label": "Luxembourg Francs*" }, { "value": 63, "abbreviation": "MYR", "label": "Malaysia Ringgits" }, { "value": 64, "abbreviation": "MTL", "label": "Malta Liri*" }, { "value": 65, "abbreviation": "MUR", "label": "Mauritius Rupees" }, { "value": 66, "abbreviation": "MXN", "label": "Mexico Pesos" }, { "value": 67, "abbreviation": "MAD", "label": "Morocco Dirhams" }, { "value": 68, "abbreviation": "NOK", "label": "Norway Kroner" }, { "value": 69, "abbreviation": "OMR", "label": "Oman Rials" }, { "value": 70, "abbreviation": "PKR", "label": "Pakistan Rupees" }, { "value": 71, "abbreviation": "XPD", "label": "Palladium Ounces" }, { "value": 72, "abbreviation": "PEN", "label": "Peru Nuevos Soles" }, { "value": 73, "abbreviation": "PHP", "label": "Philippines Pesos" }, { "value": 74, "abbreviation": "XPT", "label": "Platinum Ounces" }, { "value": 75, "abbreviation": "PLN", "label": "Poland Zlotych" }, { "value": 76, "abbreviation": "PTE", "label": "Portugal Escudos*" }, { "value": 77, "abbreviation": "QAR", "label": "Qatar Riyals" }, { "value": 78, "abbreviation": "RON", "label": "Romania New Lei" }, { "value": 79, "abbreviation": "ROL", "label": "Romania Lei*" }, { "value": 80, "abbreviation": "RUB", "label": "Russia Rubles" }, { "value": 81, "abbreviation": "SAR", "label": "Saudi Arabia Riyals" }, { "value": 82, "abbreviation": "XAG", "label": "Silver Ounces" }, { "value": 83, "abbreviation": "SGD", "label": "Singapore Dollars" }, { "value": 84, "abbreviation": "SKK", "label": "Slovakia Koruny*" }, { "value": 85, "abbreviation": "SIT", "label": "Slovenia Tolars*" }, { "value": 86, "abbreviation": "ESP", "label": "Spain Pesetas*" }, { "value": 87, "abbreviation": "LKR", "label": "Sri Lanka Rupees" }, { "value": 88, "abbreviation": "SDG", "label": "Sudan Pounds" }, { "value": 89, "abbreviation": "SEK", "label": "Sweden Kronor" }, { "value": 90, "abbreviation": "TWD", "label": "Taiwan New Dollars" }, { "value": 91, "abbreviation": "THB", "label": "Thailand Baht" }, { "value": 92, "abbreviation": "TTD", "label": "Trinidad and Tobago Dollars" }, { "value": 93, "abbreviation": "TND", "label": "Tunisia Dinars" }, { "value": 94, "abbreviation": "TRY", "label": "Turkey Lira" }, { "value": 95, "abbreviation": "AED", "label": "United Arab Emirates Dirhams" }, { "value": 96, "abbreviation": "VEB", "label": "Venezuela Bolivares*" }, { "value": 97, "abbreviation": "VEF", "label": "Venezuela Bolivares Fuertes" }, { "value": 98, "abbreviation": "VND", "label": "Vietnam Dong" }, { "value": 99, "abbreviation": "ZMK", "label": "Zambia Kwacha" }];
    }
    SearchFields.prototype.getYears = function () {
        return this.form_variables.years;
    };
    SearchFields.prototype.getCountries = function () {
        return this.form_variables.countries;
    };
    SearchFields.prototype.getStates = function (countries) {
        return this.form_variables.states
            .filter(function (state) { return countries.indexOf(state.country) >= 0 || !countries.length; })
            .map(function (state) {
            return {
                value: state.value,
                label: state.label
            };
        });
    };
    SearchFields.prototype.getCities = function (countries, states) {
        return this.form_variables.cities
            .filter(function (location) { return countries.indexOf(location.country) >= 0 || !countries.length; })
            .filter(function (location) { return states.indexOf(location.state) >= 0 || !states.length; })
            .map(function (city) {
            return {
                value: city.value,
                label: city.label
            };
        });
    };
    SearchFields.prototype.getFundingOrganizations = function () {
        return this.form_variables.funding_organizations;
    };
    SearchFields.prototype.getCurrencies = function () {
        return this.currencies.map(function (currency) {
            return {
                value: currency.value,
                label: "(" + currency.abbreviation + ") " + currency.label
            };
        });
    };
    SearchFields.prototype.getCancerTypes = function () {
        return this.form_variables.cancer_types;
    };
    SearchFields.prototype.getProjectTypes = function () {
        return this.form_variables.project_types;
    };
    SearchFields.prototype.getCsoResearchAreas = function () {
        return this.form_variables.cso_research_areas.map(function (cso) {
            return {
                value: cso.value,
                label: cso.label
            };
        });
    };
    return SearchFields;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/search-form.fields.js.map

/***/ },

/***/ 511:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return SearchResultsComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var SearchResultsComponent = (function () {
    function SearchResultsComponent() {
        this.chartData = {};
        this.sort = new __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]();
        this.paginate = new __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]();
        this.analytics = {
            country: [],
            cso_code: [],
            cancer_type_id: [],
            project_type: []
        };
        for (var key in this.analytics) {
            this.chartData[key] = this.getChart(this.analytics[key]);
        }
        console.log(this.chartData);
        this.projectColumns = [
            {
                label: 'Project Title',
                value: 'project_title',
                link: 'url'
            },
            {
                label: 'Name',
                value: "pi_name",
            },
            {
                label: 'Institution',
                value: 'institution'
            },
            {
                label: 'City',
                value: 'city'
            },
            {
                label: 'State',
                value: 'state'
            },
            {
                label: 'Country',
                value: 'country'
            },
            {
                label: 'Funding Organization',
                value: 'funding_organization'
            },
            {
                label: 'Award Code',
                value: 'award_code'
            }
        ];
        this.projectData = [];
    }
    SearchResultsComponent.prototype.ngAfterViewInit = function () {
    };
    SearchResultsComponent.prototype.ngOnChanges = function (changes) {
        if (changes['searchParameters']) {
            console.log('UPDATING SEARCH PARAMETER DISPLAY');
            var param = this.searchParameters;
            var filters = [];
            for (var key in param) {
                if (param[key]) {
                    filters.push(key + ": " + param[key]);
                }
            }
            this.search_terms = param['search_terms'] + " (" + param['search_type'] + ")";
            this.search_filters = filters.join(', ');
        }
        if (changes['analytics']) {
            var change = changes['analytics'].currentValue;
            var cancer_type_id = changes['analytics'].currentValue['cancer_type_id'].map(function (e) { return e; });
            console.log('cancer type', cancer_type_id);
            console.log('updating graphs with', change);
            for (var key in change) {
                console.log('applying ', this.getChart(change[key]), 'to', key, 'actual', change[key]);
                this.chartData[key] = this.getChart(change[key]);
            }
            console.log('New ChartData', this.chartData);
        }
        if (this.results) {
            console.log('Updating results', this.results);
            var projects = this.results;
            this.numProjects = 100;
            this.projectData = projects.map(function (result) {
                return {
                    project_title: result.project_title,
                    pi_name: result.pi_name,
                    institution: result.institution,
                    city: result.city,
                    state: result.state,
                    country: result.country,
                    funding_organization: result.funding_organization,
                    award_code: result.award_code,
                    url: "https://icrpartnership-test.org/ViewProject/" + result.project_id
                };
            });
        }
    };
    SearchResultsComponent.prototype.ngOnInit = function () {
    };
    SearchResultsComponent.prototype.getChart = function (data) {
        return {
            data: data,
            options: {
                type: 'pie'
            }
        };
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], SearchResultsComponent.prototype, "loading", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], SearchResultsComponent.prototype, "results", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], SearchResultsComponent.prototype, "analytics", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], SearchResultsComponent.prototype, "searchParameters", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], SearchResultsComponent.prototype, "param", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Output */])(), 
        __metadata('design:type', (typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]) === 'function' && _a) || Object)
    ], SearchResultsComponent.prototype, "sort", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Output */])(), 
        __metadata('design:type', (typeof (_b = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]) === 'function' && _b) || Object)
    ], SearchResultsComponent.prototype, "paginate", void 0);
    SearchResultsComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'app-search-results',
            template: __webpack_require__(687),
            styles: [__webpack_require__(678)]
        }), 
        __metadata('design:paramtypes', [])
    ], SearchResultsComponent);
    return SearchResultsComponent;
    var _a, _b;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/search-results.component.js.map

/***/ },

/***/ 512:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_http__ = __webpack_require__(212);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_rxjs_Rx__ = __webpack_require__(695);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_rxjs_Rx___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2_rxjs_Rx__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3_rxjs_add_operator_map__ = __webpack_require__(244);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3_rxjs_add_operator_map___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_3_rxjs_add_operator_map__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4_rxjs_add_operator_catch__ = __webpack_require__(243);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4_rxjs_add_operator_catch___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_4_rxjs_add_operator_catch__);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return SearchComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};





var SearchComponent = (function () {
    function SearchComponent(http) {
        this.http = http;
        this.resetParameters();
        this.loading = true;
        this.count = {
            country: [],
            cso_code: [],
            cancer_type_id: [],
            project_type: [],
        };
    }
    SearchComponent.prototype.updateResults = function (event) {
        var _this = this;
        this.loading = true;
        for (var _i = 0, _a = Object.keys(event); _i < _a.length; _i++) {
            var key = _a[_i];
            if (event[key])
                this.parameters[key] = event[key];
        }
        this.queryServer(this.parameters).subscribe(function (response) {
            _this.results = response;
            _this.loading = false;
            console.log('response', response);
            //        this.queryAnalytics();
        }, function (error) {
            console.error(error);
            _this.loading = false;
        });
    };
    SearchComponent.prototype.paginate = function (event) {
        this.parameters['page_size'] = event.page_size;
        this.parameters['page_number'] = event.page_number;
        this.updateResults(this.parameters);
    };
    SearchComponent.prototype.sort = function (event) {
        this.parameters['sort_column'] = event.sort_column;
        this.parameters['sort_type'] = event.sort_type;
        this.updateResults(this.parameters);
    };
    SearchComponent.prototype.queryServerAnalytics = function (parameters, group) {
        var endpoint = "http://localhost/drupal/db_search_api/public_analytics/" + group;
        var params = new __WEBPACK_IMPORTED_MODULE_1__angular_http__["a" /* URLSearchParams */]();
        for (var _i = 0, _a = Object.keys(parameters); _i < _a.length; _i++) {
            var key = _a[_i];
            params.set(key, parameters[key]);
        }
        return this.http.get(endpoint, { search: params })
            .map(function (res) { return res.json(); })
            .catch(function (error) { return __WEBPACK_IMPORTED_MODULE_2_rxjs_Rx__["Observable"].throw(error.json().error || 'Server error'); });
    };
    SearchComponent.prototype.queryServer = function (parameters) {
        var endpoint = 'https://icrpartnership-test.org/db/public/search';
        endpoint = 'http://localhost:10000/db/public/search';
        var params = new __WEBPACK_IMPORTED_MODULE_1__angular_http__["a" /* URLSearchParams */]();
        console.log('CURRENT SEARCH PARAMETERS', parameters);
        if (!parameters['page_size'] || !parameters['page_number']) {
            parameters['page_size'] = 50;
            parameters['page_number'] = 1;
        }
        for (var _i = 0, _a = Object.keys(parameters); _i < _a.length; _i++) {
            var key = _a[_i];
            params.set(key, parameters[key]);
        }
        return this.http.get(endpoint, { search: params })
            .map(function (res) { return res.json(); })
            .catch(function (error) { return __WEBPACK_IMPORTED_MODULE_2_rxjs_Rx__["Observable"].throw(error.json().error || 'Server error'); });
    };
    SearchComponent.prototype.resetParameters = function () {
        this.parameters = {
            search_terms: null,
            search_term_filter: null,
            years: null,
            institution: null,
            pi_first_name: null,
            pi_last_name: null,
            pi_orcid: null,
            award_code: null,
            countries: null,
            states: null,
            cities: null,
            funding_organizations: null,
            cancer_types: null,
            project_types: null,
            cso_research_areas: null,
            page_size: null,
            page_offset: null
        };
    };
    SearchComponent.prototype.ngAfterViewInit = function () {
        this.updateResults({});
    };
    SearchComponent.prototype.ngOnInit = function () {
    };
    SearchComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'app-search',
            template: __webpack_require__(688),
            styles: [__webpack_require__(679)]
        }), 
        __metadata('design:paramtypes', [(typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_1__angular_http__["b" /* Http */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_1__angular_http__["b" /* Http */]) === 'function' && _a) || Object])
    ], SearchComponent);
    return SearchComponent;
    var _a;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/search.component.js.map

/***/ },

/***/ 513:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_http__ = __webpack_require__(212);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_rxjs_add_operator_map__ = __webpack_require__(244);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_rxjs_add_operator_map___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2_rxjs_add_operator_map__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3_rxjs_add_operator_catch__ = __webpack_require__(243);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3_rxjs_add_operator_catch___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_3_rxjs_add_operator_catch__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__ui_chart_parameters__ = __webpack_require__(514);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4__ui_chart_parameters___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_4__ui_chart_parameters__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5__ui_chart_pie__ = __webpack_require__(515);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return UiChartComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};






var UiChartComponent = (function () {
    function UiChartComponent(http) {
        this.http = http;
        this.loading = true;
    }
    UiChartComponent.prototype.drawChart = function (param) {
        if (param.options.type === 'pie') {
            new __WEBPACK_IMPORTED_MODULE_5__ui_chart_pie__["a" /* PieChart */]().draw(this.svg.nativeElement, param.data);
        }
    };
    UiChartComponent.prototype.ngAfterViewInit = function () {
        //    this.queryAnalytics();
    };
    /** Redraw chart on changes */
    UiChartComponent.prototype.ngOnChanges = function (changes) {
        this.queryAnalytics();
        console.log('updated chart', changes);
        console.log('chart parameters', this.param);
        //    this.drawChart(this.param);
    };
    UiChartComponent.prototype.queryAnalytics = function () {
        var res = this.queryServerAnalytics(this.searchParam, this.group);
        new __WEBPACK_IMPORTED_MODULE_5__ui_chart_pie__["a" /* PieChart */]().draw(this.svg.nativeElement, res);
    };
    UiChartComponent.prototype.queryServerAnalytics = function (parameters, group) {
        var res = [];
        if (group === 'country') {
            res = [{ "value": 50287, "label": "US" }, { "value": 13650, "label": "CA" }, { "value": 9630, "label": "GB" }, { "value": 685, "label": "NL" }, { "value": 661, "label": "AU" }, { "value": 551, "label": "FR" }, { "value": 98, "label": "JP" }];
        }
        if (group === 'cso_code') {
            res = [{ "value": 33268, "label": "Biology" }, { "value": 23421, "label": "Treatment" }, { "value": 14436, "label": "Early Detection, Diagnosis, and Prognosis" }, { "value": 14035, "label": "Causes of Cancer/Etiology" }, { "value": 11273, "label": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 6342, "label": "Prevention" }, { "value": 327, "label": "Uncoded" }, { "value": 2, "label": "Scientific Model Systems" }];
        }
        if (group === 'cancer_type_id') {
            res = [{ "value": 20846, "label": "Breast Cancer" }, { "value": 18521, "label": "Not Site-Specific Cancer" }, { "value": 8713, "label": "Gastrointestinal Tract" }, { "value": 8478, "label": "Prostate Cancer" }, { "value": 8080, "label": "Genital System, Male" }, { "value": 7408, "label": "Blood Cancer" }, { "value": 5434, "label": "Colon and Rectal Cancer" }, { "value": 5330, "label": "Lung Cancer" }, { "value": 5241, "label": "Leukemia / Leukaemia" }, { "value": 4831, "label": "Respiratory System" }];
        }
        return res;
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], UiChartComponent.prototype, "searchParam", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', String)
    ], UiChartComponent.prototype, "group", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', (typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_4__ui_chart_parameters__["UiChartParameters"] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_4__ui_chart_parameters__["UiChartParameters"]) === 'function' && _a) || Object)
    ], UiChartComponent.prototype, "param", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', String)
    ], UiChartComponent.prototype, "title", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_1" /* ViewChild */])('svg'), 
        __metadata('design:type', (typeof (_b = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */]) === 'function' && _b) || Object)
    ], UiChartComponent.prototype, "svg", void 0);
    UiChartComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'ui-chart',
            template: __webpack_require__(689),
            styles: [__webpack_require__(680)]
        }), 
        __metadata('design:paramtypes', [(typeof (_c = typeof __WEBPACK_IMPORTED_MODULE_1__angular_http__["b" /* Http */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_1__angular_http__["b" /* Http */]) === 'function' && _c) || Object])
    ], UiChartComponent);
    return UiChartComponent;
    var _a, _b, _c;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-chart.component.js.map

/***/ },

/***/ 514:
/***/ function(module, exports) {

//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-chart.parameters.js.map

/***/ },

/***/ 515:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_d3__ = __webpack_require__(674);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_d3___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_d3__);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return PieChart; });

var PieChart = (function () {
    function PieChart() {
    }
    PieChart.prototype.draw = function (element, data) {
        var host = __WEBPACK_IMPORTED_MODULE_0_d3__["select"](element);
        var size = 400;
        var radius = size / 2;
        var arc = __WEBPACK_IMPORTED_MODULE_0_d3__["arc"]().outerRadius(radius).innerRadius(radius / 2);
        var pie = __WEBPACK_IMPORTED_MODULE_0_d3__["pie"]();
        var color = __WEBPACK_IMPORTED_MODULE_0_d3__["scaleOrdinal"](__WEBPACK_IMPORTED_MODULE_0_d3__["schemeCategory20c"]);
        var svg = host
            .attr('width', '100%')
            .attr('viewBox', "0 0 " + size + " " + size)
            .append('g')
            .attr('transform', "translate(" + size / 2 + ", " + size / 2 + ")");
        // append individual pieces
        var path = svg.selectAll('path')
            .data(pie(data.map(function (e) { return e.value; })))
            .enter().append('path')
            .transition().duration(500)
            .each(function (e) { return e; })
            .attr('d', arc)
            .style('fill', function (d) { return color(d.value.toString()); });
    };
    /**
     * Exports a base64-encoded png
     */
    PieChart.prototype.export = function (data) {
        return '';
    };
    return PieChart;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-chart.pie.js.map

/***/ },

/***/ 516:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return UiPanelComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var UiPanelComponent = (function () {
    function UiPanelComponent() {
        this.title = '';
        this.visible = false;
    }
    UiPanelComponent.prototype.ngOnInit = function () {
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', String)
    ], UiPanelComponent.prototype, "title", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Boolean)
    ], UiPanelComponent.prototype, "visible", void 0);
    UiPanelComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'ui-panel',
            template: __webpack_require__(690),
            styles: [__webpack_require__(681)],
            animations: [
                __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_3" /* trigger */])('visibilityChanged', [
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_4" /* state */])('true', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_6" /* style */])({ height: '*', paddingTop: 10, paddingBottom: 10, marginTop: 0, overflow: 'visible' })),
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_4" /* state */])('false', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_6" /* style */])({ height: 0, paddingTop: 0, paddingBottom: 0, marginTop: -2, overflow: 'hidden' })),
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_5" /* transition */])('void => *', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_7" /* animate */])('0s')),
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_5" /* transition */])('* => *', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_7" /* animate */])('0.15s ease-in-out'))
                ]),
                __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_3" /* trigger */])('rotationChanged', [
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_4" /* state */])('true', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_6" /* style */])({ transform: 'rotate(0deg)' })),
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_4" /* state */])('false', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_6" /* style */])({ transform: 'rotate(180deg)' })),
                    __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_5" /* transition */])('* => *', __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_7" /* animate */])('0.15s ease-in-out'))
                ]),
            ]
        }), 
        __metadata('design:paramtypes', [])
    ], UiPanelComponent);
    return UiPanelComponent;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-panel.component.js.map

/***/ },

/***/ 517:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_forms__ = __webpack_require__(142);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return UiSelectComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};


var UiSelectComponent = (function () {
    function UiSelectComponent(_ref) {
        this._ref = _ref;
        this.isActive = false;
        this.items = [];
        this.placeholder = '';
        this.onSelect = new __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]();
        this.values = [];
        this.labels = [];
        this.selectedItems = [];
        this.matchingItems = [];
        this.selectedIndex = -1;
    }
    UiSelectComponent.prototype.writeValue = function (values) {
        this.selectedItems = [];
        if (values && values.length) {
            for (var _i = 0, values_1 = values; _i < values_1.length; _i++) {
                var value = values_1[_i];
                var index = values.indexOf(value);
                this.selectedItems.push(index);
            }
        }
    };
    UiSelectComponent.prototype.propagateChange = function (_) { };
    ;
    UiSelectComponent.prototype.registerOnTouched = function () { };
    UiSelectComponent.prototype.registerOnChange = function (fn) {
        this.propagateChange = fn;
    };
    UiSelectComponent.prototype.updateSelection = function () {
        var _this = this;
        var selection = this.values.filter(function (v, i) {
            return _this.selectedItems.indexOf(i) >= 0;
        });
        this.onSelect.emit(selection);
        this.propagateChange(selection);
    };
    UiSelectComponent.prototype.removeSelectedItem = function (index) {
        this.selectedItems.splice(index, 1);
        this.updateSelection();
    };
    UiSelectComponent.prototype.addSelectedItem = function (index) {
        this.selectedItems.push(index);
        this.input.nativeElement.value = '';
        this.updateSelection();
    };
    UiSelectComponent.prototype.update = function (event) {
        var input = this.input.nativeElement;
        if (event.key === 'Enter' && this.matchingItems.length >= 0) {
            this.selectedItems.push(this.matchingItems[this.selectedIndex].index);
            input.value = '';
            this.updateSearchResults();
        }
        else if (event.key === 'Backspace' && input.value.length === 0 && this.selectedItems.length > 0) {
            this.selectedItems.pop();
            this.updateSearchResults();
        }
        else if (event.key === 'ArrowUp') {
            this.selectedIndex--;
            if (this.selectedIndex < 0)
                this.selectedIndex = this.matchingItems.length - 1;
        }
        else if (event.key === 'ArrowDown') {
            this.selectedIndex++;
            if (this.selectedIndex >= this.matchingItems.length)
                this.selectedIndex = 0;
        }
        else {
            this.updateSearchResults();
        }
    };
    /** Updates matching indexes */
    UiSelectComponent.prototype.updateSearchResults = function () {
        var _this = this;
        var label = this.input.nativeElement.value;
        this.matchingItems = this.labels.reduce(function (accumulator, current, index) {
            var loc = label.length && current.toLowerCase().indexOf(label.toLowerCase());
            if ((loc >= 0 && _this.selectedItems.indexOf(index) == -1))
                accumulator.push({
                    index: index,
                    location: loc
                });
            return accumulator;
        }, []);
        this.selectedIndex = this.matchingItems.length ? 0 : -1;
    };
    UiSelectComponent.prototype.highlightItem = function (item, index) {
        var label = this.labels[item.index];
        var length = this.input.nativeElement.value.length;
        var displayString = label;
        if (item.location >= 0) {
            var first = label.substr(0, item.location);
            var mid = label.substr(item.location, length);
            var end = label.substr(item.location + length);
            displayString = first + '<b>' + mid + '</b>' + end;
        }
        return displayString;
    };
    UiSelectComponent.prototype.focusInput = function (event) {
        this.isActive = this._ref.nativeElement.contains(event.target);
        if (this.isActive) {
            this.input.nativeElement.focus();
            this.updateSearchResults();
            this.isActive = true;
        }
    };
    UiSelectComponent.prototype.selectIndex = function (index) {
        console.log('new index', index);
        this.selectedIndex = index;
    };
    UiSelectComponent.prototype.ngOnChanges = function (changes) {
        if (changes['items'])
            this.initializeItems(this.items);
    };
    /**
     * Initializes separate arrays for values and labels to improve performance
     */
    UiSelectComponent.prototype.initializeItems = function (items) {
        var _this = this;
        this.values = [];
        this.labels = [];
        items.forEach(function (item) {
            if (typeof item === 'string') {
                _this.values.push(item);
                _this.labels.push(item);
            }
            else if (typeof item === 'object' && item.value && item.label) {
                _this.values.push(item.value);
                _this.labels.push(item.label);
            }
        });
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], UiSelectComponent.prototype, "items", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', String)
    ], UiSelectComponent.prototype, "placeholder", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Output */])(), 
        __metadata('design:type', (typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]) === 'function' && _a) || Object)
    ], UiSelectComponent.prototype, "onSelect", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_1" /* ViewChild */])('input'), 
        __metadata('design:type', (typeof (_b = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */]) === 'function' && _b) || Object)
    ], UiSelectComponent.prototype, "input", void 0);
    UiSelectComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'ui-select',
            template: __webpack_require__(691),
            styles: [__webpack_require__(682)],
            host: {
                '(document:click)': 'focusInput($event)'
            },
            providers: [{
                    provide: __WEBPACK_IMPORTED_MODULE_1__angular_forms__["b" /* NG_VALUE_ACCESSOR */],
                    useExisting: __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_36" /* forwardRef */])(function () { return UiSelectComponent; }),
                    multi: true
                }]
        }), 
        __metadata('design:paramtypes', [(typeof (_c = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */]) === 'function' && _c) || Object])
    ], UiSelectComponent);
    return UiSelectComponent;
    var _a, _b, _c;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-select.component.js.map

/***/ },

/***/ 518:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return UiTableComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};

var UiTableComponent = (function () {
    function UiTableComponent(renderer) {
        this.renderer = renderer;
        this.columns = [];
        this.data = [];
        this.loading = true;
        this.pageOffset = 0;
        this.sort = new __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]();
        this.paginate = new __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]();
    }
    UiTableComponent.prototype.ngAfterViewInit = function () {
        //    this.drawTable(this.mCol, this.mData);
    };
    UiTableComponent.prototype.pageChanged = function (event) {
        this.pageOffset = event.page;
        this.updatePagination();
    };
    UiTableComponent.prototype.updatePageSize = function (event) {
        this.pageSize = +event;
        this.pagingModel = 1;
        this.updatePagination();
    };
    UiTableComponent.prototype.updatePagination = function () {
        var offset = this.pageOffset || 1;
        var size = this.pageSize;
        this.paginate.emit({
            page_size: size,
            page_number: offset
        });
    };
    UiTableComponent.prototype.drawTableHeader = function (columns) {
        var _this = this;
        var thead = this.thead.nativeElement;
        this.clearChildren(thead);
        var headerRow = this.renderer.createElement(thead, 'tr');
        var _loop_1 = function(column) {
            var headerCell = this_1.renderer.createElement(headerRow, 'th');
            this_1.renderer.listen(headerCell, 'click', function (event) {
                column.sort = (column.sort === 'asc') ? 'desc' : 'asc';
                _this.drawTableHeader(columns);
                _this.sort.emit({
                    sort_column: column.value,
                    sort_type: column.sort
                });
            });
            this_1.renderer.createText(headerCell, column.label);
            var headerSortDiv = this_1.renderer.createElement(headerCell, 'span');
            this_1.renderer.createText(headerSortDiv, column.sort === 'asc' ? '▲' : '▼');
            this_1.renderer.setElementClass(headerSortDiv, 'cell-background', true);
        };
        var this_1 = this;
        for (var _i = 0, columns_1 = columns; _i < columns_1.length; _i++) {
            var column = columns_1[_i];
            _loop_1(column);
        }
    };
    UiTableComponent.prototype.drawTableBody = function (columns, data) {
        var tbody = this.tbody.nativeElement;
        this.clearChildren(tbody);
        for (var _i = 0, data_1 = data; _i < data_1.length; _i++) {
            var row = data_1[_i];
            var tableRow = this.renderer.createElement(tbody, 'tr');
            for (var _a = 0, columns_2 = columns; _a < columns_2.length; _a++) {
                var column = columns_2[_a];
                var tableCell = this.renderer.createElement(tableRow, 'td');
                if (!column.link) {
                    var label = this.renderer.createElement(tableCell, 'span');
                    this.renderer.createText(label, row[column.value]);
                }
                else {
                    var link = this.renderer.createElement(tableCell, 'a');
                    this.renderer.createText(link, row[column.value]);
                    this.renderer.setElementAttribute(link, 'href', row[column.link]);
                    this.renderer.setElementAttribute(link, 'target', '_blank');
                }
            }
        }
    };
    UiTableComponent.prototype.drawTable = function (columns, data) {
        this.drawTableHeader(columns);
        this.drawTableBody(columns, data);
    };
    UiTableComponent.prototype.ngOnChanges = function (changes) {
        this.pageSize = this.pageSizes[0];
        this.drawTable(this.columns, this.data);
        if (changes['columns'])
            this.initSort(this.columns);
    };
    UiTableComponent.prototype.clearChildren = function (el) {
        while (el.firstChild) {
            this.renderer.invokeElementMethod(el, 'removeChild', [el.firstChild]);
        }
    };
    UiTableComponent.prototype.initSort = function (columns) {
        columns.forEach(function (column) { return column.sort = 'asc'; });
    };
    UiTableComponent.prototype.initMockData = function () {
        this.mCol = [
            {
                value: 'title',
                label: 'Project Title',
                link: 'url'
            },
            {
                value: 'institution',
                label: 'Institution'
            },
            {
                value: 'lastName',
                label: 'Name'
            },
            {
                value: 'city',
                label: 'City'
            },
            {
                value: 'state',
                label: 'State'
            },
            {
                value: 'country',
                label: 'Country'
            },
            {
                value: 'fundingOrg',
                label: 'Funding Organization'
            },
        ];
        this.mData = [
            {
                "projectID": 55109,
                "title": "\"\"BCR/ABL-PI-3k-ROS pathway induce genomic instability ....\"\"",
                "lastName": "Skorski",
                "firstName": "Tomasz",
                "institution": "Temple University",
                "city": "Philadelphia",
                "state": "PA",
                "country": "US",
                "fundingOrg": "National Cancer Institute",
                "url": "http://localhost/drupal/ViewProject/55109",
            },
            {
                "projectID": 56428,
                "title": "\"\"Cancer Immunotherapy by Targeting A2 Adenosine Receptor\"\"",
                "lastName": "Sitkovsky",
                "firstName": "Michail",
                "institution": "Northeastern University",
                "city": "Boston",
                "state": "MA",
                "country": "US",
                "fundingOrg": "National Cancer Institute",
                "url": "http://localhost/drupal/ViewProject/56428",
            },
            {
                "projectID": 49892,
                "title": "\"\"Cluster Bombing\"\" of Neighbor Antioxidant & Breast Tumor Suppressor Loci",
                "lastName": "Burton",
                "firstName": "Frank",
                "institution": "Minnesota, University of, Twin Cities",
                "city": "Minneapolis",
                "state": "MN",
                "country": "US",
                "fundingOrg": "U. S. Department of Defense, CDMRP",
                "url": "http://localhost/drupal/ViewProject/49892",
            }
        ];
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Array)
    ], UiTableComponent.prototype, "data", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Object)
    ], UiTableComponent.prototype, "columns", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Boolean)
    ], UiTableComponent.prototype, "loading", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Number)
    ], UiTableComponent.prototype, "numResults", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', Array)
    ], UiTableComponent.prototype, "pageSizes", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Output */])(), 
        __metadata('design:type', (typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]) === 'function' && _a) || Object)
    ], UiTableComponent.prototype, "sort", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["C" /* Output */])(), 
        __metadata('design:type', (typeof (_b = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["_20" /* EventEmitter */]) === 'function' && _b) || Object)
    ], UiTableComponent.prototype, "paginate", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_1" /* ViewChild */])('thead'), 
        __metadata('design:type', (typeof (_c = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */]) === 'function' && _c) || Object)
    ], UiTableComponent.prototype, "thead", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_1" /* ViewChild */])('tbody'), 
        __metadata('design:type', (typeof (_d = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["g" /* ElementRef */]) === 'function' && _d) || Object)
    ], UiTableComponent.prototype, "tbody", void 0);
    UiTableComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'ui-table',
            template: __webpack_require__(692),
            styles: [__webpack_require__(683)],
            encapsulation: __WEBPACK_IMPORTED_MODULE_0__angular_core__["c" /* ViewEncapsulation */].None
        }), 
        __metadata('design:paramtypes', [(typeof (_e = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["r" /* Renderer */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["r" /* Renderer */]) === 'function' && _e) || Object])
    ], UiTableComponent);
    return UiTableComponent;
    var _a, _b, _c, _d, _e;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-table.component.js.map

/***/ },

/***/ 519:
/***/ function(module, exports) {

//# sourceMappingURL=C:/Development/Projects/icrp-search/src/treenode.js.map

/***/ },

/***/ 520:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0__angular_core__ = __webpack_require__(1);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1__angular_forms__ = __webpack_require__(142);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__treenode__ = __webpack_require__(519);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2__treenode___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2__treenode__);
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return UiTreeviewComponent; });
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};



var UiTreeviewComponent = (function () {
    function UiTreeviewComponent(renderer) {
        this.renderer = renderer;
        this.selectedValues = [];
    }
    UiTreeviewComponent.prototype.writeValue = function (values) {
        this.selectTreeValues(this.root, values || []);
        this.clearChildren(this.tree.nativeElement);
        this.createTree(this.root, this.tree.nativeElement, false, true);
    };
    UiTreeviewComponent.prototype.propagateChange = function (_) { };
    ;
    UiTreeviewComponent.prototype.registerOnTouched = function () { };
    UiTreeviewComponent.prototype.registerOnChange = function (fn) {
        this.propagateChange = fn;
    };
    UiTreeviewComponent.prototype.selectTreeValues = function (root, values) {
        root.selected = (values.indexOf(root.value) >= 0);
        if (root.children && root.children.length) {
            for (var _i = 0, _a = root.children; _i < _a.length; _i++) {
                var child = _a[_i];
                this.selectTreeValues(child, values);
            }
        }
    };
    /** Recursively creates dom nodes related to tree - on change, rebuilds the portion of the tree that changed */
    UiTreeviewComponent.prototype.createTree = function (node, el, selected, replace) {
        var _this = this;
        /** Initialize the selected state of the node */
        node.selected = selected;
        if (node.selected && node.value != null && this.selectedValues.indexOf(node.value) === -1) {
            this.selectedValues.push(node.value);
        }
        else if (!node.selected) {
            var index = this.selectedValues.indexOf(node.value);
            if (index >= 0)
                this.selectedValues.splice(index, 1);
        }
        /** Determine if node has children */
        var hasChildren = node.children && node.children.length > 0;
        /** Create container for node label */
        var div = replace ? el : this.renderer.createElement(el, 'div');
        /** Set default margin for container */
        this.renderer.setElementStyle(div, 'margin-left', '4px');
        this.renderer.setElementClass(div, 'noselect', true);
        /** Create checkboxes/label group if this is a leaf node */
        if (!hasChildren) {
            /** Create label */
            var label = this.renderer.createElement(div, 'label');
            /** Create checkbox */
            var checkbox = this.renderer.createElement(label, 'input');
            /** Set value of checkbox */
            this.renderer.setElementProperty(checkbox, 'value', node.value);
            /** Bind checked property to node selection value */
            this.renderer.setElementProperty(checkbox, 'checked', node.selected);
            /** When this checkbox is clicked, rebuild its contents */
            this.renderer.listen(checkbox, 'click', function (event) { return _this.toggleNode(node, div); });
            /** Set the type of input element */
            this.renderer.setElementAttribute(checkbox, 'type', 'checkbox');
            /** Create label text (after adding checkbox) */
            this.renderer.createText(label, node.label);
            /** Set appearance of each checkbox/label group */
            this.renderer.setElementStyle(checkbox, 'margin-right', '2px');
            this.renderer.setElementStyle(label, 'margin-bottom', '0');
            this.renderer.setElementStyle(label, 'font-weight', 'normal');
            this.renderer.setElementStyle(label, 'cursor', 'pointer');
        }
        else {
            /** Span containing node label */
            var span = this.renderer.createElement(div, 'span');
            /** Add text to span */
            this.renderer.createText(span, node.label);
            /** When this span is clicked, rebuild its contents */
            this.renderer.listen(span, 'click', function (event) { return _this.toggleNode(node, div); });
            /** Add style to span */
            this.renderer.setElementStyle(span, 'font-weight', 'bold');
            this.renderer.setElementStyle(span, 'cursor', 'pointer');
            this.renderer.setElementStyle(span, 'display', 'inline-block');
            this.renderer.setElementStyle(span, 'margin-top', '2px');
        }
        if (hasChildren) {
            for (var _i = 0, _a = node.children; _i < _a.length; _i++) {
                var child = _a[_i];
                this.createTree(child, div, selected, false);
            }
        }
        this.propagateChange(this.selectedValues);
    };
    UiTreeviewComponent.prototype.toggleNode = function (node, el) {
        this.clearChildren(el);
        this.createTree(node, el, !node.selected, true);
        console.log('selected values', this.selectedValues);
    };
    UiTreeviewComponent.prototype.clearChildren = function (el) {
        while (el.firstChild) {
            this.renderer.invokeElementMethod(el, 'removeChild', [el.firstChild]);
        }
    };
    UiTreeviewComponent.prototype.ngOnChanges = function () {
        this.createTree(this.root, this.tree.nativeElement, false, true);
        console.log('selected values on creation', this.selectedValues);
    };
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_1" /* ViewChild */])('tree'), 
        __metadata('design:type', Object)
    ], UiTreeviewComponent.prototype, "tree", void 0);
    __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["B" /* Input */])(), 
        __metadata('design:type', (typeof (_a = typeof __WEBPACK_IMPORTED_MODULE_2__treenode__["TreeNode"] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_2__treenode__["TreeNode"]) === 'function' && _a) || Object)
    ], UiTreeviewComponent.prototype, "root", void 0);
    UiTreeviewComponent = __decorate([
        __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["G" /* Component */])({
            selector: 'ui-treeview',
            template: __webpack_require__(693),
            styles: [__webpack_require__(684)],
            providers: [{
                    provide: __WEBPACK_IMPORTED_MODULE_1__angular_forms__["b" /* NG_VALUE_ACCESSOR */],
                    useExisting: __webpack_require__.i(__WEBPACK_IMPORTED_MODULE_0__angular_core__["_36" /* forwardRef */])(function () { return UiTreeviewComponent; }),
                    multi: true
                }]
        }), 
        __metadata('design:paramtypes', [(typeof (_b = typeof __WEBPACK_IMPORTED_MODULE_0__angular_core__["r" /* Renderer */] !== 'undefined' && __WEBPACK_IMPORTED_MODULE_0__angular_core__["r" /* Renderer */]) === 'function' && _b) || Object])
    ], UiTreeviewComponent);
    return UiTreeviewComponent;
    var _a, _b;
}());
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/ui-treeview.component.js.map

/***/ },

/***/ 521:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony export (binding) */ __webpack_require__.d(exports, "a", function() { return environment; });
// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `angular-cli.json`.
var environment = {
    production: false
};
//# sourceMappingURL=C:/Development/Projects/icrp-search/src/environment.js.map

/***/ },

/***/ 522:
/***/ function(module, exports, __webpack_require__) {

"use strict";
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_core_js_es6_symbol__ = __webpack_require__(536);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_0_core_js_es6_symbol___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0_core_js_es6_symbol__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_core_js_es6_object__ = __webpack_require__(529);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_1_core_js_es6_object___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_1_core_js_es6_object__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_core_js_es6_function__ = __webpack_require__(525);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_2_core_js_es6_function___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_2_core_js_es6_function__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3_core_js_es6_parse_int__ = __webpack_require__(531);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_3_core_js_es6_parse_int___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_3_core_js_es6_parse_int__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4_core_js_es6_parse_float__ = __webpack_require__(530);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_4_core_js_es6_parse_float___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_4_core_js_es6_parse_float__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5_core_js_es6_number__ = __webpack_require__(528);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_5_core_js_es6_number___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_5_core_js_es6_number__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6_core_js_es6_math__ = __webpack_require__(527);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_6_core_js_es6_math___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_6_core_js_es6_math__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7_core_js_es6_string__ = __webpack_require__(535);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_7_core_js_es6_string___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_7_core_js_es6_string__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8_core_js_es6_date__ = __webpack_require__(524);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_8_core_js_es6_date___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_8_core_js_es6_date__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9_core_js_es6_array__ = __webpack_require__(523);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_9_core_js_es6_array___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_9_core_js_es6_array__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10_core_js_es6_regexp__ = __webpack_require__(533);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_10_core_js_es6_regexp___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_10_core_js_es6_regexp__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11_core_js_es6_map__ = __webpack_require__(526);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_11_core_js_es6_map___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_11_core_js_es6_map__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12_core_js_es6_set__ = __webpack_require__(534);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_12_core_js_es6_set___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_12_core_js_es6_set__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_13_core_js_es6_reflect__ = __webpack_require__(532);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_13_core_js_es6_reflect___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_13_core_js_es6_reflect__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_14_core_js_es7_reflect__ = __webpack_require__(537);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_14_core_js_es7_reflect___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_14_core_js_es7_reflect__);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_15_zone_js_dist_zone__ = __webpack_require__(965);
/* harmony import */ var __WEBPACK_IMPORTED_MODULE_15_zone_js_dist_zone___default = __webpack_require__.n(__WEBPACK_IMPORTED_MODULE_15_zone_js_dist_zone__);
















//# sourceMappingURL=C:/Development/Projects/icrp-search/src/polyfills.js.map

/***/ },

/***/ 676:
/***/ function(module, exports) {

module.exports = ""

/***/ },

/***/ 677:
/***/ function(module, exports) {

module.exports = "label.radio-label {\r\n  font-weight: normal;\r\n  margin-bottom: 2px;\r\n  cursor: pointer;\r\n}\r\n\r\nlabel.form-label {\r\n  display: block;\r\n  margin-top: 10px;\r\n  color: #666;\r\n  font-weight: 700;\r\n}\r\n\r\nlabel.form-label:first-child {\r\n  margin-top: 4px;\r\n}\r\n\r\nselect.input {\r\n  padding-left: 4px;\r\n}\r\n\r\n.vertical-spacer {\r\n  margin: 15px 0;\r\n}\r\n\r\n\r\n.selector {\r\n  border: 1px solid #FDFDFD;\r\n}\r\n\r\n.multiselect {\r\n  max-height: 300px;\r\n  overflow: auto;\r\n\r\n  border: 1px solid #CCC;\r\n  padding: 4px;\r\n}\r\n\r\n.disable-text-selection {\r\n\r\n\r\n  -webkit-touch-callout: none; /* iOS Safari */\r\n    -webkit-user-select: none; /* Chrome/Safari/Opera */ /* Konqueror */\r\n       -moz-user-select: none; /* Firefox */\r\n        -ms-user-select: none; /* Internet Explorer/Edge */\r\n            user-select: none; /* Non-prefixed version, currently\r\n                                  not supported by any browser */\r\n\r\n\r\n}"

/***/ },

/***/ 678:
/***/ function(module, exports) {

module.exports = ""

/***/ },

/***/ 679:
/***/ function(module, exports) {

module.exports = ""

/***/ },

/***/ 680:
/***/ function(module, exports) {

module.exports = ":host .arc text {\r\n    text-anchor: middle;\r\n    font: 10px sans-serif;\r\n}\r\n\r\n:host .arc path {\r\n    stroke: #fff;\r\n}\r\n\r\npath {\r\n    fill: #CCC;\r\n    stroke: #444;\r\n}\r\n"

/***/ },

/***/ 681:
/***/ function(module, exports) {

module.exports = "\r\n:host:last-child {\r\n  margin-bottom: 200px;\r\n}\r\n\r\n.ui-panel {\r\n  border: 1px solid #BBB;\r\n  border-left: 3px solid #666;\r\n  margin-top: -1px;\r\n}\r\n\r\n.ui-panel:hover {\r\n  border-left: 3px solid #888;\r\n}\r\n\r\n.ui-panel-content {\r\n  padding: 10px;\r\n  font-size: 13px;\r\n}\r\n\r\n.ui-panel-header {\r\n  padding: 10px;\r\n  font-size: 15px;\r\n  background-color: #F9F9F9;\r\n  color: #777;\r\n  cursor: pointer;\r\n  border-bottom: 1px solid #BBB;\r\n}\r\n\r\n.ui-panel-header:hover {\r\n  background-color: #FDFDFD;\r\n}\r\n\r\n"

/***/ },

/***/ 682:
/***/ function(module, exports) {

module.exports = "/**\r\n * These styles determine the layout of this component and will always be applied\r\n * \r\n * select-container\r\n * select-input-container\r\n * select-dropdown-container\r\n * select-label\r\n * select-input\r\n * select-dropdown-item\r\n * select-dropdown-selected\r\n * select-dropdown-matched\r\n */\r\n\r\n\r\n.select-container {\r\n    width: 100%;\r\n    position: relative;\r\n}\r\n\r\n.select-input-container {\r\n    cursor: text;\r\n}\r\n\r\n.select-input-container > div {\r\n    display: inline-block;\r\n    vertical-align: middle;\r\n}\r\n\r\n.select-label {\r\n    display: inline-block;\r\n    cursor: default;\r\n}\r\n\r\n.select-label > div {\r\n    display: inline-block;\r\n}\r\n\r\n.select-label > div:last-child {\r\n    cursor: pointer;\r\n}\r\n\r\n.select-input {\r\n    display: inline-block;\r\n    border: none;\r\n    outline: none;\r\n}\r\n\r\n.select-dropdown {\r\n    position: absolute;\r\n    left: 0px;\r\n    right: 0px;\r\n    z-index: 9999;\r\n    cursor: default;\r\n}\r\n\r\n/**\r\n * Default styles\r\n */\r\n\r\n.select-container.default {\r\n\r\n    padding-left: 4px;\r\n    border: 1px solid #D1D1D1;\r\n    border-radius: 2px;\r\n    \r\n\r\n    color: #777;\r\n}\r\n\r\n.select-input-container.default {\r\n    padding-left: 6px;\r\n}\r\n\r\n.select-label.default {\r\n    margin: 2px 4px 2px -2px;\r\n\r\n    border: 1px solid #DDD;\r\n    border-radius: 2px;\r\n\r\n}\r\n\r\n.select-label.default:hover {\r\n    box-shadow: 0 0 3px #DDD;\r\n}\r\n\r\n.select-label.default > div {\r\n    padding: 0 4px;\r\n    cursor: default;\r\n}\r\n\r\n.select-label.default > div:last-child {\r\n    border-left: 1px solid #DDD;\r\n    color: #CCC;\r\n    cursor: pointer;\r\n}\r\n\r\n.select-label.default > div:last-child:hover {\r\n    color: #999;\r\n    box-shadow: 0 0 2px #BBB;   \r\n}\r\n\r\n.select-input.default {\r\n    margin-left: -2px;\r\n    padding: 6px 0;\r\n}\r\n\r\n\r\n.select-dropdown.default {\r\n    margin-top: 1px;\r\n    background-color: white;\r\n    outline: 1px solid #CCC;\r\n    box-shadow: 0 2px 3px #DDD;\r\n\r\n    overflow-y: auto;\r\n    overflow-x: hidden;\r\n    max-height: 200px;\r\n}\r\n\r\n.select-dropdown-item.default {\r\n    padding: 4px 8px;\r\n}\r\n\r\n.select-dropdown-item.default.selected {\r\n    background-color: #DEDEDE;\r\n    color: black;\r\n    outline: 1px solid white;\r\n}\r\n"

/***/ },

/***/ 683:
/***/ function(module, exports) {

module.exports = "div.ui-table-wrapper {\r\n    overflow-x: auto;\r\n    position: relative;\r\n    min-height: 200px;\r\n    width: 100%;\r\n}\r\n\r\ntable.ui-table {\r\n    width: 100%;\r\n    border-left: 1px solid #DDD;\r\n    border-top: 1px solid #DDD;\r\n}\r\n\r\ntable.ui-table > thead > tr > th {\r\n    cursor: pointer;\r\n    white-space: nowrap;\r\n}\r\n\r\n\r\ntable.ui-table > thead > tr > th,\r\ntable.ui-table > tbody > tr > td {\r\n    border-right: 1px solid #DDD; \r\n    padding: 4px;\r\n    position: relative;\r\n}\r\n\r\ntable.ui-table > thead > tr > th {\r\n    padding-right: 24px;\r\n}\r\n\r\ntable.ui-table > thead > tr > th:first-child {\r\n    min-width: 400px;\r\n}\r\n\r\ntable.ui-table > thead > tr,\r\ntable.ui-table > tbody > tr {\r\n    border-bottom: 1px solid #DDD;\r\n}\r\n\r\ntable.ui-table > tbody > tr > td > a {\r\n    color: #444;\r\n}\r\n\r\ntable.ui-table > tbody > tr:nth-child(odd) {\r\n    background-color: #F5F5F5;\r\n}\r\n\r\ntable.ui-table .cell-background {\r\n    color: #DDD;\r\n    \r\n    position: absolute;\r\n    right: 5px;\r\n    z-index: -1;\r\n    overflow: hidden;\r\n}\r\n\r\n.pagination {\r\n    margin-top: 0 !important;\r\n}\r\n\r\n.loading-wrapper {\r\n    min-height: 200px;\r\n    width: 100%;\r\n    position: absolute;\r\n    background-color: white;\r\n    opacity: 0.4;\r\n    height: 100%;\r\n    z-index: 999;\r\n}\r\n\r\n.loading {\r\n    position: absolute;\r\n    left: 50%;\r\n    top: 50%;\r\n\tborder-bottom: 6px solid rgba(0, 0, 0, .1);\r\n\tborder-left: 6px solid rgba(0, 0, 0, .1);\r\n\tborder-right: 6px solid rgba(0, 0, 0, .1);\r\n\tborder-top: 6px solid rgba(0, 0, 0, .4);\r\n\tborder-radius: 100%;\r\n\theight: 50px;\r\n\twidth: 50px;\r\n\t-webkit-animation: rot .6s infinite linear;\r\n\t        animation: rot .6s infinite linear;\r\n    z-index: 9999;\r\n\r\n}\r\n@-webkit-keyframes rot {\r\n\tfrom {-webkit-transform: rotate(0deg);transform: rotate(0deg);}\r\n\tto {-webkit-transform: rotate(359deg);transform: rotate(359deg);}\r\n}\r\n@keyframes rot {\r\n\tfrom {-webkit-transform: rotate(0deg);transform: rotate(0deg);}\r\n\tto {-webkit-transform: rotate(359deg);transform: rotate(359deg);}\r\n}"

/***/ },

/***/ 684:
/***/ function(module, exports) {

module.exports = "\r\n\r\n.treeview-label {\r\n    margin-bottom: 0 !important;\r\n    font-weight: normal !important;\r\n}\r\n\r\n\r\n/*\r\n.ui-treeview-container {\r\n    margin: 0;\r\n    padding: 0;\r\n}\r\n\r\nlabel.ui-treeview-label {\r\n    font-weight: normal;\r\n    cursor: pointer;\r\n}\r\n\r\nlabel.title.ui-treeview-label {\r\n    font-weight: bold;\r\n}\r\n\r\n.toggle-children {\r\n    display: inline-block; \r\n    font-weight: normal; \r\n    cursor: pointer;\r\n    color: #AAA;\r\n}\r\n\r\n.treeview-item-selected {\r\n    background-color: #EEE;\r\n}\r\n\r\n\r\n.treeview-item-deselected {\r\n    background-color: white;\r\n}\r\n*/\r\n\r\n\r\n.noselect {\r\n  -webkit-touch-callout: none; /* iOS Safari */\r\n    -webkit-user-select: none; /* Chrome/Safari/Opera */ /* Konqueror */\r\n       -moz-user-select: none; /* Firefox */\r\n        -ms-user-select: none; /* Internet Explorer/Edge */\r\n            user-select: none; /* Non-prefixed version, currently\r\n                                  not supported by any browser */\r\n}\r\n\r\n.noevents {\r\n    pointer-events: none;\r\n}"

/***/ },

/***/ 685:
/***/ function(module, exports) {

module.exports = "<div class=\"clearfix native-font\">\n  <app-search></app-search>\n</div>\n\n"

/***/ },

/***/ 686:
/***/ function(module, exports) {

module.exports = "<form [formGroup]=\"form\" (ngSubmit)=\"submit()\">\n\n  <!-- Search Terms -->\n  <ui-panel title=\"Search Terms\" [visible]=\"true\">\n    <label class=\"sr-only\" for=\"search_terms\">Search Terms</label>\n    <input \n      class=\"text input\" \n      id=\"search_terms\"\n      name=\"search_terms\"\n      type=\"text\"\n      placeholder=\"Enter search terms\"\n      [formControl]=\"form.controls.search_terms\">\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_all\">\n        <input \n          class=\"radio-input\" \n          type=\"radio\" \n          id=\"search_term_filter_all\" \n          name=\"search_term_filter\" \n          value=\"all\"\n          [formControl]=\"form.controls.search_term_filter\">\n        All of the keywords\n      </label>\n    </div>\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_none\">\n        <input\n          class=\"radio-input\"\n          type=\"radio\"\n          id=\"search_term_filter_none\"\n          name=\"search_term_filter\"\n          value=\"none\"\n          [formControl]=\"form.controls.search_term_filter\">\n        None of the keywords\n      </label>\n    </div>\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_any\">\n        <input\n          class=\"radio-input\"\n          type=\"radio\"\n          id=\"search_term_filter_any\"\n          name=\"search_term_filter\"\n          value=\"any\"\n          [formControl]=\"form.controls.search_term_filter\">\n        Any of the keywords\n      </label>\n    </div>\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_exact\">\n        <input \n          class=\"radio-input\"\n          type=\"radio\"\n          id=\"search_term_filter_exact\"\n          name=\"search_term_filter\"\n          value=\"exact\"\n          [formControl]=\"form.controls.search_term_filter\">\n        Exact phrase provided\n      </label>\n    </div>\n\n    <label class=\"form-label\" for=\"years_active\">Years Active</label>\n    <ui-select placeholder=\"Select years\" [items]=\"fields.years\" [formControl]=\"form.controls.years\"></ui-select>\n  </ui-panel>\n\n  <!-- Institution Receiving Award -->\n  <ui-panel title=\"Institution Receiving Award\">\n    <label class=\"form-label\" for=\"institution\">Institution Name</label>\n    <input \n      class=\"text input\"\n      type=\"text\"\n      id=\"institution\"\n      placeholder=\"Full or partial name\"\n      [formControl]=\"form.controls.institution\">\n\n    <label class=\"form-label\" for=\"pi_first_name\">Principal Investigator</label>\n    <div class=\"clearfix\">\n      <div class=\"six columns\">\n        <input \n          class=\"text input\"\n          type=\"text\"\n          id=\"pi_first_name\"\n          placeholder=\"First name or initial\"\n          [formControl]=\"form.controls.pi_first_name\">\n      </div>\n\n      <div class=\"six columns\" for=\"pi_last_name\">\n        <input\n          class=\"text input\"\n          type=\"text\"\n          id=\"pi_last_name\"\n          placeholder=\"Last name\"\n          [formControl]=\"form.controls.pi_last_name\">\n      </div>\n    </div>\n\n    <label class=\"form-label\" for=\"pi_orcid\">ORCiD ID</label>\n    <input\n      class=\"text input\"\n      type=\"text\"\n      for=\"pi_orcid\"\n      placeholder=\"nnnn-nnnn-nnnn-nnnn\"\n      [formControl]=\"form.controls.pi_orcid\">\n\n    <label class=\"form-label\" for=\"award_code\">Project Award Code</label>\n    <input\n      class=\"text input\"\n      id=\"award_code\"\n      type=\"text\"\n      placeholder=\"Award Code\"\n      [formControl]=\"form.controls.award_code\">\n\n    <label class=\"form-label\" for=\"countries\">Country</label>\n    <ui-select placeholder=\"Enter Countries\" [items]=\"fields.countries\" [formControl]=\"form.controls.countries\" (onSelect)=\"updateLocationSearch($event)\"></ui-select>\n\n    <label class=\"form-label\" for=\"states\">State/Territory</label>\n    <ui-select placeholder=\"Enter States/Territories\" [items]=\"fields.states\" [formControl]=\"form.controls.states\"></ui-select>\n\n    <label class=\"form-label\" for=\"cities\">City</label>\n    <ui-select placeholder=\"Enter Cities\" [items]=\"fields.cities\" [formControl]=\"form.controls.cities\"></ui-select>\n  </ui-panel>\n\n  <!-- Funding Organizations -->\n  <ui-panel title=\"Funding Organizations\">\n    <label class=\"sr-only\" for=\"funding_organizations\">Funding Organizations</label>\n    <div class=\"multiselect\">\n      <ui-treeview [root]=\"searchFields.fundingOrgs\" [formControl]=\"form.controls.funding_organizations\"></ui-treeview>\n    </div>\n  </ui-panel>\n\n  <!-- Cancer and Project Type -->\n  <ui-panel title=\"Cancer and Project Type\">\n\n    <label class=\"form-label\" for=\"cancer_types\">Cancer Types</label>\n    <ui-select placeholder=\"Select Cancer Types\" [items]=\"fields.cancer_types\" [formControl]=\"form.controls.cancer_types\"></ui-select>\n\n    <label class=\"form-label\" for=\"project_types\">Project Types</label>\n    <ui-select placeholder=\"Select Project Types\" [items]=\"fields.project_types\" [formControl]=\"form.controls.project_types\"></ui-select>\n  </ui-panel>\n\n  <!-- Common Scientific Outline - Research Area -->\n  <ui-panel title=\"Common Scientific Outline - Research Area\">\n    <label class=\"sr-only\" for=\"cso_research_areas\">CSO - Research Areas</label>\n\n    <div class=\"multiselect\">\n      <ui-treeview [root]=\"searchFields.csoAreas\" [formControl]=\"form.controls.cso_research_areas\"></ui-treeview>\n    </div>\n  </ui-panel>\n\n  <div class=\"text-right vertical-spacer\">\n    <button class=\"btn btn-default\" (click)=\"form.reset()\">Clear</button>\n    <button class=\"btn btn-primary\" (click)=\"submit()\">Search</button>\n  </div>\n</form>\n\n"

/***/ },

/***/ 687:
/***/ function(module, exports) {

module.exports = "<div>\n<b>Search Terms:</b>{{ search_terms }}\n</div>\n\n<div>\n<b>Search Filters:</b>{{ search_filters }}\n</div>\n\n\n<div class=\"clearfix\">\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Country\" [searchParam]=\"param\" group=\"country\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by CSO Category\" [searchParam]=\"param\" group=\"cso_code\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Cancer Type\" [searchParam]=\"param\" group=\"cancer_type_id\"></ui-chart>\n  </div>\n</div>\n\n<div class=\"clearfix\" style=\"display: none\">\n<!--  \n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Type\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Institution\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Funding Organization\"></ui-chart>\n  </div>\n\n\n<div>\n  <button class=\"btn btn-small btn-default\">Email results</button>\n  <button class=\"btn btn-small btn-default\">Export results</button>\n</div>\n\n\n-->\n\n</div>\n\n\n<br>\n\n<ui-table \n  [data]=\"projectData\" \n  [columns]=\"projectColumns\" \n  [loading]=\"loading\" \n  [pageSizes]=\"[10, 20, 30, 40, 50]\" \n  [numResults]=\"numProjects\" \n  (paginate)=\"paginate.emit($event)\" \n  (sort)=\"sort.emit($event)\">\n</ui-table>"

/***/ },

/***/ 688:
/***/ function(module, exports) {

module.exports = "<div class=\"four columns\">\n  <app-search-form (search)=\"updateResults($event)\"></app-search-form>\n</div>\n\n<div class=\"eight columns\">\n  <app-search-results [results]=\"results\" [searchParameters]=\"parameters\" [analytics]=\"count\" [loading]=\"loading\" (paginate)=\"paginate($event)\" (sort)=\"sort($event)\" [param]=\"parameters\"></app-search-results>\n</div>"

/***/ },

/***/ 689:
/***/ function(module, exports) {

module.exports = "<div style=\"text-align: center; position: relative; \">\n  <svg #svg></svg>\n  <br>\n  <i>{{ title }}</i>\n</div>"

/***/ },

/***/ 690:
/***/ function(module, exports) {

module.exports = "<div class=\"ui-panel\">\n  <div class=\"ui-panel-header disable-text-selection noselect\" (click)=\"visible = !visible\">\n    \n    {{ title }}\n\n    <div class=\"pull-right small\">\n      <i class=\"glyphicon glyphicon-triangle-top\" [@rotationChanged]=\"visible\" aria-hidden=\"true\"></i>\n    </div>\n  </div>\n\n  <div class=\"ui-panel-content\" [@visibilityChanged]=\"visible\" >\n    <ng-content></ng-content>\n  </div>\n</div>"

/***/ },

/***/ 691:
/***/ function(module, exports) {

module.exports = "<div class=\"select-container default\">\r\n  <div class=\"select-input-container default\">\r\n    <div class=\"select-label default\" *ngFor=\"let item of selectedItems; let index = index\">\r\n      <div>{{labels[item]}}</div>\r\n      <div (click)=\"removeSelectedItem(index)\">&#x2715;</div>\r\n    </div>\r\n    <div>\r\n      <input class=\"select-input default\" type=\"text\" (keyup)=\"update($event)\" #input [placeholder]=\"selectedItems.length ? '' : placeholder\">\r\n    </div>\r\n  </div>\r\n\r\n  <div class=\"select-dropdown default\" [style.display]=\"isActive && matchingItems.length ? 'block': 'none'\">\r\n    <div *ngFor=\"let item of matchingItems; let index = index\" \r\n      class=\"select-dropdown-item default\" \r\n      [ngClass]=\"{'selected': index === selectedIndex}\"  \r\n      [innerHTML]=\"highlightItem(item, index)\" \r\n      (click)=\"addSelectedItem(item.index)\" \r\n      (mouseover)=\"selectIndex(index)\" #el></div>\r\n  </div>\r\n</div>"

/***/ },

/***/ 692:
/***/ function(module, exports) {

module.exports = "<div class=\"ui-table-wrapper\">\n  <div class=\"loading-wrapper\" *ngIf=\"loading\"><div class=\"loading\"></div></div>\n\n  <table class=\"ui-table\">\n    <thead #thead></thead>\n    <tbody #tbody></tbody>\n  </table>\n</div>\n\n<div class=\"clearfix\" style=\"margin-top: 20px\">\n  <div class=\"pull-left\">\n\n<!--\n    <pagination \n      [boundaryLinks]=\"true\" \n      [totalItems]=\"numResults\" \n      [(ngModel)]=\"pagingModel\"\n      [maxSize]=\"5\"\n      (pageChanged)=\"pageChanged($event)\"\n      [itemsPerPage]=\"pageSize\"\n      class=\"pagination-sm\"\n      previousText=\"&lsaquo;\" \n      nextText=\"&rsaquo;\" \n      firstText=\"&laquo;\" \n      lastText=\"&raquo;\">\n    </pagination>\n-->\n    Pagination\n  </div>\n\n  <div class=\"pull-right\">\n    Show \n    <select #p (change)=\"updatePageSize(p.value)\">\n      <option *ngFor=\"let size of pageSizes\" [value]=\"size\">{{size}}</option>\n    </select>\n    entries of {{ numResults | number }}\n  </div>\n</div>"

/***/ },

/***/ 693:
/***/ function(module, exports) {

module.exports = "<div #tree></div>"

/***/ },

/***/ 966:
/***/ function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(401);


/***/ }

},[966]);
//# sourceMappingURL=main.bundle.map