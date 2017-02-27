import { Component, OnInit, Input, OnChanges, Renderer, ElementRef, ViewChild, AfterViewInit, forwardRef } from '@angular/core';
import { ControlValueAccessor, NG_VALUE_ACCESSOR } from '@angular/forms';
import { TreeNode } from './treenode';

@Component({
  selector: 'ui-treeview',
  templateUrl: './ui-treeview.component.html',
  styleUrls: ['./ui-treeview.component.css'],
  providers: [{
    provide: NG_VALUE_ACCESSOR,
    useExisting: forwardRef(() => UiTreeviewComponent),
    multi: true
  }]
})
export class UiTreeviewComponent implements OnChanges, ControlValueAccessor {
  
  /** Reference to root of tree */
  @ViewChild('tree') tree;

  /** Root node of tree */
  @Input() root: TreeNode;

  selectedValues: string[];

  constructor(private renderer: Renderer) {
    this.selectedValues = [];
  }

  writeValue(values: string[]) {
    this.selectTreeValues(this.root, values || []);

    this.clearChildren(this.tree.nativeElement);
    this.createTree(this.root, this.tree.nativeElement, null, false, true);
  }

  propagateChange(_: any) { };
  registerOnTouched() { }
  registerOnChange(fn) {
    this.propagateChange = fn;
  }

  selectTreeValues(root: TreeNode, values: string[]) {
    root.selected = (values.indexOf(root.value) >= 0);

    if (root.children && root.children.length) {
      for (let child of root.children) {
        this.selectTreeValues(child, values)
      }
    }
  }

  /** Recursively creates dom nodes related to tree - on change, rebuilds the portion of the tree that changed */
  createTree(node: TreeNode, el: HTMLElement, parent: TreeNode, selected: boolean, replace: boolean) {

    /** Initialize the selected state of the node */
    node.selected = selected;

    node.parent = parent;

    if (node.selected && node.value != null && this.selectedValues.indexOf(node.value) === -1) {
      this.selectedValues.push(node.value);

    } else if (!node.selected) {
      let index = this.selectedValues.indexOf(node.value)
      
      if (index >= 0)
        this.selectedValues.splice(index, 1)
    }

    /** Determine if node has children */
    let hasChildren: boolean = node.children && node.children.length > 0;

    /** Create container for node label */
    let div: HTMLElement = replace ? el : this.renderer.createElement(
      el,
      'div'
    )

    /** Set default margin for container */    
    this.renderer.setElementStyle(
      div,
      'margin-left',
      '4px'
    )

    this.renderer.setElementClass(
      div,
      'noselect',
      true
    )

    /** Create checkboxes/label group if this is a leaf node */
//    if (!hasChildren) {
      
      /** Create label */
      let label = this.renderer.createElement(
        div,
        'label'
      )

      
      /** Create checkbox */
      let checkbox = this.renderer.createElement(
        label,
        'input'
      )

      /** Set value of checkbox */      
      this.renderer.setElementProperty(
        checkbox,
        'value',
        node.value
      )

      /** Bind checked property to node selection value */      
      this.renderer.setElementProperty(
        checkbox,
        'checked',
        node.selected
      )

      /** When this checkbox is clicked, rebuild its contents */
      this.renderer.listen(
        checkbox,
        'click',
        (event) => this.toggleNode(node, div)
      )      

      /** Set the type of input element */
      this.renderer.setElementAttribute(
        checkbox,
        'type',
        'checkbox'
      )

      /** Create label text (after adding checkbox) */      
      this.renderer.createText(
        label,
        node.label
      )

      /** Set appearance of each checkbox/label group */      
      this.renderer.setElementStyle(
        checkbox,
        'margin-right',
        '2px'
      )

      node.el = checkbox;


      this.renderer.setElementStyle(
        label,
        'margin-bottom',
        '0'
      )

      this.renderer.setElementStyle(
        label,
        'font-weight',
        hasChildren ? 'bold': 'normal'
      )

      this.renderer.setElementStyle(
        label,
        'cursor',
        'pointer'
      )
//    }
    
    /** If this is not a leaf node, simply create a span 
    else {
      
      /** Span containing node label 
      let span = this.renderer.createElement(
        div,
        'span'
      )*/

      /** Add text to span 
      this.renderer.createText(
        span,
        node.label
      )*/

      /** When this span is clicked, rebuild its contents 
      this.renderer.listen(
        span,
        'click',
        (event) => this.toggleNode(node, div)
      )*/

      /** Add style to span */
/*      this.renderer.setElementStyle(
        span,
        'font-weight',
        'bold'
      )

      this.renderer.setElementStyle(
        span,
        'cursor',
        'pointer'
      )

      this.renderer.setElementStyle(
        span,
        'display',
        'inline-block'
      )

      this.renderer.setElementStyle(
        span,
        'margin-top',
        '2px'
      )
    }*/


    if (hasChildren) {
      for (let child of node.children) {
        this.createTree(child, div, node, selected, false);
      }
    }

    this.propagateChange(this.selectedValues);
  }

  toggleNode(node: TreeNode, el: HTMLElement) {
    this.clearChildren(el);
    this.createTree(node, el, node.parent, !node.selected, true);
//    console.log('node parent', node.parent);
    node.parent.selected = false;

      this.renderer.setElementProperty(
        node.parent.el,
        'checked',
        node.parent.selected
      )    
  }


  clearChildren(el: HTMLElement) {
    while (el.firstChild) {
      this.renderer.invokeElementMethod(
        el,
        'removeChild',
        [el.firstChild]
      )
    }
  }

  ngOnChanges() {
    this.createTree(this.root, this.tree.nativeElement, null, false, true);
  }
}
