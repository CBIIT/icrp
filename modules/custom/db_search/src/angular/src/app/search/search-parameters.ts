export interface SearchParameters {
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
  cancer_types?: string,
  project_types?: string,
  cso_research_areas?: string,
}

export interface SortPaginateParameters {
  search_id: number,
  sort_column: string,
  sort_type: string,
  page_number: number,
  page_size: number,  
}