export interface Column {
    value: string,
    label: string,
    link?: string,
    tooltip?: string,
    sort?: "asc" | "desc"
}