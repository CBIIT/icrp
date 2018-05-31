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

public class TestPartnerApplication {
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
	public static String City = "Montreal";                 //Required
	public static String Zip_Postal_Code = "20850";            //Required
	public static String Description_of_Org = "My organization description";
	public static String Brief_Derscription_of_Research = "My brief research description";
	public static String Year_when_initiated_research = "2017";
	public static String TypeInOther = "Quebec";

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
	public static String current_annual_operating_budget = "10M";          //Optional
	public static String current_annual_operating_budget2 = ""; 
	
	//edit-research-investment-budget-information--content
	public static String Contact_Address1 = "1000 National Institute Blvd.";            
	public static String Contact_Address2 = "Suite 12345";  
	public static String Contact_City_Town = "Rockville";             
	public static String Contact_ZipCode = "28054";  

	//Application CSS Configuration
	public static String appCSSUserActions = "td.sidebarContent";
	
	public TestPartnerApplication(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		

	/////// PARTNER APPLICATION ///////////////	
		
		//S.N.: 1
		//Test Name:  Submit Partner Application - All Fields
		@Test
		public void ICRP_Submit_Partner_Application_All_Fields() throws Exception{
			String testName = "Submit Partner Application - All Fields";
			String testDesc = "Submit Partner Application - All Fields";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.wait_For(5000);
				//Verify Join ICRP and Partner Application page
				Test.clickLink(By.linkText("Join ICRP"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Partner Application"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Thank you for your interest in becoming part of the International Cancer Research Partnership.  Please complete this application and upload the supplementary information requested below.  If you would like to download a copy of this form to review before applying online please click here."),"Thank you for your interest in becoming part of the International Cancer Research Partnership.  Please complete this application and upload the supplementary information requested below.  If you would like to download a copy of this form to review before applying online please click here.");
				Test.expected_vs_actual_verification("ICRP Partnership Application Form");
				Test.wait_For(5000);
				
			///// Fill Out Form /////
				  
				//Organization Information
				Test.form_fill_random_organization_name();
				Test.form_fill_org_info(Organizations_Address1,Organizations_Address2,City,Zip_Postal_Code,Description_of_Org,Brief_Derscription_of_Research,Year_when_initiated_research);
				Test.selectStateProvinceTerritory("Other...",TypeInOther);
				Test.selectCountry("Canada");
				Test.form_fill_Ex_Dir_Pres_Chair(Name, Position, Telephone_number, Email, Confirm_email);
				logger.info("Organization Info Filled Out");
				  
				//Research Investment Budget Information
				Test.form_fill_research_investment_budget_info(Current_annual_research_investment_budget, Reporting_period, Approximate_number_of_projects, current_annual_operating_budget);
				Test.clickLink(By.cssSelector("#edit-tier-radio-1")); //Select Contribution Tier
				Test.clickLink(By.cssSelector("#edit-payment-radio-1-july")); //Select Prefer Date For Payment
				Test.wait_For(5000);
				logger.info("Investment Budget Information Filled Out");
				
				  
				//Contact Person's Information - Optional - No Required Fields
				Test.form_fill_contact_person_info(Contact_Address1,Contact_Address2,Contact_City_Town,Contact_ZipCode);
				Test.selectContactPersonStateProvinceTerritory("Maryland");
				Test.selectContactPersonCountry("United States");
				Test.wait_For(5000);
				logger.info("Contact Person's Information Filled Out");
				
				//ICR Terms & Conditions of membership
				Test.clickLink(By.cssSelector("#edit-icrp-terms-conditions-of-membership > div.panel-heading > a")); 
				Test.wait_For(2000);
				Test.clickLink(By.cssSelector("#edit-terms-1"));
				Test.clickLink(By.cssSelector("#edit-terms-2"));
				Test.clickLink(By.cssSelector("#edit-terms-3"));
				Test.clickLink(By.cssSelector("#edit-terms-4"));
				Test.clickLink(By.cssSelector("#edit-terms-5"));
				Test.clickLink(By.cssSelector("#edit-terms-6"));
				Test.clickLink(By.cssSelector("#edit-terms-7"));
				Test.clickLink(By.cssSelector("#edit-terms-8"));
				logger.info("ICR Terms and Conditions Selected");
				
				
				  //Supplementary Information
				
				Test.clickLink(By.cssSelector("#edit-supplementary-information > div.panel-heading > a"));
				Test.wait_For(5000);
				Test.choose_statement_upload();
				Test.wait_For(2000);
				Test.choose_peer_review_upload();
				Test.wait_For(5000);
				logger.info("Supplementary Information Attached to Form");
				
			
				//Submit Partnership Application
				Test.clickLink(By.cssSelector("#edit-actions-submit"));
				Test.wait_until_element_present(By.name("New submission added to ICRP Partnership Application Form."),"New submission added to ICRP Partnership Application Form.");
				Test.wait_For(5000);
				logger.info("Partnership Application Submitted");
				
				
				
				//Login as Manager
				Test.Login_enter_manager_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
						
				//Verify Partner Application Administration Tool Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Partner Application Administration Tool"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Partner Application Administration Tool"),"Partner Application Administration Tool");
				Test.expected_vs_actual_verification("Application Status");
				Test.wait_For(5000);
		
				//Select for Review
				
				Test.clickLink(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6) > a:nth-child(1)"));
				Test.expected_vs_actual_verification("Less than $5M");
				
				//Review and Complete The Application
				Test.wait_For(2000);
				Test.clickLink(By.id("edit-status-completed"));
				Test.wait_For(2000);
				Test.clickLink(By.id("edit-submit"));
				
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
		//Test Name: Submit Partner Application - Only Required Fields
		@Test
		public void ICRP_Submit_Partner_Application_Only_Required_Fields() throws Exception{
			String testName = "Submit Partner Application - Only Required Fields";
			String testDesc = "Submit Partner Application - Only Required Fields";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.wait_For(5000);
				//Verify Join ICRP and Partner Application page
				Test.clickLink(By.linkText("Join ICRP"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Partner Application"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Thank you for your interest in becoming part of the International Cancer Research Partnership.  Please complete this application and upload the supplementary information requested below.  If you would like to download a copy of this form to review before applying online please click here."),"Thank you for your interest in becoming part of the International Cancer Research Partnership.  Please complete this application and upload the supplementary information requested below.  If you would like to download a copy of this form to review before applying online please click here.");
				Test.expected_vs_actual_verification("ICRP Partnership Application Form");
				Test.wait_For(5000);
				
			///// Fill Out Form /////
				  
				//Organization Information
				Test.form_fill_random_organization_name();
				Test.form_fill_org_info(Organizations_Address1,Organizations_Address2,City,Zip_Postal_Code,Description_of_Org,Brief_Derscription_of_Research,Year_when_initiated_research);
				//Test.selectStateProvinceTerritory("Other...",TypeInOther);
				Test.selectCountry("Canada");
				Test.form_fill_Ex_Dir_Pres_Chair(Name, Position, Telephone_number, Email, Confirm_email);
				logger.info("Organization Info Filled Out");
				  
				//Research Investment Budget Information
				Test.form_fill_research_investment_budget_info(Current_annual_research_investment_budget, Reporting_period, Approximate_number_of_projects, current_annual_operating_budget2);
				Test.clickLink(By.cssSelector("#edit-tier-radio-1")); //Select Contribution Tier
				Test.clickLink(By.cssSelector("#edit-payment-radio-1-july")); //Select Prefer Date For Payment
				Test.wait_For(5000);
				logger.info("Investment Budget Information Filled Out");
				
				  
				//Contact Person's Information - Optional - No Required Fields
				//Test.form_fill_contact_person_info(Contact_Address1,Contact_Address2,Contact_City_Town,Contact_ZipCode);
				//Test.selectContactPersonStateProvinceTerritory("Maryland");
				//Test.selectContactPersonCountry("United States");
				//Test.wait_For(5000);
				//logger.info("Contact Person's Information Filled Out");
				
				//ICR Terms & Conditions of membership
				Test.clickLink(By.cssSelector("#edit-icrp-terms-conditions-of-membership > div.panel-heading > a")); 
				Test.wait_For(2000);
				Test.clickLink(By.cssSelector("#edit-terms-1"));
				Test.clickLink(By.cssSelector("#edit-terms-2"));
				Test.clickLink(By.cssSelector("#edit-terms-3"));
				Test.clickLink(By.cssSelector("#edit-terms-4"));
				Test.clickLink(By.cssSelector("#edit-terms-5"));
				Test.clickLink(By.cssSelector("#edit-terms-6"));
				Test.clickLink(By.cssSelector("#edit-terms-7"));
				Test.clickLink(By.cssSelector("#edit-terms-8"));
				logger.info("ICR Terms and Conditions Selected");
				
				
				  //Supplementary Information
				
				Test.clickLink(By.cssSelector("#edit-supplementary-information > div.panel-heading > a"));
				Test.wait_For(5000);
				Test.choose_statement_upload();
				Test.wait_For(2000);
				Test.choose_peer_review_upload();
				Test.wait_For(5000);
				logger.info("Supplementary Information Attached to Form");
				
			
				//Submit Partnership Application
				Test.clickLink(By.cssSelector("#edit-actions-submit"));
				Test.wait_until_element_present(By.name("New submission added to ICRP Partnership Application Form."),"New submission added to ICRP Partnership Application Form.");
				Test.wait_For(5000);
				logger.info("Partnership Application Submitted");
				
				
				
				//Login as Manager
				Test.Login_enter_manager_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				logger.info("Logged in as Manager.");
						
				//Verify Partner Application Administration Tool Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Partner Application Administration Tool"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Partner Application Administration Tool"),"Partner Application Administration Tool");
				Test.expected_vs_actual_verification("Application Status");
				Test.wait_For(5000);
		
				//Select for Review
				
				Test.clickLink(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6) > a:nth-child(1)"));
				Test.expected_vs_actual_verification("Less than $5M");
				
				//Review and Complete The Application
				Test.wait_For(2000);
				Test.clickLink(By.id("edit-status-completed"));
				Test.wait_For(2000);
				Test.clickLink(By.id("edit-submit"));
				
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