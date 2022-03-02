<?php

namespace Drupal\data_load\Services;
use \Exception;

class InvalidFileFormatException extends Exception { }

class CSVReader {

    private $fd = null;
    private $numColumns = null;
    private $delimiter = null;
    private $BUFFERSIZE = 8192;

    private $debug_fd = null;

    public function __construct($filePath, $numColumns, $delimiter) {
        $this->fd = fopen($filePath, 'rb') or die("Could not open file " . $filePath);
        $this->numColumns = $numColumns;
        $this->delimiter = $delimiter;

        // $this->debug_fd = fopen('/var/www/html/modules/custom/data_load/src/Controller/debug.txt', 'w') or die("Could not open debug file");
    }

    public function close() {
        fclose($this->fd);
        // fclose($this->debug_fd);
    }

    public function checkHeaders() {

        $headerArr = $this->getNextLine();

        if ($headerArr === false || count($headerArr) !== $this->numColumns) {
            throw new InvalidFileFormatException('The file must have ' . $this->numColumns . ' columns.');
        }
    }

    public function getNextLine() {
        $line = '';
        while (true) {
            // Read from file until \r\n is reached, or buffer is full (0 = default length = 8192 Bytes), or EOF is reached.
            $lineCandidate = stream_get_line($this->fd, $this->BUFFERSIZE, "\r\n");

            if ($lineCandidate !== false) {
                // fwrite($this->debug_fd, 'Line candidate: ' . $lineCandidate . '\n');

                // append what was read to running line. Multiple reads will be necessary for rows longer than default length.
                $line .= $lineCandidate;

                // if (preg_match('/\|$/', $line)) {
                    // Count the number of delimiters in the line to see if it matches the column number
                    $numDelimiters = substr_count($line, $this->delimiter);
                    if ($numDelimiters < $this->numColumns-1) {
                        continue;
                        // if (strlen($lineCandidate) === $this->BUFFERSIZE) {
                        //     // The text parsed so far ends with a the delimiter, but this is not the end of the line - a rare case where the buffer is full and the read in text ends with the delimiter.
                        //     continue;
                        // } else {
                        //     // A line was read completely and it does not have a full set of columns.
                        //     throw new InvalidFileFormatException('Unexpected number of columns in line ' . $line);
                        // }
                    } else if ($numDelimiters > $this->numColumns-1) {
                         throw new InvalidFileFormatException('Unexpected number of columns in line ' . $line);
                    }

                    // The end of the line was reached. Convert to array and return
                    $lineArr = explode($this->delimiter, $line);
                    $lineArr = array_map(function($value) {
                        return $value === "" ? NULL : $value;
                    }, $lineArr);
                    return array_slice($lineArr, 0, $this->numColumns);
                // }
                // Continue reading...

            } else {
                // Return false when trying to read after EOF
                return false;
            }
        }
    }
}

?>