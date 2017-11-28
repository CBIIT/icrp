<?php

namespace Drupal\data_load\Services\MYSQL;

use Drupal\data_load\Controller\Utilities\FileUtilities;
use Drupal;
use PDO;
use SplFileInfo;

class DataUpload {


    /**
     * Retrieves data validation rules for the integrity check
     *
     * @return array An array of validation rule definitions
     */
    public static function get_validation_rules(): array {
        return Database::get_connection()
            ->query('SELECT * FROM lu_DataUploadIntegrityCheckRules')
            ->fetchAll();
    }


    /**
     * Executes an integrity check for a specific partner
     *
     * @param string $type
     * @param string $partnerCode
     * @return array
     */
    public static function integrity_check(string $type, string $partnerCode): array {
        $stmt = Database::get_connection()->prepare(
            'CALL DataUpload_IntegrityCheck (:type, :partnerCode)');

        $stmt->execute([
            ':type' => $type,
            ':partnerCode' => $partnerCode,
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
    public function integrity_check_details(string $ruleId, string $partnerCode): array {
        $stmt = Database::get_connection()->prepare(
            'CALL DataUpload_IntegrityCheckDetails (:ruleId, :partnerCode)');

        $stmt->execute([
          ':ruleId' => $ruleId,
          ':partnerCode' => $partnerCode,
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
    public static function get_data(int $page = 1, string $sortDirection = 'ASC', string $sortColumn = 'InternalId'): array {

        $sortDirectionKeys = ['ASC', 'DESC'];
        $sortColumnKeys = [
            'InternalId', 'AwardCode', 'AwardStartDate', 'AwardEndDate',
            'SourceId', 'AltId', 'AwardTitle', 'Category', 'AwardType',
            'Childhood', 'BudgetStartDate', 'BudgetEndDate', 'CSOCodes',
            'CSORel', 'SiteCodes', 'SiteRel', 'AwardFunding', 'IsAnnualized',
            'FundingMechanismCode', 'FundingMechanism', 'FundingOrgAbbr',
            'FundingDiv', 'FundingDivAbbr', 'FundingContact', 'PILastName',
            'PIFirstName', 'SubmittedInstitution', 'City', 'State', 'Country',
            'PostalZipCode', 'InstitutionICRP', 'Latitute', 'Longitute', 'GRID',
            'TechAbstract', 'PublicAbstract', 'RelatedAwardCode', 'RelationshipType',
            'ORCID', 'OtherResearcherID', 'OtherResearcherIDType', 'InternalUseOnly'
        ];

        if (!in_array($sortDirection, $sortDirectionKeys)) {
          $sortDirection = $sortDirectionKeys[0];
        }

        if (!in_array($sortColumn, $sortColumnKeys)) {
          $sortColumn = $sortColumnKeys[0];
        }

        $pageSize = 25;
        $offset = ($page - 1) * $pageSize;
        $stmt = Database::get_connection()->prepare(
            'SELECT * FROM wb ORDER BY :sortColumn :sortDirection LIMIT :offset, :pageSize');

        $stmt->execute([
          ':sortColumn' => $sortColumn,
          ':sortDirection' => $sortDirection,
          ':offset' => $offset,
          ':pageSize' => $pageSize,
        ]);

        return $stmt->fetchAll();
    }

    /**
     * Loads data from an uploaded file into a temporary table (wb) for validation
     *
     * @param string $filePath The path to the uploaded file
     * @return array An array with the following properties:
     *   'rowCount' => The total number of rows in the workbook
     *   'projects' => The first 25 projects from the workbook
     */
    public function load_data(string $filePath): array {
        FileUtilities::convert_file($filePath);

        try {
            $conn = Database::get_connection();
            $conn->exec("
                TRUNCATE wb;
                ALTER TABLE wb AUTO_INCREMENT = 1;
                LOAD DATA LOCAL INFILE '${filePath}' INTO TABLE wb FIELDS TERMINATED BY '|' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (
                    @AwardCode,
                    @AwardStartDate,
                    @AwardEndDate,
                    @SourceId,
                    @AltId,
                    @AwardTitle,
                    @Category,
                    @AwardType,
                    @Childhood,
                    @BudgetStartDate,
                    @BudgetEndDate,
                    @CSOCodes,
                    @CSORel,
                    @SiteCodes,
                    @SiteRel,
                    @AwardFunding,
                    @IsAnnualized,
                    @FundingMechanismCode,
                    @FundingMechanism,
                    @FundingOrgAbbr,
                    @FundingDiv,
                    @FundingDivAbbr,
                    @FundingContact,
                    @PILastName,
                    @PIFirstName,
                    @SubmittedInstitution,
                    @City,
                    @State,
                    @Country,
                    @PostalZipCode,
                    @InstitutionICRP,
                    @Latitute,
                    @Longitute,
                    @GRID,
                    @TechAbstract,
                    @PublicAbstract,
                    @RelatedAwardCode,
                    @RelationshipType,
                    @ORCID,
                    @OtherResearcherID,
                    @OtherResearcherIDType,
                    @InternalUseOnly)

                    SET
                    AwardCode = nullif(@AwardCode,''),
                    AwardStartDate = STR_TO_DATE(@AwardStartDate, '%c/%e/%Y'),
                    AwardEndDate = STR_TO_DATE(@AwardEndDate, '%c/%e/%Y'),
                    AltId = nullif(@AltId,''),
                    AwardTitle = nullif(@AwardTitle,''),
                    Category = nullif(@Category,''),
                    AwardType = nullif(@AwardType,''),
                    Childhood = nullif(@Childhood,''),
                    BudgetStartDate = STR_TO_DATE(@BudgetStartDate, '%c/%e/%Y'),
                    BudgetEndDate = STR_TO_DATE(@BudgetEndDate, '%c/%e/%Y'),
                    CSOCodes = nullif(@CSOCodes,''),
                    CSORel = nullif(@CSORel,''),
                    SiteCodes = nullif(@SiteCodes,''),
                    SiteRel = nullif(@SiteRel,''),
                    AwardFunding = nullif(@AwardFunding,''),
                    IsAnnualized = nullif(@IsAnnualized,''),
                    FundingMechanismCode = nullif(@FundingMechanismCode,''),
                    FundingMechanism = nullif(@FundingMechanism,''),
                    FundingOrgAbbr = nullif(@FundingOrgAbbr,''),
                    FundingDiv = nullif(@FundingDiv,''),
                    FundingDivAbbr = nullif(@FundingDivAbbr,''),
                    FundingContact = nullif(@FundingContact,''),
                    PILastName = nullif(@PILastName,''),
                    PIFirstName = nullif(@PIFirstName,''),
                    SubmittedInstitution = nullif(@SubmittedInstitution,''),
                    City = nullif(@City,''),
                    State = nullif(@State,''),
                    Country = nullif(@Country,''),
                    PostalZipCode = nullif(@PostalZipCode,''),
                    InstitutionICRP = nullif(@InstitutionICRP,''),
                    Longitute = nullif(@Longitute,''),
                    GRID = nullif(@GRID,''),
                    TechAbstract = nullif(@TechAbstract,''),
                    PublicAbstract = nullif(@PublicAbstract,''),
                    RelatedAwardCode = nullif(@RelatedAwardCode,''),
                    RelationshipType = nullif(@RelationshipType,''),
                    ORCID = nullif(@ORCID,''),
                    OtherResearcherID = nullif(@OtherResearcherID,''),
                    OtherResearcherIDType = nullif(@OtherResearcherIDType,''),
                    InternalUseOnly = nullif(@InternalUseOnly,'')
            ");

            $rowCount = $conn->query("SELECT COUNT(*) FROM wb")->fetchColumn();
            $projects = $conn->query("SELECT * FROM wb ORDER BY InternalId limit 25")->fetchAll();

            return [
                'rowCount' => $rowCount,
                'projects' => $projects,
            ];
        }

        catch(PDOException $e) {
            return ['ERROR' => $e->getMessage()];
        }
    }
}