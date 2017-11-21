<?php

namespace Drupal\data_load\Services\MSSQL;

use PDO;
use PDOException;

class DataLoad {


  public static function integrityCheck(PDO $connection, array $parameters): array {

  }
}


<?php

namespace Drupal\data_load\Services\DataLoad\MSSQL;

use Drupal\data_load\Controller\Services\FileHandler;
use League\Csv\Reader;

use Drupal;
use PDO;
use SplFileInfo;

class DataLoad {

    const WORKBOOK_COLUMNS = [
        'InternalId' => 'int IDENTITY (1,1)',
        'AwardCode' => 'NVARCHAR(50)',
        'AwardStartDate' => 'DATE',
        'AwardEndDate' => 'DATE',
        'SourceId' => 'VARCHAR(150)',
        'AltId' => 'VARCHAR(50)',
        'AwardTitle' => 'VARCHAR(1000)',
        'Category' => 'VARCHAR(25)',
        'AwardType' => 'VARCHAR(50)',
        'Childhood' => 'VARCHAR(5)',
        'BudgetStartDate' => 'DATE',
        'BudgetEndDate' => 'DATE',
        'CSOCodes' => 'VARCHAR(500)',
        'CSORel' => 'VARCHAR(500)',
        'SiteCodes' => 'VARCHAR(500)',
        'SiteRel' => 'VARCHAR(500)',
        'AwardFunding' => 'DECIMAL(16,2)',
        'IsAnnualized' => 'VARCHAR(1)',
        'FundingMechanismCode' => 'VARCHAR(30)',
        'FundingMechanism' => 'VARCHAR(200)',
        'FundingOrgAbbr' => 'VARCHAR(50)',
        'FundingDiv' => 'VARCHAR(75)',
        'FundingDivAbbr' => 'VARCHAR(50)',
        'FundingContact' => 'VARCHAR(50)',
        'PILastName' => 'VARCHAR(50)',
        'PIFirstName' => 'VARCHAR(50)',
        'SubmittedInstitution' => 'VARCHAR(250)',
        'City' => 'VARCHAR(50)',
        'State' => 'VARCHAR(150)',
        'Country' => 'VARCHAR(3)',
        'PostalZipCode' => 'VARCHAR(15)',
        'InstitutionICRP' => 'VARCHAR(4000)',
        'Latitute' => 'DECIMAL(9,6)',
        'Longitute' => 'DECIMAL(9,6)',
        'GRID' => 'VARCHAR(50)',
        'TechAbstract' => 'NVARCHAR(MAX)',
        'PublicAbstract' => 'NVARCHAR(MAX)',
        'RelatedAwardCode' => 'VARCHAR(200)',
        'RelationshipType' => 'VARCHAR(200)',
        'ORCID' => 'VARCHAR(25)',
        'OtherResearcherID' => 'INT',
        'OtherResearcherIDType' => 'VARCHAR(1000)',
        'InternalUseOnly' => 'NVARCHAR(MAX)'
    ];

    const INSTITUTION_COLUMNS = [
        'Id' => 'INT IDENTITY (1,1)',
        'Name' => 'VARCHAR(250)',
        'City' => 'VARCHAR(50)',
        'State' => 'VARCHAR(50)',
        'Country' => 'VARCHAR(3)',
        'Postal' => 'VARCHAR(50)',
        'Longitude' => 'DECIMAL(9, 6)',
        'Latitude' => 'DECIMAL(9, 6)',
        'GRID' => 'VARCHAR(250)',
    ];


    /**
     * Retrieves partner sponsor codes
     *
     * @return array A list of partner sponsor codes
     */
    public static function getSponsorCodes(): array {
        return Database::getConnection()
            ->query('SELECT SponsorCode FROM Partner')
            ->fetchAll(PDO::FETCH_COLUMN);
    }

    /**
     * Retrieves data validation rules for the integrity check
     *
     * @return array An array of validation rule definitions
     */
    public static function getValidationRules(): array {
        return Database::getConnection()
            ->query('SELECT * FROM lu_DataUploadIntegrityCheckRules')
            ->fetchAll();
    }

    /**
     * Executes an integrity check for a specific partner
     *
     * @param string $type (UPDATE or NEW)
     * @param string $partnerCode
     * @return array
     */
    public static function integrityCheck(string $type, string $partnerCode): array {
        $stmt = Database::getConnection()->prepare('
            SET NOCOUNT ON;
            EXECUTE DataUpload_IntegrityCheck
                @Type=:type,
                @PartnerCode=:partnerCode;
        ');

        $stmt->execute([
            'type' => $type,
            'partnerCode' => $partnerCode,
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Retrieves integrity check details for a specific rule
     *
     * @param string $ruleId The rule id
     * @param string $partnerCode The partner code for the upload
     * @return array
     */
    public function integrityCheckDetails(string $ruleId, string $partnerCode): array {
        $stmt = Database::getConnection()->prepare('
            SET NOCOUNT ON;
            EXECUTE DataUpload_IntegrityCheckDetails
                @RuleId=:ruleId,
                @PartnerCode=:partnerCode;
        ');

        $stmt->execute([
          'ruleId' => $ruleId,
          'partnerCode' => $partnerCode,
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Retrieves sorted and paginated rows from the uploaded workbook
     *
     * @param int $page The page to retreive (indexing starts at 1)
     * @param string $sortDirection The direction to sort in (ASC or DESC, defaults to ASC)
     * @param string $sortColumn The column to sort by (defaults to InternalId)
     * @return array Sorted and paginated rows from the current workbook
     */
    public static function getData(
        int $page = 1,
        int $pageSize = 25,
        string $sortDirection = 'ASC',
        string $sortColumn = 'InternalId'): array {

        $sortDirectionKeys = ['ASC', 'DESC'];
        $sortColumnKeys = array_keys(self::WORKBOOK_COLUMNS);

        if (!in_array($sortDirection, $sortDirectionKeys)) {
          $sortDirection = $sortDirectionKeys[0];
        }

        if (!in_array($sortColumn, $sortColumnKeys)) {
          $sortColumn = $sortColumnKeys[0];
        }

        $stmt = Database::getConnection()->prepare(
            'SELECT * FROM UploadWorkbook
                ORDER BY :sortColumn :sortDirection
                OFFSET :offset ROWS FETCH NEXT :pageSize ROWS ONLY'
        );

        $stmt->execute([
          'sortColumn' => $sortColumn,
          'sortDirection' => $sortDirection,
          'offset' => ($page - 1) * $pageSize,
          'pageSize' => $pageSize,
        ]);

        return $stmt->fetchAll();
    }


    /**
     * Loads data from an uploaded file into a temporary database
     * table (UploadWorkBook) for validation
     *
     * @param string $filePath The path to the uploaded file
     * @return array An array with the following properties:
     *   'rowCount' => The total number of rows in the workbook
     *   'columns'  => The column names used in this workbook
     *   'projects' => The first 25 projects from the workbook
     */
    public static function loadData(string $filePath, string $fileName = NULL): array {

        if (!$fileName) {
            $fileName = (new SplFileInfo($filePath))->getFilename();
            error_log("Filename: " . $fileName);
        }

        try {
            $pdo = Database::getConnection();

            $columns = self::WORKBOOK_COLUMNS;
            self::createTable($pdo, 'UploadWorkBook', $columns);

            unset($columns['InternalId']);
            $stmt = self::getInsertStmt($pdo, 'UploadWorkBook', $columns);

            $csv = Reader::createFromPath($filePath)
                ->setHeaderOffset(0);

            // ensure any utf-16 files are parsed as utf-8
            if (in_array($csv->getInputBOM(), [Reader::BOM_UTF16_LE, Reader::BOM_UTF16_BE])) {
                FileHandler::convertFile($filePath, 'UTF-16', 'UTF-8');

                // re-initialize reader
                $csv = Reader::createFromPath($filePath)
                    ->setHeaderOffset(0);
            }

            if (count($csv->getHeader()) !== 42) {
                throw new Exception('The input file does not contain the expected number of headers.');
            }

            foreach($csv as $index => $row) {
                $values = array_map(function($key, $value) {
                    if (strtolower($key) === 'awardfunding') {
                        $value = floatval(str_replace(',', '', $value));
                        $value = round($value, 2);
                    }

                    return $value ? $value : NULL;
                }, array_keys($row), array_values($row));

                try {
                    $stmt->execute($values);
                }

                catch(PDOException $e) {
                    error_log($e->getMessage());
                    $line = $index + 1;
                    throw new Exception("The input file contains an invalid row. Please check line ${line}.");
                }
            }

            return [
                'count' => $pdo->query('SELECT COUNT(*) FROM UploadWorkBook')->fetchColumn(),
                'projects' => self::getData(),
            ];
        }

        catch(Exception $e) {
            error_log($e->getMessage());
            return ['ERROR' => $e->getMessage()];
        }
    }


    /**
     * Generates an excel export for the integrity check results
     *
     * @param array $exportRules A list of validation rule ids
     * @param string $partnerCode The sponsor code for the uploaded projects
     * @return string The path to the generated export file
     */
    public static function exportIntegrityCheck(array $exportRules = [], string $partnerCode = ''): string {

        $exportsFolder = join(DIRECTORY_SEPARATOR, [self::getModulePath(), 'exports']);

        if (!file_exists($exportsFolder)) {
            mkdir($exportsFolder, 0744, true);
        }

        $timestamp = date('Ymd_G.i.s');
        $fileName = "Data_Upload_Validation_Results_${timestamp}.xlsx";
        $filePath = join(DIRECTORY_SEPARATOR, [$exportsFolder, $fileName]);
        unlink($filePath);

        $writer = WriterFactory::create(Type::XLSX);
        $writer->openToFile($filePath);

        $pdo = self::getConnection();

        // iterate over each of the export rules
        foreach ($exportRules as $index => $rule) {
            $sheet = $writer->getCurrentSheet();

            // do not allow \ / ? * : [ or ] in title
            $title = preg_replace('/[\\\\\/\?\*\[\]]/', '', $rule['name']);
            $sheet->setName(substr($title, 0, 31));

            $stmt = $pdo->prepare('
                SET NOCOUNT ON;
                EXECUTE DataUpload_IntegrityCheckDetails
                    @RuleId = :ruleId,
                    @PartnerCode = :partnerCode;
            ');

            $stmt->execute([
                'ruleId' => $rule['id'],
                'partnerCode' => $partnerCode,
            ]);

            $headers = [];
            foreach(range(0, $stmt->columnCount() - 1) as $i) {
                $meta = $stmt->getColumnMeta($i);
                array_push($headers, $meta['name']);
            }

            $writer->addRows([
                [$rule['name']],
                [''],
                $headers,
            ]);

            while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
                $writer->addRow($row);
            }

            if ($index < count($exportRules) - 1) {
                $writer->addNewSheetAndMakeItCurrent();
            }
        }

        $writer->close();
        return $fileName;
    }

    public static function importProjects(
        $partnerCode = '',
        $fundingYears = [],
        $importNotes = '',
        $receivedDate = '',
        $type = '') {

        $conn = self::getConnection();
        $stmt = $conn->prepare('
            SET NOCOUNT ON;
            EXECUTE DataUpload_Import
                @PartnerCode = :partnerCode,
                @fundingYears = :fundingYears,
                @importNotes = :importNotes,
                @receivedDate = :receivedDate,
                @type = :type;
        ');

        $stmt->execute([
            'partnerCode' => $partnerCode,
            'fundingYears' => $fundingYears,
            'importNotes' => $importNotes,
            'receivedDate' => $receivedDate,
            'type' => $type,
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Imports institutions into the database
     *
     * @param array $institutions An array of institutions to import
     * @return array Institutions that already exist in the database, and failed to import
     */
    public static function importInstitutions(array $institutions): array {

        $pdo = Database::getConnection();

        $columns = self::INSTITUTION_COLUMNS;
        self::createTable($pdo, 'tmp_LoadInstitutions', $columns);

        unset($columns['Id']);
        $stmt = self::getInsertStmt($pdo, 'tmp_loadInstitutions', $columns);

        foreach($institutions as $institution) {
            $data = array_map(function($value) {
                return $value ? $value : NULL;
            }, $institution);

            $stmt->execute($data);
        }

        return $pdo->query('SET NOCOUNT ON; EXEC AddInstitutions')->fetchAll();
    }

    /**
     * Creates a temporary table with the specified name and column definitions
     *
     * @param PDO $pdo The PDO connection object
     * @param string $name The name of the table
     * @param array $columns The column definitions
     * @return void
     */
    private static function createTable(PDO $pdo, string $name, array $columns): void {

        $columnDefinitions = implode(',', array_map(
            function($key, $value) { return "$key $value"; },
            array_keys($columns),
            array_values($columns)
        ));

        $pdo->exec("
            DROP TABLE IF EXISTS ${name};
            CREATE TABLE ${name} ($columnDefinitions);
        ");
    }

    /**
     * Creates a prepared statement to be used for inserting values into a table
     *
     * @param PDO $pdo The PDO connection object
     * @param string $table The name of the table
     * @param array $columns The columns to use in this statement
     * @return PDOStatement
     */
    private static function getInsertStmt(PDO $pdo, string $table, array $columns): PDOStatement {

        $tableColumns = implode(',', array_map(
            function($column) { return "[$column]"; },
            array_keys($columns)
        ));

        $columnPlaceholders = implode(',',
            array_fill(0, count($columns), '?')
        );

        return $pdo->prepare(
            "INSERT INTO $table ($tableColumns) VALUES $columnPlaceholders"
        );
    }
}