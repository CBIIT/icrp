<?php

namespace Drupal\db_search_api\Controller;


class TreeBuilder {
  /**
  * Creates a tree from an array of data that contains groups indexed by columns
  * @param array $data - an array containing value-label pairs, as well as group identifiers
  * @param int $height - the current level of the tree being generated
  * @param string $prefix - the group prefix
  * @param string $format - the formatting string used to generate group node labels
  * @return An array containining search parameters
  */
  public static function createTree(array $data, int $height, string $prefix = 'group_', string $format = '%s'): array {

    // get group column containing root elements
    $group_key = $prefix . $height;

    // get unique group names from column
    $group_names = array_unique(array_column($data, $group_key));

    // populate the current level of the tree with group nodes
    $root = array_map(function($group_name) use ($format) {
      return [
        'value'    => $group_name,
        'label'    => sprintf($format, $group_name),
        'children' => [],
      ];
    }, array_values($group_names));

    // populate each node's children
    foreach($root as &$node) {

      // fetch rows with groups filtered by the current node's value
      $rows = array_filter($data, function($row) use ($group_key, $node) {
        return $row[$group_key] == $node['value'];
      });

      // if this is not a leaf node, generate a subtree with values based on the child group column
      if ($height > 1) {
        $node['children'] = self::createTree($rows, $height - 1, $prefix, $format);
      }

      // if this is a leaf node, generate children with values based on the contents of the 'value' column
      else {
        foreach($rows as $row) {
          array_push($node['children'], [
            'value' => $row['value'],
            'label' => $row['label'],
            'children' => [],
          ]);
        }
      }
    }

    return $root;
  }

  /**
   * Flattens nodes with only one child
   *
   */
  public static function flattenTree(&$node) {

    $children = &$node['children'];

    if (count($children) === 1 && count($children[0]['children']) === 0) {
      $node = &$children[0];
      $children = &$node['children'];
    }

    foreach($children as &$child) {
      $child = self::flattenTree($child);
    }

    return $node;
  }

  public static function countChildren($node) {
    $children = $node['children'];
    $total = count($children);

    foreach($children as $child) {
      $total += self::countChildren($child);
    }

    return $total;
  }

  public static function sortTree(&$node, bool $compare_lengths = true) {
    usort($node['children'], function ($a, $b) {
      $countA = self::countChildren($a);
      $countB = self::countChildren($b);

      if ($compare_lengths && $countA != $countB)
        return $countB - $countA;

      return strcasecmp($a['label'], $b['label']);
    });

    foreach($node['children'] as &$child) {
      $child = self::sortTree($child, $compare_lengths);
    }

    return $node;
  }
}
