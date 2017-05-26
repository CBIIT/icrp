export interface TreeNode {
    value: string | number,
    label: string,
    children?: TreeNode[],
    selected?: boolean,
    showChildren?: boolean,
    parent?: TreeNode,
    el?: HTMLElement
}