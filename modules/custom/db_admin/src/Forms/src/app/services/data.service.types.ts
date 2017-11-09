export interface Field {
  value: string;
  label: string;
  country?: string  | null;
  currency?: string | null;
}

export interface ApiFields {
  funding_organizations: any[];
  partners: Field[],
  countries: Field[],
  currencies: Field[],
}

export interface ApiStatusMessage {
  [type: string]: string;
}

export interface FundingOrganizationParameters {
  partner: string;
  memberType: string;
  name: string;
  abbreviation: string;
  organizationType: string;
  latitude: number;
  longitude: number;
  country: string;
  currency: string;
  note: string;
  annualizedFunding: boolean;
}