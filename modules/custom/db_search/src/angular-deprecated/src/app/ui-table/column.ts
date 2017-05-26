export interface Column {
    value: string,
    label: string,
    link?: string,
    tooltip?: string,
    sortAscending?: (boolean | null)
}