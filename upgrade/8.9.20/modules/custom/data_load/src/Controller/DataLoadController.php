<?php


namespace Drupal\data_load\Controller;

// require_once __DIR__ . '/../../vendor/autoload.php';

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use League\Csv\Reader;
use Box\Spout\Writer\WriterFactory;
use Box\Spout\Common\Type;
use PDO;
use PDOException;
use Drupal\data_load\Services\CSVReader;

class DataLoadController {

    /**
    * Adds CORS Headers to a response
    */
    static function addCorsHeaders($response) {
        $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
        $response->headers->set('Access-Control-Allow-Origin', '*');
        $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');

        return $response;
    }

    static function getConnection() {
        $cfg=[];
        $icrp_dataload_db = \Drupal::config('icrp_load_database');
        foreach(['driver', 'host', 'port', 'database', 'username', 'password'] as $key) {
            $cfg[$key] = $icrp_dataload_db->get($key);
        }

        // connection string
        $cfg['dsn'] =
        $cfg['driver'] .
        ":Server={$cfg['host']},{$cfg['port']}" .
        ";Database={$cfg['database']}";

        // default configuration options
        switch ($cfg['driver']) {
            case 'sqlsrv':
                $cfg['options'] = [
                PDO::SQLSRV_ATTR_ENCODING    => PDO::SQLSRV_ENCODING_UTF8,
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::SQLSRV_ATTR_QUERY_TIMEOUT => 0,
                ];
                break;
            case 'mysql':
                $cfg['options'] = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::MYSQL_ATTR_LOCAL_INFILE => TRUE
                ];
        }

        // create new PDO object
        return new PDO(
        $cfg['dsn'],
        $cfg['username'],
        $cfg['password'],
        $cfg['options']
        );
    }

    public static function load_app() {
        return [
        '#theme'    => 'data_load',
        '#attached' => [
        'library'   => [
        'data_load/resources'
        ],
        ],
        ];
    }

    public static function integrity_check_mssql(Request $request) {
        set_time_limit(0);
        $conn = self::getConnection();
        $stmt = $conn->prepare('SET NOCOUNT ON; EXECUTE DataUpload_IntegrityCheck @Type=:type, @PartnerCode=:partnerCode');
        // $response = array(partnerCode=>$request->request->get(partnerCode), type=> $request->request->get(type));

        $type = $request->request->get('type');
        $partnerCode = $request->request->get('partnerCode');
        $stmt->bindParam(':type', $type);
        $stmt->bindParam(':partnerCode', $partnerCode);

        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response=array('results' => $results);

        return self::addCorsHeaders(new JsonResponse($response));
    }

    public static function getValidationRuleDefinitions() {
        $conn = self::getConnection();
        $stmt = $conn->prepare('SELECT * FROM lu_DataUploadIntegrityCheckRules');
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response = ['results' => $results];

        return self::addCorsHeaders(new JsonResponse($response));
    }

    public static function integrity_check_details_mssql(Request $request) {
        $conn = self::getConnection();
        $stmt = $conn->prepare('SET NOCOUNT ON; EXECUTE DataUpload_IntegrityCheckDetails @RuleId=:ruleId, @PartnerCode=:partnerCode');

        $ruleId = $request->request->get('ruleId');
        $partnerCode = $request->request->get('partnerCode');

        $stmt->bindParam(':ruleId', $ruleId);
        $stmt->bindParam(':partnerCode', $partnerCode);
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response = ['results' => $results];

        return self::addCorsHeaders(new JsonResponse($response));
    }

    public static function getdata(Request $request) {
        $page = $request->request->get('page');
        $conn = self::getConnection();

        $offset = ($page - 1) * 25;
        $stmt = $conn->prepare('SELECT * FROM wb ORDER BY InternalId limit :offset, 25');
        $stmt->bindParam(':offset', $offset);
        $stmt->execute();
        $projects = $stmt->fetchAll();
        $stmt = null;
        $conn = null;

        $response = ['projects' => $projects];

        return self::addCorsHeaders(new JsonResponse($response));
    }

    public static function getdata_mssql(Request $request) {
        $page = $request->request->get('page');
        $sortDirection = $request->request->get('sortDirection');
        $sortColumn = $request->request->get('sortColumn');

        $sortDirectionKeys = array("ASC", "DESC");
        $key = array_search($sortDirection, $sortDirectionKeys);
        $sortDirection = $sortDirectionKeys[$key];

        $orderByKeys = array("InternalId", "AwardCode", "AwardStartDate", "AwardEndDate", "SourceId", "AltId", "NewAltId", "AwardTitle", "Category",
        "AwardType", "Childhood", "BudgetStartDate", "BudgetEndDate", "CSOCodes", "CSORel", "SiteCodes", "SiteRel", "AwardFunding", "IsAnnualized", "FundingMechanismCode", "FundingMechanism",
        "FundingOrgAbbr", "FundingDiv", "FundingDivAbbr", "FundingContact", "PILastName", "PIFirstName", "SubmittedInstitution", "City", "State", "Country", "PostalZipCode", "InstitutionICRP", "Latitute", "Longitute", "GRID",
        "TechAbstract", "PublicAbstract", "RelatedAwardCode", "RelationshipType", "ORCID", "OtherResearcherID", "OtherResearcherIDType", "InternalUseOnly");
        $key = array_search($sortColumn, $orderByKeys);
        $sortColumn = $orderByKeys[$key];

        $conn = self::getConnection();

        $offset = ($page - 1) * 25;
        $stmt = $conn->prepare("SELECT * FROM  ( SELECT ROW_NUMBER() OVER(ORDER BY $sortColumn $sortDirection) NUM, * FROM UploadWorkBook ) A WHERE NUM > ? AND NUM <= ?");
        $stmt->execute(array($offset, $offset + 25));
        $projects = $stmt->fetchAll();
        $stmt = null;
        $conn = null;

        $response = ['projects' => $projects];

        return self::addCorsHeaders(new JsonResponse($response));
    }

    public static function loaddata_mssql(Request $request) {
        $uploaddir = getcwd() . '/modules/custom/data_load/uploads/';
        $fileName = '';
        $response = '';
        $originalFileName = $request->request->get('originalFileName');
        $locale = strtolower($request->request->get('locale'));
        foreach($request->files as $uploadedFile) {
            $fileName = $uploadedFile->getClientOriginalName();
            $file = $uploadedFile->move($uploaddir, $fileName);
            chdir($uploaddir);
            $from = $uploaddir . $fileName;
            $to = $uploaddir . $fileName . '.utf8';
//            exec('iconv -f UTF-16 -t UTF-8 ' . $from . ' -o ' . $to . '; rm ' . $from . '; mv ' . $to . ' ' .$from . ';');
            // exec("sed -i 's/\r/|\r/g' " . $from);
        }

        $response=array('rowCount' => 50, 'projects' => array());

        try {
            $conn = self::getConnection();
            $conn->exec("DROP TABLE IF EXISTS UploadWorkBook");
            $conn->exec("CREATE TABLE UploadWorkBook (
            InternalId int IDENTITY (1,1),
            AwardCode NVARCHAR(50),
            AwardStartDate Date,
            AwardEndDate date,
            SourceId VARCHAR(150),
            AltId VARCHAR(50),
            NewAltId VARCHAR(50),
            AwardTitle VARCHAR(1000),
            Category VARCHAR(25),
            AwardType VARCHAR(50),
            Childhood VARCHAR(5),
            BudgetStartDate date,
            BudgetEndDate date,
            CSOCodes VARCHAR(500),
            CSORel VARCHAR(500),
            SiteCodes VARCHAR(500),
            SiteRel VARCHAR(500),
            AwardFunding decimal(16,2),
            IsAnnualized VARCHAR(1),
            FundingMechanismCode VARCHAR(30),
            FundingMechanism VARCHAR(200),
            FundingOrgAbbr VARCHAR(50),
            FundingDiv VARCHAR(75),
            FundingDivAbbr VARCHAR(50),
            FundingContact VARCHAR(50),
            PILastName VARCHAR(50),
            PIFirstName VARCHAR(50),
            SubmittedInstitution VARCHAR(250),
            City VARCHAR(50),
            State VARCHAR(50),
            Country VARCHAR(3),
            PostalZipCode VARCHAR(50),
            InstitutionICRP VARCHAR(4000),
            Latitute decimal(9,6),
            Longitute decimal(9,6),
            GRID VARCHAR(250),
            TechAbstract NVARCHAR(max),
            PublicAbstract NVARCHAR(max),
            RelatedAwardCode VARCHAR(200),
            RelationshipType VARCHAR(200),
            ORCID VARCHAR(25),
            OtherResearcherID INT,
            OtherResearcherIDType VARCHAR(1000),
            InternalUseOnly  NVARCHAR(MAX),
            OriginalFileName VARCHAR(200)
            )");

            $stmt = $conn->prepare("INSERT INTO UploadWorkBook ([AwardCode], [AwardStartDate], [AwardEndDate], [SourceId], [AltId], [NewAltId], [AwardTitle], [Category],
            [AwardType], [Childhood], [BudgetStartDate], [BudgetEndDate], [CSOCodes], [CSORel], [SiteCodes], [SiteRel], [AwardFunding], [IsAnnualized], [FundingMechanismCode], [FundingMechanism],
            [FundingOrgAbbr], [FundingDiv], [FundingDivAbbr], [FundingContact], [PILastName], [PIFirstName], [SubmittedInstitution], [City], [State], [Country], [PostalZipCode], [InstitutionICRP], [Latitute], [Longitute], [GRID],
            [TechAbstract], [PublicAbstract], [RelatedAwardCode], [RelationshipType], [ORCID], [OtherResearcherID], [OtherResearcherIDType], [InternalUseOnly], [OriginalFileName]) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

            $csv = Reader::createFromPath($uploaddir . $fileName);
            $csv->setHeaderOffset(0); //set the CSV header offset

            if (count($csv->getHeader()) !== 43) {
                $response = new Response(
                    'Content',
                    Response::HTTP_BAD_REQUEST,
                    array('content-type' => 'text/html')
                );
                $response->setContent('The input file does not contain the expected number of columns.');
                return self::addCorsHeaders($response);
            }

            foreach($csv as $index => $row) {

                $values = array_map(function($key, $value) use ($locale) {
                    $key = strtolower($key);
                    if ($key === 'awardfunding') {
//                        error_log("$key replacing $value");
                        $value = floatval(str_replace(',', '', $value));
                        $value = round($value, 2);
                    } else if ($locale === 'en-gb' && (
                                $key === 'awardstartdate' ||
                                $key === 'awardenddate' ||
                                $key === 'budgetstartdate' ||
                                $key === 'budgetenddate')
                              ) {

                        list($date, $month, $year) = sscanf($value, "%d/%d/%d");
                        $value = "$month/$date/$year";
                    }

                    return strlen($value) > 0 ? $value : NULL;
                }, array_keys($row), array_values($row));

//                error_log(json_encode($row));
//                error_log(json_encode($values));
                array_push($values, $originalFileName);
                try {
                    $stmt->execute($values);
                }
                catch(PDOException $e) {

                    error_log("failed to insert row:");
                    error_log(json_encode($row));
                    error_log($e);

                    $response = new Response(
                        'Content',
                        Response::HTTP_BAD_REQUEST,
                        array('content-type' => 'text/html')
                    );
                    $response->setContent("The input file contains an invalid row. Please check line " . ($index + 1) . ".");
                    return self::addCorsHeaders($response);
                }

            }

/*
            $csvReader = new CSVReader($uploaddir . $fileName, 42, '|');

            // Read the header row and check the number of columns is as expected
            try {
                $csvReader->checkHeaders();

                $index = 0;
                while ($line = $csvReader->getNextLine()) {
                    array_push($line, $originalFileName);

                    $index ++;
                    //error_log($index);
                    //error_log(json_encode($line));
                    $stmt->execute($line);
                }

            } catch (InvalidFileFormatException $e) {
                $response = new Response(
                    'Content',
                    Response::HTTP_BAD_REQUEST,
                    array('content-type' => 'text/html')
                );
                $response->setContent($e->getMessage() );
                $csvReader->close();
                return self::addCorsHeaders($response);
            }

            $csvReader->close();
*/
            $rowCount = $conn->query("SELECT COUNT(*) FROM UploadWorkBook")->fetchColumn();
            $stmt = $conn->prepare("SELECT ORDINAL_POSITION, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_NAME = 'UploadWorkBook' AND COLUMN_NAME != 'InternalId' AND COLUMN_NAME != 'OriginalFileName'
            ORDER BY ORDINAL_POSITION");
            $stmt->execute();
            $columns = $stmt->fetchAll();

            $stmt = $conn->prepare("SELECT TOP(25) " . implode(", ", array_column($columns, 'COLUMN_NAME')) . " FROM UploadWorkBook ORDER BY InternalId");

            $stmt->execute();
            $projects = $stmt->fetchAll();

            $columnsResult = [];
            foreach ($columns as $columnObjArr ) {
                $obj = array('key' => $columnObjArr['COLUMN_NAME'], 'name' => $columnObjArr['COLUMN_NAME'], 'width' => 100, 'resizable' => true, 'filterable' => true, 'sortable' => true);
                array_push($columnsResult, $obj);
            }

            $stmt = null;
            $conn = null;

            $response=array('rowCount' => $rowCount, 'columns' => $columnsResult, 'projects' => $projects);
        }
        catch(PDOException $e)
        {
            $response = $e->getMessage();
        }

        return self::addCorsHeaders(new JsonResponse($response));
    }


    public static function loaddata_mysql(Request $request) {

        $headers = $request->headers;
        $uploaddir = getcwd() . '/modules/custom/data_load/uploads/';
        chdir($uploaddir);
        $fileName = '';
        $response = '';
        foreach($request->files as $uploadedFile) {
            $fileName = $uploadedFile->getClientOriginalName();
            $file = $uploadedFile->move($uploaddir, $fileName);
            chdir($uploaddir);
            $from = $uploaddir . $fileName;
            $to = $uploaddir . $fileName . '.utf8';
            exec('iconv -f UTF-16 -t UTF-8 ' . $from . ' -o ' . $to . '; rm ' . $from . '; mv ' . $to . ' ' .$from . ';');
            // exec("sed -i 's/\r/|\r/g' " . $from);
        }

        $response = 'OK';

        try
        {
            $conn = self::getConnection();
            $conn->exec("Truncate wb; ALTER TABLE wb AUTO_INCREMENT = 1; LOAD DATA LOCAL INFILE '" . $uploaddir . $fileName . "' INTO TABLE wb FIELDS TERMINATED BY '|' LINES TERMINATED BY '\r\n' IGNORE 1 LINES
            (@AwardCode,
            @AwardStartDate,
            @AwardEndDate,
            @SourceId,
            @AltId,
            @NewAltId
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
            NewAltId = nullif(@NewAltId,''),
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
            InternalUseOnly = nullif(@InternalUseOnly,'')");

            $rowCount = $conn->query("SELECT COUNT(*) FROM wb")->fetchColumn();
            $stmt = $conn->prepare("SELECT * FROM wb ORDER BY InternalId limit 25");
            $stmt->execute();
            $projects = $stmt->fetchAll();
            $stmt = null;
            $conn = null;

            $response=array('rowCount' => $rowCount, 'projects' => $projects);

        }
        catch(PDOException $e)
        {
            $response = $e->getMessage();
        }
        return self::addCorsHeaders(new JsonResponse($response));
    }

    public static function export(Request $request) {
        $exportRules = $request->request->get('exportRules', []);
        $originalFileName = $request->request->get('originalFileName', 'N/A');
        $type = $request->request->get('uploadType', 'N/A');
        $partnerCode = $request->request->get('partnerCode', 'N/A');

        if ($exportRules) {
            $exportRules = json_decode($exportRules, true);
        }

        $exportsFolder = getcwd() . '/modules/custom/data_load/exports/';
        if (!file_exists($exportsFolder)) {
            mkdir($exportsFolder, 0744, true);
        }

        $fileName = uniqid('Data_Upload_Export_') . '.xlsx';
        $filePath = $exportsFolder . $fileName;

        $writer = WriterFactory::create(Type::XLSX);
        $writer->openToFile($filePath);

        $conn = self::getConnection();

        foreach ($exportRules as $sheetIndex => $rule) {
            $sheet = $writer->getCurrentSheet();

            // do not allow \ / ? * : [ or ] in title
            $title = substr($rule['name'], 0, 31);
            $title = preg_replace('/[\\\\\/\?\*\[\]]/', '', $title);
            $sheet->setName($title);

            $stmt = $conn->prepare('SET NOCOUNT ON; EXECUTE DataUpload_IntegrityCheckDetails @RuleId=:ruleId, @PartnerCode=:partnerCode');

            $stmt->execute([
                ':ruleId' => $rule['id'],
                ':partnerCode' => $partnerCode,
            ]);

            $headers = [];
            foreach(range(0, $stmt->columnCount() - 1) as $index) {
                $meta = $stmt->getColumnMeta($index);
                array_push($headers, $meta['name']);
            }

            $writer->addRows([
                [$rule['name']],
                [''],
                $headers,
            ]);
            $writer->addRows($stmt->fetchAll(PDO::FETCH_NUM));

            if ($sheetIndex < count($exportRules) - 1) {
                $writer->addNewSheetAndMakeItCurrent();
            }
        }

        $writer->close();
        return self::addCorsHeaders(new JsonResponse($fileName));

    }

    public static function getSponsorCodes() {
        $conn = self::getConnection();
        $stmt = $conn->prepare('SET NOCOUNT ON; EXECUTE GetPartners;');
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_NUM);

        return self::addCorsHeaders(
            new JsonResponse(
                array_column($results, 1)
            )
        );
    }

    private static function calculateFundingAmounts() {

        $pdo = self::getConnection();
        $statement = $pdo->prepare('
                            INSERT INTO ProjectFundingExt(
                                    ProjectFundingID,
                                    CalendarYear,
                                    CalendarAmount)
                            VALUES(:id, :year, :amount)');

        foreach($pdo->query('
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

            $years = null;
        }
        $statement = null;
        $pdo = null;
    }


    public static function importProjects(Request $request) {

        $params = json_decode($request->getContent(), true);

        $partnerCode = $params['partnerCode'] ?? '';
        $fundingYears = $params['fundingYears'] ?? '';
        $importNotes = $params['importNotes'] ?? '';
        $receivedDate = $params['receivedDate'] ?? NULL;
        $type = $params['type'] ?? '';

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

        try {

            $stmt->execute([
                'partnerCode' => $partnerCode,
                'fundingYears' => $fundingYears,
                'importNotes' => $importNotes,
                'receivedDate' => $receivedDate,
                'type' => $type,
            ]);

            self::calculateFundingAmounts();

            return self::addCorsHeaders(
                new JsonResponse(
                    $stmt->fetch()
                )
            );

        }
        catch(PDOException $e) {

            error_log("Failed to run DataUpload_Import with parameters: " . json_encode($params));
            error_log($e->getMessage());

            $response = new Response(
                'Content',
                Response::HTTP_BAD_REQUEST,
                array('content-type' => 'text/html')
            );

            // Remove the text prepended to the user-defined error message by SQL Server
            $messageArray = explode("[SQL Server]", $e->getMessage(), 2);
            $message = "";
            if (count($messageArray == 2)) {
                $message = $messageArray[1];
            } else {
                $message = $messageArray[0];
            }
            $message .= ". The import was aborted.";

            $response->setContent($message);
            return self::addCorsHeaders($response);
        }
    }

    public static function ping() {

        return new Response('Ping you back!');
    }
}

?>