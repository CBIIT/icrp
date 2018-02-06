package gov.nih.nci;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
//import org.openqa.selenium.internal.seleniumemulation.Click;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

import gov.nih.nci.HelperMethods.BaseTestMethods;
import gov.nih.nci.HelperMethods.BaseMethods;

import org.junit.*;
import org.apache.log4j.Logger;

public class TestPartnerDataUpload {
	static BaseMethods Test = new BaseMethods();
	private static Logger logger=Logger.getLogger("TestSuite");
	public static String seleniumBrowser = "firefox";
	public static String tier = "dev";

	public static String HostName = "https://www.icrpartnership-test.org/";

	public static String seleniumUrl = HostName + "";

	public static String ManagerUserName = "manager@icrpartnership.org";
	public static String ManagerPassword = "ICRPManager!23";
		
	//Organization Information Form
	public static String Organizations_Name = "Leidos";            //Required
	public static String Organizations_Address1 = "9605 Medical Center Drive";   //Required
	public static String Organizations_Address2 = "SAMPLES";
	public static String City = "Rockville";                 //Required
	public static String Zip_Postal_Code = "20850";            //Required
	public static String Description_of_Org = "My organization description";
	public static String Brief_Derscription_of_Research = "My brief research description";
	public static String Year_when_initiated_research = "2017";

	//Executive Director/President/Chairperson Form
	public static String Name = "John Smith";            //Required
	public static String Position = "CEO";   //Required
	public static String Telephone_number = "800-1213-5467";             //Required
	public static String Email = "jsmith@google.com";                //Required
	public static String Confirm_email = "jsmith@google.com";            //Required
	
	//edit-research-investment-budget-information--content
	public static String Current_annual_research_investment_budget = "1000M";            //Required
	public static String Reporting_period = "2017";   //Required
	public static String Approximate_number_of_projects = "5";             //Required
	


	//Application CSS Configuration
	public static String appCSSUserActions = "td.sidebarContent";
	
	public TestPartnerDataUpload(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// PARTNER DATA UPLOAD ///////////////
	
		//S.N.: 1
		//Test Name: Partner Data Upload - Valid Data
		@Test
		public void Partner_Data_Upload_Valid_Data() throws Exception{
			String testName = "Partner Data Upload - Valid Data";
			String testDesc = "Partner Data Upload - Valid Data";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.login(ManagerUserName, ManagerPassword, "pass");
				//Verify First Login Page
				Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
				Test.expected_vs_actual_verification("ICRP Partner");
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				
				//Verify Search ICRP Database Page
				Test.clickLink(By.linkText("Search and Analyze"));
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("Search ICRP Database");
				Test.wait_For(5000);
				
				//Perform Specific Search
				
				Test.clickLink(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel.ng-tns-c9-2 > div.ui-panel-header"));
				Test.wait_For(5000);
				logger.info("Clicked Institutions and Investigators");
				Test.enter_award_code("Automation");
				Test.wait_For(5000);
				logger.info("Award code entered.");
				
				//Click Search 
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(1)"));
				logger.info("Clicked Search");
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("No results found"); 
				logger.info("No results found returned");
				
				Test.clickLink(By.cssSelector("li.dropdown:nth-child(1) > a:nth-child(1)"));
				Test.wait_For(2000);
				Test.clickLink(By.cssSelector("li.dropdown:nth-child(1) > ul:nth-child(2) > li:nth-child(8) > a:nth-child(1)"));
				Test.wait_For(2000);
				logger.info("Clicked Partner Data Upload Tool");
				Test.wait_For(2000);
				Test.expected_vs_actual_verification("Data Upload Tool");
				logger.info("Data Upload Tool page presented.");
				
				//Select Data File To Upload
				
				Test.choose_data_upload();
				logger.info("Data file uploaded.");
				Test.wait_For(2000);
				Test.selectSponsorCode("ASTRO");
				logger.info("Sponsor code selected.");
				Test.enter_current_calendar_date();
				logger.info("Current Calendar Date entered.");
				Test.wait_For(5000);
				
				
				//Click Load Button
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div > div > form > div.col-lg-5.col-xs-12 > div:nth-child(2) > div > div > button:nth-child(1)"));
				logger.info("Load button clicked.");
				Test.wait_For(2000);
				
				//Verify Award Code
				Test.clickLink(By.cssSelector("div.react-grid-HeaderCell:nth-child(1) > div:nth-child(1)"));  //Sort the Award Code Column
				Test.wait_For(2000);
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(2) > div.react-grid-Container > div > div > div:nth-child(2) > div > div > div > div:nth-child(1) > div:nth-child(1) > div > div > span > div"),"Leidos1_17-4");
				logger.info("Award Code present");
				Test.wait_For(2000);
				
				//Click Next Button
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div.text-center.padding-top > button"));
				Test.wait_For(2000);
				logger.info("Click Next Button");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(1) > div.component-panel-header.false > div.component-panel-title"),"Validation Rules");
				logger.info("Data Integrity Check Tab is Active");
				
				//Perform Check
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(1) > div.collapse.in.panel.panel-default > div > div.text-center.padding-top > button"));
				logger.info("Perform Check clicked.");
				Test.wait_For(2000);
				
				//Verify Under Data Integrity Check Summary
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(2) > div > span:nth-child(1) > div > div.col-xs-6"),"Total Base Projects (Unique AwardCodes)");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(2) > div > span:nth-child(1) > div > div.col-xs-2"),"4");
				logger.info("Data Integrity Check Tab is Active");
				logger.info("Total Base Projects (Unique AwardCodes)is 4");
				
				//Verify Data Check Results
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(1) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(2) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(3) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(4) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(5) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(6) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(7) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(8) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(9) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(10) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(11) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(12) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(13) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(14) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(15) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(16) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(17) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child18) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(19) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(20) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(21) > span > div > div.success-list-item.col-xs-2"),"Pass");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > div > div:nth-child(22) > span > div > div.success-list-item.col-xs-2"),"Pass");
				logger.info("Data Integrity Check Results all Pass");
				
				Test.checkExportErrorRecordsButton();
				Test.wait_For(2000);
				
				//Click Next Button at bottom of page
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div.text-center.padding-top > button:nth-child(2)"));
				logger.info("Next button is clicked.");
				
				Test.expected_vs_actual_verification("Please provide the following information and click Import to import the data to staging.");
				logger.info("Import Tab is active");
				
				Test.enter_funding_year_begin("2010");
				Test.wait_For(2000);
				Test.enter_funding_year_end("2019");
				Test.wait_For(2000);
				logger.info("Entered funding year start and end.");
				
				Test.enter_import_notes();
				logger.info("Import notes entered");
				Test.wait_For(2000);
				
				//Click Import Button
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(2) > div:nth-child(2) > button:nth-child(2)"));
				Test.wait_For(5000);
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div.alert.alert-success.alert-dismissable"),"The uploaded projects were imported successfuly.");
				logger.info("Import confirmation message presented.");
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div:nth-child(2) > table > tr:nth-child(1) > td:nth-child(1)"),"Project Count");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div:nth-child(2) > table > tr:nth-child(1) > td:nth-child(2)"),"4");
				logger.info("Project Count is 4");
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div:nth-child(2) > table > tr:nth-child(4) > td:nth-child(1)"),"Project CSO Count");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div:nth-child(2) > table > tr:nth-child(4) > td:nth-child(2)"),"9");
				logger.info("Project CSO Count is 9");
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div:nth-child(2) > table > tr:nth-child(5) > td:nth-child(1)"),"Project Cancer Type Count");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div:nth-child(2) > table > tr:nth-child(5) > td:nth-child(2)"),"5");
				logger.info("Project Cancer Type Count is 5");
				
				Test.wait_For(5000);
				
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(3) > div.form-group > a"));
				logger.info("Data Review Tool link clicked.");
				Test.wait_For(5000);
				
				Test.expected_vs_actual_verification("Data Review Tool");
				logger.info("Data Review Tool page is presented.");
				
				Test.wait_until_element_present(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-review-page > div > icrp-review-uploads-table > table > tbody > tr:nth-child(1) > td:nth-child(1)"),"ASTRO");
				Test.wait_until_element_present(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-review-page > div > icrp-review-uploads-table > table > tbody > tr:nth-child(1) > td:nth-child(2)"),"2010 - 2019");
				Test.wait_until_element_present(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-review-page > div > icrp-review-uploads-table > table > tbody > tr:nth-child(1) > td:nth-child(3)"),"New");
					
				Test.clickLink(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-review-page > div > icrp-review-uploads-table > table > tbody > tr:nth-child(1) > td:nth-child(6) > button"));
				logger.info("Update Prod button clicked");
				Test.wait_For(5000);
				
				Test.wait_until_element_present(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-review-page > alert > div"),"Congratulations! The selected partner data book has been successfully loaded into the production database.");
				logger.info("Prod Upload confirmation message presented.");
				Test.wait_For(2000);
				
				//Verify Search ICRP Database Page
				Test.clickLink(By.linkText("Search and Analyze"));
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("Search ICRP Database");
				Test.wait_For(5000);
				
				//Perform Specific Search
				
				Test.clickLink(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel.ng-tns-c9-2 > div.ui-panel-header"));
				Test.wait_For(5000);
				logger.info("Clicked Institutions and Investigators");
				Test.enter_award_code("Automation");
				Test.wait_For(5000);
				logger.info("Award code entered.");
				
				//Click Search 
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(1)"));
				logger.info("Clicked Search");
				Test.wait_For(5000);
				
				//Verify projects uploaded is now listed in search results on Search and Analyze page.
				
				
				
				Test.wait_For(10000);
				//Test.logout();
				logger.info("---------------End of Test " + testName + "--------------------------------------");
				logger.info("Test "+testName+ " Passed");
				Test.setupAfterSuite();
			}catch (Exception e){
				logger.error("Test "+testName+" failed. Error: -"+e.getMessage());
				logger.info("---------------End of Test "+ testName + "--------------------------------------");
				Test.setupAfterSuite();		
			}
		}
		
		//S.N.: 2
		//Test Name: Partner Data Upload - Invalid File Format
		@Test
		public void Partner_Data_Upload_Invalid_File_Format() throws Exception{
			String testName = "Partner Data Upload - Invalid File Format";
			String testDesc = "Partner Data Upload - Invalid File Format";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.login(ManagerUserName, ManagerPassword, "pass");
				//Verify First Login Page
				Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
				Test.expected_vs_actual_verification("ICRP Partner");
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_For(1000);
				
				Test.clickLink(By.cssSelector("li.dropdown:nth-child(1) > a:nth-child(1)"));
				Test.wait_For(2000);
				Test.clickLink(By.cssSelector("li.dropdown:nth-child(1) > ul:nth-child(2) > li:nth-child(8) > a:nth-child(1)"));
				Test.wait_For(2000);
				logger.info("Clicked Partner Data Upload Tool");
				Test.wait_For(2000);
				Test.expected_vs_actual_verification("Data Upload Tool");
				logger.info("Data Upload Tool page presented.");
				
				//Select Data File To Upload
				
				Test.choose_bad_data_upload();
				logger.info("Data file uploaded.");
				Test.wait_For(2000);
				Test.selectSponsorCode("ASTRO");
				logger.info("Sponsor code selected.");
				Test.enter_current_calendar_date();
				logger.info("Current Calendar Date entered.");
				
				//Click Load Button
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div > div > form > div.col-lg-5.col-xs-12 > div:nth-child(2) > div > div > button:nth-child(1)"));
				logger.info("Load button clicked.");
				Test.wait_For(2000);
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div.alert.alert-danger.alert-dismissable"),"The input file does not contain the expected number of columns.");
				logger.info("Error message presented: The input file does not contain the expected number of columns.");
				Test.wait_For(5000);
				
				Test.clickLink(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div.panel.panel-default > div > form > div.col-lg-5.col-xs-12 > div:nth-child(2) > div > div > button:nth-child(2)"));
				logger.info("Reset button clicked.");
				
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div > div > form > div.col-lg-4.col-md-5.col-xs-12 > div:nth-child(2) > div > select > option:nth-child(1)"),"Select a sponsor code");
				Test.wait_until_element_present(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div > div > form > div.col-lg-6.col-md-7.col-xs-12 > div:nth-child(2) > div > div > input"),"Click to select a date");
				logger.info("Fields are reset.");
				
				
				Test.wait_For(10000);
				//Test.logout();
				logger.info("---------------End of Test " + testName + "--------------------------------------");
				logger.info("Test "+testName+ " Passed");
				Test.setupAfterSuite();
			}catch (Exception e){
				logger.error("Test "+testName+" failed. Error: -"+e.getMessage());
				logger.info("---------------End of Test "+ testName + "--------------------------------------");
				Test.setupAfterSuite();		
			}
		}
		
		
		@After
	  public void tearDown() throws Exception {
		Test.shutdown();
	  }
}