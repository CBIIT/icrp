<?php

namespace Drupal\feeds\Exception;

use RuntimeException;

/**
 * Exception thrown if the feed has not been updated since the last run.
 */
class NotModifiedException extends RuntimeException {}
