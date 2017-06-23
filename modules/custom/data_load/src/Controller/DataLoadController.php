<?php


namespace Drupal\data_load\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use \PDO;

class DataLoadController {
    
    /**
    * Adds CORS Headers to a response
    */
    function addCorsHeaders($response) {
        $response->headers->set('Access-Control-Allow-Headers', 'origin, content-type, accept');
        $response->headers->set('Access-Control-Allow-Origin', '*');
        $response->headers->set('Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, PATCH, OPTIONS');
        
        return $response;
    }
    
    function getConnection() {
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
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
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

    public function load_app() {
        return [
            '#theme'    => 'data_load',
            '#attached' => [
                'library'   => [
                    'data_load/resources'
                ],
            ],
        ];
    }
    
    public function integrity_check_mssql(Request $request) {
        $conn = self::getConnection();
        $stmt = $conn->prepare('SET NOCOUNT ON; EXECUTE DataUpload_IntegrityCheck @type=:type');
        //$stmt->bindParam(':type', $request->request->get('New'));
        $stmt->bindParam(':type', $request->request->get(type));
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response=array('results' => $results);
        
        return self::addCorsHeaders(new JsonResponse($response));
    }
    
    public function integrity_check_details_mssql(Request $request) {
        $conn = self::getConnection();
        $stmt = $conn->prepare('SET NOCOUNT ON; EXECUTE DataUpload_IntegrityCheckDetails @RuleId=:ruleId');
        $stmt->bindParam(':ruleId', $request->request->get(ruleId));
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response=array('results' => $results);
        
        return self::addCorsHeaders(new JsonResponse($response));
    }
    
    public function getdata(Request $request) {
        $page = $request->request->get(page);
        $conn = self::getConnection();
        
        $offset = ($page - 1) * 25;
        $stmt = $conn->prepare('SELECT * FROM wb ORDER BY InternalId limit :offset, 25');
        $stmt->bindParam(':offset', $offset);
        $stmt->execute();
        $projects = $stmt->fetchAll();
        $stmt = null;
        $conn = null;
        
        $response=array('projects' => $projects);
        
        return self::addCorsHeaders(new JsonResponse($response));
    }
    
    public function getdata_mssql(Request $request) {
        $page = $request->request->get(page);
        
        $sortDirectionKeys = array("ASC", "DESC");
        $key = array_Search($request->request->get(sortDirection), $sortDirectionKeys);
        $sortDirection = $sortDirectionKeys[$key];
        
        $orderByKeys = array("InternalId", "AwardCode", "AwardStartDate", "AwardEndDate", "SourceId", "AltId", "AwardTitle", "Category",
        "AwardType", "Childhood", "BudgetStartDate", "BudgetEndDate", "CSOCodes", "CSORel", "SiteCodes", "SiteRel", "AwardFunding", "IsAnnualized", "FundingMechanismCode", "FundingMechanism",
        "FundingOrgAbbr", "FundingDiv", "FundingDivAbbr", "FundingContact", "PILastName", "PIFirstName", "SubmittedInstitution", "City", "State", "Country", "PostalZipCode", "InstitutionICRP", "Latitute", "Longitute", "GRID",
        "TechAbstract", "PublicAbstract", "RelatedAwardCode", "RelationshipType", "ORCID", "OtherResearcherID", "OtherResearcherIDType", "InternalUseOnly");
        $key = array_Search($request->request->get(sortColumn), $orderByKeys);
        $sortColumn = $orderByKeys[$key];
        
        $conn = self::getConnection();
        
        $offset = ($page - 1) * 25;
        $stmt = $conn->prepare("SELECT * FROM  ( SELECT ROW_NUMBER() OVER(ORDER BY $sortColumn $sortDirection) NUM, * FROM UploadWorkBook_Svet ) A WHERE NUM > ? AND NUM <= ?");
        $stmt->execute(array($offset, $offset + 25));
        $projects = $stmt->fetchAll();
        $stmt = null;
        $conn = null;
        
        $response=array('projects' => $projects);
        
        return self::addCorsHeaders(new JsonResponse($response));
    }
    
    public function loaddata_mssql(Request $request) {
        $uploaddir = getcwd() . '/modules/custom/data_load/uploads/';
        $fileName = '';
        $response = '';
        $originalFileName = $request->request->get(originalFileName);
        foreach($request->files as $uploadedFile) {
            $fileName = $uploadedFile->getClientOriginalName();
            $file = $uploadedFile->move($uploaddir, $fileName);
            chdir($uploaddir);
            $from = $uploaddir . $fileName;
            $to = $uploaddir . $fileName . '.utf8';
            exec('iconv -f UTF-16 -t UTF-8 ' . $from . ' -o ' . $to . '; rm ' . $from . '; mv ' . $to . ' ' .$from . ';');
            exec("sed -i 's/\r/|\r/g' " . $from);
        }
        
        $response=array('rowCount' => 50, 'projects' => array());
        
        try {
            $conn = self::getConnection();
            $conn->exec("DROP TABLE IF EXISTS UploadWorkBook_Svet");
            $conn->exec("CREATE TABLE UploadWorkBook_Svet (	
                        InternalId int IDENTITY (1,1), 
	                    AwardCode NVARCHAR(50),
	                    AwardStartDate Date,
	                    AwardEndDate date,
                        SourceId VARCHAR(50),
                        AltId VARCHAR(50),
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
                        AwardFunding float,
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
                        State VARCHAR(3),
                        Country VARCHAR(3),
                        PostalZipCode VARCHAR(15),
                        InstitutionICRP VARCHAR(4000),
                        Latitute decimal(9,6),
                        Longitute decimal(9,6),
                        GRID VARCHAR(50),
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

            $stmt = $conn->prepare("INSERT INTO UploadWorkBook_Svet ([AwardCode], [AwardStartDate], [AwardEndDate], [SourceId], [AltId], [AwardTitle], [Category],
            [AwardType], [Childhood], [BudgetStartDate], [BudgetEndDate], [CSOCodes], [CSORel], [SiteCodes], [SiteRel], [AwardFunding], [IsAnnualized], [FundingMechanismCode], [FundingMechanism],
            [FundingOrgAbbr], [FundingDiv], [FundingDivAbbr], [FundingContact], [PILastName], [PIFirstName], [SubmittedInstitution], [City], [State], [Country], [PostalZipCode], [InstitutionICRP], [Latitute], [Longitute], [GRID],
            [TechAbstract], [PublicAbstract], [RelatedAwardCode], [RelationshipType], [ORCID], [OtherResearcherID], [OtherResearcherIDType], [InternalUseOnly], [OriginalFileName]) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
            $csvReader = new CSVReader($uploaddir . $fileName, 42, '|');
            try {
                $csvReader->checkHeaders();
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
            
            while( ($lineArr = $csvReader->getNextLine()) != false ) {
                array_push($lineArr, $originalFileName);
                $stmt->execute($lineArr);
            }
            
            $csvReader->close();
            
            $rowCount = $conn->query("SELECT COUNT(*) FROM UploadWorkBook_Svet")->fetchColumn();
            $stmt = $conn->prepare("SELECT ORDINAL_POSITION, COLUMN_NAME FROM icrp_dataload.INFORMATION_SCHEMA.COLUMNS 
                                    WHERE TABLE_NAME = 'UploadWorkBook_Svet' AND COLUMN_NAME != 'InternalId' AND COLUMN_NAME != 'OriginalFileName' 
                                    ORDER BY ORDINAL_POSITION");
            $stmt->execute();
            $columns = $stmt->fetchAll();
            
            $stmt = $conn->prepare("SELECT TOP(25) " . implode(", ", array_column($columns, 'COLUMN_NAME')) . " FROM UploadWorkBook_Svet ORDER BY InternalId");
            
            $stmt->execute();
            $projects = $stmt->fetchAll();
            
            $columnsResult = [];
            foreach ($columns as $columnObjArr ) {
                $obj = array('key' => $columnObjArr['COLUMN_NAME'], 'name' => $columnObjArr['COLUMN_NAME'], 'width' => 200, 'resizable' => true, 'filterable' => true, 'sortable' => true);
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
    
    public function loaddata_mysql(Request $request) {
        
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
            exec("sed -i 's/\r/|\r/g' " . $from);
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
    
    public function ping() {
        
        return new Response('Ping you back!');
    }
}

?>