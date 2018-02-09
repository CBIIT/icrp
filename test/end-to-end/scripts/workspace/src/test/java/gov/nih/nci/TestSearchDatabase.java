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

public class TestSearchDatabase {
	static BaseMethods Test = new BaseMethods();
	private static Logger logger=Logger.getLogger("TestSuite");
	public static String seleniumBrowser = "firefox";
	public static String tier = "dev";

	public static String HostName = "https://www.icrpartnership-test.org/";

	public static String seleniumUrl = HostName + "";
		
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
	
	public TestSearchDatabase(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		

		
	/////// Search Database ///////////////		
		
		//S.N.: 1
		//Test Name: Search Database - Partner
		@Test
		public void ICRP_Search_Database_Partner() throws Exception{
			String testName = "Search Database - Partner";
			String testDesc = "Search Database - Partner";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_manager_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
		
				//Verify Search ICRP Database Page
				Test.clickLink(By.linkText("Search & Analysis"));
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("Search ICRP Database");
				Test.wait_For(5000);
				
				//Click Clear Database
				
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > div > button:nth-child(3)"));
				logger.info("Clicked Clear button");
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("All Years Selected");
				
				//Perform Specific Search
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(2) > div.ui-panel-header"));
				logger.info("Click Institutions and Investigations");
				Test.wait_For(5000);
				//Test.clickLink(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel.ng-tns-c9-2 > div.ui-panel-content.ng-trigger.ng-trigger-visibilityChanged > ui-select:nth-child(12) > div > div.select-input-container.default > div > input"));
				Test.clickLink(By.cssSelector("ui-select.ng-untouched:nth-child(11) > div:nth-child(1) > div:nth-child(1) > div:nth-child(1) > input:nth-child(1)"));
				logger.info("Click Country");
				Test.wait_For(2000);
				Test.enter_country("United States");
				logger.info("Country selected.");
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel.ng-tns-c9-3 > div.ui-panel-header"));
				logger.info("Funding Organizations clicked.");
				Test.wait_For(2000);
				Test.clickLink(By.cssSelector("div.multiselect:nth-child(5) > ui-treeview:nth-child(1) > div:nth-child(1) > div:nth-child(3) > div:nth-child(1) > div:nth-child(3) > div:nth-child(1) > div:nth-child(5) > div:nth-child(1) > label:nth-child(1) > input:nth-child(1)"));
				Test.wait_For(5000);
				logger.info("National Cancer Institute selected.");
				
				//Click Search 
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(1)"));
				logger.info("Clicked Search button.");
				Test.wait_For(5000);
				
				//Check 6 Buttons
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-email-results-button:nth-child(1)"),"Email Results");
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-export-button:nth-child(2) > button:nth-child(2)"),"Export Results");
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-export-button:nth-child(3) > button:nth-child(2)"),"Export Singles");
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-export-button:nth-child(4) > button:nth-child(2)"),"Export Abstracts");
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-export-button:nth-child(5) > button:nth-child(2)"),"Export Abstracts Singles");
				Test.wait_until_element_present(By.cssSelector("span.pull-right > icrp-export-button:nth-child(1) > button:nth-child(2)"),"Export Graphs");
				logger.info("Buttons checked.");
				
				//Click Search Criteria
				Test.clickLink(By.cssSelector("span.pull-left:nth-child(1) > div:nth-child(1)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.cssSelector(".display-parameters > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2)"),"US");
				Test.wait_until_element_present(By.cssSelector(".display-parameters > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(2)"),"NIH - National Cancer Institute");
				logger.info("Search Criteria checked.");
				
				//Click Reset
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(2)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.cssSelector("div.select-label:nth-child(1) > div:nth-child(1)"),"2017");
				Test.wait_until_element_present(By.cssSelector("div.select-label:nth-child(2) > div:nth-child(1)"),"2016");
				
				
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
		//Test Name: Search Database - Public
		@Test
		public void ICRP_Search_Public_Database() throws Exception{
			String testName = "Search Database - Public";
			String testDesc = "Search Database - Public";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.wait_For(5000);
				
				//Verify ICRP Public Page
				Test.expected_vs_actual_verification("Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.");
				Test.wait_For(5000);
				
				//Click ICRP Data
				Test.clickLink(By.cssSelector("#anonymous-navbar > ul > li:nth-child(3) > a"));
				Test.wait_For(5000);
				logger.info("Click ICRP Data");
				//Click Search Database
				Test.clickLink(By.cssSelector("#anonymous-navbar > ul > li.dropdown.open > ul > li:nth-child(1) > a"));
				logger.info("Click Search Database");
				//Verify Search Database Page
				Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > h1"),"Search ICRP Database");
				Test.wait_For(1000);
				Test.wait_until_element_present(By.cssSelector("#block-anonymoususermenu > div > div.field--item > div:nth-child(2) > a"),"Log in");  //Check user is not logged in
				Test.wait_For(1000);
				//Click Clear Database
				
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > div > button:nth-child(3)"));
				//Test.clickLink(By.xpath("/html/body/div[1]/div/section/div[2]/icrp-root/div/icrp-search-page/div/div[1]/icrp-search-form/form/div/button[3]"));
				Test.wait_For(5000);
				logger.info("Click Clear Database");
				
				Test.expected_vs_actual_verification("All Years Selected");
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("Enter search terms");
				
				//Expand Cancer and Project Type
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(4) > div.ui-panel-header"));
				Test.wait_For(2000);
				logger.info("Expand Cancer and Project Type");
				//Click on Select Cancer Type
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(4) > div.ui-panel-content > ui-select:nth-child(2) > div > div.select-input-container.default > div > input"));
				Test.wait_For(2000);
				logger.info("Click on Select Cancer Type");
				//Select Bladder Cancer
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(4) > div.ui-panel-content > ui-select:nth-child(2) > div > div.select-dropdown.default > div:nth-child(3)"));
				Test.wait_For(5000);
				logger.info("Select Bladder Cancer");
				//Click Search Button for Bladder Cancer
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(1)"));
				Test.wait_For(5000);
				logger.info("Click Search Button for Bladder Cancer");
				//Check 3 Buttons on search results page
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-email-results-button:nth-child(1)"),"Email Results");
				Test.wait_until_element_present(By.cssSelector(".margin-bottom > icrp-export-button:nth-child(2) > button:nth-child(2)"),"Export Results");
				Test.wait_until_element_present(By.cssSelector("span.pull-right > icrp-export-button:nth-child(1) > button:nth-child(2)"),"Export Graphs");
				logger.info("Check 3 Buttons on search results page");
				//Click Search Criteria and check that only Bladder Cancer is listed
				Test.clickLink(By.cssSelector("span.pull-left:nth-child(1) > div:nth-child(1)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-9 > icrp-search-summary-panel > icrp-summary-panel > div.content > div > table > tbody > tr:nth-child(2) > td:nth-child(2)"),"Bladder Cancer");
				
				//Click on Year Active and select 2012 and 2013
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(1) > div.ui-panel-content > ui-select > div > div.select-input-container.default > div > input"));
				Test.wait_For(2000);
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(1) > div.ui-panel-content > ui-select > div > div.select-dropdown.default > div:nth-child(7)"));  //Select 2012
				Test.clickLink(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(1) > div.ui-panel-content > ui-select > div > div.select-dropdown.default > div:nth-child(6)"));  //Select 2013
				
				//Click Search Button for Bladder Cancer for Years 2012 and 2013
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(1)"));
				Test.wait_For(5000);
				
				//Click Search Criteria and check that only Bladder Cancer and 2013,2013 are listed
				Test.clickLink(By.cssSelector("span.pull-left:nth-child(1) > div:nth-child(1)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-9 > icrp-search-summary-panel > icrp-summary-panel > div.content > div > table > tbody > tr:nth-child(1) > td:nth-child(2)"),"2012,2013");
				Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-9 > icrp-search-summary-panel > icrp-summary-panel > div.content > div > table > tbody > tr:nth-child(3) > td:nth-child(2)"),"Bladder Cancer");
				
				//Click Reset
				Test.clickLink(By.cssSelector("div.text-right:nth-child(6) > button:nth-child(2)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.cssSelector("div.select-label:nth-child(1) > div:nth-child(1)"),"2017");
				Test.wait_until_element_present(By.cssSelector("div.select-label:nth-child(2) > div:nth-child(1)"),"2016");
				
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