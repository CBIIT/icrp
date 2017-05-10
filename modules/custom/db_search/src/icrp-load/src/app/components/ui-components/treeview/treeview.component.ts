import { Component, Input, Output, OnChanges, Renderer, ElementRef, forwardRef, EventEmitter } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { TreeNode } from './treenode';

@Component({
  selector: 'ui-treeview',
  template: '',
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => TreeViewComponent),
    multi: true
  }]
})
export class TreeViewComponent implements OnChanges, ControlValueAccessor {

  /** root node of tree */
  @Input() root: TreeNode;

  /** emits values upen selection */
  @Output() select: EventEmitter<TreeNode[]>;

  /** array of selected values */
  selectedValues: string[];

  /** array of selected nodes */
  selectedNodes: TreeNode[];

  /** Renderer helper methods */
  private _r: {
    setElementStyles: (el: HTMLElement, styles: Object) => void,
    setElementProperties: (el: HTMLElement, styles: Object) => void,
    setElementAttributes: (el: HTMLElement, styles: Object) => void,
    clearElementChildren: (el: HTMLElement) => void,
  }

  constructor(
    private _renderer: Renderer,
    private _elementRef: ElementRef,
  ) {
    this.root = null;
    this.selectedValues = [];
    this.selectedNodes = [];
    this.select = new EventEmitter<TreeNode[]>();

    /** initialize _renderer helper methods */
    this._r = {
      setElementStyles: (el: HTMLElement, styles: Object): void => {
        for (let key in styles) {
          _renderer.setElementStyle(el, key, styles[key]);
        }
      },
      setElementProperties: (el: HTMLElement, properties: Object): void => {
        for (let key in properties) {
          _renderer.setElementProperty(el, key, properties[key]);
        }
      },
      setElementAttributes: (el: HTMLElement, attributes: Object): void => {
        for (let key in attributes) {
          _renderer.setElementAttribute(el, key, attributes[key]);
        }
      }, 
      clearElementChildren: (el: HTMLElement) => {
        while (el.firstChild) {
          _renderer.invokeElementMethod(
            el, 'removeChild', [el.firstChild]
          );
        }
      }, 
    }
    /** end _renderer helper methods */
  }

  /** Creates a TreeView */
  createTree(node: TreeNode) {

    /** Update the array of selected nodes */
    this.updateSelectedNodes(node);

    /** Create the node's container */
    let div: HTMLDivElement = 
      this._renderer.createElement(node.el, 'div');

    /** Create the label */
    let label: HTMLLabelElement = 
      this._renderer.createElement(div, 'label');

    /** Create the checkbox */
    let checkbox: HTMLInputElement = 
      this._renderer.createElement(label, 'input');

    /** Set the label text */      
    this._renderer.createText(label, node.label);

    /** Toggle this node when is clicked */
    this._renderer.listen(
      checkbox, 'click', this.toggleNode.bind(this, node)
    );

    /** Set the type of input element */
    this._r.setElementAttributes(
      checkbox, {
        'type': 'checkbox'
      });

    /** Bind properties to node */      
    this._r.setElementProperties(
      checkbox, {
        'value': node.value,
        'checked': node.selected
      });

    /** Set appearance of each checkbox/label group */      
    this._r.setElementStyles(
      div, {
        'margin-left': '6px',
        '-webkit-touch-callout': 'none',
        '-webkit-user-select': 'none',
        '-khtml-user-select': 'none',
        '-moz-user-select': 'none',
        '-ms-user-select': 'none',
        'user-select': 'none'
      });

    this._r.setElementStyles(
      checkbox, {
        'margin-right': '2px'
      });

    this._r.setElementStyles(
      label, {
        'margin-bottom': '0',
        'font-weight': (node.children && node.children.length) ? 'bold': 'normal',
        'cursor': 'pointer'
      });

    if (node.children) {
      for (let child of node.children) {
        child.el = this._renderer.createElement(div, 'div');
        child.parent = node;
        this.createTree(child);
      }
    }

    this.propagateChange(this.selectedNodes.map(node => node.value));
  }

  
  /**
   * Toggles the selected status of the node
   * @param node 
   */
  toggleNode(node: TreeNode) {
    /** Toggle the selected property */
    node.selected = !node.selected;
    
    /** If this node has been deselected, deselect its parents as well */
    if (!node.selected) {
      let temp = node;
      while (temp.parent != null) {
        temp.parent.selected = false;
        temp = temp.parent;
      }
    }

    /** If this node has been selected, include its children in the selection */
    if (node.children) {
      let select = (root: TreeNode) => {
        for (let child of root.children || []) {
          child.selected = root.selected;
          select(child);
        }
      }

      select(node);
    }

    /** Clear the tree at the level of the node's parent */
    this._r.clearElementChildren(node.parent ? node.parent.el : node.el);

    /** Recreate this node, starting from its parent */
    this.createTree(node.parent || node);

    /** Emit only selected values */
    this.select.emit(this.getSelectedNodes());
  }

  getSelectedNodes(): TreeNode[] {

    let filterSelected = (root: TreeNode, selection: TreeNode[]) => {
      if (root.selected)
        selection.push(root);
      
      for (let child of root.children || []) {
        filterSelected(child, selection);
      }

      return selection;
    }

    return filterSelected(this.root, []);
  }

  /**
   * Update the array of selected nodes
   * @param node {TreeNode} The current node being compared against the list of selected values
   */
  updateSelectedNodes(node: TreeNode): void {
    
    /** The index of the node in this list */
    let index = this.selectedNodes.findIndex(
      (each: TreeNode) => each.value === node.value
    );

    /** If the node is selected and is not yet in the array of selected nodes,
     *  add it to the array */
    if (node.selected && index === -1) {
      this.selectedNodes.push(node);
    }

    /** If the node is not selected and is contained within the array of selected nodes, 
     *  remove it from the array */
    else if (!node.selected && index > -1) {
      this.selectedNodes.splice(index, 1);
    }
  }

  /**
   * Select only nodes that have values found in the specified array
   * 
   * @param node {TreeNode} The current node
   * @param values {(string|number)[]} The values which the nodes are checked against
   */
  selectNodes(node: TreeNode, values: (string|number)[]): void {
    node.selected = values.indexOf(node.value) > -1;

    if (node.children) {
      for (let child of node.children) {
        this.selectNodes(child, values);
      }
    }
  }

  /**
   * Rebuild the tree
   */
  rebuildTree() {
    this.root = this.root || { label: null, value: null };
    this.root.parent = null;
    this.root.el = this._elementRef.nativeElement;
    this._r.clearElementChildren(this._elementRef.nativeElement);
    this.createTree(this.root);
  }

  /**
   * Rebuild the tree on changes
   */
  ngOnChanges() {
    this.rebuildTree();
  }

  /**
   * Select nodes that have values found in the specified array
   * @param values {(string|number)[]} The values to select
   */
  writeValue(values: (string|number)[]) {
    /** select nodes */
    this.selectNodes(this.root, values || []);
    this.rebuildTree();
  }

  propagateChange(_: any) { }
  registerOnTouched() { }
  registerOnChange(fn) {
    this.propagateChange = fn;
  }
}
