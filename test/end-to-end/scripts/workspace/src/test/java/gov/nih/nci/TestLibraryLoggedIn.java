package gov.nih.nci;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.support.ui.Select;
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

public class TestLibraryLoggedIn {
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
	

	//Edit Library File Required Fields
	public static String File1 = "NewFileName";            //Required
	public static String Title1 = "NewTitleName";   //Required
	public static String Description1= "NewDescription";             //Required
	
	//Original Values
	public static String File2 = "ICRP_LungCancer_2016.pdf";            //Required
	public static String Title2 = "ICRP Lung Cancer Overview 2016";   //Required
	public static String Description2= "An overview of research investment in lung cancer in the ICRP portfolio";             //Required

	//Application CSS Configuration
	public static String appCSSUserActions = "td.sidebarContent";
	
	public TestLibraryLoggedIn(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// Library Logged In ///////////////
	
		//S.N.: 1
		//Test Name: Verify that Admin User is able to archive a file in Library
		@Test
		public void ICRP_Admin_User_Able_To_Archive_Library_File() throws Exception{
			String testName = "Admin User is able to archive a file in Library";
			String testDesc = "Admin User is able to archive a file in Library";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_manager_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				logger.info("Logged Into Admin Page");
				Test.wait_For(5000);
				
				//Verify Library Page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us."),"The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us.");
				logger.info("Library Page Presented");
				Test.expected_vs_actual_verification("Library");
				Test.wait_For(5000);
				
				//Click on Library Category "Publications"
				Test.clickLink(By.linkText("Publications"));
				Test.wait_For(5000);
				
				//Click On Archive for a File
				Test.wait_until_element_present(By.cssSelector("#library-display > div:nth-child(1) > div.display-header.clearfix.search > div:nth-child(2) > span.document-count"),"9");
				logger.info("Total Document Count is 9");
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("div.item-wrapper:nth-child(1) > div:nth-child(1) > div:nth-child(3) > button:nth-child(2)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.cssSelector("#library-display > div:nth-child(1) > div.display-header.clearfix.search > div:nth-child(2) > span.document-count"),"8");
				logger.info("Total Document Count is 8");
				
				//Restore the Archived File
				Test.clickLink(By.cssSelector("#library-show-archives"));
				Test.wait_For(5000);
				logger.info("Clicked on Show Archives Check Box");
				Test.wait_until_element_present(By.cssSelector("#library-display > div:nth-child(1) > div.display-header.clearfix.search > div:nth-child(2) > span.document-count"),"10");
				logger.info("All Files including archived files are shown");
				Test.clickLink(By.cssSelector("#library-display > div:nth-child(1) > div.frame.archived > div.item-wrapper.archived.public-doc > div > div:nth-child(3) > button.admin.restore-file > a"));
				Test.wait_until_element_present(By.cssSelector("#library-display > div:nth-child(1) > div.frame.archived > div:nth-child(1) > div > div:nth-child(3) > button.admin.archive-file > a"),"Archived");
				logger.info("Archived File is Restored");
				Test.wait_For(5000);
				
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
		//Test Name: Verify that Admin User is able to Edit a file in Library
		@Test
		public void ICRP_Admin_User_Able_To_Edit_Library_File() throws Exception{
			String testName = "Admin User is able to edit a file in Library";
			String testDesc = "Admin User is able to edit a file in Library";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_manager_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				logger.info("Logged Into Admin Page");
				Test.wait_For(5000);
				
				//Verify Library Page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(5000);
				logger.info("Library Page Presented");
				Test.expected_vs_actual_verification("Library");
				Test.wait_For(5000);
				
				//Click on Library Category "Publications"
				Test.clickLink(By.linkText("Publications"));
				Test.wait_For(5000);
				
				//Click Edit for a file in the Library
				Test.clickLink(By.cssSelector("div.item-wrapper:nth-child(1) > div:nth-child(1) > div:nth-child(3) > button:nth-child(1)"));
				Test.wait_For(2000);
				
				//Edit Required Fields and Click Save
				Test.selectParentCategrory("Meeting Reports");
				Test.wait_For(4000);
				Test.edit_library_file_required_fields(File1,Title1,Description1);
				Test.wait_For(5000);
				
				//Click to Save edits and verify changes are saved
				Test.clickLink(By.cssSelector("#library-save"));
				Test.wait_For(2000);
				logger.info("Edits are Saved");
				
						
				Test.clickLink(By.linkText("Meeting Reports"));
				Test.wait_For(2000);
				//Click Edit for a file in the Library
				Test.clickLink(By.cssSelector("div.item-wrapper:nth-child(3) > div:nth-child(1) > div:nth-child(3) > button:nth-child(1)"));
				Test.wait_For(2000);
				
			
				Test.verifyFileds("NewFileName");
				Test.wait_For(2000);
				//Test.actual_with_expected_cssSelector_text_verification("NewTitleName","div.folder:nth-child(6) > input:nth-child(2)");
				//Test.verifyFileds("NewDescription");
				
				//Restore fields back to Original values
				Test.select_parent_from_drop_down("Publications");
				Test.wait_For(4000);
				Test.edit_library_file_required_fields(File2,Title2,Description2);
				Test.wait_For(5000);
	
				Test.clickLink(By.cssSelector("#library-save"));
				Test.wait_For(2000);
				
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
		
		//S.N.: 3
		//Test Name: Verify that the Partner User can access Library Page
		@Test
		public void ICRP_Partner_User_Able_To_Access_Library_Page() throws Exception{
			String testName = "Verify that the Partner User can access Library Page";
			String testDesc = "Verify that the Partner User can access Library Page";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_Partner1_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				logger.info("Logged Into Partner Page");
				Test.wait_For(5000);
				
				//Verify Library Page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(5000);
				logger.info("Library Page Presented");
				Test.expected_vs_actual_verification("Library");
				logger.info("Partner user has access to Library page");
				Test.wait_For(5000);
				
				
				
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
				
		//S.N.: 4
		//Test Name: Verify that the Partner User is able to Upload New File to library
		@Test
		public void ICRP_Partner_User_Able_To_Upload_New_File() throws Exception{
			String testName = "Verify that the Partner User is able to Upload New File to library";
			String testDesc = "Verify that the Partner User is able to Upload New File to library";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_Partner1_cred_from_json();
				//Verify Welcome ICRP Partner Page
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				logger.info("Logged Into Partner Page");
				Test.wait_For(5000);
				
				//Verify Library Page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(5000);
				logger.info("Library Page Presented");
				Test.expected_vs_actual_verification("Library");
				logger.info("Partner user has access to Library page");
				Test.wait_For(5000);
				
				//Select a Category
				Test.clickLink(By.linkText("Finance"));
				Test.wait_For(2000);
				
				//Click on Upload New File
				Test.clickLink(By.linkText("Upload New File"));
				Test.wait_For(2000);
				
				//Fill Out Required Fields and Select Files To Upload
				Test.choose_library_file_upload();
				Test.wait_For(2000);
				Test.choose_library_image_upload();
				Test.wait_For(2000);
				Test.form_fill_create_library_file(Title1,Description1);
				Test.wait_For(2000);
				Test.clickLink(By.name("is_public"));
				Test.wait_For(2000);
				
				//Click Save to Create Upload Library File
				Test.clickLink(By.cssSelector("#library-save"));
				Test.wait_For(2000);
				
				//Verify File Created
				Test.wait_until_element_present(By.name("Upload.pdf"),"Upload.pdf");
				logger.info("File created in Library Folder");
				
				//Archive the File Just created (For Admin Only)
				//Test.clickLink(By.cssSelector("html.js body.toolbar-themes.toolbar-has-tabs.toolbar-has-icons.toolbar-themes-admin-theme--seven.user-logged-in.path-library.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div#library.tab-content.admin div#library-view.tab-pane.active div#library-view-table div#library-display div div.frame div.item-wrapper.public-doc div.item div button.admin.archive-file"));
				//Test.wait_For(2000);
				
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