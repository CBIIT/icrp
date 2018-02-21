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
//TestNG
//import org.testng.Assert;
//import org.testng.annotations.AfterClass;
//import org.testng.annotations.BeforeClass;
//import org.testng.annotations.Test;

public class TestNavigation {
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
	
	public TestNavigation(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// NAVIGATION ///////////////
	
		//S.N.: 1
		//Test Name: ICRP Public Menu Navigation
		@Test
		public void ICRP_Public_Menu_Navigation() throws Exception{
			String testName = "Public_Menu_Navigation";
			String testDesc = "Navigate Through Public Menu";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.wait_For(5000);
				//Verify About Us Page navigation
				Test.clickLink(By.xpath("/html/body/footer/div/div/div[2]/div/nav/ul/li[1]/a"));
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("About the Partners");
				Test.wait_For(5000);
				//Verify ICRP Data Page navigation
				Test.clickLink(By.linkText("ICRP Data"));
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("li.dropdown:nth-child(3) > ul:nth-child(2) > li:nth-child(1) > a:nth-child(1)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Search ICRP Database"),"Search ICRP Database");
				Test.expected_vs_actual_verification("Search ICRP Database");
				Test.wait_For(5000);
				//Verify Common Scientific Online Page
				Test.clickLink(By.linkText("ICRP Data"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Common Scientific Outline (CSO)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Common Scientific Outline (CSO)"),"Common Scientific Outline (CSO)");
				Test.expected_vs_actual_verification("Research included in this category looks at the biology of how cancer starts and progresses as well as normal biology relevant to these processes");
				Test.wait_For(5000);
				//Verify Funding Organizations Page
				Test.clickLink(By.linkText("ICRP Data"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Funding Organizations"));
				Test.wait_For(10000);
				Test.wait_until_element_present(By.name("Funding Organizations"),"Funding Organizations");
				Test.expected_vs_actual_verification("ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible.");
				Test.wait_For(5000);
				//Verify Join ICRP and Become a Partner
				Test.clickLink(By.linkText("Join ICRP"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Become a Partner"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("ICRP welcomes applications for membership from cancer research funding organizations across the world. As a partner you will join an active network of major cancer research funders."),"ICRP welcomes applications for membership from cancer research funding organizations across the world. As a partner you will join an active network of major cancer research funders.");
				Test.expected_vs_actual_verification("Being a Partner");
				Test.wait_For(5000);
				//Verify Join ICRP and Become a Partner
				Test.clickLink(By.linkText("Join ICRP"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Current Partners"));
				Test.wait_For(10000);
				Test.wait_until_element_present(By.name("CRP partners represent a wide range of governmental, public and non-profit cancer research funding organizations from across the world. Our membership includes organizations focused on one type of cancer through to health research organizations supporting research into many cancer types."),"CRP partners represent a wide range of governmental, public and non-profit cancer research funding organizations from across the world. Our membership includes organizations focused on one type of cancer through to health research organizations supporting research into many cancer types.");
				Test.expected_vs_actual_verification("Current Partners");
				Test.wait_For(5000);
				//Verify Join ICRP and Partner Application page
				Test.clickLink(By.linkText("Join ICRP"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Partner Application"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Thank you for your interest in becoming part of the International Cancer Research Partnership.  Please complete this application and upload the supplementary information requested below.  If you would like to download a copy of this form to review before applying online please click here."),"Thank you for your interest in becoming part of the International Cancer Research Partnership.  Please complete this application and upload the supplementary information requested below.  If you would like to download a copy of this form to review before applying online please click here.");
				Test.expected_vs_actual_verification("ICRP Partnership Application Form");
				Test.wait_For(5000);
				//Verify Join ICRP and User Registration page
				Test.clickLink(By.linkText("Join ICRP"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("User Registration"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures. Partners are asked to note that access to the analytical tools can only be obtained once your organization has uploaded data. If your organization is not yet a member of ICRP, please see Become a Partner for further details. Applications to register are normally processed within 48 hours. Please use an institutional email address if possible."),"Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures. Partners are asked to note that access to the analytical tools can only be obtained once your organization has uploaded data. If your organization is not yet a member of ICRP, please see Become a Partner for further details. Applications to register are normally processed within 48 hours. Please use an institutional email address if possible.");
				Test.expected_vs_actual_verification("User Registration");
				Test.wait_For(5000);
				//Verify Library page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(7000);
				Test.wait_until_element_present(By.name("The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us."),"The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us.");
				Test.expected_vs_actual_verification("Library");
				//Test.expected_vs_actual_verification("ICRP Lung Cancer Overview 2016");
				
				Test.wait_For(1000);
			
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
		//Test Name: ICRP Manager Menu Navigation
		@Test
		public void ICRP_Manager_Menu_Navigation() throws Exception{
			String testName = "Manager Menu Navigation";
			String testDesc = "Navigate through the Manager Menu";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_manager_cred_from_json();
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
				//Verify Common Scientific Outline (CSO) Page
				Test.clickLink(By.linkText("Data Resources"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Common Scientific Outline (CSO)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Awards on the International Cancer Research Partnership (ICRP) database are coded using a common language — the Common Scientific Outline or 'CSO', a classification system organized into six broad areas of scientific interest in cancer research. The CSO is complemented by a standard cancer type coding scheme. Together, these tools lay a framework to improve coordination among research organizations, making it possible to compare and contrast the research portfolios of public, non-profit, and governmental research agencies. In the section below, you can browse the CSO and see examples of research in each area. Links to the CSO in other languages, and training guides are provided in the download area. The current version (v2) of the CSO was adopted by the International Cancer Research Partnership in April 2015 and all awards in the database are coded to this version. To register as a CSO user, or to receive training in its use, please contact us."),"Awards on the International Cancer Research Partnership (ICRP) database are coded using a common language — the Common Scientific Outline or 'CSO', a classification system organized into six broad areas of scientific interest in cancer research. The CSO is complemented by a standard cancer type coding scheme. Together, these tools lay a framework to improve coordination among research organizations, making it possible to compare and contrast the research portfolios of public, non-profit, and governmental research agencies. In the section below, you can browse the CSO and see examples of research in each area. Links to the CSO in other languages, and training guides are provided in the download area. The current version (v2) of the CSO was adopted by the International Cancer Research Partnership in April 2015 and all awards in the database are coded to this version. To register as a CSO user, or to receive training in its use, please contact us.");
				Test.expected_vs_actual_verification("Common Scientific Outline (CSO)");
				Test.wait_For(5000);
				//Verify Funding Organizations Page
				Test.clickLink(By.linkText("Data Resources"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Funding Organizations"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below."),"ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below.");
				Test.expected_vs_actual_verification("Funding Organizations");
				Test.wait_For(5000);
				//Verify ICRP Data Caveats Page
				Test.clickLink(By.linkText("Data Resources"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("ICRP Data Caveats"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Single-funder organizations"),"Single-funder organizations");
				Test.expected_vs_actual_verification("ICRP Data Caveats");
				Test.wait_For(5000);
				
				//Verify Data Dictionary Page
				Test.clickLink(By.linkText("Data Resources"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Data Dictionary"));
				Test.wait_For(5000);
				Test.switchToChildBrowserWindow();
				//Test.GoToNewTabWindow();
				Test.verifyUrl("https://www.icrpartnership-test.org/sites/default/files/downloads/ICRPDataDictionary.pdf");
				Test.wait_For(5000);
				Test.switchToParentBrowserWindow();
				//Test.GoToPreviousTabWindow();
				//Verify Export Lookup Table
				Test.clickLink(By.linkText("Data Resources"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Export Lookup Table"));
				Test.wait_For(5000);
				//Verify Data Upload Status Report Page
				Test.clickLink(By.linkText("Data Resources"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Data Upload Status Report"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Information about the status of data submissions and uploads to the ICRP database is included below. Please note that each organization has its own data upload schedule and the latest data uploaded for each organization can be seen here."),"Information about the status of data submissions and uploads to the ICRP database is included below. Please note that each organization has its own data upload schedule and the latest data uploaded for each organization can be seen here.");
				Test.expected_vs_actual_verification("Data Upload Status Report");
				Test.wait_For(5000);
				//Verify Forum Page
				Test.clickLink(By.linkText("Forum"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
				Test.expected_vs_actual_verification("ICRP Partnership Forum");
				Test.wait_For(5000);
				
				//Verify Library Page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us."),"The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us.");
				Test.expected_vs_actual_verification("Library");
				Test.wait_For(5000);
				Test.wait_For(5000);
				//Verify User Account Administration Tool Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("User Account Administration Tool"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("User Account Administration Tool"),"User Account Administration Tool");
				Test.expected_vs_actual_verification("Organization");
				Test.wait_For(5000);
				//Verify Partner Application Administration Tool Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Partner Application Administration Tool"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Partner Application Administration Tool"),"Partner Application Administration Tool");
				Test.expected_vs_actual_verification("Application Status");
				Test.wait_For(5000);
				//Verify Edit Site Updated Date Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Edit Site Updated Date"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Edit Site Updated Date"),"Edit Site Updated Date");
				Test.expected_vs_actual_verification("Edit Site Updated Date");
				Test.wait_For(5000);
				
				
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
		
		//S.N.: 3
		//Test Name: ICRP Manager Menu Navigation
		@Test
		public void ICRP_Manager_Welcome_ICRP_Partner_Navigation() throws Exception{
			String testName = "Manager Welcome ICRP Partner Navigation";
			String testDesc = "Navigate through the Manager Welcome ICRP Partner page.";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.Login_enter_manager_cred_from_json();
				//Verify First Login Page
				Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
				Test.expected_vs_actual_verification("ICRP Partner");
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
			
				//Verify Update Profile Page
				Test.clickLink(By.linkText("Update Profile"));
				Test.wait_until_element_present(By.name("My Profile"),"My Profile");
				Test.expected_vs_actual_verification("First Name");
				Test.wait_For(5000);
				logger.info("My Profile Page Displayed");
				
				//Back to ICRP Welcome Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				logger.info("Welcome ICRP Partner displayed.");
			
				//Verify Search ICRP Database Page
				Test.clickLink(By.linkText("Search & Analysis"));
				Test.wait_For(5000);
				Test.expected_vs_actual_verification("Search ICRP Database");
				Test.wait_For(5000);
				logger.info("Search ICRP Database displayed.");
	
				
				//Back to ICRP Welcome Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify Data Review Tool Page
				Test.clickLink(By.linkText("Data Review Tool"));
				Test.wait_until_element_present(By.name("The following submitted workbooks have been uploaded to the staging website. Please select the relevant Sponsor Code to review your data and contact us by email to identify any problems or to approve your data to go live."),"The following submitted workbooks have been uploaded to the staging website. Please select the relevant Sponsor Code to review your data and contact us by email to identify any problems or to approve your data to go live.");
				Test.expected_vs_actual_verification("Data Review Tool");
				Test.wait_For(5000);
				
				//Back to ICRP Welcome Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify Common Scientific Outline (CSO) Page
				Test.clickLink(By.linkText("CSO"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Awards on the International Cancer Research Partnership (ICRP) database are coded using a common language — the Common Scientific Outline or 'CSO', a classification system organized into six broad areas of scientific interest in cancer research. The CSO is complemented by a standard cancer type coding scheme. Together, these tools lay a framework to improve coordination among research organizations, making it possible to compare and contrast the research portfolios of public, non-profit, and governmental research agencies. In the section below, you can browse the CSO and see examples of research in each area. Links to the CSO in other languages, and training guides are provided in the download area. The current version (v2) of the CSO was adopted by the International Cancer Research Partnership in April 2015 and all awards in the database are coded to this version. To register as a CSO user, or to receive training in its use, please contact us."),"Awards on the International Cancer Research Partnership (ICRP) database are coded using a common language — the Common Scientific Outline or 'CSO', a classification system organized into six broad areas of scientific interest in cancer research. The CSO is complemented by a standard cancer type coding scheme. Together, these tools lay a framework to improve coordination among research organizations, making it possible to compare and contrast the research portfolios of public, non-profit, and governmental research agencies. In the section below, you can browse the CSO and see examples of research in each area. Links to the CSO in other languages, and training guides are provided in the download area. The current version (v2) of the CSO was adopted by the International Cancer Research Partnership in April 2015 and all awards in the database are coded to this version. To register as a CSO user, or to receive training in its use, please contact us.");
				Test.expected_vs_actual_verification("Common Scientific Outline (CSO)");
				Test.wait_For(5000);
				
				//Back to ICRP Welcome Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify ICRP Data Caveats Page
				Test.clickLink(By.linkText("ICRP Data Caveats"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Single-funder organizations"),"Single-funder organizations");
				Test.expected_vs_actual_verification("ICRP Data Caveats");
				Test.wait_For(5000);
				
				//Back to ICRP Welcome Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify Data Dictionary Page
				Test.clickLink(By.linkText("Data Dictionary"));
				Test.wait_For(5000);
				//Test.switchToChildBrowserWindow();
				//Test.GoToNewTabWindow();
				Test.verifyUrl("https://www.icrpartnership-test.org/sites/default/files/downloads/ICRPDataDictionary.pdf");
				Test.wait_For(5000);
				Test.navigate_back();
				//Test.switchToParentBrowserWindow();
				
		
				//Verify Export Lookup Table
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("section.block-block-content8c71aff9-4894-42a5-bf26-c41c9f8ad280:nth-child(1) > div:nth-child(1) > div:nth-child(2) > ul:nth-child(5) > li:nth-child(4) > a:nth-child(1)"));
				Test.wait_For(2000);
				//Test.switchToParentBrowserWindow();
				//Test.navigate_back();
				//Test.wait_For(2000);
				
				//Verify Data Upload Status Report Page
				Test.clickLink(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-9 div.region.region-content div.tab-content.partner-content div#welcome.tab-pane.fade.in.active section#block-partnerhomewelcome.block.block-block-content.block-block-content8c71aff9-4894-42a5-bf26-c41c9f8ad280.clearfix div.field.field--name-body.field--type-text-with-summary.field--label-visually_hidden div.field--item ul li a"));
				Test.wait_For(5000);
				//Test.wait_until_element_present(By.name("Information about the status of data submissions and uploads to the ICRP database is included below. Please note that each organization has its own data upload schedule and the latest data uploaded for each organization can be seen here."),"Information about the status of data submissions and uploads to the ICRP database is included below. Please note that each organization has its own data upload schedule and the latest data uploaded for each organization can be seen here.");
				Test.expected_vs_actual_verification("Data Upload Status Report");
				Test.wait_For(5000);
			
				//Back to ICRP Welcome Page By Clicking on ICRP Logo
				Test.clickLink(By.cssSelector("#navbar > div.navbar-header > div > a > img"));
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify Funding Organizations Page
				Test.clickLink(By.linkText("Funding Organization"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below."),"ICRP organizations submit their latest available research projects or research funding to the ICRP database as soon as possible. Each partner submits data on a different schedule as each has different timelines for awarding, collating and classifying projects, so recent calendar years in the ‘Year active’ search may not yet include all available data for that year. In the table below, the ‘Import Description’ column shows the latest import from each partner, and the date on which that import was uploaded to the database. Organizations that update research funding annually for all projects in the database are listed as ‘yes’ in the ‘Annual funding updates’ column below.");
				Test.expected_vs_actual_verification("Funding Organizations");
				Test.wait_For(5000);
				Test.navigate_back();				
				
				//Verify Click on Twitter Page
				
				Test.clickLink(By.linkText("Twitter"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("We've updated our Privacy Policy, effective June 18th, 2017. You can learn more about what's changed on our Help Center. "),"We've updated our Privacy Policy, effective June 18th, 2017. You can learn more about what's changed on our Help Center. ");
				Test.switchToChildBrowser();
				//Test.GoToNewTabWindow();
				Test.wait_For(3000);
				//Test.verifyUrl("https://twitter.com/icrpartners1"); //https://twitter.com/icrpartners1?ref_src=twsrc%5Etfw
				Test.verifyUrl("https://twitter.com/icrpartners1?ref_src=twsrc%5Etfw");
				Test.wait_For(5000);
				Test.switchToParentBrowser();
				//Test.GoToPreviousTabWindow();
				
				//Verify Library Page
				Test.clickLink(By.linkText("Library"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us."),"The ICRP publishes regular data analyses, newsletters and reports. Please use our library to find reports of interest to the cancer research community, news and announcements. Please note that you must have Adobe's Acrobat Reader to view many of these files. Get Adobe Acrobat Reader free by clicking here . To receive the ICRP newsletter by email please Contact Us.");
				Test.expected_vs_actual_verification("Library");
				Test.wait_For(5000);
				
				//Verify Welcome Link to Home Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("As a partner, you can use the resources and information available to all members of our funding organizations. Use the links below to update you user profile, access the full partner dataset or find resources in the partner library."),"As a partner, you can use the resources and information available to all members of our funding organizations. Use the links below to update you user profile, access the full partner dataset or find resources in the partner library.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				

				//Verify User Account Administration Tool Page
				Test.clickLink(By.linkText("User Account Administration Tool"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("User Account Administration Tool"),"User Account Administration Tool");
				Test.expected_vs_actual_verification("Organization");
				Test.wait_For(5000);
				
				//Verify Welcome Link to Home Page
				Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("As a partner, you can use the resources and information available to all members of our funding organizations. Use the links below to update you user profile, access the full partner dataset or find resources in the partner library."),"As a partner, you can use the resources and information available to all members of our funding organizations. Use the links below to update you user profile, access the full partner dataset or find resources in the partner library.");
				Test.expected_vs_actual_verification("Welcome ICRP Partner");
				Test.wait_For(5000);
				
				//Verify Partner Calendar Tab
				Test.clickLink(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-9 div.region.region-content ul.nav.nav-tabs li a"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us."),"Please use the tabs below to find out more about the partner site and resources available to you. If you have any questions, please contact us.");
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
				//Verify Edit Site Updated Date Page
				Test.clickLink(By.linkText("Admin"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Edit Site Updated Date"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Edit Site Updated Date"),"Edit Site Updated Date");
				Test.expected_vs_actual_verification("Edit Site Updated Date");
				Test.wait_For(5000);
			
				
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