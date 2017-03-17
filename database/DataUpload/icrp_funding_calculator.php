<?php

if (sizeof($argv) != 5) {
    print("Usage: php icrp_funding_calculator.php <host> <database> <user> <password>");
    die();
}

$host = $argv[1];
$database = $argv[2];
$target_url = 'sqlsrv:Server=' . $host . ';Database=' . $database;
$user = $argv[3];
$password = $argv[4];

try {
    $dbh = new PDO($target_url, $user, $password);
    $statement = $dbh->prepare("INSERT INTO ProjectFundingExt(ProjectFundingID, CalendarYear, CalendarAmount) VALUES(:id, :year, :amount)");
    foreach($dbh->query('SELECT ProjectId, pf.ProjectFundingID, BudgetStartDate, BudgetEndDate, Amount FROM ProjectFunding pf LEFT  OUTER JOIN ProjectFundingExt pfe ON pf.ProjectFundingID = pfe.ProjectFundingID WHERE  pfe.ProjectFundingID IS NULL') as $row) {
        
        $projectFundingID = $row['ProjectFundingID'];
        $start_date = strtotime($row['BudgetStartDate']);
        $end_date = strtotime($row['BudgetEndDate']);
        $start_date = mktime(0, 0, 0, date("m", $start_date), date("d", $start_date), date("Y", $start_date));
        $end_date = mktime(0, 0, 0, date("m", $end_date), date("d", $end_date), date("Y", $end_date));
        $total_amount = $row['Amount'];
        $number_of_days = ($end_date - $start_date) / (60 * 60 * 24) + 1;
        if ($number_of_days <= 0) {
            print "Error: Project with project funding ID " . $projectFundingID . " has a duration of " . ($number_of_days - 1) . " days. Skipping over this project.\n";
            continue;
        }
        $amount_per_day = $total_amount / $number_of_days;

        
        // print("Start date: " . $row['BudgetStartDate'] . " | End date: " . $row['BudgetEndDate'] . " | Amount: " . $row['Amount'] . "\n");
        // print("Number of Days: " . $number_of_days . " | Amount per day: " . $amount_per_day . "\n");
        
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
            $current_date = mktime(0, 0, 0, date("m", $current_date), date("d", $current_date) + 1, date("Y", $current_date));
        }
        
        $years[$current_year] = array('year' => $current_year, 'amount' => $day_counter * $amount_per_day, 'days' => $day_counter);
        
        foreach($years as $year_arr) {
            // print($projectFundingID . ", " . $year_arr['year'] . ", " . $year_arr['amount'] . ", " . $year_arr['days'] . "\n");
            $statement->execute(array("id" => $projectFundingID, "year" => $year_arr['year'], "amount" => $year_arr['amount']));
        }
        
        $years = null;
        
    }
    
    $statement = null;
    $dbh = null;
    
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}

?>