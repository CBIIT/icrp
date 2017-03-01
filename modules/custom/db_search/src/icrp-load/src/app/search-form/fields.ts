export interface Fields {
    years?: { "value": number, "label": string }[],
    cities?: { "value": string, "label": string, "group": string, "supergroup": string }[],
    states?: { "value": string, "label": string, "group": string }[],
    countries?: { "value": string, "label": string }[],
    funding_organizations?: { "value": number, "label": string, "group": string, "supergroup": string }[],
    cancer_types?: { "value": number, "label": string }[],
    project_types?: { "value": number, "label": string }[],
    cso_research_areas?: { "value": number, "label": string, "group": string, "supergroup": string }[]
}