<?php

namespace Drupal\dbug;

use Drupal\Core\Render\Markup;

/**
 * Implementation of dBug for Business Rules module.
 *
 * The main modification is to return a render array instead of echo.
 *
 * AUTHOR
 * ===========
 * Yuri Seki
 * yuriseki@gmail.com
 *
 * @see https://github.com/ospinto/dBug
 *
 * ============================================================================
 * dBug original comments.
 * ============================================================================
 *
 * AUTHOR
 * =============
 * Kwaku Otchere
 * ospinto@hotmail.com
 *
 * AFTERMARKET HACKER
 * ==================
 * Josh Sherman
 * josh@crowdsavings.com
 *
 * Thanks to Andrew Hewitt (rudebwoy@hotmail.com) for the idea and suggestion
 *
 * All the credit goes to ColdFusion's brilliant cfdump tag
 * Hope the next version of PHP can implement this or have something similar
 * I love PHP, but var_dump BLOWS!!!
 *
 * FOR DOCUMENTATION AND MORE EXAMPLES: VISIT http://dbug.ospinto.com
 *
 *
 * PURPOSE
 * =============
 * Dumps/Displays the contents of a variable in a colored tabular format
 * Based on the idea, javascript and css code of Macromedia's ColdFusion cfdump
 * tag.
 * A much better presentation of a variable's contents than PHP's var_dump and
 * print_r functions.
 *
 *
 * USAGE
 * =============
 * new dBug ( variable [,forceType] );
 * example:
 * new dBug ( $myVariable );
 *
 *
 * if the optional "forceType" string is given, the variable supplied to the
 * function is forced to have that forceType type.
 * example: new dBug( $myVariable , "array" );
 * will force $myVariable to be treated and dumped as an array type,
 * even though it might originally have been a string type, etc.
 *
 * NOTE!
 * ==============
 * forceType is REQUIRED for dumping an xml string or xml file
 * new dBug ( $strXml, "xml" );
 */
class Dbug {

  /**
   * Variable $xmlDepth.
   *
   * @var array
   */
  public $xmlDepth = [];

  /**
   * Variable $xmlCData.
   *
   * @var string
   */
  public $xmlCData;

  /**
   * Variable $xmlSData.
   *
   * @var string
   */
  public $xmlSData;

  /**
   * Variable $xmlDData.
   *
   * @var string
   */
  public $xmlDData;

  /**
   * Variable $xmlCount.
   *
   * @var int
   */
  public $xmlCount = 0;

  /**
   * Variable $xmlAttrib.
   *
   * @var string
   */
  public $xmlAttrib;

  /**
   * Variable $xmlName.
   *
   * @var string
   */
  public $xmlName;

  /**
   * Variable $arrType.
   *
   * @var array
   */
  public $arrType = ["array", "object", "resource", "boolean", "NULL"];

  /**
   * Variable $bInitialized.
   *
   * @var bool
   */
  public $bInitialized = FALSE;

  /**
   * Variable $bCollapsed.
   *
   * @var bool
   */
  public $bCollapsed = FALSE;

  /**
   * Variable $arrHistory.
   *
   * @var array
   */
  public $arrHistory = [];

  /**
   * The output debug table.
   *
   * @var array
   */
  public $output = [];

  /**
   * BusinessRulesDbug constructor.
   *
   * @param mixed $var
   *   The variable to debug.
   * @param string $forceType
   *   Variable type to be forced.
   * @param bool $bCollapsed
   *   Collapse the result?
   */
  public function __construct($var, $forceType = "", $bCollapsed = FALSE) {
    // Include js and css scripts.
    if (!defined('BDBUGINIT')) {
      define("BDBUGINIT", TRUE);
    }
    // Array of variable types that can be "forced".
    $arrAccept = [
      "array",
      "object",
      "xml",
    ];

    $this->bCollapsed = $bCollapsed;
    if (in_array($forceType, $arrAccept)) {
      $this->{"varIs" . ucfirst($forceType)}($var);
    }
    else {
      $this->checkType($var);
    }

  }

  /**
   * Return the debug output.
   *
   * @param mixed $var
   *   The variable to debug.
   * @param string $forceType
   *   Variable type to be forced.
   * @param bool $bCollapsed
   *   Collapse the result?
   *
   * @return string
   *   The variable string representation.
   */
  public static function debug($var, $forceType = "", $bCollapsed = FALSE) {
    $dbug   = new self($var, $forceType, $bCollapsed);
    $output = $dbug->output;
    $output = implode(chr(10), $output);

    return Markup::create($output);
  }

  /**
   * Get the variable name.
   *
   * @return string
   *   The variable name.
   */
  protected function getVariableName() {
    $arrBacktrace = debug_backtrace();

    // Possible 'included' functions.
    $arrInclude = ["include", "include_once", "require", "require_once"];

    // Check for any included/required files. if found, get array of the last
    // included file (they contain the right line numbers).
    for ($i = count($arrBacktrace) - 1; $i >= 0; $i--) {
      $arrCurrent = $arrBacktrace[$i];
      if (array_key_exists("function", $arrCurrent) &&
        (in_array($arrCurrent["function"], $arrInclude) || (0 != strcasecmp($arrCurrent["function"], "dbug")))
      ) {
        continue;
      }
      $arrFile = $arrCurrent;
      break;
    }
    if (isset($arrFile)) {
      $arrLines = file($arrFile["file"]);
      $code     = $arrLines[($arrFile["line"] - 1)];

      // Find call to dBug class.
      preg_match('/\bnew dBug\s*\(\s*(.+)\s*\);/i', $code, $arrMatches);
      return $arrMatches[1];
    }
    return "";
  }

  /**
   * Create the main table header.
   *
   * @param string $type
   *   The header type.
   * @param string $header
   *   The header.
   * @param int $colspan
   *   The colspan.
   */
  protected function makeTableHeader($type, $header, $colspan = 2) {
    if (!$this->bInitialized) {
      $header             = $this->getVariableName() . " (" . $header . ")";
      $this->bInitialized = TRUE;
    }
    $str_i          = ($this->bCollapsed) ? "style=\"font-style:italic\" " : "";
    $this->output[] = "<table cellspacing=2 cellpadding=3 class=\"dBug_" . $type . "\">
				<tr>
					<td " . $str_i . "class=\"dBug_" . $type . "Header\" colspan=" . $colspan . " onClick='dBug_toggleTable(this)'>" . $header . "</td>
				</tr>";
  }

  /**
   * Create the table row header.
   *
   * @param string $type
   *   The type.
   * @param string $header
   *   The header.
   */
  protected function makeTdHeader($type, $header) {
    $str_d          = ($this->bCollapsed) ? " style=\"display:none\"" : "";
    $this->output[] = "<tr" . $str_d . ">
				<td valign=\"top\" onClick='dBug_toggleRow(this)' class=\"dBug_" . $type . "Key\">" . $header . "</td>
				<td>";
  }

  /**
   * Close table row.
   *
   * @return string
   *   The td close tag.
   */
  protected function closeTdRow() {
    return "</td></tr>\n";
  }

  /**
   * Error.
   *
   * @param string $type
   *   The error type.
   *
   * @return string
   *   The error description.
   */
  protected function error($type) {
    $error = "Error: Variable cannot be a";
    // This just checks if the type starts with a vowel or "x" and displays
    // either "a" or "an".
    if (in_array(substr($type, 0, 1), ["a", "e", "i", "o", "u", "x"])) {
      $error .= "n";
    }
    return ($error . " " . $type . " type");
  }

  /**
   * Check variable type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function checkType($var) {
    switch (gettype($var)) {
      case "resource":
        $this->varIsResource($var);
        break;

      case "object":
        $this->varIsObject($var);
        break;

      case "array":
        $this->varIsArray($var);
        break;

      case "NULL":
        $this->varIsNull();
        break;

      case "boolean":
        $this->varIsBoolean($var);
        break;

      default:
        $var            = ($var == "") ? "[empty string]" : $var;
        $this->output[] = "<table cellspacing=0><tr>\n<td>" . $var . "</td>\n</tr>\n</table>\n";
        break;
    }
  }

  /**
   * If variable is a NULL type.
   */
  protected function varIsNull() {
    $this->output[] = "NULL";
  }

  /**
   * If variable is a boolean type.
   *
   * @param bool $var
   *   The variable.
   */
  protected function varIsBoolean($var) {
    $var            = ($var == 1) ? "TRUE" : "FALSE";
    $this->output[] = $var;
  }

  /**
   * If variable is an array type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function varIsArray($var) {
    $var_ser = serialize($var);
    array_push($this->arrHistory, $var_ser);
    $this->makeTableHeader("array", "array");
    if (is_array($var)) {
      foreach ($var as $key => $value) {
        $this->makeTdHeader("array", $key);
        // Check for recursion.
        if (is_array($value)) {
          $var_ser = serialize($value);
          if (in_array($var_ser, $this->arrHistory, TRUE)) {
            $value = "*RECURSION*";
          }
        }
        if (in_array(gettype($value), $this->arrType)) {
          $this->checkType($value);
        }
        else {
          $value          = (trim($value) == "") ? "[empty string]" : $value;
          $this->output[] = $value;
        }
        $this->output[] = $this->closeTdRow();
      }
    }
    else {
      $this->output[] = "<tr><td>" . $this->error("array") . $this->closeTdRow();
    }
    array_pop($this->arrHistory);
    $this->output[] = "</table>";
  }

  /**
   * If variable is an object type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function varIsObject($var) {
    $var_ser = serialize($var);
    array_push($this->arrHistory, $var_ser);
    $this->makeTableHeader("object", "object");
    if (is_object($var)) {
      $arrObjVars = get_object_vars($var);
      foreach ($arrObjVars as $key => $value) {
        $value = (!is_object($value) && !is_array($value) && trim($value) == "") ? "[empty string]" : $value;
        $this->makeTdHeader("object", $key);
        // Check for recursion.
        if (is_object($value) || is_array($value)) {
          $var_ser = serialize($value);
          if (in_array($var_ser, $this->arrHistory, TRUE)) {
            $value = (is_object($value)) ? "*RECURSION* -> $" . get_class($value) : "*RECURSION*";
          }
        }
        if (in_array(gettype($value), $this->arrType)) {
          $this->checkType($value);
        }
        else {
          $this->output[] = $value;
        }
        $this->output[] = $this->closeTdRow();
      }
      $arrObjMethods = get_class_methods(get_class($var));
      foreach ($arrObjMethods as $key => $value) {
        $this->makeTdHeader("object", $value);
        $this->output[] = "[function]" . $this->closeTdRow();
      }
    }
    else {
      $this->output[] = "<tr><td>" . $this->error("object") . $this->closeTdRow();
    }
    array_pop($this->arrHistory);
    $this->output[] = "</table>";
  }

  /**
   * If variable is a resource type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function varIsResource($var) {
    $this->makeTableHeader("resourceC", "resource", 1);
    $this->output[] = "<tr>\n<td>\n";
    switch (get_resource_type($var)) {
      case "fbsql result":
      case "mssql result":
      case "msql query":
      case "pgsql result":
      case "sybase-db result":
      case "sybase-ct result":
      case "mysql result":
        $db = current(explode(" ", get_resource_type($var)));
        $this->varIsDbResource($var, $db);
        break;

      case "gd":
        $this->varIsGdResource($var);
        break;

      case "xml":
        $this->varIsXmlResource($var);
        break;

      default:
        $this->output[] = get_resource_type($var) . $this->closeTdRow();
        break;
    }
    $this->output[] = $this->closeTdRow() . "</table>\n";
  }

  /**
   * If variable is a database resource type.
   *
   * @param mixed $var
   *   The variable.
   * @param string $db
   *   The database.
   */
  protected function varIsDbResource($var, $db = "mysql") {
    if ($db == "pgsql") {
      $db = "pg";
    }
    if ($db == "sybase-db" || $db == "sybase-ct") {
      $db = "sybase";
    }
    $arrFields = ["name", "type", "flags"];
    $numrows   = call_user_func($db . "_num_rows", $var);
    $numfields = call_user_func($db . "_num_fields", $var);
    $this->makeTableHeader("resource", $db . " result", $numfields + 1);
    $this->output[] = "<tr><td class=\"dBug_resourceKey\">&nbsp;</td>";
    for ($i = 0; $i < $numfields; $i++) {
      $field_header = "";
      for ($j = 0; $j < count($arrFields); $j++) {
        $db_func = $db . "_field_" . $arrFields[$j];
        if (function_exists($db_func)) {
          $fheader = call_user_func($db_func, $var, $i) . " ";
          if ($j == 0) {
            $field_name = $fheader;
          }
          else {
            $field_header .= $fheader;
          }
        }
      }
      $field[$i]      = call_user_func($db . "_fetch_field", $var, $i);
      $this->output[] = "<td class=\"dBug_resourceKey\" title=\"" . $field_header . "\">" . $field_name . "</td>";
    }
    $this->output[] = "</tr>";
    for ($i = 0; $i < $numrows; $i++) {
      $row            = call_user_func($db . "_fetch_array", $var, constant(strtoupper($db) . "_ASSOC"));
      $this->output[] = "<tr>\n";
      $this->output[] = "<td class=\"dBug_resourceKey\">" . ($i + 1) . "</td>";
      for ($k = 0; $k < $numfields; $k++) {
        $tempField      = $field[$k]->name;
        $field_row      = $row[($field[$k]->name)];
        $field_row      = ($field_row == "") ? "[empty string]" : $field_row;
        $this->output[] = "<td>" . $field_row . "</td>\n";
      }
      $this->output[] = "</tr>\n";
    }
    $this->output[] = "</table>";
    if ($numrows > 0) {
      call_user_func($db . "_data_seek", $var, 0);
    }
  }

  /**
   * If variable is an image/gd resource type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function varIsGdResource($var) {
    $this->makeTableHeader("resource", "gd", 2);
    $this->makeTdHeader("resource", "Width");
    $this->output[] = imagesx($var) . $this->closeTdRow();
    $this->makeTdHeader("resource", "Height");
    $this->output[] = imagesy($var) . $this->closeTdRow();
    $this->makeTdHeader("resource", "Colors");
    $this->output[] = imagecolorstotal($var) . $this->closeTdRow();
    $this->output[] = "</table>";
  }

  /**
   * If variable is an xml type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function varIsXml($var) {
    $this->varIsXmlResource($var);
  }

  /**
   * If variable is an xml resource type.
   *
   * @param mixed $var
   *   The variable.
   */
  protected function varIsXmlResource($var) {
    $xml_parser = xml_parser_create();
    xml_parser_set_option($xml_parser, XML_OPTION_CASE_FOLDING, 0);
    xml_set_element_handler($xml_parser, [&$this, "xmlStartElement"], [
      &$this,
      "xmlEndElement",
    ]);
    xml_set_character_data_handler($xml_parser, [&$this, "xmlCharacterData"]);
    xml_set_default_handler($xml_parser, [&$this, "xmlDefaultHandler"]);
    $this->makeTableHeader("xml", "xml document", 2);
    $this->makeTdHeader("xml", "xmlRoot");
    // Attempt to open xml file.
    $bFile = (!($fp = @fopen($var, "r"))) ? FALSE : TRUE;
    // Read xml file.
    if ($bFile) {
      while ($data = str_replace("\n", "", fread($fp, 4096))) {
        $this->xmlParse($xml_parser, $data, feof($fp));
      }
    }
    // If xml is not a file, attempt to read it as a string.
    else {
      if (!is_string($var)) {
        $this->output[] = $this->error("xml") . $this->closeTdRow() . "</table>\n";
        return;
      }
      $data = $var;
      $this->xmlParse($xml_parser, $data, 1);
    }
    $this->output[] = $this->closeTdRow() . "</table>\n";
  }

  /**
   * Parse xml.
   *
   * @param string $xml_parser
   *   The parser.
   * @param string $data
   *   The data.
   * @param string $bFinal
   *   The final.
   */
  protected function xmlParse($xml_parser, $data, $bFinal) {
    if (!xml_parse($xml_parser, $data, $bFinal)) {
      die(sprintf("XML error: %s at line %d\n",
        xml_error_string(xml_get_error_code($xml_parser)),
        xml_get_current_line_number($xml_parser)));
    }
  }

  /**
   * Xml: inititiated when a start tag is encountered.
   *
   * @param string $parser
   *   The parser.
   * @param string $name
   *   The name.
   * @param string $attribs
   *   The attributes.
   */
  protected function xmlStartElement($parser, $name, $attribs) {
    $this->xmlAttrib[$this->xmlCount] = $attribs;
    $this->xmlName[$this->xmlCount]   = $name;
    $this->xmlSData[$this->xmlCount]  = '$this->makeTableHeader("xml","xml element",2);';
    $this->xmlSData[$this->xmlCount] .= '$this->makeTDHeader("xml","xmlName");';
    $this->xmlSData[$this->xmlCount] .= '$this->output[] = "<strong>' . $this->xmlName[$this->xmlCount] . '</strong>".$this->closeTDRow();';
    $this->xmlSData[$this->xmlCount] .= '$this->makeTDHeader("xml","xmlAttributes");';
    if (count($attribs) > 0) {
      $this->xmlSData[$this->xmlCount] .= '$this->varIsArray($this->xmlAttrib[' . $this->xmlCount . ']);';
    }
    else {
      $this->xmlSData[$this->xmlCount] .= '$this->output[] = "&nbsp;";';
    }
    $this->xmlSData[$this->xmlCount] .= '$this->output[] = $this->closeTDRow();';
    $this->xmlCount++;
  }

  /**
   * Xml: initiated when an end tag is encountered.
   *
   * @param string $parser
   *   The parser.
   * @param string $name
   *   The name.
   */
  protected function xmlEndElement($parser, $name) {
    for ($i = 0; $i < $this->xmlCount; $i++) {
      eval($this->xmlSData[$i]);
      $this->makeTdHeader("xml", "xmlText");
      $this->output[] = (!empty($this->xmlCData[$i])) ? $this->xmlCData[$i] : "&nbsp;";
      $this->output[] = $this->closeTdRow();
      $this->makeTdHeader("xml", "xmlComment");
      $this->output[] = (!empty($this->xmlDData[$i])) ? $this->xmlDData[$i] : "&nbsp;";
      $this->output[] = $this->closeTdRow();
      $this->makeTdHeader("xml", "xmlChildren");
      unset($this->xmlCData[$i], $this->xmlDData[$i]);
    }
    $this->output[] = $this->closeTdRow();
    $this->output[] = "</table>";
    $this->xmlCount = 0;
  }

  /**
   * Xml: initiated when text between tags is encountered.
   *
   * @param string $parser
   *   The parser.
   * @param string $data
   *   The data.
   */
  protected function xmlCharacterData($parser, $data) {
    $count = $this->xmlCount - 1;
    if (!empty($this->xmlCData[$count])) {
      $this->xmlCData[$count] .= $data;
    }
    else {
      $this->xmlCData[$count] = $data;
    }
  }

  /**
   * Xml: initiated when a comment or other miscellaneous texts is encountered.
   *
   * @param string $parser
   *   The parser.
   * @param string $data
   *   The data.
   */
  protected function xmlDefaultHandler($parser, $data) {
    // Strip '<!--' and '-->' off comments.
    $data  = str_replace(["&lt;!--", "--&gt;"], "", htmlspecialchars($data));
    $count = $this->xmlCount - 1;
    if (!empty($this->xmlDData[$count])) {
      $this->xmlDData[$count] .= $data;
    }
    else {
      $this->xmlDData[$count] = $data;
    }
  }

}
