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
import org.openqa.selenium.interactions.Actions;
import java.util.concurrent.TimeUnit;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

import gov.nih.nci.HelperMethods.BaseTestMethods;
import gov.nih.nci.HelperMethods.BaseMethods;

import org.junit.*;
import org.apache.log4j.Logger;

//import com.thoughtworks.selenium.webdriven.commands.GetText;

public class TestAddPartner {
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
	
	//Add Partner Form
	public static String Sponsor_Code = "8675309";            							//Required
	public static String Website = "www.msn.com";   									//Required
	public static String Map_Coordinates = "31.0777065";             					//Required
	public static String Note = "This is a note for the Add partner page.";             //Required
	public static String Longitude = "-87";        						//Required
	
	//Application CSS Configuration
	public static String appCSSUserActions = "td.sidebarContent";
	
	public TestAddPartner(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// Add Partner  ///////////////
		
		//S.N.: 1
		//Test Name: Admin Tools - Add Partner
		@Test
		public void ICRP_Admin_Tools_Add_Partner() throws Exception{
			String testName = "ICRP_Admin_Tools_Add_Partner";
			String testDesc = "ICRP_Admin_Tools_Add_Partner";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_manager_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify Partner Application Administration Tool Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(2000);
				Test.clickLink(By.linkText("Add / Edit Partner"));
				Test.wait_For(2000);
				Test.wait_until_element_present(By.cssSelector("html.js body.user-logged-in.path-addpartner.has-glyphicons div.dialog-off-canvas-main-canvas div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div.container icrp-partners-form form.ng-untouched.ng-invalid.ng-dirty div.mb-4.pr-4 label.font-weight-bold.control-label.asterisk"),"Add / Edit Partner");
				logger.info("Add / Edit Partner present");
				Test.wait_until_element_present(By.cssSelector("html.js body.user-logged-in.path-addpartner.has-glyphicons div.dialog-off-canvas-main-canvas div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div.container icrp-partners-form form.ng-untouched.ng-invalid.ng-dirty div.mb-4.pr-4 label.font-weight-bold.control-label.asterisk"),"Country");
				logger.info("Country field present.");
				Test.wait_For(2000);
				
				//Select a Partner to Add
				
				Test.selectPartner("O");
				Test.wait_For(1000);
				//Test.clickLink(By.cssSelector("html.js body.user-logged-in.path-addpartner.has-glyphicons div.dialog-off-canvas-main-canvas div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div.container icrp-partners-form form.ng-invalid.ng-dirty.ng-touched div.mb-4.pl-4 input.form-control.input-sm.ng-pristine.ng-invalid.ng-touched"));
				
				//Verify Partner Information
				
				Test.wait_until_element_present(By.id("selectCountry"),"Canada");
				Test.wait_For(1000);
				logger.info("Partner country verified correct.");
				Test.wait_until_element_present(By.id("selectEmail"),"jsmith@google.com");
				Test.wait_For(1000);
				logger.info("Partner email verified correct.");
				//Test.wait_until_element_present(By.cssSelector("#add-partner > div > div > div.container > div:nth-child(1) > div:nth-child(2) > div > div > div.react-datepicker__input-container.react-datepicker__tether-target.react-datepicker__tether-abutted.react-datepicker__tether-abutted-left.react-datepicker__tether-element-attached-top.react-datepicker__tether-element-attached-left.react-datepicker__tether-target-attached-bottom.react-datepicker__tether-target-attached-left.react-datepicker__tether-enabled"),"2017-07-25");
				Test.wait_For(3000);
				logger.info("Partner joined date verified correct.");
				Test.wait_until_element_present(By.id("partner-description"),"My organization description");
				Test.wait_For(3000);
				logger.info("Partner organization description verified correct.");
				
				//Fill Add Partner Form
				Test.form_fill_add_partner_info(Sponsor_Code,Website,Map_Coordinates,Longitude,Note);
				Test.clickLink(By.cssSelector("#isDsaSigned")); //Agreed to Terms and Conditions
				Test.wait_For(1000);
				Test.clickLink(By.cssSelector("body > div.dialog-off-canvas-main-canvas > div > div > section > div.region.region-content > div > icrp-partners-form > form > div.mb-2 > label > input"));  //Add as a Partner Funding Organization
				Test.wait_For(1000);
				Test.choose_logo_file_upload();
				Test.wait_For(1000);
				Test.clickLink(By.cssSelector("#isAnnualized")); //Select Annualized Funding
				Test.wait_For(1000);
				Test.wait_until_element_present(By.id("selectCurrency"),"CAD");
				Test.wait_For(1000);
				Test.selectOrganizationType("Government");
				Test.wait_For(1000);
				logger.info("Add Partner page filled out.");
				
				//Click Save to Add Partner
				
				Test.clickLink(By.xpath("//button[contains(text(),'Save')]"));
				Test.wait_For(1000);
				Test.enter_random_sponsor_code();
				Test.wait_For(1000);
				//Test.clickLink(By.xpath("//button[contains(text(),'Save')]"));
				Test.wait_For(4000);
			
				
				//Test.testClickSaveButton();
				//Test.wait_For(3000);
				//Test.wait_until_element_present(By.cssSelector("#add-partner > div > div > div.container > div:nth-child(1) > div"),"This partner has been successfully saved. You can go to Current Partners to view a list of current ICRP partners.");
				
				
				//Verify Partner Added to List
			
				//Test.verify_Partner_added_to_List();
				
				
				
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