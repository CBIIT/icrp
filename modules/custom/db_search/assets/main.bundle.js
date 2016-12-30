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
        this.title = 'icrp works!';
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
            search_term_filter: [''],
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
        this.search.emit({
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
        });
    };
    SearchFormComponent.prototype.initializeFields = function () {
        this.fields = {
            years: this.searchFields.getYears(),
            countries: this.searchFields.getCountries(),
            states: this.searchFields.getStates([]),
            cities: this.searchFields.getCities([], []),
            currencies: this.searchFields.getCurrencies(),
            cancer_types: this.searchFields.cancer_types,
            project_types: this.searchFields.project_types,
            funding_organizations: this.searchFields.getFundingOrganizations(),
            cso_research_areas: this.searchFields.getCsoResearchAreas()
        };
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
        this.cancer_types = [{ "value": 2, "label": "Not Site-Specific Cancer" }, { "value": 0, "label": "Adrenocortical Cancer" }, { "value": 3, "label": "Bladder Cancer" }, { "value": 4, "label": "Bone Cancer, Osteosarcoma / Malignant Fibrous Histiocytoma" }, { "value": 5, "label": "Bone Marrow Transplantation" }, { "value": 6, "label": "Brain Tumor" }, { "value": 7, "label": "Breast Cancer" }, { "value": 8, "label": "Heart Cancer" }, { "value": 9, "label": "Cervical Cancer" }, { "value": 10, "label": "Ear Cancer" }, { "value": 11, "label": "Endometrial Cancer" }, { "value": 12, "label": "Esophageal / Oesophageal Cancer" }, { "value": 13, "label": "Eye Cancer" }, { "value": 14, "label": "Gallbladder Cancer" }, { "value": 15, "label": "Gastrointestinal Tract" }, { "value": 17, "label": "Genital System, Female" }, { "value": 19, "label": "Genital System, Male" }, { "value": 21, "label": "Head and Neck Cancer" }, { "value": 23, "label": "Liver Cancer" }, { "value": 24, "label": "Hodgkin's Disease" }, { "value": 25, "label": "Kidney Cancer" }, { "value": 26, "label": "Laryngeal Cancer" }, { "value": 27, "label": "Leukemia / Leukaemia" }, { "value": 28, "label": "Lung Cancer" }, { "value": 29, "label": "Melanoma" }, { "value": 30, "label": "Myeloma" }, { "value": 31, "label": "Nasal Cavity and Paranasal Sinus Cancer" }, { "value": 32, "label": "Neuroblastoma" }, { "value": 33, "label": "Nervous System" }, { "value": 35, "label": "Non-Hodgkin's Lymphoma" }, { "value": 36, "label": "Oral Cavity and Lip Cancer" }, { "value": 37, "label": "Pancreatic Cancer" }, { "value": 38, "label": "Parathyroid Cancer" }, { "value": 39, "label": "Penile Cancer" }, { "value": 40, "label": "Pituitary Tumor" }, { "value": 42, "label": "Prostate Cancer" }, { "value": 43, "label": "Respiratory System" }, { "value": 45, "label": "Retinoblastoma" }, { "value": 46, "label": "Kaposi's Sarcoma" }, { "value": 47, "label": "Sarcoma, Rhabdomyosarcoma, Childhood" }, { "value": 48, "label": "Sarcoma, Soft Tissue" }, { "value": 49, "label": "Skin Cancer" }, { "value": 50, "label": "Small Intestine Cancer" }, { "value": 51, "label": "Stomach Cancer" }, { "value": 52, "label": "Testicular Cancer" }, { "value": 53, "label": "Thymoma, Malignant" }, { "value": 54, "label": "Thyroid Cancer" }, { "value": 55, "label": "Urinary System" }, { "value": 57, "label": "Vaginal Cancer" }, { "value": 58, "label": "Vascular System" }, { "value": 60, "label": "Wilms' Tumor" }, { "value": 61, "label": "Pharyngeal Cancer" }, { "value": 63, "label": "Salivary Gland Cancer" }, { "value": 64, "label": "Colon and Rectal Cancer" }, { "value": 66, "label": "Ovarian Cancer" }, { "value": 67, "label": "Blood Cancer" }, { "value": 68, "label": "Oesophageal / Esophageal Cancer" }, { "value": 69, "label": "Heart Cancer / Cardiotoxicity" }, { "value": 101, "label": "Vulva Cancer" }, { "value": 102, "label": "Primary of Unknown Origin" }, { "value": 103, "label": "Anal Cancer" }, { "value": 104, "label": "Primary CNS Lymphoma" }, { "value": 105, "label": "Sarcoma" }, { "value": 99, "label": "Uncoded" }];
        this.project_types = [{ "value": 1, "label": "Clinical Trial" }, { "value": 2, "label": "Research" }, { "value": 3, "label": "Training" }];
        this.cso_research_areas = [{ "value": 1, "code": "0", "label": "Uncoded", "category": "Uncoded" }, { "value": 2, "code": "1.1", "label": "Normal Functioning", "category": "Biology" }, { "value": 3, "code": "1.2", "label": "Cancer Initiation:  Alterations in Chromosomes", "category": "Biology" }, { "value": 4, "code": "1.3", "label": "Cancer Initiation:  Oncogenes and Tumor Suppressor Genes", "category": "Biology" }, { "value": 5, "code": "1.4", "label": "Cancer Progression and Metastasis", "category": "Biology" }, { "value": 6, "code": "1.5", "label": "Resources and Infrastructure Related to Biology", "category": "Biology" }, { "value": 7, "code": "1.6", "label": "Cancer Related Biology", "category": "Biology" }, { "value": 8, "code": "2.1", "label": "Exogenous Factors in the Origin and Cause of Cancer", "category": "Causes of Cancer/Etiology" }, { "value": 9, "code": "2.2", "label": "Endogenous Factors in the Origin and Cause of Cancer", "category": "Causes of Cancer/Etiology" }, { "value": 10, "code": "2.3", "label": "Interactions of Genes and/or Genetic Polymorphisms with Exogenous and/or Endogenous Factors", "category": "Causes of Cancer/Etiology" }, { "value": 11, "code": "2.4", "label": "Resources and Infrastructure Related to Etiology", "category": "Causes of Cancer/Etiology" }, { "value": 12, "code": "3.1", "label": "Interventions to Prevent Cancer: Personal Behaviors that Affect Cancer Risk", "category": "Prevention" }, { "value": 13, "code": "3.2", "label": "Nutritional Science in Cancer Prevention", "category": "Prevention" }, { "value": 14, "code": "3.3", "label": "Chemoprevention", "category": "Prevention" }, { "value": 15, "code": "3.4", "label": "Vaccines", "category": "Prevention" }, { "value": 16, "code": "3.5", "label": "Complementary and Alternative Prevention Approaches", "category": "Prevention" }, { "value": 17, "code": "3.6", "label": "Resources and Infrastructure Related to Prevention", "category": "Prevention" }, { "value": 18, "code": "4.1", "label": "Technology Development and/or Marker Discovery", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": 19, "code": "4.2", "label": "Technology and/or Marker Evaluation with Respect to Fundamental Parameters of Method", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": 20, "code": "4.3", "label": "Technology and/or Marker Testing in a Clinical Setting", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": 21, "code": "4.4", "label": "Resources and Infrastructure Related to Early Detection, Diagnosis or Prognosis", "category": "Early Detection, Diagnosis, and Prognosis" }, { "value": 22, "code": "5.1", "label": "Localized Therapies - Discovery and Development", "category": "Treatment" }, { "value": 23, "code": "5.2", "label": "Localized Therapies - Clinical Applications", "category": "Treatment" }, { "value": 24, "code": "5.3", "label": "Systemic Therapies - Discovery and Development", "category": "Treatment" }, { "value": 25, "code": "5.4", "label": "Systemic Therapies - Clinical Applications", "category": "Treatment" }, { "value": 26, "code": "5.5", "label": "Combinations of Localized and Systemic Therapies", "category": "Treatment" }, { "value": 27, "code": "5.6", "label": "Complementary and Alternative Treatment Approaches", "category": "Treatment" }, { "value": 28, "code": "5.7", "label": "Resources and Infrastructure Related to Treatment", "category": "Treatment" }, { "value": 29, "code": "6.1", "label": "Patient Care and Survivorship Issues", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 30, "code": "6.2", "label": "Surveillance", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 31, "code": "6.3", "label": "Behavior Related to Cancer Control", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 32, "code": "6.4", "label": "Cost Analyses and Health Care Delivery", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 33, "code": "6.5", "label": "Education and Communication", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 34, "code": "6.6", "label": "End-of-Life Care", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 35, "code": "6.7", "label": "Ethics and Confidentiality in Cancer Research", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 36, "code": "6.8", "label": "Complementary and Alternative Approaches for Supportive Care of Patients and Survivors", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 37, "code": "6.9", "label": "Resources and Infrastructure Related to Cancer Control, Survivorship, and Outcomes Research", "category": "Cancer Control, Survivorship and Outcomes Research" }, { "value": 38, "code": "7.1", "label": "Development and Characterization of Model Systems", "category": "Scientific Model Systems" }, { "value": 39, "code": "7.2", "label": " Application of Model Systems", "category": "Scientific Model Systems" }, { "value": 40, "code": "7.3", "label": "Resources and Infrastructure Related to Scientific Model Systems", "category": "Scientific Model Systems" }];
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
        this.organizations = [{ "id": 82, "name": "National Breast Cancer Foundation", "country": "AU", "sponsor_code": "NBCF" }, { "id": 138, "name": "Cancer Australia", "country": "AU", "sponsor_code": "CancerAust" }, { "id": 78, "name": "Canadian Partnership Against Cancer", "country": "CA", "sponsor_code": "CCRA" }, { "id": 137, "name": "Breast Cancer Society of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 108, "name": "Brain Tumour Foundation of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 109, "name": "C17 Research Network", "country": "CA", "sponsor_code": "CCRA" }, { "id": 110, "name": "Canadian Association of Radiation Oncology", "country": "CA", "sponsor_code": "CCRA" }, { "id": 111, "name": "The Kidney Foundation of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 113, "name": "The Leukemia & Lymphoma Society of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 114, "name": "Research Manitoba", "country": "CA", "sponsor_code": "CCRA" }, { "id": 115, "name": "New Brunswick Health Research Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "id": 116, "name": "Newfoundland and Labrador Centre for Applied Health Research", "country": "CA", "sponsor_code": "CCRA" }, { "id": 117, "name": "Natural Sciences and Engineering Research Council", "country": "CA", "sponsor_code": "CCRA" }, { "id": 118, "name": "Nova Scotia Health Research Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "id": 119, "name": "Ovarian Cancer Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 120, "name": "Pancreatic Cancer Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 121, "name": "Pediatric Oncology Group of Ontario", "country": "CA", "sponsor_code": "CCRA" }, { "id": 122, "name": "PROCURE", "country": "CA", "sponsor_code": "CCRA" }, { "id": 123, "name": "Saskatchewan Health Research Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "id": 22, "name": "Alberta Cancer Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "id": 23, "name": "Alberta Innovates - Health Solutions", "country": "CA", "sponsor_code": "CCRA" }, { "id": 25, "name": "Canadian Breast Cancer Foundation", "country": "CA", "sponsor_code": "CCRA" }, { "id": 26, "name": "Canadian Breast Cancer Research Alliance", "country": "CA", "sponsor_code": "CCRA" }, { "id": 27, "name": "Canadian Institutes of Health Research", "country": "CA", "sponsor_code": "CCRA" }, { "id": 28, "name": "Canadian Prostate Cancer Research Initiative", "country": "CA", "sponsor_code": "CCRA" }, { "id": 29, "name": "Canadian Tobacco Control Research Initiative", "country": "CA", "sponsor_code": "CCRA" }, { "id": 30, "name": "CancerCare Manitoba", "country": "CA", "sponsor_code": "CCRA" }, { "id": 31, "name": "Cancer Care Nova Scotia", "country": "CA", "sponsor_code": "CCRA" }, { "id": 32, "name": "Cancer Care Ontario", "country": "CA", "sponsor_code": "CCRA" }, { "id": 33, "name": "Foundation du cancer du sein du Québec / Quebec Breast Cancer Foundation ", "country": "CA", "sponsor_code": "CCRA" }, { "id": 34, "name": "Fonds de la recherche du Québec – Santé", "country": "CA", "sponsor_code": "CCRA" }, { "id": 35, "name": "Michael Smith Foundation for Health Research", "country": "CA", "sponsor_code": "CCRA" }, { "id": 37, "name": "National Research Council of Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 38, "name": "Ontario Institute for Cancer Research", "country": "CA", "sponsor_code": "CCRA" }, { "id": 39, "name": "Saskatchewan Cancer Agency", "country": "CA", "sponsor_code": "CCRA" }, { "id": 40, "name": "Cancer Research Society", "country": "CA", "sponsor_code": "CCRA" }, { "id": 41, "name": "Canadian Cancer Society", "country": "CA", "sponsor_code": "CCRA" }, { "id": 42, "name": "The Terry Fox Research Institute", "country": "CA", "sponsor_code": "CCRA" }, { "id": 43, "name": "Genome Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 44, "name": "Prostate Cancer Canada", "country": "CA", "sponsor_code": "CCRA" }, { "id": 70, "name": "Institut National du Cancer", "country": "FR", "sponsor_code": "INCa" }, { "id": 71, "name": "DGOS-Ministère de la Santé", "country": "FR", "sponsor_code": "INCa" }, { "id": 76, "name": "Prostate Cancer UK", "country": "GB", "sponsor_code": "NCRI" }, { "id": 55, "name": "Children with CANCER UK", "country": "GB", "sponsor_code": "NCRI" }, { "id": 3, "name": "Cancer Research UK", "country": "GB", "sponsor_code": "NCRI" }, { "id": 5, "name": "Northern Ireland Health & Social Care - R & D Office", "country": "GB", "sponsor_code": "NCRI" }, { "id": 6, "name": "Scottish Government Health Directorates - Chief Scientist Office", "country": "GB", "sponsor_code": "NCRI" }, { "id": 7, "name": "Welsh Assembly Government - Office of R & D", "country": "GB", "sponsor_code": "NCRI" }, { "id": 8, "name": "Association for International Cancer Research", "country": "GB", "sponsor_code": "NCRI" }, { "id": 9, "name": "Tenovus", "country": "GB", "sponsor_code": "NCRI" }, { "id": 10, "name": "Biotechnology & Biological Sciences Research Council", "country": "GB", "sponsor_code": "NCRI" }, { "id": 11, "name": "Medical Research Council", "country": "GB", "sponsor_code": "NCRI" }, { "id": 12, "name": "Department of Health", "country": "GB", "sponsor_code": "NCRI" }, { "id": 13, "name": "Marie Curie Cancer Care", "country": "GB", "sponsor_code": "NCRI" }, { "id": 14, "name": "Macmillan Cancer Support", "country": "GB", "sponsor_code": "NCRI" }, { "id": 15, "name": "Yorkshire Cancer Research", "country": "GB", "sponsor_code": "NCRI" }, { "id": 16, "name": "Breakthrough Breast Cancer", "country": "GB", "sponsor_code": "NCRI" }, { "id": 17, "name": "Leukaemia and Lymphoma Research", "country": "GB", "sponsor_code": "NCRI" }, { "id": 18, "name": "Breast Cancer Campaign", "country": "GB", "sponsor_code": "NCRI" }, { "id": 19, "name": "Roy Castle Lung Cancer Foundation", "country": "GB", "sponsor_code": "NCRI" }, { "id": 20, "name": "Wellcome Trust", "country": "GB", "sponsor_code": "NCRI" }, { "id": 21, "name": "Economic and Social Research Council", "country": "GB", "sponsor_code": "NCRI" }, { "id": 107, "name": "National Cancer Center, Japan", "country": "JP", "sponsor_code": "NCC" }, { "id": 56, "name": "KWF Kankerbestrijding / Dutch Cancer Society", "country": "NL", "sponsor_code": "KWF" }, { "id": 57, "name": "Avon Foundation for Women", "country": "US", "sponsor_code": "AVONFDN" }, { "id": 58, "name": "Pancreatic Cancer Action Network", "country": "US", "sponsor_code": "PanCAN" }, { "id": 1, "name": "National Cancer Institute", "country": "US", "sponsor_code": "NIH" }, { "id": 2, "name": "U. S. Department of Defense, CDMRP", "country": "US", "sponsor_code": "CDMRP" }, { "id": 79, "name": "American Institute for Cancer Research", "country": "US", "sponsor_code": "AICR (USA)" }, { "id": 81, "name": "National Pancreas Foundation", "country": "US", "sponsor_code": "NPF" }, { "id": 51, "name": "California Breast Cancer Research Program", "country": "US", "sponsor_code": "CBCRP" }, { "id": 52, "name": "Susan G. Komen for the Cure", "country": "US", "sponsor_code": "KOMEN" }, { "id": 53, "name": "Oncology Nursing Society Foundation", "country": "US", "sponsor_code": "ONS" }, { "id": 54, "name": "American Cancer Society", "country": "US", "sponsor_code": "ACS" }, { "id": 125, "name": "National Center for Advancing Translational Sciences", "country": "US", "sponsor_code": "NIH" }, { "id": 126, "name": "Coalition Against Childhood Cancer", "country": "US", "sponsor_code": "CAC2" }, { "id": 127, "name": "Alex's Lemonade Stand Foundation", "country": "US", "sponsor_code": "CAC2" }, { "id": 128, "name": "Bradens' Hope For Childhood Cancer", "country": "US", "sponsor_code": "CAC2" }, { "id": 129, "name": "Luck2Tuck", "country": "US", "sponsor_code": "CAC2" }, { "id": 130, "name": "Steven G Aya foundation", "country": "US", "sponsor_code": "CAC2" }, { "id": 131, "name": "Team Connor", "country": "US", "sponsor_code": "CAC2" }, { "id": 132, "name": "TayBandz", "country": "US", "sponsor_code": "CAC2" }, { "id": 133, "name": "CSCN Alliance", "country": "US", "sponsor_code": "CAC2" }, { "id": 134, "name": "Sammy's Superheroes", "country": "US", "sponsor_code": "CAC2" }, { "id": 135, "name": "The Pediatric Brain Tumor Foundation", "country": "US", "sponsor_code": "CAC2" }, { "id": 136, "name": "Noah's Light", "country": "US", "sponsor_code": "CAC2" }, { "id": 83, "name": "National Institute on Alcohol Abuse and Alcoholism", "country": "US", "sponsor_code": "NIH" }, { "id": 84, "name": "National Institute on Aging", "country": "US", "sponsor_code": "NIH" }, { "id": 85, "name": "National Institute of Allergy and Infectious Diseases", "country": "US", "sponsor_code": "NIH" }, { "id": 86, "name": "National Institute of Arthritis and Musculoskeletal and Skin Diseases", "country": "US", "sponsor_code": "NIH" }, { "id": 87, "name": "National Center for Complementary and Alternative Medicine", "country": "US", "sponsor_code": "NIH" }, { "id": 88, "name": "National Institute on Drug Abuse", "country": "US", "sponsor_code": "NIH" }, { "id": 89, "name": "National Institute on Deafness and Other Communication Disorders", "country": "US", "sponsor_code": "NIH" }, { "id": 90, "name": "National Institute of Dental and Craniofacial Research", "country": "US", "sponsor_code": "NIH" }, { "id": 91, "name": "National Institute of Diabetes and Digestive and Kidney Diseases", "country": "US", "sponsor_code": "NIH" }, { "id": 92, "name": "National Institute of Biomedical Imaging and Bioengineering", "country": "US", "sponsor_code": "NIH" }, { "id": 93, "name": "National Institute of Environmental Health Sciences", "country": "US", "sponsor_code": "NIH" }, { "id": 94, "name": "National Eye Institute", "country": "US", "sponsor_code": "NIH" }, { "id": 95, "name": "National Institute of General Medical Sciences", "country": "US", "sponsor_code": "NIH" }, { "id": 96, "name": "Eunice Kennedy Shriver National Institute of Child Health and Human Development", "country": "US", "sponsor_code": "NIH" }, { "id": 97, "name": "National Human Genome Research Institute", "country": "US", "sponsor_code": "NIH" }, { "id": 98, "name": "National Heart, Lung and Blood Institute", "country": "US", "sponsor_code": "NIH" }, { "id": 99, "name": "National Library of Medicine", "country": "US", "sponsor_code": "NIH" }, { "id": 100, "name": "National Institute on Minority Health and Health Disparities", "country": "US", "sponsor_code": "NIH" }, { "id": 101, "name": "National Institute of Mental Health", "country": "US", "sponsor_code": "NIH" }, { "id": 102, "name": "National Institute of Nursing Research", "country": "US", "sponsor_code": "NIH" }, { "id": 103, "name": "National Institute of Neurological Disorders and Stroke", "country": "US", "sponsor_code": "NIH" }, { "id": 104, "name": "Office of the Director", "country": "US", "sponsor_code": "NIH" }, { "id": 105, "name": "National Center for Research Resources", "country": "US", "sponsor_code": "NIH" }, { "id": 106, "name": "Fogarty International Center", "country": "US", "sponsor_code": "NIH" }];
        this.currencies = [{ "value": 1, "abbreviation": "USD", "label": "United States Dollars" }, { "value": 2, "abbreviation": "GBP", "label": "United Kingdom Pounds" }, { "value": 3, "abbreviation": "CAD", "label": "Canada Dollars" }, { "value": 4, "abbreviation": "EUR", "label": "Euro" }, { "value": 5, "abbreviation": "AUD", "label": "Australia Dollars" }, { "value": 6, "abbreviation": "JPY", "label": "Japan Yen " }, { "value": 7, "abbreviation": "INR", "label": "India Rupees" }, { "value": 8, "abbreviation": "NZD", "label": "New Zealand Dollars" }, { "value": 9, "abbreviation": "CHF", "label": "Switzerland Francs" }, { "value": 10, "abbreviation": "ZAR", "label": "South Africa Rand" }, { "value": 11, "abbreviation": "AFN", "label": "Afghanistan Afghanis" }, { "value": 12, "abbreviation": "ALL", "label": "Albania Leke" }, { "value": 13, "abbreviation": "DZD", "label": "Algeria Dinars" }, { "value": 14, "abbreviation": "ARS", "label": "Argentina Pesos" }, { "value": 15, "abbreviation": "ATS", "label": "Austria Schillings*" }, { "value": 16, "abbreviation": "BSD", "label": "Bahamas Dollars" }, { "value": 17, "abbreviation": "BHD", "label": "Bahrain Dinars" }, { "value": 18, "abbreviation": "BDT", "label": "Bangladesh Taka" }, { "value": 19, "abbreviation": "BBD", "label": "Barbados Dollars" }, { "value": 20, "abbreviation": "BEF", "label": "Belgium Francs*" }, { "value": 21, "abbreviation": "BMD", "label": "Bermuda Dollars" }, { "value": 22, "abbreviation": "BRL", "label": "Brazil Reais" }, { "value": 23, "abbreviation": "BGN", "label": "Bulgaria Leva" }, { "value": 24, "abbreviation": "XOF", "label": "CFA BCEAO Francs" }, { "value": 25, "abbreviation": "XAF", "label": "CFA BEAC Francs" }, { "value": 26, "abbreviation": "CLP", "label": "Chile Pesos" }, { "value": 27, "abbreviation": "CNY", "label": "China Yuan Renminbi" }, { "value": 28, "abbreviation": "COP", "label": "Colombia Pesos" }, { "value": 29, "abbreviation": "XPF", "label": "CFP Francs" }, { "value": 30, "abbreviation": "CRC", "label": "Costa Rica Colones" }, { "value": 31, "abbreviation": "HRK", "label": "Croatia Kuna" }, { "value": 32, "abbreviation": "CYP", "label": "Cyprus Pounds*" }, { "value": 33, "abbreviation": "CZK", "label": "Czech Republic Koruny" }, { "value": 34, "abbreviation": "DKK", "label": "Denmark Kroner" }, { "value": 35, "abbreviation": "DEM", "label": "Deutsche (Germany) Marks*" }, { "value": 36, "abbreviation": "DOP", "label": "Dominican Republic Pesos" }, { "value": 37, "abbreviation": "NLG", "label": "Dutch (Netherlands) Guilders*" }, { "value": 38, "abbreviation": "XCD", "label": "Eastern Caribbean Dollars" }, { "value": 39, "abbreviation": "EGP", "label": "Egypt Pounds" }, { "value": 40, "abbreviation": "EEK", "label": "Estonia Krooni" }, { "value": 41, "abbreviation": "FJD", "label": "Fiji Dollars" }, { "value": 42, "abbreviation": "FIM", "label": "Finland Markkaa*" }, { "value": 43, "abbreviation": "FRF", "label": "France Francs*" }, { "value": 44, "abbreviation": "XAU", "label": "Gold Ounces" }, { "value": 45, "abbreviation": "GRD", "label": "Greece Drachmae*" }, { "value": 46, "abbreviation": "HKD", "label": "Hong Kong Dollars" }, { "value": 47, "abbreviation": "HUF", "label": "Hungary Forint" }, { "value": 48, "abbreviation": "ISK", "label": "Iceland Kronur" }, { "value": 49, "abbreviation": "XDR", "label": "IMF Special Drawing Right" }, { "value": 50, "abbreviation": "IDR", "label": "Indonesia Rupiahs" }, { "value": 51, "abbreviation": "IRR", "label": "Iran Rials" }, { "value": 52, "abbreviation": "IQD", "label": "Iraq Dinars" }, { "value": 53, "abbreviation": "IEP", "label": "Ireland Pounds*" }, { "value": 54, "abbreviation": "ILS", "label": "Israel New Shekels" }, { "value": 55, "abbreviation": "ITL", "label": "Italy Lire*" }, { "value": 56, "abbreviation": "JMD", "label": "Jamaica Dollars" }, { "value": 57, "abbreviation": "JOD", "label": "Jordan Dinars" }, { "value": 58, "abbreviation": "KES", "label": "Kenya Shillings" }, { "value": 59, "abbreviation": "KRW", "label": "Korea (South) Won" }, { "value": 60, "abbreviation": "KWD", "label": "Kuwait Dinars" }, { "value": 61, "abbreviation": "LBP", "label": "Lebanon Pounds" }, { "value": 62, "abbreviation": "LUF", "label": "Luxembourg Francs*" }, { "value": 63, "abbreviation": "MYR", "label": "Malaysia Ringgits" }, { "value": 64, "abbreviation": "MTL", "label": "Malta Liri*" }, { "value": 65, "abbreviation": "MUR", "label": "Mauritius Rupees" }, { "value": 66, "abbreviation": "MXN", "label": "Mexico Pesos" }, { "value": 67, "abbreviation": "MAD", "label": "Morocco Dirhams" }, { "value": 68, "abbreviation": "NOK", "label": "Norway Kroner" }, { "value": 69, "abbreviation": "OMR", "label": "Oman Rials" }, { "value": 70, "abbreviation": "PKR", "label": "Pakistan Rupees" }, { "value": 71, "abbreviation": "XPD", "label": "Palladium Ounces" }, { "value": 72, "abbreviation": "PEN", "label": "Peru Nuevos Soles" }, { "value": 73, "abbreviation": "PHP", "label": "Philippines Pesos" }, { "value": 74, "abbreviation": "XPT", "label": "Platinum Ounces" }, { "value": 75, "abbreviation": "PLN", "label": "Poland Zlotych" }, { "value": 76, "abbreviation": "PTE", "label": "Portugal Escudos*" }, { "value": 77, "abbreviation": "QAR", "label": "Qatar Riyals" }, { "value": 78, "abbreviation": "RON", "label": "Romania New Lei" }, { "value": 79, "abbreviation": "ROL", "label": "Romania Lei*" }, { "value": 80, "abbreviation": "RUB", "label": "Russia Rubles" }, { "value": 81, "abbreviation": "SAR", "label": "Saudi Arabia Riyals" }, { "value": 82, "abbreviation": "XAG", "label": "Silver Ounces" }, { "value": 83, "abbreviation": "SGD", "label": "Singapore Dollars" }, { "value": 84, "abbreviation": "SKK", "label": "Slovakia Koruny*" }, { "value": 85, "abbreviation": "SIT", "label": "Slovenia Tolars*" }, { "value": 86, "abbreviation": "ESP", "label": "Spain Pesetas*" }, { "value": 87, "abbreviation": "LKR", "label": "Sri Lanka Rupees" }, { "value": 88, "abbreviation": "SDG", "label": "Sudan Pounds" }, { "value": 89, "abbreviation": "SEK", "label": "Sweden Kronor" }, { "value": 90, "abbreviation": "TWD", "label": "Taiwan New Dollars" }, { "value": 91, "abbreviation": "THB", "label": "Thailand Baht" }, { "value": 92, "abbreviation": "TTD", "label": "Trinidad and Tobago Dollars" }, { "value": 93, "abbreviation": "TND", "label": "Tunisia Dinars" }, { "value": 94, "abbreviation": "TRY", "label": "Turkey Lira" }, { "value": 95, "abbreviation": "AED", "label": "United Arab Emirates Dirhams" }, { "value": 96, "abbreviation": "VEB", "label": "Venezuela Bolivares*" }, { "value": 97, "abbreviation": "VEF", "label": "Venezuela Bolivares Fuertes" }, { "value": 98, "abbreviation": "VND", "label": "Vietnam Dong" }, { "value": 99, "abbreviation": "ZMK", "label": "Zambia Kwacha" }];
        this.countries = [{ "value": 11, "label": "American Samoa" }, { "value": 10, "label": "Argentina" }, { "value": 13, "label": "Australia" }, { "value": 12, "label": "Austria" }, { "value": 20, "label": "Belgium" }, { "value": 31, "label": "Brazil" }, { "value": 38, "label": "Canada" }, { "value": 46, "label": "Chile" }, { "value": 48, "label": "China" }, { "value": 50, "label": "Costa Rica" }, { "value": 56, "label": "Czech Republic" }, { "value": 59, "label": "Denmark" }, { "value": 65, "label": "Egypt" }, { "value": 64, "label": "Estonia" }, { "value": 70, "label": "Finland" }, { "value": 75, "label": "France" }, { "value": 76, "label": "Gabon" }, { "value": 85, "label": "Gambia" }, { "value": 57, "label": "Germany" }, { "value": 89, "label": "Greece" }, { "value": 91, "label": "Guatemala" }, { "value": 95, "label": "Hong Kong" }, { "value": 100, "label": "Hungary" }, { "value": 109, "label": "Iceland" }, { "value": 105, "label": "India" }, { "value": 102, "label": "Ireland" }, { "value": 103, "label": "Israel" }, { "value": 110, "label": "Italy" }, { "value": 112, "label": "Jamaica" }, { "value": 114, "label": "Japan" }, { "value": 122, "label": "Korea, Republic of" }, { "value": 156, "label": "Malawi" }, { "value": 157, "label": "Mexico" }, { "value": 166, "label": "Netherlands" }, { "value": 171, "label": "New Zealand" }, { "value": 164, "label": "Nigeria" }, { "value": 174, "label": "Peru" }, { "value": 179, "label": "Poland" }, { "value": 184, "label": "Portugal" }, { "value": 182, "label": "Puerto Rico" }, { "value": 191, "label": "Russian Federation" }, { "value": 205, "label": "Senegal" }, { "value": 198, "label": "Singapore" }, { "value": 247, "label": "South Africa" }, { "value": 68, "label": "Spain" }, { "value": 213, "label": "Swaziland" }, { "value": 197, "label": "Sweden" }, { "value": 43, "label": "Switzerland" }, { "value": 228, "label": "Taiwan, Province Of China" }, { "value": 218, "label": "Thailand" }, { "value": 225, "label": "Turkey" }, { "value": 231, "label": "Uganda" }, { "value": 77, "label": "United Kingdom" }, { "value": 233, "label": "United States" }];
        this.states = [{ "value": 1, "label": "Alberta", "country": 38 }, { "value": 2, "label": "Alaska", "country": 233 }, { "value": 3, "label": "Alabama", "country": 233 }, { "value": 4, "label": "Arkansas", "country": 233 }, { "value": 6, "label": "Arizona", "country": 233 }, { "value": 7, "label": "British Columbia", "country": 38 }, { "value": 7, "label": "British Columbia", "country": 233 }, { "value": 8, "label": "California", "country": 233 }, { "value": 9, "label": "Colorado", "country": 233 }, { "value": 10, "label": "Connecticut", "country": 233 }, { "value": 11, "label": "District Of Columbia", "country": 233 }, { "value": 12, "label": "Delaware", "country": 233 }, { "value": 13, "label": "Florida", "country": 233 }, { "value": 14, "label": "Georgia", "country": 233 }, { "value": 15, "label": "Guam", "country": 233 }, { "value": 16, "label": "Hawaii", "country": 233 }, { "value": 17, "label": "Iowa", "country": 233 }, { "value": 18, "label": "Idaho", "country": 233 }, { "value": 19, "label": "Illinois", "country": 77 }, { "value": 19, "label": "Illinois", "country": 233 }, { "value": 20, "label": "Indiana", "country": 233 }, { "value": 21, "label": "Jalisco", "country": 157 }, { "value": 22, "label": "Karnataka ", "country": 105 }, { "value": 23, "label": "Kansas", "country": 233 }, { "value": 24, "label": "Kentucky", "country": 233 }, { "value": 25, "label": "Louisiana", "country": 233 }, { "value": 26, "label": "Massachusetts", "country": 77 }, { "value": 26, "label": "Massachusetts", "country": 233 }, { "value": 27, "label": "Manitoba", "country": 38 }, { "value": 28, "label": "Maryland", "country": 48 }, { "value": 28, "label": "Maryland", "country": 110 }, { "value": 28, "label": "Maryland", "country": 112 }, { "value": 28, "label": "Maryland", "country": 233 }, { "value": 29, "label": "Maine", "country": 233 }, { "value": 30, "label": "Michigan", "country": 233 }, { "value": 31, "label": "Minnesota", "country": 59 }, { "value": 31, "label": "Minnesota", "country": 233 }, { "value": 32, "label": "Missouri", "country": 233 }, { "value": 33, "label": "Mississippi", "country": 233 }, { "value": 34, "label": "Montana", "country": 233 }, { "value": 35, "label": "New Brunswick", "country": 38 }, { "value": 36, "label": "North Carolina", "country": 233 }, { "value": 37, "label": "North Dakota", "country": 233 }, { "value": 38, "label": "Nebraska", "country": 103 }, { "value": 38, "label": "Nebraska", "country": 233 }, { "value": 39, "label": "New Hampshire", "country": 233 }, { "value": 40, "label": "New Jersey", "country": 233 }, { "value": 41, "label": "Newfoundland and Labrador", "country": 38 }, { "value": 42, "label": "New Mexico", "country": 233 }, { "value": 43, "label": "Nova Scotia", "country": 38 }, { "value": 44, "label": "New South Wales", "country": 13 }, { "value": 46, "label": "Nevada", "country": 233 }, { "value": 47, "label": "New York", "country": 233 }, { "value": 48, "label": "Ohio", "country": 233 }, { "value": 49, "label": "Oklahoma", "country": 233 }, { "value": 50, "label": "Ontario", "country": 38 }, { "value": 50, "label": "Ontario", "country": 233 }, { "value": 51, "label": "Oregon", "country": 233 }, { "value": 52, "label": "Pennsylvania", "country": 233 }, { "value": 53, "label": "Prince Edward Island", "country": 38 }, { "value": 54, "label": "Quebec", "country": 38 }, { "value": 54, "label": "Quebec", "country": 233 }, { "value": 55, "label": "Puerto Rico", "country": 233 }, { "value": 56, "label": "Quebec", "country": 38 }, { "value": 56, "label": "Quebec", "country": 233 }, { "value": 57, "label": "Queensland", "country": 13 }, { "value": 58, "label": "Rhode Island", "country": 233 }, { "value": 59, "label": "South Australia", "country": 13 }, { "value": 60, "label": "South Carolina", "country": 233 }, { "value": 61, "label": "South Dakota", "country": 233 }, { "value": 62, "label": "Saskatchewan", "country": 38 }, { "value": 63, "label": "Sonora", "country": 157 }, { "value": 64, "label": "Tasmania", "country": 13 }, { "value": 65, "label": "Tennessee", "country": 233 }, { "value": 66, "label": "Texas", "country": 103 }, { "value": 66, "label": "Texas", "country": 233 }, { "value": 67, "label": "Utah", "country": 233 }, { "value": 68, "label": "Virginia", "country": 233 }, { "value": 70, "label": "Victoria", "country": 13 }, { "value": 71, "label": "Vermont", "country": 233 }, { "value": 72, "label": "Washington", "country": 13 }, { "value": 72, "label": "Washington", "country": 233 }, { "value": 73, "label": "Wisconsin", "country": 233 }, { "value": 74, "label": "West Virginia", "country": 233 }, { "value": 75, "label": "Wyoming", "country": 233 }];
        this.locations = [{ "value": 87, "label": "Abbotsford", "state": 7, "country": 38 }, { "value": 90, "label": "Abilene", "state": 66, "country": 233 }, { "value": 93, "label": "Acton", "state": 26, "country": 233 }, { "value": 95, "label": "Adelaide", "state": 44, "country": 13 }, { "value": 96, "label": "Adelaide", "state": 59, "country": 13 }, { "value": 97, "label": "Agoura Hills", "state": 8, "country": 233 }, { "value": 98, "label": "Akron", "state": 48, "country": 233 }, { "value": 99, "label": "Alabaster", "state": 3, "country": 233 }, { "value": 100, "label": "Alachua", "state": 13, "country": 233 }, { "value": 101, "label": "Alameda", "state": 8, "country": 233 }, { "value": 102, "label": "Albany", "state": 8, "country": 233 }, { "value": 103, "label": "Albany", "state": 14, "country": 233 }, { "value": 104, "label": "Albany", "state": 47, "country": 233 }, { "value": 105, "label": "Albuquerque", "state": 42, "country": 233 }, { "value": 106, "label": "Alexandria", "state": 68, "country": 233 }, { "value": 107, "label": "Alhambra", "state": 8, "country": 233 }, { "value": 108, "label": "Altanta", "state": 14, "country": 233 }, { "value": 109, "label": "Amarillo", "state": 66, "country": 233 }, { "value": 110, "label": "Ames", "state": 17, "country": 233 }, { "value": 111, "label": "Ames", "state": 19, "country": 233 }, { "value": 112, "label": "Amherst", "state": 26, "country": 233 }, { "value": 113, "label": "Amherst", "state": 47, "country": 233 }, { "value": 114, "label": "Amhert", "state": 26, "country": 233 }, { "value": 118, "label": "Anchorage", "state": 2, "country": 233 }, { "value": 119, "label": "Andover", "state": 26, "country": 233 }, { "value": 121, "label": "Angleton", "state": 66, "country": 233 }, { "value": 122, "label": "Ann Arbor", "state": 19, "country": 233 }, { "value": 123, "label": "Ann Arbor", "state": 30, "country": 233 }, { "value": 124, "label": "Ann Arbor", "state": 66, "country": 233 }, { "value": 125, "label": "Annandale", "state": 40, "country": 233 }, { "value": 126, "label": "Annapolis", "state": 28, "country": 233 }, { "value": 127, "label": "Antigonish", "state": 43, "country": 38 }, { "value": 128, "label": "Apex", "state": 36, "country": 233 }, { "value": 129, "label": "Arcadia", "state": 8, "country": 233 }, { "value": 130, "label": "Arcata", "state": 8, "country": 233 }, { "value": 131, "label": "Arlington", "state": 66, "country": 233 }, { "value": 132, "label": "Arlington", "state": 68, "country": 233 }, { "value": 133, "label": "ARLINGTON HEIGHTS", "state": 19, "country": 233 }, { "value": 134, "label": "Arvada", "state": 9, "country": 233 }, { "value": 135, "label": "Ashburn", "state": 68, "country": 233 }, { "value": 136, "label": "Asheville", "state": 36, "country": 233 }, { "value": 137, "label": "Ashland", "state": 26, "country": 233 }, { "value": 138, "label": "Aston", "state": 52, "country": 233 }, { "value": 139, "label": "Athabasca", "state": 1, "country": 38 }, { "value": 141, "label": "Athens", "state": 14, "country": 233 }, { "value": 142, "label": "Athens", "state": 48, "country": 233 }, { "value": 143, "label": "Atherton", "state": 8, "country": 233 }, { "value": 144, "label": "Atlanta", "state": 14, "country": 233 }, { "value": 146, "label": "Attleboro", "state": 26, "country": 233 }, { "value": 147, "label": "Auburn", "state": 3, "country": 233 }, { "value": 148, "label": "Auburn", "state": 72, "country": 233 }, { "value": 149, "label": "Auburn University", "state": 3, "country": 233 }, { "value": 150, "label": "Auburndale", "state": 26, "country": 233 }, { "value": 151, "label": "Auchenflower", "state": 57, "country": 13 }, { "value": 153, "label": "Augusta", "state": 14, "country": 233 }, { "value": 154, "label": "Aurora", "state": 9, "country": 233 }, { "value": 155, "label": "Austin", "state": 31, "country": 233 }, { "value": 156, "label": "Austin", "state": 47, "country": 233 }, { "value": 157, "label": "Austin", "state": 66, "country": 233 }, { "value": 158, "label": "Aventura", "state": 13, "country": 233 }, { "value": 161, "label": "Avon Lake", "state": 48, "country": 233 }, { "value": 162, "label": "Ayer", "state": 26, "country": 233 }, { "value": 164, "label": "Azusa", "state": 8, "country": 233 }, { "value": 166, "label": "Bainbridge Island", "state": 72, "country": 233 }, { "value": 167, "label": "Bala Cynwyd", "state": 52, "country": 233 }, { "value": 169, "label": "Baltimore", "state": 28, "country": 233 }, { "value": 171, "label": "Bangalore", "state": 22, "country": 105 }, { "value": 174, "label": "Bangor", "state": 29, "country": 233 }, { "value": 176, "label": "Bar Harbor", "state": 29, "country": 233 }, { "value": 178, "label": "Barrie", "state": 50, "country": 38 }, { "value": 179, "label": "Bartlesville", "state": 49, "country": 233 }, { "value": 182, "label": "Basking Ridge", "state": 40, "country": 233 }, { "value": 183, "label": "Bastrop", "state": 66, "country": 233 }, { "value": 185, "label": "Baton Rouge", "state": 25, "country": 233 }, { "value": 187, "label": "Bayamon", "state": 55, "country": 233 }, { "value": 188, "label": "Beachwood", "state": 48, "country": 233 }, { "value": 189, "label": "Bedford", "state": 26, "country": 233 }, { "value": 190, "label": "Bedford Park", "state": 59, "country": 13 }, { "value": 193, "label": "Beijing", "state": 28, "country": 48 }, { "value": 196, "label": "Bellaire", "state": 66, "country": 233 }, { "value": 197, "label": "Bellefonte", "state": 52, "country": 233 }, { "value": 198, "label": "Belleville", "state": 40, "country": 233 }, { "value": 199, "label": "Bellevue", "state": 72, "country": 233 }, { "value": 200, "label": "Bellingham", "state": 72, "country": 233 }, { "value": 201, "label": "Belmont", "state": 26, "country": 233 }, { "value": 204, "label": "Beltsville", "state": 28, "country": 233 }, { "value": 205, "label": "Belvedere", "state": 8, "country": 233 }, { "value": 206, "label": "Bennington", "state": 71, "country": 233 }, { "value": 208, "label": "Bentley", "state": 72, "country": 13 }, { "value": 210, "label": "Berkeley", "state": 8, "country": 233 }, { "value": 211, "label": "Berkley", "state": 8, "country": 233 }, { "value": 217, "label": "Berwyn", "state": 52, "country": 233 }, { "value": 219, "label": "Bethesda", "state": 28, "country": 233 }, { "value": 221, "label": "Bethesda", "state": 47, "country": 233 }, { "value": 222, "label": "Bethlehem", "state": 52, "country": 233 }, { "value": 223, "label": "Beverly", "state": 26, "country": 233 }, { "value": 224, "label": "Big Rapids", "state": 30, "country": 233 }, { "value": 225, "label": "Billerica", "state": 26, "country": 233 }, { "value": 226, "label": "Billings", "state": 34, "country": 233 }, { "value": 228, "label": "Binghamton", "state": 47, "country": 233 }, { "value": 229, "label": "Birminagham", "state": 3, "country": 233 }, { "value": 231, "label": "Birmingham", "state": 3, "country": 233 }, { "value": 232, "label": "Birmingham", "state": 30, "country": 233 }, { "value": 233, "label": "Blacksburg", "state": 68, "country": 233 }, { "value": 237, "label": "Bloomfield Hills", "state": 30, "country": 233 }, { "value": 238, "label": "Bloomington", "state": 20, "country": 233 }, { "value": 239, "label": "Bloomington", "state": 31, "country": 233 }, { "value": 240, "label": "Blue Bell", "state": 52, "country": 233 }, { "value": 241, "label": "Bluffton", "state": 60, "country": 233 }, { "value": 243, "label": "Boca Raton", "state": 13, "country": 233 }, { "value": 244, "label": "Bogart", "state": 14, "country": 233 }, { "value": 245, "label": "Boise", "state": 18, "country": 233 }, { "value": 249, "label": "Bonita Springs", "state": 13, "country": 233 }, { "value": 251, "label": "Bordentown", "state": 40, "country": 233 }, { "value": 253, "label": "Boston", "state": 26, "country": 233 }, { "value": 254, "label": "Boston", "state": 28, "country": 233 }, { "value": 255, "label": "Bothell", "state": 72, "country": 233 }, { "value": 256, "label": "Boucherville", "state": 56, "country": 38 }, { "value": 257, "label": "Boulder", "state": 9, "country": 233 }, { "value": 260, "label": "Bowdoin", "state": 29, "country": 233 }, { "value": 261, "label": "Bowie", "state": 28, "country": 233 }, { "value": 262, "label": "Bowling Green", "state": 48, "country": 233 }, { "value": 263, "label": "Boyertown", "state": 52, "country": 233 }, { "value": 264, "label": "Boys Town", "state": 38, "country": 233 }, { "value": 265, "label": "Bozeman", "state": 34, "country": 233 }, { "value": 267, "label": "Branchburg", "state": 40, "country": 233 }, { "value": 268, "label": "Brandon", "state": 27, "country": 38 }, { "value": 269, "label": "Brattleboro", "state": 71, "country": 233 }, { "value": 271, "label": "Briarcliff Manor", "state": 47, "country": 233 }, { "value": 272, "label": "Brick", "state": 40, "country": 233 }, { "value": 273, "label": "Bridgeport", "state": 10, "country": 233 }, { "value": 274, "label": "Bridgewater", "state": 26, "country": 233 }, { "value": 277, "label": "Brisbane", "state": 57, "country": 13 }, { "value": 279, "label": "Bristol", "state": 52, "country": 233 }, { "value": 282, "label": "Brockport", "state": 47, "country": 233 }, { "value": 283, "label": "Bronx", "state": 47, "country": 233 }, { "value": 284, "label": "Brookfield", "state": 10, "country": 233 }, { "value": 285, "label": "Brookings", "state": 61, "country": 233 }, { "value": 286, "label": "Brookline", "state": 26, "country": 233 }, { "value": 287, "label": "Brooklyn", "state": 47, "country": 233 }, { "value": 288, "label": "Broomall", "state": 52, "country": 233 }, { "value": 289, "label": "Brownsville", "state": 66, "country": 233 }, { "value": 291, "label": "Buda", "state": 66, "country": 233 }, { "value": 293, "label": "Buena", "state": 40, "country": 233 }, { "value": 296, "label": "Buffalo", "state": 47, "country": 233 }, { "value": 297, "label": "Buffalo Grove", "state": 19, "country": 233 }, { "value": 298, "label": "Bulffalo", "state": 47, "country": 233 }, { "value": 301, "label": "Burke", "state": 68, "country": 233 }, { "value": 302, "label": "Burlingame", "state": 8, "country": 233 }, { "value": 303, "label": "Burlington", "state": 26, "country": 233 }, { "value": 304, "label": "Burlington", "state": 50, "country": 38 }, { "value": 305, "label": "Burlington", "state": 71, "country": 233 }, { "value": 306, "label": "Burnaby", "state": 7, "country": 38 }, { "value": 307, "label": "Burnaby", "state": 7, "country": 233 }, { "value": 308, "label": "Burnsville", "state": 31, "country": 233 }, { "value": 309, "label": "Butte", "state": 34, "country": 233 }, { "value": 312, "label": "Calabasas", "state": 8, "country": 233 }, { "value": 314, "label": "Calgary", "state": 1, "country": 38 }, { "value": 315, "label": "Calverton", "state": 28, "country": 233 }, { "value": 317, "label": "Cambridge", "state": 26, "country": 77 }, { "value": 318, "label": "Cambridge", "state": 26, "country": 233 }, { "value": 319, "label": "Cambridge", "state": 50, "country": 38 }, { "value": 320, "label": "Camden", "state": 40, "country": 233 }, { "value": 321, "label": "Camp Springs", "state": 28, "country": 233 }, { "value": 323, "label": "Camperdown", "state": 44, "country": 13 }, { "value": 327, "label": "Candler", "state": 36, "country": 233 }, { "value": 331, "label": "Carbondale", "state": 19, "country": 233 }, { "value": 333, "label": "Cardiff", "state": 8, "country": 233 }, { "value": 334, "label": "Carlisle", "state": 52, "country": 233 }, { "value": 336, "label": "Carlsbad", "state": 8, "country": 233 }, { "value": 337, "label": "Carlsbad", "state": 52, "country": 233 }, { "value": 338, "label": "Carlton", "state": 70, "country": 13 }, { "value": 339, "label": "Carrboro", "state": 36, "country": 233 }, { "value": 340, "label": "Carrollton", "state": 14, "country": 233 }, { "value": 341, "label": "Carrollton", "state": 66, "country": 233 }, { "value": 342, "label": "Carson", "state": 8, "country": 233 }, { "value": 344, "label": "Cary", "state": 36, "country": 233 }, { "value": 345, "label": "Casselberry", "state": 13, "country": 233 }, { "value": 346, "label": "Catonsville", "state": 28, "country": 233 }, { "value": 347, "label": "Cedar Rapids", "state": 17, "country": 233 }, { "value": 349, "label": "Chalestown", "state": 26, "country": 233 }, { "value": 350, "label": "Champaign", "state": 19, "country": 233 }, { "value": 351, "label": "Chandler", "state": 6, "country": 233 }, { "value": 352, "label": "Chantilly", "state": 28, "country": 233 }, { "value": 353, "label": "Chantilly", "state": 68, "country": 233 }, { "value": 354, "label": "Chapel Hill", "state": 36, "country": 233 }, { "value": 355, "label": "Chappaqua", "state": 47, "country": 233 }, { "value": 356, "label": "Charlesbourg", "state": 56, "country": 38 }, { "value": 357, "label": "Charleston", "state": 19, "country": 233 }, { "value": 358, "label": "Charleston", "state": 60, "country": 233 }, { "value": 359, "label": "Charlestown", "state": 26, "country": 233 }, { "value": 360, "label": "Charlotte", "state": 36, "country": 233 }, { "value": 361, "label": "Charlottesville", "state": 68, "country": 233 }, { "value": 362, "label": "Charlottetown", "state": 53, "country": 38 }, { "value": 363, "label": "Charlottsville", "state": 68, "country": 233 }, { "value": 364, "label": "Chaska", "state": 31, "country": 233 }, { "value": 365, "label": "Chattanooga", "state": 65, "country": 233 }, { "value": 366, "label": "Chelmsford", "state": 26, "country": 233 }, { "value": 371, "label": "Chester", "state": 52, "country": 233 }, { "value": 372, "label": "Chestnut Hill", "state": 26, "country": 233 }, { "value": 375, "label": "Chicago", "state": 19, "country": 233 }, { "value": 376, "label": "Chicago", "state": 26, "country": 233 }, { "value": 377, "label": "Chicago", "state": 30, "country": 233 }, { "value": 380, "label": "Church Hill", "state": 28, "country": 233 }, { "value": 382, "label": "Cincinnati", "state": 48, "country": 233 }, { "value": 383, "label": "Claremont", "state": 8, "country": 233 }, { "value": 384, "label": "Clarksville", "state": 28, "country": 233 }, { "value": 386, "label": "Clayton", "state": 70, "country": 13 }, { "value": 387, "label": "Clearwater", "state": 13, "country": 233 }, { "value": 388, "label": "Clemson", "state": 60, "country": 233 }, { "value": 390, "label": "Cleveland", "state": 48, "country": 233 }, { "value": 392, "label": "Clifton Park", "state": 47, "country": 233 }, { "value": 393, "label": "Clinton", "state": 47, "country": 233 }, { "value": 394, "label": "Cockeysville", "state": 28, "country": 233 }, { "value": 395, "label": "Coeur D' Alene", "state": 18, "country": 233 }, { "value": 397, "label": "Colchester", "state": 71, "country": 233 }, { "value": 398, "label": "Cold Spring", "state": 47, "country": 233 }, { "value": 399, "label": "Cold Spring Harbor", "state": 11, "country": 233 }, { "value": 400, "label": "Cold Spring Harbor", "state": 47, "country": 233 }, { "value": 402, "label": "College Park", "state": 28, "country": 233 }, { "value": 403, "label": "College Station", "state": 66, "country": 233 }, { "value": 404, "label": "Collegeville", "state": 52, "country": 233 }, { "value": 405, "label": "Colorado Springs", "state": 9, "country": 233 }, { "value": 406, "label": "Columbia", "state": 28, "country": 233 }, { "value": 407, "label": "Columbia", "state": 32, "country": 233 }, { "value": 408, "label": "Columbia", "state": 60, "country": 233 }, { "value": 409, "label": "Columbia City", "state": 20, "country": 233 }, { "value": 410, "label": "Columbus", "state": 48, "country": 233 }, { "value": 411, "label": "Columbus", "state": 72, "country": 233 }, { "value": 412, "label": "Columubus", "state": 48, "country": 233 }, { "value": 415, "label": "Concord", "state": 8, "country": 233 }, { "value": 416, "label": "Concord", "state": 44, "country": 13 }, { "value": 417, "label": "Conway", "state": 4, "country": 233 }, { "value": 418, "label": "Cooperstown", "state": 47, "country": 233 }, { "value": 420, "label": "Copenhagen", "state": 31, "country": 59 }, { "value": 421, "label": "Coral Gables", "state": 13, "country": 233 }, { "value": 422, "label": "Coralville", "state": 17, "country": 233 }, { "value": 424, "label": "Cornelius", "state": 36, "country": 233 }, { "value": 425, "label": "Corvallis", "state": 51, "country": 233 }, { "value": 429, "label": "Covington", "state": 24, "country": 233 }, { "value": 430, "label": "Cranberry Township", "state": 52, "country": 233 }, { "value": 432, "label": "Cranston", "state": 58, "country": 233 }, { "value": 434, "label": "Crawley", "state": 72, "country": 13 }, { "value": 437, "label": "Crofton", "state": 28, "country": 233 }, { "value": 438, "label": "Crookston", "state": 31, "country": 233 }, { "value": 439, "label": "Croton-On-Hudson", "state": 47, "country": 233 }, { "value": 440, "label": "Crown Point", "state": 20, "country": 233 }, { "value": 441, "label": "Crozet", "state": 68, "country": 233 }, { "value": 442, "label": "Crystal Lake", "state": 19, "country": 233 }, { "value": 444, "label": "Culver City", "state": 8, "country": 233 }, { "value": 445, "label": "Cupertino", "state": 8, "country": 233 }, { "value": 447, "label": "Dallas", "state": 66, "country": 233 }, { "value": 448, "label": "Danbury", "state": 10, "country": 233 }, { "value": 449, "label": "Danvers", "state": 26, "country": 233 }, { "value": 450, "label": "Danville", "state": 52, "country": 233 }, { "value": 452, "label": "Darlinghurst", "state": 44, "country": 13 }, { "value": 453, "label": "Davidson", "state": 36, "country": 233 }, { "value": 454, "label": "Davis", "state": 8, "country": 233 }, { "value": 455, "label": "Dayton", "state": 48, "country": 233 }, { "value": 456, "label": "De Kalb", "state": 19, "country": 233 }, { "value": 457, "label": "Decatur", "state": 3, "country": 233 }, { "value": 458, "label": "Decatur", "state": 14, "country": 233 }, { "value": 459, "label": "Decatur", "state": 19, "country": 233 }, { "value": 460, "label": "Deerfield", "state": 19, "country": 233 }, { "value": 461, "label": "DeKalb", "state": 19, "country": 233 }, { "value": 462, "label": "Del Mar", "state": 8, "country": 233 }, { "value": 463, "label": "Denton", "state": 66, "country": 233 }, { "value": 464, "label": "Denver", "state": 9, "country": 233 }, { "value": 466, "label": "Derby", "state": 10, "country": 233 }, { "value": 467, "label": "Des Moines", "state": 17, "country": 233 }, { "value": 468, "label": "Detriot", "state": 30, "country": 233 }, { "value": 469, "label": "Detroit", "state": 30, "country": 233 }, { "value": 470, "label": "Dickinson", "state": 66, "country": 233 }, { "value": 473, "label": "Dixon", "state": 8, "country": 233 }, { "value": 475, "label": "Dorchester", "state": 26, "country": 233 }, { "value": 476, "label": "Dover", "state": 12, "country": 233 }, { "value": 477, "label": "Downers Grove", "state": 19, "country": 233 }, { "value": 478, "label": "Doylestown", "state": 52, "country": 233 }, { "value": 479, "label": "Duarte", "state": 8, "country": 233 }, { "value": 481, "label": "Dublin", "state": 8, "country": 233 }, { "value": 482, "label": "Dublin", "state": 48, "country": 233 }, { "value": 483, "label": "Duluth", "state": 31, "country": 233 }, { "value": 487, "label": "Durham", "state": 36, "country": 233 }, { "value": 488, "label": "Durham", "state": 39, "country": 233 }, { "value": 489, "label": "Durham (Rtp)", "state": 36, "country": 233 }, { "value": 490, "label": "Eagan", "state": 31, "country": 233 }, { "value": 491, "label": "East Amherst", "state": 47, "country": 233 }, { "value": 492, "label": "East Falmouth", "state": 26, "country": 233 }, { "value": 494, "label": "East Hartford", "state": 10, "country": 233 }, { "value": 495, "label": "East Lansing", "state": 30, "country": 233 }, { "value": 497, "label": "East Melbourne", "state": 70, "country": 13 }, { "value": 498, "label": "East Providence", "state": 58, "country": 233 }, { "value": 499, "label": "East Setauket", "state": 47, "country": 233 }, { "value": 500, "label": "East Syracuse", "state": 47, "country": 233 }, { "value": 501, "label": "Easton", "state": 52, "country": 233 }, { "value": 502, "label": "Eden", "state": 47, "country": 233 }, { "value": 503, "label": "Edinburg", "state": 66, "country": 233 }, { "value": 505, "label": "Edmond", "state": 49, "country": 233 }, { "value": 506, "label": "Edmonds", "state": 72, "country": 233 }, { "value": 508, "label": "Edmonton", "state": 1, "country": 38 }, { "value": 511, "label": "El Cajon", "state": 8, "country": 233 }, { "value": 512, "label": "El Paso", "state": 66, "country": 233 }, { "value": 513, "label": "El Segundo", "state": 8, "country": 233 }, { "value": 514, "label": "Elizabeth City", "state": 36, "country": 233 }, { "value": 515, "label": "Elizabethtown", "state": 52, "country": 233 }, { "value": 516, "label": "Elk Grove Village", "state": 19, "country": 233 }, { "value": 517, "label": "Elkridge", "state": 28, "country": 233 }, { "value": 518, "label": "Ellicott City", "state": 28, "country": 233 }, { "value": 519, "label": "Elm Grove", "state": 73, "country": 233 }, { "value": 520, "label": "Elmira", "state": 47, "country": 233 }, { "value": 521, "label": "Elmwood Park", "state": 40, "country": 233 }, { "value": 522, "label": "Emeryville", "state": 8, "country": 233 }, { "value": 523, "label": "Emporia", "state": 23, "country": 233 }, { "value": 524, "label": "Encinitas", "state": 8, "country": 233 }, { "value": 525, "label": "Encino", "state": 8, "country": 233 }, { "value": 526, "label": "Englewood", "state": 40, "country": 233 }, { "value": 529, "label": "Escondido", "state": 8, "country": 233 }, { "value": 531, "label": "Eugene", "state": 51, "country": 233 }, { "value": 533, "label": "Evanston", "state": 19, "country": 233 }, { "value": 534, "label": "Evansville", "state": 20, "country": 233 }, { "value": 535, "label": "Ewing", "state": 40, "country": 233 }, { "value": 537, "label": "Exton", "state": 52, "country": 233 }, { "value": 538, "label": "Fairfax", "state": 68, "country": 233 }, { "value": 539, "label": "Fairfield", "state": 8, "country": 233 }, { "value": 540, "label": "Fairfield", "state": 10, "country": 233 }, { "value": 541, "label": "Fall River", "state": 26, "country": 233 }, { "value": 542, "label": "Falls Church", "state": 68, "country": 233 }, { "value": 543, "label": "Fargo", "state": 37, "country": 233 }, { "value": 544, "label": "Farmington", "state": 10, "country": 233 }, { "value": 545, "label": "Farmington Hills", "state": 30, "country": 233 }, { "value": 546, "label": "Fayetteville", "state": 4, "country": 233 }, { "value": 547, "label": "Fayetteville", "state": 36, "country": 233 }, { "value": 548, "label": "Ferndale", "state": 30, "country": 233 }, { "value": 552, "label": "Fitzroy", "state": 70, "country": 13 }, { "value": 553, "label": "Flagstaff", "state": 6, "country": 233 }, { "value": 554, "label": "Flint", "state": 30, "country": 233 }, { "value": 555, "label": "Flushing", "state": 47, "country": 233 }, { "value": 556, "label": "Folsom", "state": 8, "country": 233 }, { "value": 558, "label": "Fort Collins", "state": 9, "country": 233 }, { "value": 559, "label": "Fort Pierce", "state": 13, "country": 233 }, { "value": 560, "label": "Fort Worth", "state": 66, "country": 233 }, { "value": 561, "label": "Fountain Valley", "state": 8, "country": 233 }, { "value": 562, "label": "Framingham", "state": 26, "country": 233 }, { "value": 563, "label": "Franklin", "state": 26, "country": 233 }, { "value": 564, "label": "Franklin", "state": 65, "country": 233 }, { "value": 566, "label": "Frederick", "state": 28, "country": 233 }, { "value": 567, "label": "Fredericton", "state": 35, "country": 38 }, { "value": 568, "label": "Fremont", "state": 8, "country": 233 }, { "value": 569, "label": "Fresno", "state": 8, "country": 233 }, { "value": 570, "label": "Ft. Detrick", "state": 28, "country": 233 }, { "value": 572, "label": "Fullerton", "state": 8, "country": 233 }, { "value": 573, "label": "Gainesville", "state": 13, "country": 233 }, { "value": 574, "label": "Gainsville", "state": 13, "country": 233 }, { "value": 575, "label": "Gaithersburg", "state": 28, "country": 233 }, { "value": 576, "label": "Galveston", "state": 66, "country": 233 }, { "value": 578, "label": "Garden City", "state": 47, "country": 233 }, { "value": 579, "label": "Garden Grove", "state": 8, "country": 233 }, { "value": 581, "label": "Geneva", "state": 47, "country": 233 }, { "value": 583, "label": "Georgetown", "state": 11, "country": 233 }, { "value": 584, "label": "Germantown", "state": 28, "country": 233 }, { "value": 585, "label": "Germantown", "state": 47, "country": 233 }, { "value": 588, "label": "Gig Harbor", "state": 72, "country": 233 }, { "value": 591, "label": "Glassboro", "state": 40, "country": 233 }, { "value": 592, "label": "Glen Ellyn", "state": 19, "country": 233 }, { "value": 593, "label": "Glen Head", "state": 47, "country": 233 }, { "value": 594, "label": "Glenside", "state": 52, "country": 233 }, { "value": 595, "label": "Glenview", "state": 19, "country": 233 }, { "value": 598, "label": "Golden", "state": 9, "country": 233 }, { "value": 599, "label": "Goleta", "state": 8, "country": 233 }, { "value": 604, "label": "Grand Forks", "state": 37, "country": 233 }, { "value": 605, "label": "Grand Junction", "state": 9, "country": 233 }, { "value": 606, "label": "Grand Rapids", "state": 30, "country": 233 }, { "value": 607, "label": "Grass Valley", "state": 8, "country": 233 }, { "value": 608, "label": "Great Falls", "state": 68, "country": 233 }, { "value": 609, "label": "Great Lakes", "state": 19, "country": 233 }, { "value": 610, "label": "Great Neck", "state": 47, "country": 233 }, { "value": 611, "label": "Greeley", "state": 9, "country": 233 }, { "value": 612, "label": "Green Bay", "state": 73, "country": 233 }, { "value": 613, "label": "Greenbrae", "state": 8, "country": 233 }, { "value": 614, "label": "Greenfield Park", "state": 56, "country": 38 }, { "value": 615, "label": "Greensboro", "state": 36, "country": 233 }, { "value": 616, "label": "Greenvale", "state": 47, "country": 233 }, { "value": 617, "label": "Greenville", "state": 20, "country": 233 }, { "value": 618, "label": "Greenville", "state": 36, "country": 233 }, { "value": 619, "label": "Greenville", "state": 60, "country": 233 }, { "value": 620, "label": "Greenwood", "state": 60, "country": 233 }, { "value": 624, "label": "Grosse Pointe Farms", "state": 30, "country": 233 }, { "value": 625, "label": "Groton", "state": 10, "country": 233 }, { "value": 626, "label": "Groton", "state": 26, "country": 233 }, { "value": 627, "label": "Guadalajara", "state": 21, "country": 157 }, { "value": 629, "label": "Guelph", "state": 50, "country": 38 }, { "value": 631, "label": "Guilford", "state": 10, "country": 233 }, { "value": 633, "label": "Hackensack", "state": 40, "country": 233 }, { "value": 634, "label": "Hagerstown", "state": 28, "country": 233 }, { "value": 637, "label": "Halifax", "state": 43, "country": 38 }, { "value": 640, "label": "Hamilton", "state": 40, "country": 233 }, { "value": 641, "label": "Hamilton", "state": 50, "country": 38 }, { "value": 642, "label": "Hamlton", "state": 50, "country": 38 }, { "value": 643, "label": "Hampton", "state": 68, "country": 233 }, { "value": 645, "label": "Hanover", "state": 28, "country": 233 }, { "value": 646, "label": "Hanover", "state": 39, "country": 233 }, { "value": 647, "label": "Harlingen", "state": 66, "country": 233 }, { "value": 649, "label": "Harrisburg", "state": 52, "country": 233 }, { "value": 651, "label": "Hartford", "state": 10, "country": 233 }, { "value": 652, "label": "Hastings", "state": 30, "country": 233 }, { "value": 654, "label": "Hattiesburg", "state": 33, "country": 233 }, { "value": 655, "label": "Hauppauge", "state": 47, "country": 233 }, { "value": 656, "label": "Haverford", "state": 52, "country": 233 }, { "value": 657, "label": "Hayward", "state": 8, "country": 233 }, { "value": 663, "label": "Heidelberg", "state": 70, "country": 13 }, { "value": 665, "label": "Henderson", "state": 46, "country": 233 }, { "value": 666, "label": "Henrietta", "state": 47, "country": 233 }, { "value": 668, "label": "Herndon", "state": 68, "country": 233 }, { "value": 669, "label": "Hershey", "state": 52, "country": 233 }, { "value": 671, "label": "Herston", "state": 57, "country": 13 }, { "value": 672, "label": "Heshey", "state": 52, "country": 233 }, { "value": 675, "label": "Highland Heights", "state": 24, "country": 233 }, { "value": 676, "label": "Highland Park", "state": 40, "country": 233 }, { "value": 677, "label": "Hillsborough", "state": 36, "country": 233 }, { "value": 678, "label": "Hillsborough", "state": 40, "country": 233 }, { "value": 679, "label": "Hillside", "state": 40, "country": 233 }, { "value": 680, "label": "Hilo", "state": 16, "country": 233 }, { "value": 681, "label": "Hines", "state": 19, "country": 233 }, { "value": 683, "label": "Hobart", "state": 64, "country": 13 }, { "value": 684, "label": "Hoboken", "state": 40, "country": 233 }, { "value": 685, "label": "Holland", "state": 30, "country": 233 }, { "value": 687, "label": "Honolulu", "state": 16, "country": 233 }, { "value": 688, "label": "Horsham", "state": 52, "country": 233 }, { "value": 690, "label": "Houghton", "state": 30, "country": 233 }, { "value": 692, "label": "Houston", "state": 66, "country": 233 }, { "value": 696, "label": "Humacao", "state": 55, "country": 233 }, { "value": 697, "label": "Humble", "state": 66, "country": 233 }, { "value": 698, "label": "Hummelstown", "state": 52, "country": 233 }, { "value": 699, "label": "Huntingdon Valley", "state": 52, "country": 233 }, { "value": 700, "label": "Huntingon", "state": 74, "country": 233 }, { "value": 701, "label": "Huntington", "state": 74, "country": 233 }, { "value": 702, "label": "Huntsville", "state": 3, "country": 233 }, { "value": 703, "label": "Hyattsville", "state": 28, "country": 233 }, { "value": 704, "label": "IA City", "state": 17, "country": 233 }, { "value": 705, "label": "Ijamsville", "state": 28, "country": 233 }, { "value": 708, "label": "Indianapolis", "state": 20, "country": 233 }, { "value": 709, "label": "Inglewood", "state": 8, "country": 233 }, { "value": 711, "label": "INpolis", "state": 20, "country": 233 }, { "value": 712, "label": "Iowa City", "state": 17, "country": 233 }, { "value": 714, "label": "Irvine", "state": 8, "country": 233 }, { "value": 715, "label": "Irvington", "state": 47, "country": 233 }, { "value": 716, "label": "Issaquah", "state": 72, "country": 233 }, { "value": 718, "label": "Ithaca", "state": 47, "country": 233 }, { "value": 719, "label": "Jackson", "state": 33, "country": 233 }, { "value": 720, "label": "Jacksonville", "state": 13, "country": 233 }, { "value": 721, "label": "Jasper", "state": 14, "country": 233 }, { "value": 722, "label": "Jefferson", "state": 4, "country": 233 }, { "value": 723, "label": "Jefferson City", "state": 32, "country": 233 }, { "value": 724, "label": "Jenkintown", "state": 52, "country": 233 }, { "value": 727, "label": "Jerusalem", "state": 38, "country": 103 }, { "value": 728, "label": "Johns Creek", "state": 14, "country": 233 }, { "value": 729, "label": "Johnson City", "state": 65, "country": 233 }, { "value": 730, "label": "Johnstown", "state": 52, "country": 233 }, { "value": 732, "label": "Jupiter", "state": 13, "country": 233 }, { "value": 733, "label": "Kahnawake", "state": 56, "country": 38 }, { "value": 734, "label": "Kalamazoo", "state": 30, "country": 233 }, { "value": 736, "label": "Kansas City", "state": 23, "country": 233 }, { "value": 737, "label": "Kansas City", "state": 32, "country": 233 }, { "value": 741, "label": "Kearney", "state": 38, "country": 233 }, { "value": 743, "label": "Keller", "state": 66, "country": 233 }, { "value": 744, "label": "Kelowna", "state": 7, "country": 38 }, { "value": 745, "label": "Kelvin Grove", "state": 57, "country": 13 }, { "value": 746, "label": "Kenmore", "state": 72, "country": 233 }, { "value": 747, "label": "Kensington", "state": 28, "country": 233 }, { "value": 749, "label": "Kent", "state": 48, "country": 233 }, { "value": 750, "label": "Kerrville", "state": 66, "country": 233 }, { "value": 751, "label": "King of Prussia", "state": 52, "country": 233 }, { "value": 753, "label": "Kingston", "state": 50, "country": 38 }, { "value": 754, "label": "Kingston", "state": 50, "country": 233 }, { "value": 755, "label": "Kingston", "state": 58, "country": 233 }, { "value": 757, "label": "Kingsville", "state": 66, "country": 233 }, { "value": 758, "label": "Kirkland", "state": 56, "country": 38 }, { "value": 759, "label": "Kirksville", "state": 32, "country": 233 }, { "value": 760, "label": "Kitchener", "state": 50, "country": 38 }, { "value": 761, "label": "Kittery", "state": 29, "country": 233 }, { "value": 762, "label": "Kittery Point", "state": 29, "country": 233 }, { "value": 763, "label": "Knoxville", "state": 65, "country": 233 }, { "value": 765, "label": "Kogarah", "state": 44, "country": 13 }, { "value": 769, "label": "KS City", "state": 23, "country": 233 }, { "value": 771, "label": "La Crescenta", "state": 8, "country": 233 }, { "value": 772, "label": "La Crosse", "state": 73, "country": 233 }, { "value": 774, "label": "La Jolla", "state": 8, "country": 233 }, { "value": 775, "label": "La Marque", "state": 66, "country": 233 }, { "value": 778, "label": "La Verne", "state": 8, "country": 233 }, { "value": 779, "label": "Lafayette", "state": 9, "country": 233 }, { "value": 780, "label": "Lafayette", "state": 20, "country": 233 }, { "value": 781, "label": "Laguna Hills", "state": 8, "country": 233 }, { "value": 782, "label": "Laguna Niguel", "state": 8, "country": 233 }, { "value": 783, "label": "Lajolla", "state": 8, "country": 233 }, { "value": 784, "label": "Lake Placid", "state": 47, "country": 233 }, { "value": 785, "label": "Lakeland", "state": 13, "country": 233 }, { "value": 786, "label": "Lakewood", "state": 9, "country": 233 }, { "value": 787, "label": "Lambertville", "state": 40, "country": 233 }, { "value": 789, "label": "Lancaster", "state": 8, "country": 233 }, { "value": 790, "label": "Lancaster", "state": 52, "country": 233 }, { "value": 791, "label": "Langhorne", "state": 52, "country": 233 }, { "value": 792, "label": "Langley", "state": 7, "country": 38 }, { "value": 793, "label": "Lanham", "state": 28, "country": 233 }, { "value": 794, "label": "Lansing", "state": 30, "country": 233 }, { "value": 795, "label": "Laramie", "state": 75, "country": 233 }, { "value": 796, "label": "Laredo", "state": 66, "country": 233 }, { "value": 797, "label": "Largo", "state": 13, "country": 233 }, { "value": 798, "label": "Las Cruces", "state": 42, "country": 233 }, { "value": 799, "label": "Las Vegas", "state": 46, "country": 233 }, { "value": 800, "label": "Laurel", "state": 28, "country": 233 }, { "value": 803, "label": "Laval", "state": 56, "country": 38 }, { "value": 804, "label": "Lawrence", "state": 23, "country": 233 }, { "value": 805, "label": "Lawrenceville", "state": 40, "country": 233 }, { "value": 807, "label": "League City", "state": 66, "country": 233 }, { "value": 808, "label": "Leawood", "state": 23, "country": 233 }, { "value": 809, "label": "Lebanon", "state": 39, "country": 233 }, { "value": 815, "label": "Lethbridge", "state": 1, "country": 38 }, { "value": 817, "label": "Lévis", "state": 56, "country": 38 }, { "value": 818, "label": "Lewisburg", "state": 52, "country": 233 }, { "value": 819, "label": "Lexington", "state": 24, "country": 233 }, { "value": 820, "label": "Lexington", "state": 26, "country": 233 }, { "value": 821, "label": "Lidcombe", "state": 44, "country": 13 }, { "value": 825, "label": "Lincoln", "state": 38, "country": 233 }, { "value": 826, "label": "Lincoln", "state": 58, "country": 233 }, { "value": 827, "label": "Lincoln University", "state": 52, "country": 233 }, { "value": 828, "label": "Lincolnshire", "state": 19, "country": 233 }, { "value": 829, "label": "Lincolnwood", "state": 19, "country": 233 }, { "value": 830, "label": "Lindfield", "state": 44, "country": 13 }, { "value": 831, "label": "Lindon", "state": 67, "country": 233 }, { "value": 832, "label": "Linthicum", "state": 28, "country": 233 }, { "value": 834, "label": "Lithia Springs", "state": 14, "country": 233 }, { "value": 835, "label": "Little Rock", "state": 4, "country": 233 }, { "value": 836, "label": "Littleton", "state": 9, "country": 233 }, { "value": 837, "label": "Livermore", "state": 8, "country": 233 }, { "value": 839, "label": "Liverpool", "state": 44, "country": 13 }, { "value": 840, "label": "Livingston", "state": 40, "country": 233 }, { "value": 843, "label": "Logan", "state": 67, "country": 233 }, { "value": 844, "label": "Loma Linda", "state": 8, "country": 233 }, { "value": 848, "label": "London", "state": 19, "country": 77 }, { "value": 849, "label": "London", "state": 50, "country": 38 }, { "value": 851, "label": "Long Beach", "state": 8, "country": 233 }, { "value": 852, "label": "Long Island City", "state": 47, "country": 233 }, { "value": 853, "label": "Longmont", "state": 9, "country": 233 }, { "value": 855, "label": "Lorton", "state": 68, "country": 233 }, { "value": 856, "label": "Los Alamos", "state": 42, "country": 233 }, { "value": 857, "label": "Los Altos Hills", "state": 8, "country": 233 }, { "value": 858, "label": "Los Angeles", "state": 8, "country": 233 }, { "value": 859, "label": "Los Angles", "state": 8, "country": 233 }, { "value": 861, "label": "Louisville", "state": 24, "country": 233 }, { "value": 862, "label": "Lowell", "state": 26, "country": 233 }, { "value": 863, "label": "Lubbock", "state": 66, "country": 233 }, { "value": 867, "label": "Lynden", "state": 72, "country": 233 }, { "value": 868, "label": "Lynwood", "state": 8, "country": 233 }, { "value": 871, "label": "Lývis", "state": 56, "country": 38 }, { "value": 873, "label": "Macomb", "state": 19, "country": 233 }, { "value": 874, "label": "Macon", "state": 14, "country": 233 }, { "value": 875, "label": "Madison", "state": 10, "country": 233 }, { "value": 876, "label": "Madison", "state": 73, "country": 233 }, { "value": 879, "label": "Malvern", "state": 52, "country": 233 }, { "value": 880, "label": "Manassas", "state": 68, "country": 233 }, { "value": 882, "label": "Mangilao", "state": 15, "country": 233 }, { "value": 883, "label": "Manhasset", "state": 47, "country": 233 }, { "value": 884, "label": "Manhattan", "state": 23, "country": 233 }, { "value": 885, "label": "Manhattan Beach", "state": 8, "country": 233 }, { "value": 886, "label": "Manlo Park", "state": 8, "country": 233 }, { "value": 888, "label": "Mansfield", "state": 26, "country": 233 }, { "value": 889, "label": "Manvel", "state": 66, "country": 233 }, { "value": 890, "label": "Maple Grove", "state": 31, "country": 233 }, { "value": 891, "label": "Mapleton", "state": 51, "country": 233 }, { "value": 892, "label": "Marathon", "state": 13, "country": 233 }, { "value": 894, "label": "Marietta", "state": 14, "country": 233 }, { "value": 895, "label": "Marin", "state": 8, "country": 233 }, { "value": 896, "label": "Markham", "state": 50, "country": 38 }, { "value": 897, "label": "Marlborough", "state": 26, "country": 233 }, { "value": 899, "label": "Marshfield", "state": 73, "country": 233 }, { "value": 901, "label": "Mashantucket", "state": 10, "country": 233 }, { "value": 902, "label": "Massachusetts", "state": 26, "country": 233 }, { "value": 904, "label": "Mayaguez", "state": 55, "country": 233 }, { "value": 905, "label": "Maynard", "state": 26, "country": 233 }, { "value": 906, "label": "Maywood", "state": 19, "country": 233 }, { "value": 907, "label": "Maywood", "state": 55, "country": 233 }, { "value": 908, "label": "Mc Lean", "state": 68, "country": 233 }, { "value": 909, "label": "McKeesport", "state": 52, "country": 233 }, { "value": 910, "label": "McLean", "state": 68, "country": 233 }, { "value": 911, "label": "Medford", "state": 26, "country": 233 }, { "value": 912, "label": "Media", "state": 52, "country": 233 }, { "value": 915, "label": "Melbourne", "state": 13, "country": 233 }, { "value": 916, "label": "Melbourne", "state": 57, "country": 13 }, { "value": 917, "label": "Melbourne", "state": 70, "country": 13 }, { "value": 918, "label": "Melbourne, Victoria", "state": 70, "country": 13 }, { "value": 919, "label": "Memphis", "state": 65, "country": 233 }, { "value": 920, "label": "Menands", "state": 47, "country": 233 }, { "value": 921, "label": "Mendocino", "state": 8, "country": 233 }, { "value": 922, "label": "Menlo Park", "state": 8, "country": 233 }, { "value": 923, "label": "Merced", "state": 8, "country": 233 }, { "value": 924, "label": "Mercer Island", "state": 72, "country": 233 }, { "value": 925, "label": "Mesa", "state": 6, "country": 233 }, { "value": 926, "label": "Metamora", "state": 30, "country": 233 }, { "value": 929, "label": "Miami", "state": 13, "country": 233 }, { "value": 930, "label": "Miami", "state": 47, "country": 233 }, { "value": 931, "label": "Miami Beach", "state": 13, "country": 233 }, { "value": 932, "label": "Miami Shores", "state": 13, "country": 233 }, { "value": 934, "label": "Middlesex", "state": 40, "country": 233 }, { "value": 935, "label": "Middleton", "state": 73, "country": 233 }, { "value": 936, "label": "Middletown", "state": 10, "country": 233 }, { "value": 937, "label": "Middletown", "state": 48, "country": 233 }, { "value": 939, "label": "Milan", "state": 28, "country": 110 }, { "value": 941, "label": "Milford", "state": 26, "country": 233 }, { "value": 942, "label": "Millbrae", "state": 8, "country": 233 }, { "value": 943, "label": "Milton", "state": 71, "country": 233 }, { "value": 945, "label": "Milwaukee", "state": 73, "country": 233 }, { "value": 947, "label": "Minneapolis", "state": 31, "country": 233 }, { "value": 948, "label": "Minnesota", "state": 31, "country": 233 }, { "value": 949, "label": "Miramar", "state": 13, "country": 233 }, { "value": 950, "label": "Mission Hills", "state": 8, "country": 233 }, { "value": 951, "label": "Mississauga", "state": 50, "country": 38 }, { "value": 952, "label": "Mississippi State", "state": 33, "country": 233 }, { "value": 953, "label": "Missoula", "state": 34, "country": 233 }, { "value": 954, "label": "Mobile", "state": 3, "country": 233 }, { "value": 955, "label": "Moncton", "state": 35, "country": 38 }, { "value": 956, "label": "Monmouth", "state": 19, "country": 233 }, { "value": 957, "label": "Monmouth Junction", "state": 40, "country": 233 }, { "value": 958, "label": "Monreal", "state": 56, "country": 38 }, { "value": 959, "label": "Monroe", "state": 25, "country": 233 }, { "value": 960, "label": "Monrovia", "state": 8, "country": 233 }, { "value": 961, "label": "Mont-Royal", "state": 56, "country": 38 }, { "value": 962, "label": "Montclair", "state": 40, "country": 233 }, { "value": 963, "label": "Monterey", "state": 8, "country": 233 }, { "value": 964, "label": "Monterey Park", "state": 8, "country": 233 }, { "value": 966, "label": "Monticello", "state": 4, "country": 233 }, { "value": 969, "label": "Montreal", "state": 54, "country": 38 }, { "value": 970, "label": "Montreal", "state": 54, "country": 233 }, { "value": 971, "label": "Montreal", "state": 56, "country": 38 }, { "value": 972, "label": "Montreal", "state": 56, "country": 233 }, { "value": 973, "label": "Montréal", "state": 56, "country": 38 }, { "value": 974, "label": "Moon Township", "state": 52, "country": 233 }, { "value": 975, "label": "Moorestown", "state": 40, "country": 233 }, { "value": 976, "label": "Moorhead", "state": 31, "country": 233 }, { "value": 978, "label": "Moreno Valley", "state": 8, "country": 233 }, { "value": 979, "label": "Morgantown", "state": 52, "country": 233 }, { "value": 980, "label": "Morgantown", "state": 74, "country": 233 }, { "value": 981, "label": "Morris Plains", "state": 40, "country": 233 }, { "value": 982, "label": "Morrisville", "state": 36, "country": 233 }, { "value": 983, "label": "Moscow", "state": 18, "country": 233 }, { "value": 984, "label": "Moss Beach", "state": 8, "country": 233 }, { "value": 985, "label": "Mount Pleasant", "state": 30, "country": 233 }, { "value": 986, "label": "Mount Pleasant", "state": 60, "country": 233 }, { "value": 987, "label": "Mountain View", "state": 8, "country": 233 }, { "value": 988, "label": "Mountlake Terrace", "state": 72, "country": 233 }, { "value": 989, "label": "Mukilteo", "state": 72, "country": 233 }, { "value": 991, "label": "Muncie", "state": 20, "country": 233 }, { "value": 993, "label": "N. Bethesda", "state": 28, "country": 233 }, { "value": 994, "label": "Nacogdoches", "state": 66, "country": 233 }, { "value": 1003, "label": "Nashua", "state": 39, "country": 233 }, { "value": 1004, "label": "Nashville", "state": 65, "country": 233 }, { "value": 1005, "label": "Natick", "state": 26, "country": 233 }, { "value": 1006, "label": "National City", "state": 8, "country": 233 }, { "value": 1007, "label": "Needham", "state": 26, "country": 233 }, { "value": 1008, "label": "Needham Heights", "state": 26, "country": 233 }, { "value": 1010, "label": "Nevada City", "state": 8, "country": 233 }, { "value": 1011, "label": "New Brighton", "state": 31, "country": 233 }, { "value": 1012, "label": "New Brunswick", "state": 40, "country": 233 }, { "value": 1013, "label": "New Canaan", "state": 10, "country": 233 }, { "value": 1014, "label": "New City", "state": 47, "country": 233 }, { "value": 1017, "label": "New Haven", "state": 10, "country": 233 }, { "value": 1018, "label": "New Hyde Park", "state": 47, "country": 233 }, { "value": 1019, "label": "New Jersey", "state": 40, "country": 233 }, { "value": 1020, "label": "New London", "state": 10, "country": 233 }, { "value": 1021, "label": "New Market", "state": 28, "country": 233 }, { "value": 1022, "label": "New Orleans", "state": 25, "country": 233 }, { "value": 1023, "label": "New Rochelle", "state": 47, "country": 233 }, { "value": 1024, "label": "New York", "state": 47, "country": 233 }, { "value": 1025, "label": "New York City", "state": 47, "country": 233 }, { "value": 1026, "label": "Newark", "state": 12, "country": 233 }, { "value": 1027, "label": "Newark", "state": 40, "country": 233 }, { "value": 1028, "label": "Newark", "state": 48, "country": 233 }, { "value": 1029, "label": "Newburyport", "state": 26, "country": 233 }, { "value": 1030, "label": "Newcastle", "state": 44, "country": 13 }, { "value": 1032, "label": "NewHaven", "state": 10, "country": 233 }, { "value": 1033, "label": "Newington", "state": 10, "country": 233 }, { "value": 1034, "label": "Newmarket", "state": 50, "country": 38 }, { "value": 1035, "label": "Newport", "state": 24, "country": 233 }, { "value": 1036, "label": "Newport", "state": 36, "country": 233 }, { "value": 1037, "label": "Newscastle", "state": 44, "country": 13 }, { "value": 1038, "label": "Newton", "state": 26, "country": 233 }, { "value": 1039, "label": "Newtown", "state": 52, "country": 233 }, { "value": 1041, "label": "Niagara Falls", "state": 47, "country": 233 }, { "value": 1042, "label": "Niagara University", "state": 47, "country": 233 }, { "value": 1046, "label": "Niskayuna", "state": 47, "country": 233 }, { "value": 1049, "label": "Norcross", "state": 14, "country": 233 }, { "value": 1050, "label": "Norfolk", "state": 68, "country": 233 }, { "value": 1051, "label": "Normal", "state": 19, "country": 233 }, { "value": 1052, "label": "Norman", "state": 49, "country": 233 }, { "value": 1053, "label": "North Andover", "state": 26, "country": 233 }, { "value": 1054, "label": "North Bay", "state": 50, "country": 38 }, { "value": 1055, "label": "North Brunswick", "state": 40, "country": 233 }, { "value": 1056, "label": "North Chicago", "state": 19, "country": 233 }, { "value": 1057, "label": "North Haven", "state": 10, "country": 233 }, { "value": 1058, "label": "North Kingstown", "state": 58, "country": 233 }, { "value": 1059, "label": "North Palm Beach", "state": 13, "country": 233 }, { "value": 1060, "label": "North Potomac", "state": 28, "country": 233 }, { "value": 1061, "label": "North Ryde", "state": 44, "country": 13 }, { "value": 1062, "label": "North Wollongong", "state": 44, "country": 13 }, { "value": 1063, "label": "Northampton", "state": 26, "country": 233 }, { "value": 1064, "label": "Northamton", "state": 26, "country": 233 }, { "value": 1065, "label": "Northbrook", "state": 19, "country": 233 }, { "value": 1067, "label": "Northport", "state": 47, "country": 233 }, { "value": 1068, "label": "Northridge", "state": 8, "country": 233 }, { "value": 1070, "label": "Northwood", "state": 30, "country": 233 }, { "value": 1071, "label": "Norton", "state": 26, "country": 233 }, { "value": 1073, "label": "Norwood", "state": 26, "country": 233 }, { "value": 1074, "label": "Notre Dame", "state": 20, "country": 233 }, { "value": 1077, "label": "Novato", "state": 8, "country": 233 }, { "value": 1078, "label": "NULL", "state": 52, "country": 233 }, { "value": 1079, "label": "Nw York", "state": 47, "country": 233 }, { "value": 1080, "label": "NY", "state": 47, "country": 233 }, { "value": 1081, "label": "NYC", "state": 47, "country": 233 }, { "value": 1082, "label": "Oak Brook", "state": 19, "country": 233 }, { "value": 1083, "label": "Oak Park", "state": 19, "country": 233 }, { "value": 1084, "label": "Oak Ridge", "state": 65, "country": 233 }, { "value": 1085, "label": "Oakdale", "state": 47, "country": 233 }, { "value": 1086, "label": "Oakland", "state": 8, "country": 233 }, { "value": 1087, "label": "Oakton", "state": 68, "country": 233 }, { "value": 1088, "label": "Oakwood Village", "state": 48, "country": 233 }, { "value": 1089, "label": "Oberlin", "state": 48, "country": 233 }, { "value": 1090, "label": "Obregon", "state": 63, "country": 157 }, { "value": 1093, "label": "Okemos", "state": 30, "country": 233 }, { "value": 1094, "label": "Oklahoma", "state": 49, "country": 233 }, { "value": 1095, "label": "Oklahoma City", "state": 49, "country": 233 }, { "value": 1096, "label": "Old Westbury", "state": 47, "country": 233 }, { "value": 1097, "label": "Omaha", "state": 38, "country": 233 }, { "value": 1099, "label": "Orange", "state": 8, "country": 233 }, { "value": 1100, "label": "Orangeburg", "state": 47, "country": 233 }, { "value": 1101, "label": "Orangeburg", "state": 60, "country": 233 }, { "value": 1103, "label": "Oriental", "state": 36, "country": 233 }, { "value": 1104, "label": "Orlando", "state": 13, "country": 233 }, { "value": 1106, "label": "Orono", "state": 29, "country": 233 }, { "value": 1109, "label": "Oshawa", "state": 50, "country": 38 }, { "value": 1111, "label": "Ottawa", "state": 50, "country": 38 }, { "value": 1113, "label": "Overland Park", "state": 23, "country": 233 }, { "value": 1114, "label": "Owego", "state": 47, "country": 233 }, { "value": 1115, "label": "Owings Mills", "state": 28, "country": 233 }, { "value": 1118, "label": "Oxford", "state": 33, "country": 233 }, { "value": 1119, "label": "Oxford", "state": 48, "country": 233 }, { "value": 1120, "label": "Oxnard", "state": 8, "country": 233 }, { "value": 1122, "label": "Pacific Palisades", "state": 8, "country": 233 }, { "value": 1126, "label": "Palo Alto", "state": 8, "country": 233 }, { "value": 1127, "label": "Palos Verdes", "state": 8, "country": 233 }, { "value": 1128, "label": "Panorama City", "state": 8, "country": 233 }, { "value": 1129, "label": "Paoli", "state": 52, "country": 233 }, { "value": 1131, "label": "Park Ridge", "state": 19, "country": 233 }, { "value": 1133, "label": "Parkville", "state": 44, "country": 13 }, { "value": 1134, "label": "Parkville", "state": 70, "country": 13 }, { "value": 1136, "label": "Pasadena", "state": 8, "country": 233 }, { "value": 1137, "label": "Pascagoula", "state": 33, "country": 233 }, { "value": 1140, "label": "Pawtucket", "state": 58, "country": 233 }, { "value": 1145, "label": "Pendleton", "state": 60, "country": 233 }, { "value": 1146, "label": "Penrith South Dc", "state": 44, "country": 13 }, { "value": 1147, "label": "Pensacola", "state": 13, "country": 233 }, { "value": 1148, "label": "Peoria", "state": 19, "country": 233 }, { "value": 1149, "label": "Perth", "state": 72, "country": 13 }, { "value": 1153, "label": "Peterborough", "state": 50, "country": 38 }, { "value": 1154, "label": "Philadelphia", "state": 36, "country": 233 }, { "value": 1155, "label": "Philadelphia", "state": 52, "country": 233 }, { "value": 1156, "label": "Phoenix", "state": 6, "country": 233 }, { "value": 1158, "label": "Pikesville", "state": 28, "country": 233 }, { "value": 1159, "label": "Pine", "state": 9, "country": 233 }, { "value": 1161, "label": "Piscataway", "state": 40, "country": 233 }, { "value": 1162, "label": "Pittsburg", "state": 52, "country": 233 }, { "value": 1163, "label": "Pittsburgh", "state": 52, "country": 233 }, { "value": 1164, "label": "Pittsford", "state": 47, "country": 233 }, { "value": 1165, "label": "Plainsboro", "state": 40, "country": 233 }, { "value": 1166, "label": "Plano", "state": 66, "country": 233 }, { "value": 1167, "label": "Playa Del Rey", "state": 8, "country": 233 }, { "value": 1168, "label": "Pleasant Hill", "state": 8, "country": 233 }, { "value": 1169, "label": "Pleasanton", "state": 8, "country": 233 }, { "value": 1170, "label": "Pleasantville", "state": 47, "country": 233 }, { "value": 1172, "label": "Plymouth", "state": 30, "country": 233 }, { "value": 1173, "label": "Plymouth", "state": 31, "country": 233 }, { "value": 1175, "label": "Pointe-Claire", "state": 56, "country": 38 }, { "value": 1178, "label": "Pomona", "state": 8, "country": 233 }, { "value": 1180, "label": "Ponce", "state": 55, "country": 233 }, { "value": 1182, "label": "Port Hueneme", "state": 8, "country": 233 }, { "value": 1183, "label": "Port Orange", "state": 13, "country": 233 }, { "value": 1184, "label": "Port Saint Lucie", "state": 13, "country": 233 }, { "value": 1185, "label": "Port St. Lucie", "state": 13, "country": 233 }, { "value": 1186, "label": "Portland", "state": 29, "country": 233 }, { "value": 1187, "label": "Portland", "state": 51, "country": 233 }, { "value": 1191, "label": "Portola Valley", "state": 8, "country": 233 }, { "value": 1194, "label": "Potomac", "state": 28, "country": 233 }, { "value": 1195, "label": "Potsdam", "state": 47, "country": 233 }, { "value": 1197, "label": "Poway", "state": 8, "country": 233 }, { "value": 1199, "label": "Prairie Village", "state": 23, "country": 233 }, { "value": 1202, "label": "Prince George", "state": 7, "country": 38 }, { "value": 1203, "label": "Princess Anne", "state": 28, "country": 233 }, { "value": 1204, "label": "Princeton", "state": 40, "country": 233 }, { "value": 1205, "label": "Princeton", "state": 47, "country": 233 }, { "value": 1206, "label": "Princeton Junction", "state": 40, "country": 233 }, { "value": 1207, "label": "Prospect", "state": 24, "country": 233 }, { "value": 1208, "label": "Providence", "state": 58, "country": 233 }, { "value": 1209, "label": "Provo", "state": 67, "country": 233 }, { "value": 1210, "label": "Pttsburgh", "state": 52, "country": 233 }, { "value": 1211, "label": "Pueblo", "state": 9, "country": 233 }, { "value": 1212, "label": "Pullman", "state": 72, "country": 233 }, { "value": 1214, "label": "Purchase", "state": 47, "country": 233 }, { "value": 1215, "label": "Quebec", "state": 56, "country": 38 }, { "value": 1216, "label": "Québec", "state": 56, "country": 38 }, { "value": 1217, "label": "Queens", "state": 47, "country": 233 }, { "value": 1218, "label": "Queensbury", "state": 47, "country": 233 }, { "value": 1220, "label": "Quincy", "state": 26, "country": 233 }, { "value": 1222, "label": "Radford", "state": 68, "country": 233 }, { "value": 1223, "label": "Radnor", "state": 52, "country": 233 }, { "value": 1224, "label": "Raleigh", "state": 36, "country": 233 }, { "value": 1228, "label": "Rancho Dominguez", "state": 8, "country": 233 }, { "value": 1229, "label": "Randwick", "state": 44, "country": 13 }, { "value": 1230, "label": "Rapid City", "state": 61, "country": 233 }, { "value": 1232, "label": "Redlands", "state": 8, "country": 233 }, { "value": 1233, "label": "Redmond", "state": 72, "country": 233 }, { "value": 1234, "label": "Redwood City", "state": 8, "country": 233 }, { "value": 1235, "label": "Regina", "state": 62, "country": 38 }, { "value": 1238, "label": "Rehovot", "state": 66, "country": 103 }, { "value": 1242, "label": "Reno", "state": 46, "country": 233 }, { "value": 1243, "label": "Rensselaer", "state": 47, "country": 233 }, { "value": 1244, "label": "Research Triangle", "state": 36, "country": 233 }, { "value": 1245, "label": "Research Triangle Pa", "state": 36, "country": 233 }, { "value": 1246, "label": "Research Triangle Park", "state": 36, "country": 233 }, { "value": 1247, "label": "Reston", "state": 68, "country": 233 }, { "value": 1250, "label": "Richardson", "state": 66, "country": 233 }, { "value": 1251, "label": "Richland", "state": 72, "country": 233 }, { "value": 1252, "label": "Richmond", "state": 7, "country": 38 }, { "value": 1253, "label": "Richmond", "state": 8, "country": 233 }, { "value": 1254, "label": "Richmond", "state": 68, "country": 233 }, { "value": 1255, "label": "Richmond Hill", "state": 50, "country": 38 }, { "value": 1256, "label": "Rio Nido", "state": 8, "country": 233 }, { "value": 1257, "label": "Rio Piedras", "state": 55, "country": 233 }, { "value": 1258, "label": "River Vale", "state": 40, "country": 233 }, { "value": 1259, "label": "Riverside", "state": 8, "country": 233 }, { "value": 1260, "label": "Roanoke", "state": 68, "country": 233 }, { "value": 1261, "label": "Rochester", "state": 30, "country": 233 }, { "value": 1262, "label": "Rochester", "state": 31, "country": 233 }, { "value": 1263, "label": "Rochester", "state": 47, "country": 233 }, { "value": 1264, "label": "Rochester Hills", "state": 30, "country": 233 }, { "value": 1265, "label": "Rochester, Mn", "state": 31, "country": 233 }, { "value": 1266, "label": "Rock Hill", "state": 60, "country": 233 }, { "value": 1267, "label": "Rockford", "state": 30, "country": 233 }, { "value": 1268, "label": "Rockvile", "state": 28, "country": 233 }, { "value": 1269, "label": "Rockville", "state": 28, "country": 233 }, { "value": 1270, "label": "Rockville", "state": 36, "country": 233 }, { "value": 1271, "label": "Rocky Hill", "state": 10, "country": 233 }, { "value": 1272, "label": "Rolla", "state": 32, "country": 233 }, { "value": 1276, "label": "Rootstown", "state": 48, "country": 233 }, { "value": 1277, "label": "Rosemont", "state": 19, "country": 233 }, { "value": 1278, "label": "Roseville", "state": 31, "country": 233 }, { "value": 1279, "label": "Roslyn", "state": 47, "country": 233 }, { "value": 1282, "label": "Rouyn-Noranda", "state": 56, "country": 38 }, { "value": 1283, "label": "Rowlett", "state": 66, "country": 233 }, { "value": 1284, "label": "Roxbury", "state": 10, "country": 233 }, { "value": 1285, "label": "Royal Oak", "state": 30, "country": 233 }, { "value": 1287, "label": "Rtp", "state": 36, "country": 233 }, { "value": 1288, "label": "Ruskin", "state": 13, "country": 233 }, { "value": 1289, "label": "Ruston", "state": 25, "country": 233 }, { "value": 1290, "label": "Rutherford", "state": 40, "country": 233 }, { "value": 1292, "label": "Sackville", "state": 35, "country": 38 }, { "value": 1293, "label": "Sacramento", "state": 8, "country": 233 }, { "value": 1295, "label": "Saint John", "state": 35, "country": 38 }, { "value": 1296, "label": "Saint Louis", "state": 32, "country": 233 }, { "value": 1297, "label": "Saint Paul", "state": 31, "country": 233 }, { "value": 1301, "label": "Saint-Laurent", "state": 56, "country": 38 }, { "value": 1303, "label": "Saint-Leonard", "state": 56, "country": 38 }, { "value": 1305, "label": "Sainte-Anne-De-Bel", "state": 56, "country": 38 }, { "value": 1306, "label": "Sainte-Anne-De-Bellevue", "state": 56, "country": 38 }, { "value": 1308, "label": "Salem", "state": 51, "country": 233 }, { "value": 1310, "label": "Salinas", "state": 8, "country": 233 }, { "value": 1312, "label": "Salisbury", "state": 28, "country": 233 }, { "value": 1313, "label": "Salisbury Cove", "state": 29, "country": 233 }, { "value": 1314, "label": "Salt lake", "state": 67, "country": 233 }, { "value": 1315, "label": "Salt Lake City", "state": 67, "country": 233 }, { "value": 1317, "label": "Sammamish", "state": 72, "country": 233 }, { "value": 1318, "label": "San Antonio", "state": 66, "country": 233 }, { "value": 1319, "label": "San Carlos", "state": 8, "country": 233 }, { "value": 1321, "label": "San Diego", "state": 8, "country": 233 }, { "value": 1322, "label": "San Francisco", "state": 8, "country": 233 }, { "value": 1323, "label": "San Francisco,", "state": 8, "country": 233 }, { "value": 1324, "label": "San Francsico", "state": 8, "country": 233 }, { "value": 1325, "label": "San Jose", "state": 8, "country": 233 }, { "value": 1326, "label": "San Juan", "state": 55, "country": 233 }, { "value": 1327, "label": "San Leandro", "state": 8, "country": 233 }, { "value": 1328, "label": "San Marcos", "state": 8, "country": 233 }, { "value": 1329, "label": "San Marcos", "state": 66, "country": 233 }, { "value": 1330, "label": "San Marino", "state": 8, "country": 233 }, { "value": 1331, "label": "San Mateo", "state": 8, "country": 233 }, { "value": 1332, "label": "San Rafael", "state": 8, "country": 233 }, { "value": 1333, "label": "San Ysidro", "state": 8, "country": 233 }, { "value": 1334, "label": "Sandy", "state": 67, "country": 233 }, { "value": 1335, "label": "Santa Ana", "state": 8, "country": 233 }, { "value": 1336, "label": "Santa Babara", "state": 8, "country": 233 }, { "value": 1337, "label": "Santa Barbara", "state": 8, "country": 233 }, { "value": 1338, "label": "Santa Clara", "state": 8, "country": 233 }, { "value": 1339, "label": "Santa Cruz", "state": 8, "country": 233 }, { "value": 1340, "label": "Santa Fe", "state": 42, "country": 233 }, { "value": 1341, "label": "Santa Fe Springs", "state": 8, "country": 233 }, { "value": 1342, "label": "Santa Monica", "state": 8, "country": 233 }, { "value": 1343, "label": "Santa Rosa", "state": 8, "country": 233 }, { "value": 1346, "label": "Saranac Lake", "state": 47, "country": 233 }, { "value": 1347, "label": "Sarasota", "state": 13, "country": 233 }, { "value": 1348, "label": "Saskatoon", "state": 62, "country": 38 }, { "value": 1349, "label": "Sault Ste Marie", "state": 50, "country": 38 }, { "value": 1350, "label": "Sault Ste. Marie", "state": 30, "country": 233 }, { "value": 1351, "label": "Savage", "state": 28, "country": 233 }, { "value": 1352, "label": "Savannah", "state": 14, "country": 233 }, { "value": 1353, "label": "Savoy", "state": 19, "country": 233 }, { "value": 1354, "label": "Saybrook Manor", "state": 10, "country": 233 }, { "value": 1355, "label": "Sayre", "state": 52, "country": 233 }, { "value": 1357, "label": "Scarborough", "state": 29, "country": 233 }, { "value": 1358, "label": "Schaumburg", "state": 19, "country": 233 }, { "value": 1359, "label": "Schenectady", "state": 47, "country": 233 }, { "value": 1361, "label": "Scottsdale", "state": 6, "country": 233 }, { "value": 1362, "label": "Scranton", "state": 52, "country": 233 }, { "value": 1363, "label": "Seattle", "state": 72, "country": 233 }, { "value": 1364, "label": "Sebastopol", "state": 8, "country": 233 }, { "value": 1367, "label": "Sepulveda", "state": 8, "country": 233 }, { "value": 1368, "label": "Setauket", "state": 47, "country": 233 }, { "value": 1369, "label": "Severna Park", "state": 28, "country": 233 }, { "value": 1373, "label": "Shelby Township", "state": 30, "country": 233 }, { "value": 1374, "label": "Sherbrooke", "state": 56, "country": 38 }, { "value": 1377, "label": "Shiprock", "state": 42, "country": 233 }, { "value": 1379, "label": "Shoreline", "state": 72, "country": 233 }, { "value": 1380, "label": "Shreveport", "state": 25, "country": 233 }, { "value": 1381, "label": "Shrewsbury", "state": 26, "country": 233 }, { "value": 1382, "label": "Sillery", "state": 56, "country": 38 }, { "value": 1384, "label": "Silver Spring", "state": 28, "country": 233 }, { "value": 1385, "label": "Silverthorne", "state": 9, "country": 233 }, { "value": 1387, "label": "Sioux Center", "state": 17, "country": 233 }, { "value": 1388, "label": "Sioux Falls", "state": 61, "country": 233 }, { "value": 1389, "label": "Skillman", "state": 40, "country": 233 }, { "value": 1390, "label": "Slidell", "state": 25, "country": 233 }, { "value": 1391, "label": "Smithville", "state": 66, "country": 233 }, { "value": 1392, "label": "Snyder", "state": 47, "country": 233 }, { "value": 1393, "label": "Socorro", "state": 42, "country": 233 }, { "value": 1394, "label": "Solon", "state": 48, "country": 233 }, { "value": 1395, "label": "Somerset", "state": 40, "country": 233 }, { "value": 1396, "label": "Somerville", "state": 26, "country": 233 }, { "value": 1397, "label": "Sonora", "state": 63, "country": 157 }, { "value": 1398, "label": "South Bend", "state": 20, "country": 233 }, { "value": 1399, "label": "South Brisbane", "state": 57, "country": 13 }, { "value": 1400, "label": "South Dartmouth", "state": 26, "country": 233 }, { "value": 1401, "label": "South Lyon", "state": 30, "country": 233 }, { "value": 1403, "label": "South Orange", "state": 40, "country": 233 }, { "value": 1404, "label": "South Plainfield", "state": 40, "country": 233 }, { "value": 1405, "label": "South Portland", "state": 29, "country": 233 }, { "value": 1406, "label": "South San Francisco", "state": 8, "country": 233 }, { "value": 1409, "label": "Southbridge", "state": 26, "country": 233 }, { "value": 1410, "label": "Southfield", "state": 30, "country": 233 }, { "value": 1411, "label": "Southport", "state": 57, "country": 13 }, { "value": 1412, "label": "Spartanburg", "state": 60, "country": 233 }, { "value": 1413, "label": "Spinnerstown", "state": 52, "country": 233 }, { "value": 1414, "label": "Spokane", "state": 72, "country": 233 }, { "value": 1415, "label": "Springdale", "state": 4, "country": 233 }, { "value": 1416, "label": "Springfield", "state": 19, "country": 233 }, { "value": 1417, "label": "Springfield", "state": 26, "country": 233 }, { "value": 1418, "label": "Springfield", "state": 32, "country": 233 }, { "value": 1419, "label": "Springfield", "state": 68, "country": 233 }, { "value": 1422, "label": "St Catharines", "state": 50, "country": 38 }, { "value": 1424, "label": "St Leonards", "state": 44, "country": 13 }, { "value": 1425, "label": "St Louis", "state": 32, "country": 233 }, { "value": 1426, "label": "St Lucia", "state": 57, "country": 13 }, { "value": 1427, "label": "St Paul", "state": 31, "country": 233 }, { "value": 1429, "label": "St. Catharines", "state": 50, "country": 38 }, { "value": 1430, "label": "St. John'S", "state": 41, "country": 38 }, { "value": 1431, "label": "St. Joseph", "state": 30, "country": 233 }, { "value": 1432, "label": "St. Joseph", "state": 32, "country": 233 }, { "value": 1434, "label": "St. Louis", "state": 31, "country": 233 }, { "value": 1435, "label": "St. Louis", "state": 32, "country": 233 }, { "value": 1436, "label": "St. Louis", "state": 72, "country": 233 }, { "value": 1437, "label": "St. Louis Park", "state": 31, "country": 233 }, { "value": 1438, "label": "St. Paul", "state": 31, "country": 233 }, { "value": 1439, "label": "St. Rose", "state": 25, "country": 233 }, { "value": 1440, "label": "Stanford", "state": 8, "country": 233 }, { "value": 1441, "label": "Stanford", "state": 47, "country": 233 }, { "value": 1442, "label": "State College", "state": 52, "country": 233 }, { "value": 1443, "label": "Staten Island", "state": 47, "country": 233 }, { "value": 1444, "label": "Statesboro", "state": 14, "country": 233 }, { "value": 1445, "label": "Sterling", "state": 68, "country": 233 }, { "value": 1446, "label": "Stillwater", "state": 31, "country": 233 }, { "value": 1447, "label": "Stillwater", "state": 49, "country": 233 }, { "value": 1452, "label": "Stockton", "state": 8, "country": 233 }, { "value": 1454, "label": "Stony Brook", "state": 47, "country": 233 }, { "value": 1455, "label": "Storrs", "state": 10, "country": 233 }, { "value": 1456, "label": "Storrs-Mansfield", "state": 10, "country": 233 }, { "value": 1457, "label": "Strafford", "state": 52, "country": 233 }, { "value": 1459, "label": "Stratford", "state": 40, "country": 233 }, { "value": 1460, "label": "Strawberry Hills", "state": 44, "country": 13 }, { "value": 1462, "label": "Subiaco", "state": 72, "country": 13 }, { "value": 1463, "label": "Sudbury", "state": 50, "country": 38 }, { "value": 1464, "label": "Sugar Land", "state": 66, "country": 233 }, { "value": 1466, "label": "Sunnybrook", "state": 47, "country": 233 }, { "value": 1467, "label": "Sunnyvale", "state": 8, "country": 233 }, { "value": 1470, "label": "Surrey", "state": 7, "country": 38 }, { "value": 1471, "label": "Surry Hills", "state": 44, "country": 13 }, { "value": 1475, "label": "Swarthmore", "state": 52, "country": 233 }, { "value": 1479, "label": "Sydney", "state": 43, "country": 38 }, { "value": 1480, "label": "Sydney", "state": 44, "country": 13 }, { "value": 1481, "label": "Sylvania", "state": 48, "country": 233 }, { "value": 1482, "label": "Syracuse", "state": 47, "country": 233 }, { "value": 1483, "label": "Tacoma", "state": 72, "country": 233 }, { "value": 1484, "label": "Tahlequah", "state": 49, "country": 233 }, { "value": 1489, "label": "Tallahassee", "state": 13, "country": 233 }, { "value": 1491, "label": "Tampa", "state": 13, "country": 233 }, { "value": 1492, "label": "Tarrytown", "state": 47, "country": 233 }, { "value": 1494, "label": "Tarzana", "state": 8, "country": 233 }, { "value": 1498, "label": "Temecula", "state": 8, "country": 233 }, { "value": 1499, "label": "Tempe", "state": 6, "country": 233 }, { "value": 1500, "label": "Temple", "state": 66, "country": 233 }, { "value": 1501, "label": "Temple Terrace", "state": 13, "country": 233 }, { "value": 1502, "label": "Terre Haute", "state": 20, "country": 233 }, { "value": 1503, "label": "The Woodlands", "state": 66, "country": 233 }, { "value": 1504, "label": "Thousand Oaks", "state": 8, "country": 233 }, { "value": 1505, "label": "Thunder Bay", "state": 50, "country": 38 }, { "value": 1507, "label": "Tigard", "state": 51, "country": 233 }, { "value": 1510, "label": "Toledo", "state": 48, "country": 233 }, { "value": 1511, "label": "Toluca Lake", "state": 8, "country": 233 }, { "value": 1512, "label": "Toms River", "state": 40, "country": 233 }, { "value": 1513, "label": "Toowoomba", "state": 57, "country": 13 }, { "value": 1516, "label": "Toronto", "state": 50, "country": 38 }, { "value": 1517, "label": "Toronto", "state": 50, "country": 233 }, { "value": 1518, "label": "Torrance", "state": 8, "country": 233 }, { "value": 1521, "label": "Towson", "state": 28, "country": 233 }, { "value": 1523, "label": "Trenton", "state": 40, "country": 233 }, { "value": 1524, "label": "Triangle Park", "state": 36, "country": 233 }, { "value": 1526, "label": "Trois-Rivieres", "state": 56, "country": 38 }, { "value": 1527, "label": "Trois-Rivières", "state": 56, "country": 38 }, { "value": 1528, "label": "Trois-Riviýres", "state": 56, "country": 38 }, { "value": 1529, "label": "Troy", "state": 30, "country": 233 }, { "value": 1530, "label": "Troy", "state": 47, "country": 233 }, { "value": 1531, "label": "Trumbull", "state": 10, "country": 233 }, { "value": 1533, "label": "Tsaile", "state": 6, "country": 233 }, { "value": 1534, "label": "Tucker", "state": 14, "country": 233 }, { "value": 1535, "label": "Tucon", "state": 6, "country": 233 }, { "value": 1537, "label": "Tucson", "state": 6, "country": 233 }, { "value": 1538, "label": "Tullahoma", "state": 65, "country": 233 }, { "value": 1539, "label": "Tulsa", "state": 49, "country": 233 }, { "value": 1543, "label": "Tuscaloosa", "state": 3, "country": 233 }, { "value": 1544, "label": "Tuskegee", "state": 3, "country": 233 }, { "value": 1545, "label": "Tuxedo", "state": 47, "country": 233 }, { "value": 1546, "label": "Tyler", "state": 66, "country": 233 }, { "value": 1551, "label": "Union City", "state": 8, "country": 233 }, { "value": 1552, "label": "University", "state": 33, "country": 233 }, { "value": 1553, "label": "University Park", "state": 52, "country": 233 }, { "value": 1554, "label": "Upper Marlboro", "state": 28, "country": 233 }, { "value": 1557, "label": "Upton", "state": 47, "country": 233 }, { "value": 1558, "label": "Urbana", "state": 19, "country": 233 }, { "value": 1559, "label": "Urbandale", "state": 17, "country": 233 }, { "value": 1565, "label": "Valhalla", "state": 47, "country": 233 }, { "value": 1566, "label": "Vallejo", "state": 8, "country": 233 }, { "value": 1568, "label": "Vancouver", "state": 7, "country": 38 }, { "value": 1569, "label": "Vancouver", "state": 7, "country": 233 }, { "value": 1570, "label": "Vancouver", "state": 72, "country": 233 }, { "value": 1574, "label": "Vermillion", "state": 61, "country": 233 }, { "value": 1576, "label": "Verona", "state": 73, "country": 233 }, { "value": 1577, "label": "Vestavia Hills", "state": 3, "country": 233 }, { "value": 1580, "label": "Victoria", "state": 7, "country": 38 }, { "value": 1582, "label": "Villanova", "state": 52, "country": 233 }, { "value": 1583, "label": "Villanova University", "state": 52, "country": 233 }, { "value": 1586, "label": "Vista", "state": 8, "country": 233 }, { "value": 1587, "label": "Waban", "state": 26, "country": 233 }, { "value": 1588, "label": "Waco", "state": 66, "country": 233 }, { "value": 1591, "label": "Wakefield", "state": 26, "country": 233 }, { "value": 1592, "label": "Walnut", "state": 8, "country": 233 }, { "value": 1593, "label": "Walnut Creek", "state": 8, "country": 233 }, { "value": 1594, "label": "Waltham", "state": 26, "country": 233 }, { "value": 1597, "label": "Warwick", "state": 58, "country": 233 }, { "value": 1599, "label": "Washington", "state": 11, "country": 233 }, { "value": 1600, "label": "Washington", "state": 68, "country": 233 }, { "value": 1601, "label": "Washington Crossing", "state": 52, "country": 233 }, { "value": 1602, "label": "Washington DC", "state": 11, "country": 233 }, { "value": 1604, "label": "Waterloo", "state": 50, "country": 38 }, { "value": 1605, "label": "Waterloo", "state": 50, "country": 233 }, { "value": 1606, "label": "Waterton", "state": 26, "country": 233 }, { "value": 1607, "label": "Watertown", "state": 26, "country": 233 }, { "value": 1608, "label": "Waterville", "state": 29, "country": 233 }, { "value": 1609, "label": "Waunakee", "state": 73, "country": 233 }, { "value": 1610, "label": "Wauwatosa", "state": 73, "country": 233 }, { "value": 1611, "label": "Wellesley", "state": 26, "country": 233 }, { "value": 1612, "label": "Wellesley Hills", "state": 26, "country": 233 }, { "value": 1613, "label": "Wellington Point", "state": 57, "country": 13 }, { "value": 1616, "label": "West Chester", "state": 52, "country": 233 }, { "value": 1617, "label": "West Des Moines", "state": 17, "country": 233 }, { "value": 1618, "label": "West Haven", "state": 10, "country": 233 }, { "value": 1619, "label": "West Henrietta", "state": 47, "country": 233 }, { "value": 1620, "label": "West Kingston", "state": 58, "country": 233 }, { "value": 1621, "label": "West Lafayette", "state": 20, "country": 233 }, { "value": 1622, "label": "West Lin", "state": 51, "country": 233 }, { "value": 1623, "label": "West Orange", "state": 40, "country": 233 }, { "value": 1624, "label": "West Palm Beach", "state": 13, "country": 233 }, { "value": 1625, "label": "West Roxbury", "state": 26, "country": 233 }, { "value": 1626, "label": "West Valley City", "state": 67, "country": 233 }, { "value": 1627, "label": "Westborough", "state": 26, "country": 233 }, { "value": 1628, "label": "Westlake Village", "state": 8, "country": 233 }, { "value": 1629, "label": "Westmead", "state": 44, "country": 13 }, { "value": 1630, "label": "Weston", "state": 26, "country": 233 }, { "value": 1631, "label": "Westport", "state": 10, "country": 233 }, { "value": 1632, "label": "Wheat Ridge", "state": 9, "country": 233 }, { "value": 1633, "label": "Wheeling", "state": 19, "country": 233 }, { "value": 1634, "label": "White Plains", "state": 47, "country": 233 }, { "value": 1635, "label": "White River Junction", "state": 39, "country": 233 }, { "value": 1636, "label": "White River Junction", "state": 71, "country": 233 }, { "value": 1638, "label": "Whitewater", "state": 73, "country": 233 }, { "value": 1639, "label": "Wichita", "state": 23, "country": 233 }, { "value": 1641, "label": "Williamsburg", "state": 68, "country": 233 }, { "value": 1642, "label": "Williamstown", "state": 26, "country": 233 }, { "value": 1643, "label": "Williamsville", "state": 47, "country": 233 }, { "value": 1644, "label": "Wilmette", "state": 19, "country": 233 }, { "value": 1645, "label": "Wilmington", "state": 12, "country": 233 }, { "value": 1646, "label": "Wilmington", "state": 26, "country": 233 }, { "value": 1647, "label": "Wilmington", "state": 36, "country": 233 }, { "value": 1648, "label": "Windber", "state": 52, "country": 233 }, { "value": 1650, "label": "Windsor", "state": 50, "country": 38 }, { "value": 1651, "label": "Winnipeg", "state": 27, "country": 38 }, { "value": 1652, "label": "Winston Salem", "state": 36, "country": 233 }, { "value": 1653, "label": "Winston-Salem", "state": 36, "country": 233 }, { "value": 1655, "label": "Woburn", "state": 26, "country": 233 }, { "value": 1656, "label": "Wolfville", "state": 43, "country": 38 }, { "value": 1657, "label": "Wollongong", "state": 44, "country": 13 }, { "value": 1659, "label": "Woodbury", "state": 47, "country": 233 }, { "value": 1660, "label": "Woodinville", "state": 72, "country": 233 }, { "value": 1661, "label": "Woods Hole", "state": 26, "country": 233 }, { "value": 1662, "label": "Woodside", "state": 8, "country": 233 }, { "value": 1663, "label": "Woodville", "state": 59, "country": 13 }, { "value": 1664, "label": "Woolwich", "state": 29, "country": 233 }, { "value": 1665, "label": "Worcester", "state": 26, "country": 233 }, { "value": 1666, "label": "Worchester", "state": 26, "country": 233 }, { "value": 1671, "label": "Wynantskill", "state": 47, "country": 233 }, { "value": 1672, "label": "Wynnewood", "state": 52, "country": 233 }, { "value": 1673, "label": "Yaphank", "state": 47, "country": 233 }, { "value": 1674, "label": "Yardley", "state": 52, "country": 233 }, { "value": 1678, "label": "York", "state": 52, "country": 233 }, { "value": 1679, "label": "Ypsilanti", "state": 30, "country": 233 }, { "value": 1680, "label": "Zionsville", "state": 20, "country": 233 }];
    }
    SearchFields.prototype.getYears = function () {
        var years = [];
        for (var i = 2016; i >= 2000; i--) {
            years.push({
                value: i,
                label: (i).toString()
            });
        }
        return years;
    };
    SearchFields.prototype.getCountries = function () {
        return this.countries;
    };
    SearchFields.prototype.getStates = function (countries) {
        return this.states
            .filter(function (state) { return countries.indexOf(state.country) >= 0 || !countries.length; })
            .map(function (state) {
            return {
                value: state.value,
                label: state.label
            };
        });
    };
    SearchFields.prototype.getCities = function (countries, states) {
        return this.locations
            .filter(function (location) { return countries.indexOf(location.country) >= 0 || !countries.length; })
            .filter(function (location) { return states.indexOf(location.state) >= 0 || !states.length; })
            .map(function (location) {
            return {
                value: location.value,
                label: location.label
            };
        });
    };
    SearchFields.prototype.getFundingOrganizations = function () {
        return this.organizations.map(function (organization) {
            return {
                value: organization.id,
                label: organization.name
            };
        });
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
        return this.cancer_types;
    };
    SearchFields.prototype.getCsoResearchAreas = function () {
        return this.cso_research_areas.map(function (cso) {
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
        console.log('changes made', changes);
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
        this.parameters['page_size'] = event.size;
        this.parameters['page_offset'] = event.offset;
        this.updateResults(this.parameters);
    };
    SearchComponent.prototype.sort = function (event) {
        this.parameters['order_by'] = event.column;
        this.parameters['order_type'] = event.type;
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
        //    endpoint = 'http://localhost:10000/db/public/search';
        var params = new __WEBPACK_IMPORTED_MODULE_1__angular_http__["a" /* URLSearchParams */]();
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
        var size = element.clientWidth;
        var radius = size / 2;
        var arc = __WEBPACK_IMPORTED_MODULE_0_d3__["arc"]().outerRadius(radius).innerRadius(radius / 2);
        var pie = __WEBPACK_IMPORTED_MODULE_0_d3__["pie"]();
        var color = __WEBPACK_IMPORTED_MODULE_0_d3__["scaleOrdinal"](__WEBPACK_IMPORTED_MODULE_0_d3__["schemeCategory20c"]);
        var svg = host
            .attr('width', size)
            .attr('height', size)
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
        this.propagateChange(this.values.filter(function (v, i) {
            return _this.selectedItems.indexOf(i) >= 0;
        }));
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
            size: size,
            offset: (offset - 1) * size
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
                    column: column.value,
                    type: column.sort
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
        console.log('CHANGES', changes);
        console.log('col ', this.columns);
        console.log('data ', this.data);
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

module.exports = "<form [formGroup]=\"form\" (ngSubmit)=\"submit()\">\n\n  <!-- Search Terms -->\n  <ui-panel title=\"Search Terms\" [visible]=\"true\">\n    <label class=\"sr-only\" for=\"search_terms\">Search Terms</label>\n    <input \n      class=\"text input\" \n      id=\"search_terms\"\n      name=\"search_terms\"\n      type=\"text\"\n      placeholder=\"Enter search terms\"\n      [formControl]=\"form.controls.search_terms\">\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_all\">\n        <input \n          class=\"radio-input\" \n          type=\"radio\" \n          id=\"search_term_filter_all\" \n          name=\"search_term_filter\" \n          value=\"all\"\n          [formControl]=\"form.controls.search_term_filter\">\n        All of the keywords\n      </label>\n    </div>\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_none\">\n        <input\n          class=\"radio-input\"\n          type=\"radio\"\n          id=\"search_term_filter_none\"\n          name=\"search_term_filter\"\n          value=\"none\"\n          [formControl]=\"form.controls.search_term_filter\">\n        None of the keywords\n      </label>\n    </div>\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_any\">\n        <input\n          class=\"radio-input\"\n          type=\"radio\"\n          id=\"search_term_filter_any\"\n          name=\"search_term_filter\"\n          value=\"any\"\n          [formControl]=\"form.controls.search_term_filter\">\n        Any of the keywords\n      </label>\n    </div>\n\n    <div>\n      <label class=\"radio-label\" for=\"search_term_filter_exact\">\n        <input \n          class=\"radio-input\"\n          type=\"radio\"\n          id=\"search_term_filter_exact\"\n          name=\"search_term_filter\"\n          value=\"exact\"\n          [formControl]=\"form.controls.search_term_filter\">\n        Exact phrase provided\n      </label>\n    </div>\n\n    <label class=\"form-label\" for=\"years_active\">Years Active</label>\n    <ui-select placeholder=\"Select years\" [items]=\"fields.years\" [formControl]=\"form.controls.years\"></ui-select>\n  </ui-panel>\n\n  <!-- Institution Receiving Award -->\n  <ui-panel title=\"Institution Receiving Award\">\n    <label class=\"form-label\" for=\"institution\">Institution Name</label>\n    <input \n      class=\"text input\"\n      type=\"text\"\n      id=\"institution\"\n      placeholder=\"Full or partial name\"\n      [formControl]=\"form.controls.institution\">\n\n    <label class=\"form-label\" for=\"pi_first_name\">Principal Investigator</label>\n    <div class=\"clearfix\">\n      <div class=\"six columns\">\n        <input \n          class=\"text input\"\n          type=\"text\"\n          id=\"pi_first_name\"\n          placeholder=\"First name or initial\"\n          [formControl]=\"form.controls.pi_first_name\">\n      </div>\n\n      <div class=\"six columns\" for=\"pi_last_name\">\n        <input\n          class=\"text input\"\n          type=\"text\"\n          id=\"pi_last_name\"\n          placeholder=\"Last name\"\n          [formControl]=\"form.controls.pi_last_name\">\n      </div>\n    </div>\n\n    <label class=\"form-label\" for=\"pi_orcid\">ORCiD ID</label>\n    <input\n      class=\"text input\"\n      type=\"text\"\n      for=\"pi_orcid\"\n      placeholder=\"nnnn-nnnn-nnnn-nnnn\"\n      [formControl]=\"form.controls.pi_orcid\">\n\n    <label class=\"form-label\" for=\"award_code\">Project Award Code</label>\n    <input\n      class=\"text input\"\n      id=\"award_code\"\n      type=\"text\"\n      placeholder=\"Award Code\"\n      [formControl]=\"form.controls.award_code\">\n\n    <label class=\"form-label\" for=\"countries\">Country</label>\n    <ui-select placeholder=\"Enter Countries\" [items]=\"fields.countries\" [formControl]=\"form.controls.countries\"></ui-select>\n\n    <label class=\"form-label\" for=\"states\">State/Territory</label>\n    <ui-select placeholder=\"Enter States/Territories\" [items]=\"fields.states\" [formControl]=\"form.controls.states\"></ui-select>\n\n    <label class=\"form-label\" for=\"cities\">City</label>\n    <ui-select placeholder=\"Enter Cities\" [items]=\"fields.cities\" [formControl]=\"form.controls.cities\"></ui-select>\n  </ui-panel>\n\n  <!-- Funding Organizations -->\n  <ui-panel title=\"Funding Organizations\">\n    <label class=\"sr-only\" for=\"funding_organizations\">Funding Organizations</label>\n    <div class=\"multiselect\">\n      <ui-treeview [root]=\"searchFields.fundingOrgs\" [formControl]=\"form.controls.funding_organizations\"></ui-treeview>\n    </div>\n  </ui-panel>\n\n  <!-- Cancer and Project Type -->\n  <ui-panel title=\"Cancer and Project Type\">\n\n    <label class=\"form-label\" for=\"cancer_types\">Cancer Types</label>\n    <ui-select placeholder=\"Select Cancer Types\" [items]=\"fields.cancer_types\" [formControl]=\"form.controls.cancer_types\"></ui-select>\n\n    <label class=\"form-label\" for=\"project_types\">Project Types</label>\n    <ui-select placeholder=\"Select Project Types\" [items]=\"fields.project_types\" [formControl]=\"form.controls.project_types\"></ui-select>\n  </ui-panel>\n\n  <!-- Common Scientific Outline - Research Area -->\n  <ui-panel title=\"Common Scientific Outline - Research Area\">\n    <label class=\"sr-only\" for=\"cso_research_areas\">CSO - Research Areas</label>\n\n    <div class=\"multiselect\">\n      <ui-treeview [root]=\"searchFields.csoAreas\" [formControl]=\"form.controls.cso_research_areas\"></ui-treeview>\n    </div>\n  </ui-panel>\n\n  <div class=\"text-right vertical-spacer\">\n    <button class=\"btn btn-default\" (click)=\"form.reset()\">Clear</button>\n    <button class=\"btn btn-primary\" (click)=\"submit()\">Search</button>\n  </div>\n</form>\n\n"

/***/ },

/***/ 687:
/***/ function(module, exports) {

module.exports = "<div class=\"clearfix\">\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Country\" [searchParam]=\"param\" group=\"country\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by CSO Category\" [searchParam]=\"param\" group=\"cso_code\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Cancer Type\" [searchParam]=\"param\" group=\"cancer_type_id\"></ui-chart>\n  </div>\n</div>\n\n<div class=\"clearfix\" style=\"display: none\">\n<!--  \n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Type\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Institution\"></ui-chart>\n  </div>\n\n  <div class=\"four columns\">\n    <ui-chart title=\"Projects by Funding Organization\"></ui-chart>\n  </div>\n\n-->\n</div>\n\n\n<div>\n  <button class=\"btn btn-small btn-default\">Email results</button>\n  <button class=\"btn btn-small btn-default\">Export results</button>\n</div>\n\n<br>\n\n<ui-table \n  [data]=\"projectData\" \n  [columns]=\"projectColumns\" \n  [loading]=\"loading\" \n  [pageSizes]=\"[10, 20, 30, 40, 50]\" \n  [numResults]=\"numProjects\" \n  (paginate)=\"paginate.emit($event)\" \n  (sort)=\"sort.emit($event)\">\n</ui-table>"

/***/ },

/***/ 688:
/***/ function(module, exports) {

module.exports = "<div class=\"four columns\">\n  <app-search-form (search)=\"updateResults($event)\"></app-search-form>\n</div>\n\n<div class=\"eight columns\">\n  <app-search-results [results]=\"results\" [analytics]=\"count\" [loading]=\"loading\" (paginate)=\"paginate($event)\" (sort)=\"sort($event)\" [param]=\"parameters\"></app-search-results>\n</div>"

/***/ },

/***/ 689:
/***/ function(module, exports) {

module.exports = "<div style=\"min-height: 300px; text-align: center; margin: 20px 0; position: relative; \">\n  <svg #svg viewBox=\"0 0 600 600\" style=\"position: absolute; top: 0; left: 0;\"></svg>\n  <br>\n  <i>{{ title }}</i>\n</div>"

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