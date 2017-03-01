export interface TreeNode {
    value: string,
    label: string,
    children?: TreeNode[],
    selected?: boolean,
    showChildren?: boolean,
    parent?: TreeNode,
    el?: HTMLElement
}