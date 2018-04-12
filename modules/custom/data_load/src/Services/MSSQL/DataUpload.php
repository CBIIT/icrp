<?php

namespace Drupal\data_load\Services\MSSQL;

use Drupal\data_load\Services\FileHandler;
use Drupal\data_load\Services\PDOBuilder;
use League\Csv\Reader;

use Exception;
use PDO;
use PDOException;
use PDOStatement;

class DataUpload {

    const WORKBOOK_COLUMNS = [
        'InternalId' => 'int identity',
        'AwardCode' => 'nvarchar(50)',
        'AwardStartDate' => 'date',
        'AwardEndDate' => 'date',
        'SourceId' => 'varchar(150)',
        'AltId' => 'varchar(50)',
        'NewAltId' => 'varchar(50)',
        'AwardTitle' => 'varchar(1000)',
        'Category' => 'varchar(25)',
        'AwardType' => 'varchar(50)',
        'Childhood' => 'varchar(5)',
        'BudgetStartDate' => 'date',
        'BudgetEndDate' => 'date',
        'CSOCodes' => 'varchar(500)',
        'CSORel' => 'varchar(500)',
        'SiteCodes' => 'varchar(500)',
        'SiteRel' => 'varchar(500)',
        'AwardFunding' => 'decimal(16,2)',
        'IsAnnualized' => 'varchar(1)',
        'FundingMechanismCode' => 'varchar(30)',
        'FundingMechanism' => 'varchar(200)',
        'FundingOrgAbbr' => 'varchar(50)',
        'FundingDiv' => 'varchar(75)',
        'FundingDivAbbr' => 'varchar(50)',
        'FundingContact' => 'varchar(50)',
        'PILastName' => 'varchar(50)',
        'PIFirstName' => 'varchar(50)',
        'SubmittedInstitution' => 'varchar(250)',
        'City' => 'varchar(50)',
        'State' => 'varchar(50)',
        'Country' => 'varchar(3)',
        'PostalZipCode' => 'varchar(50)',
        'InstitutionICRP' => 'varchar(4000)',
        'Latitute' => 'decimal(9,6)',
        'Longitute' => 'decimal(9,6)',
        'GRID' => 'varchar(250)',
        'TechAbstract' => 'nvarchar(max)',
        'PublicAbstract' => 'nvarchar(max)',
        'RelatedAwardCode' => 'varchar(200)',
        'RelationshipType' => 'varchar(200)',
        'ORCID' => 'varchar(25)',
        'OtherResearcherID' => 'int',
        'OtherResearcherIDType' => 'varchar(1000)',
        'InternalUseOnly' => 'nvarchar(max)',
    ];


    /**
     * Retrieves partner sponsor codes
     *
     * @return array A list of partner sponsor codes
     */
    public static function getPartners(PDO $connection): array {
        return $connection
            ->query('SELECT SponsorCode FROM Partner ORDER BY SponsorCode')
            ->fetchAll(PDO::FETCH_COLUMN);
    }

    /**
     * Retrieves data validation rules for the integrity check
     *
     * @return array An array of validation rule definitions
     */
    public static function getValidationRules(PDO $connection): array {
        return $connection
            ->query('SELECT
                lu_DataUploadIntegrityCheckRules_ID as id,
                Name as name,
                Category as category,
                IsRequired as isRequired,
                IsActive as isActive,
                Type as type
                FROM lu_DataUploadIntegrityCheckRules
                ORDER BY DisplayOrder')
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
    public static function integrityCheckDetails(PDO $connection, array $parameters): array {
        try {
            return PDOBuilder::executePreparedStatement(
                $connection,
                'SET NOCOUNT ON;
                EXECUTE DataUpload_IntegrityCheckDetails
                    @RuleId=:ruleId,
                    @Type = :type,
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
    public static function getProjects(PDO $connection, array $parameters): array {
        $page = intval($parameters['page']) ?? 1;
        $pageSize = intval($parameters['pageSize']) ?? 25;
        $sortDirection = $parameters['sortDirection'] ?? 'ASC';
        $sortColumn = $parameters['sortColumn'] ?? 'InternalId';

        $sortDirectionKeys = ['asc', 'desc'];
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

        $columns = array_keys(self::WORKBOOK_COLUMNS);
        array_shift($columns);
        $columnNames = implode(',', $columns);

        try {
            return $connection
                ->query("SELECT $columnNames FROM UploadWorkbook
                        ORDER BY $options[sortColumn] $options[sortDirection]
                        OFFSET $options[offset] ROWS FETCH NEXT $options[pageSize] ROWS ONLY")
                ->fetchAll();
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
            $locale = $parameters['locale'] ?? 'en-US';
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

            if (count($csv->getHeader()) === 42) {
                throw new Exception('The input file is using an unsupported version of the Partner Data Upload workbook format.');
            }

            // ensure that the file contains 43 header columns
            if (count($csv->getHeader()) !== 43) {
                throw new Exception('The input file does not contain the expected number of headers.');
            }

            // read each row into the table
            foreach($csv as $index => $row) {

                // ensure that values are parsed correctly before insertion
                $values = array_map(function($key, $value) use ($locale) {
                    if (strtolower($key) === 'awardfunding') {
                        $value = floatval(str_replace(',', '', $value));
                        $value = round($value, 2);
                    } else if (in_array(strtolower($key), [
                        'awardstartdate',
                        'awardenddate',
                        'budgetstartdate',
                        'budgetenddate',
                    ])) {
                        if (strtolower($locale) === 'en')
                            list($month, $day, $year) = sscanf($value, "%d/%d/%d");

                        else if (strtolower($locale) === 'en-gb')
                            list($day, $month, $year) = sscanf($value, "%d/%d/%d");

                        $value = "$year-$month-$day";
                    }

                    ## disregard strings that are empty or null
                    return in_array($value, ['', 'NULL'], true)
                        ? NULL : $value;
                }, array_keys($row), array_values($row));

                try {
                    $stmt->execute($values);
                }

                catch(PDOException $e) {
                    ++$index;
                    error_log($e->getMessage());
                    $message = preg_replace('/^SQLSTATE\[.*\]/', '', $e->getMessage());
                    throw new Exception("The input file contains an invalid row. Please check line ${index} (${message})");
                }
            }

            return [
                'count' => $connection->query('SELECT COUNT(*) FROM UploadWorkBook')->fetchColumn(),
                'projects' => self::getProjects($connection, [
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
                strtolower($parameters['type']) === 'new'
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
						AND pf.Amount IS NOT NULL
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

            $years = [];
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
            "INSERT INTO $table ($tableColumns) VALUES ($columnPlaceholders)"
        );
    }
}