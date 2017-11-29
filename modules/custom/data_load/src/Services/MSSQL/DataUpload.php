<?php

namespace Drupal\data_load\Services\MSSQL;

use Drupal\data_load\Controller\Services\FileHandler;
use Drupal\data_load\Controller\Services\PDOBuilder;
use League\Csv\Reader;

use Exception;
use PDO;
use PDOException;
use SplFileInfo;

class DataUpload {

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


    /**
     * Retrieves partner sponsor codes
     *
     * @return array A list of partner sponsor codes
     */
    public static function getPartners(PDO $connection): array {
        return $connection
            ->query('SELECT SponsorCode FROM Partner')
            ->fetchAll(PDO::FETCH_COLUMN);
    }

    /**
     * Retrieves data validation rules for the integrity check
     *
     * @return array An array of validation rule definitions
     */
    public static function getValidationRules(PDO $connection): array {
        return $connection
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
    public static function integrityCheck(PDO $connection, array $parameters): array {
        try {
            return PDOBuilder::executePreparedStatement(
                $connection,
                'SET NOCOUNT ON;
                EXECUTE DataUpload_IntegrityCheck
                    @Type = :type,
                    @PartnerCode = :partnerCode;',
                $parameters
            )->fetchAll();
        }

        catch (PDOException $e) {
            return ['ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())];
        }
    }


    /**
     * Retrieves integrity check details for a specific rule
     *
     * @param string $ruleId The rule id
     * @param string $partnerCode The partner code for the upload
     * @return array
     */
    public function integrityCheckDetails(PDO $pdo, array $parameters): array {
        try {
            return PDOBuilder::executePreparedStatement(
                $connection,
                'SET NOCOUNT ON;
                EXECUTE DataUpload_IntegrityCheckDetails
                    @RuleId=:ruleId,
                    @PartnerCode=:partnerCode;',
                $parameters
            )->fetchAll();
        }

        catch (PDOException $e) {
            return ['ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())];
        }
    }


    /**
     * Retrieves sorted and paginated rows from the uploaded workbook
     *
     * @param int $page The page to retreive (indexing starts at 1)
     * @param string $sortDirection The direction to sort in (ASC or DESC, defaults to ASC)
     * @param string $sortColumn The column to sort by (defaults to InternalId)
     * @return array Sorted and paginated rows from the current workbook
     */
    public static function getProjects(PDO $pdo, array $parameters): array {
        $page = $parameters['page'] ?? 1;
        $pageSize = $parameters['pageSize'] ?? 25;
        $sortDirection = $parameters['sortDirection'] ?? 'ASC';
        $sortColumn = $parameters['sortColumn'] ?? 'InternalId';

        $sortDirectionKeys = ['ASC', 'DESC'];
        $sortColumnKeys = array_keys(self::WORKBOOK_COLUMNS);

        if (!in_array($sortDirection, $sortDirectionKeys)) {
          $sortDirection = $sortDirectionKeys[0];
        }

        if (!in_array($sortColumn, $sortColumnKeys)) {
          $sortColumn = $sortColumnKeys[0];
        }

        $options = [
            'sortColumn' => $sortColumn,
            'sortDirection' => $sortDirection,
            'offset' => ($page - 1) * $pageSize,
            'pageSize' => $pageSize,
        ];

        try {
            return PDOBuilder::executePreparedStatement(
                $connection,
                'SELECT * FROM UploadWorkbook
                    ORDER BY :sortColumn :sortDirection
                    OFFSET :offset ROWS FETCH NEXT :pageSize ROWS ONLY',
                $options
            )->fetchAll();
        }

        catch (PDOException $e) {
            return ['ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())];
        }
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
    public static function loadProjects(PDO $connection, array $parameters, string $filePath = NULL): array {
        try {
            $locale = $parameters['locale'] ?? 'en-us';
            $columns = self::WORKBOOK_COLUMNS;

            // create a temp table for the records
            self::createTable($connection, 'UploadWorkBook', $columns);

            // create a PDOStatment for inserting records into the workbook
            unset($columns['InternalId']);
            $stmt = self::getInsertStmt($connection, 'UploadWorkBook', $columns);

            $csv = Reader::createFromPath($filePath)
                ->setHeaderOffset(0);

            // ensure any utf-16 files are parsed as utf-8
            if (in_array($csv->getInputBOM(), [Reader::BOM_UTF16_LE, Reader::BOM_UTF16_BE])) {
                FileHandler::convertFile($filePath, 'UTF-16', 'UTF-8');

                // re-initialize reader
                $csv = Reader::createFromPath($filePath)
                    ->setHeaderOffset(0);
            }

            // ensure that the file contains 42 header columns
            if (count($csv->getHeader()) !== 42) {
                throw new Exception('The input file does not contain the expected number of headers.');
            }

            // read each row into the table
            foreach($csv as $index => $row) {

                // ensure that values are parsed correctly before insertion
                $values = array_map(function($key, $value) use ($locale) {
                    if (strtolower($key) === 'awardfunding') {
                        $value = floatval(str_replace(',', '', $value));
                        $value = round($value, 2);
                    } else if ($locale === 'en-gb' && in_array($key, [
                        'awardstartdate',
                        'awardenddate',
                        'budgetstartdate',
                        'budgetenddate',
                    ])) {
                        list($date, $month, $year) = sscanf($value, "%d/%d/%d");
                        $value = "$month/$date/$year";
                    }

                    return $value ? $value : NULL;
                }, array_keys($row), array_values($row));

                try {
                    $stmt->execute($values);
                }

                catch(PDOException $e) {
                    error_log($e->getMessage());
                    $line = $index + 1;
                    $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());
                    throw new Exception("The input file contains an invalid row. Please check line ${line} (${message})");
                }
            }

            return [
                'count' => $connection->query('SELECT COUNT(*) FROM UploadWorkBook')->fetchColumn(),
                'projects' => self::getData($connection, [
                    'page' => 1,
                    'pageSize' => 25,
                    'sortDirection' => 'ASC',
                    'sortColumn' => 'InternalId',
                ]),
            ];
        }

        catch(Exception $e) {
            error_log($e->getMessage());
            return ['ERROR' => $e->getMessage()];
        }
    }


    /**
     * Imports projects from the staging database to the production database
     *
     * @param PDO $connection The database connection object
     * @param array $parameters An associative array:
     *   partnerCode: A partner code (from getPartners)
     *   fundingYears: The year range as a string (eg: '2016 - 2017')
     *   importNotes: Import notes (optional)
     *   receivedDate: The date this import was received ('YYYY-MM-DD')
     *   type: The type of import ('UPDATE' or 'NEW')
     * @return array
     */
    public static function importProjects(PDO $connection, array $parameters): array {
        try {
            $stmt = PDOBuilder::executePreparedStatement(
                $connection,
                $parameters['type'] === 'NEW'
                    ? 'SET NOCOUNT ON;
                        EXECUTE DataUpload_ImportNew
                            @PartnerCode = :partnerCode,
                            @fundingYears = :fundingYears,
                            @importNotes = :importNotes,
                            @receivedDate = :receivedDate'
                    : 'SET NOCOUNT ON;
                        EXECUTE DataUpload_ImportUpdate
                            @PartnerCode = :partnerCode,
                            @fundingYears = :fundingYears,
                            @importNotes = :importNotes,
                            @receivedDate = :receivedDate',
                $parameters
            );

            self::calculateFundingAmounts($connection);
            return $stmt->fetchAll();
        }

        catch (PDOException $e) {
            return ['ERROR' => preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage())];
        }
    }


    private static function calculateFundingAmounts(PDO $connection) {

        $statement = $connection->prepare('
                            INSERT INTO ProjectFundingExt(
                                    ProjectFundingID,
                                    CalendarYear,
                                    CalendarAmount)
                            VALUES(:id, :year, :amount)');

        foreach($connection->query('
                        SELECT ProjectId,
                            pf.ProjectFundingID,
                            BudgetStartDate,
                            BudgetEndDate,
                            Amount
                        FROM ProjectFunding pf
                        LEFT OUTER JOIN ProjectFundingExt pfe
                        ON pf.ProjectFundingID = pfe.ProjectFundingID
                        WHERE  pfe.ProjectFundingID IS NULL
                        AND pf.BudgetStartDate IS NOT NULL
                        AND pf.BudgetEndDate IS NOT NULL
                        AND pf.BudgetEndDate >= pf.BudgetStartDate
                        ') as $row) {

            $projectFundingID = $row['ProjectFundingID'];
            $start_date = strtotime($row['BudgetStartDate']);
            $end_date = strtotime($row['BudgetEndDate']);
            $start_date = mktime(0, 0, 0, date('m', $start_date), date('d', $start_date), date('Y', $start_date));
            $end_date = mktime(0, 0, 0, date('m', $end_date), date('d', $end_date), date('Y', $end_date));
            $total_amount = $row['Amount'];
            $number_of_days = ($end_date - $start_date) / (60 * 60 * 24) + 1;
            $amount_per_day = $total_amount / $number_of_days;

            $current_date = $start_date;
            $current_year = date('Y', $start_date);

            $day_counter = 0;

            while($current_date <= $end_date) {

                if (date('Y', $current_date) == $current_year) {
                    $day_counter++;
                } else {
                    $years[$current_year] = array('year' => $current_year, 'amount' => $day_counter * $amount_per_day, 'days' => $day_counter);
                    $current_year = date('Y', $current_date);
                    $day_counter = 1;
                }
                $current_date = mktime(0, 0, 0, date('m', $current_date), date('d', $current_date) + 1, date('Y', $current_date));
            }

            $years[$current_year] = array('year' => $current_year, 'amount' => $day_counter * $amount_per_day, 'days' => $day_counter);

            foreach($years as $year_arr) {
                $statement->execute(array('id' => $projectFundingID, 'year' => $year_arr['year'], 'amount' => $year_arr['amount']));
            }
        }
    }


    /**
     * Creates a temporary table with the specified name and column definitions
     *
     * @param PDO $connection The PDO connection object
     * @param string $name The name of the table
     * @param array $columns The column definitions (an associative array containing names and types)
     * @return void
     */
    private static function createTable(PDO $connection, string $name, array $columns): void {

        $columnDefinitions = implode(',', array_map(
            function($key, $value) { return "$key $value"; },
            array_keys($columns),
            array_values($columns)
        ));

        $connection->exec("
            DROP TABLE IF EXISTS ${name};
            CREATE TABLE ${name} ($columnDefinitions);
        ");
    }


    /**
     * Creates a prepared statement to be used for inserting values into a table
     *
     * @param PDO $connection The PDO connection object
     * @param string $table The name of the table
     * @param array $columns The columns to use in this statement
     * @return PDOStatement
     */
    private static function getInsertStmt(PDO $connection, string $table, array $columns): PDOStatement {

        $tableColumns = implode(',', array_map(
            function($column) { return "[$column]"; },
            array_keys($columns)
        ));

        $columnPlaceholders = implode(',',
            array_fill(0, count($columns), '?')
        );

        return $connection->prepare(
            "INSERT INTO $table ($tableColumns) VALUES $columnPlaceholders"
        );
    }
}