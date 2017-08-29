<?php

/**
 * @file
 * Drush integration for Snippet manager module.
 */

/**
 * Implements hook_drush_command().
 */
function snippet_manager_drush_command() {
  $items['code-mirror-download'] = [
    'description' => dt('Download and install CodeMirror library.'),
    'bootstrap' => DRUSH_BOOTSTRAP_DRUSH,
    'aliases' => ['c-m-d'],
  ];
  return $items;
}

/**
 * Command to download theCodeMirror library.
 */
function drush_snippet_manager_code_mirror_download() {

  $version = '5.14.2';
  $download_url = "https://github.com/codemirror/CodeMirror/archive/$version.zip";

  $libraries_dir = 'libraries';
  $cm_dir = $libraries_dir . '/codemirror';
  $temp_dir = drush_tempdir();
  $temp_cm_dir = "$temp_dir/CodeMirror-$version";
  $cm_archive_path = "$temp_dir/code-mirror-$version.zip";

  // Check if libraries directory does exist.
  if (!is_dir($libraries_dir)) {
    return drush_set_error('snippet_manager', dt('Directory @libraries_dir does not exist.', ['@libraries_dir' => $libraries_dir]));
  }

  // Check install directory already exists.
  if (is_dir($cm_dir)) {
    return drush_set_error('snippet_manager', dt('Install location @cm_dir already exists.', ['@cm_dir' => $cm_dir]));
  }

  // Download the library.
  drush_shell_exec('wget --timeout=15 -O %s %s', $cm_archive_path, $download_url);

  // Check if library was downloaded successfully.
  if (!_drush_snippet_manager_check_file($cm_archive_path)) {
    return drush_set_error('snippet_manager', dt('Could not download CodeMirror library from GitHub.'));
  }

  // Extract an archive.
  if (!drush_tarball_extract($cm_archive_path, $temp_dir)) {
    return drush_set_error('snippet_manager', dt('Could not extract files from archive.'));
  }

  // Move library to permanent location.
  if (!drush_move_dir($temp_cm_dir, $cm_dir, TRUE)) {
    return drush_set_error('snippet_manager', dt('Could not create @cm_dir directory.', ['@cm_dir' => $cm_dir]));
  }

  // Register archive file for deletion.
  drush_register_file_for_deletion($cm_archive_path);

  // Check if the library has installed.
  if (is_dir($cm_dir)) {
    drush_log(dt('CodeMirror library has been installed in @path', ['@path' => $cm_dir]), 'success');
  }
  else {
    return drush_set_error('snippet_manager', dt('Drush was unable to install the CodeMirror library.'));
  }

}

/**
 * Check whether a given file is not empty.
 */
function _drush_snippet_manager_check_file($file) {
  if (file_exists($file)) {
    clearstatcache();
    $stat = stat($file);
    if ($stat['size'] > 0) {
      return TRUE;
    }
  }
  return FALSE;
}
