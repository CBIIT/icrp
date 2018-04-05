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
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.util.UUID;


import gov.nih.nci.HelperMethods.BaseTestMethods;
import gov.nih.nci.HelperMethods.BaseMethods;

import org.junit.*;
import org.apache.log4j.Logger;

public class TestUserApplication {
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
	
	//User Registration Form
	public static String First_Name = "John";            //Required
	public static String Last_Name = "Smith";                    //Required
	public static String Organization = "ICRP - Operations Manager (510)";  //Required
	public static String User_Email = "jsmith@yahoo.com";         //Required

	//Application CSS Configuration
	public static String appCSSUserActions = "td.sidebarContent";
	
	
	//Random email generation
	
	private static String randomEmail() {
        return "random-" + UUID.randomUUID().toString() + "@example.com";
    }
	
	
	
	public TestUserApplication(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		

	/////// User APPLICATION ///////////////	
	
	//S.N.: 1
			//Test Name: User Application - Submit And Active For Manager
			@Test
			public void ICRP_User_Application_Submit_And_Active_For_Manager() throws Exception{
				String testName = "User Application - Submit And Active For Manager";
				String testDesc = "User Application - Submit And Active For Manager";
				try{
					logger.info("---------------Begin Test case: " + testName + "--------------");
					Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
					Test.launchSite();
					Test.wait_For(5000);
					
					
					//Verify Join ICRP and User Application page
					Test.clickLink(By.linkText("Join ICRP"));
					Test.wait_For(2000);
					Test.clickLink(By.linkText("User Registration"));
					Test.wait_For(2000);
					Test.wait_until_element_present(By.name("Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures."),"Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures.");
					Test.expected_vs_actual_verification("User Registration");
					Test.wait_For(2000);
					
					//Fill out all required fields for the User Registration
					
					Test.form_fill_user_registration(First_Name,Last_Name,Organization);
					Test.wait_For(2000);
					Test.enter_random_user_email();
					
					//Click Create New Account
					
					//Test.clickLink(By.xpath("/html/body/div[1]/div/div/section/div[3]/div/div/form/div[5]/button"));
					Test.clickLink(By.id("edit-submit"));
					Test.wait_For(4000);
					logger.info("Click create new account button");
					
					//Verify Confirmation Message
					//Test.expected_value_verification("Thank you for applying");
					//Test.actual_with_expected_xpath_text_verification("In the meantime, a welcome message with further instructions has been sent to your email address.","/html/body/div/div/section/div[1]/div/div/div");
					Test.wait_For(5000);
					
					//Login as Manager
					
					Test.Login_enter_manager_cred_from_json();
					//Verify Welcome ICRP Partner Page
					Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-9 div.region.region-content h1"));
					Test.expected_vs_actual_verification("Welcome ICRP Partner");
					Test.wait_For(5000);
					logger.info("Logged In as Manager");
					
					//Select User Account Administration Tool
					
					Test.clickLink(By.linkText("Admin"));
					Test.wait_For(5000);
					Test.clickLink(By.linkText("User Account Administration Tool"));
					Test.wait_For(5000);
					Test.wait_until_element_present(By.name("User Account Administration Tool"),"User Account Administration Tool");
					Test.expected_vs_actual_verification("Organization");
					Test.wait_For(5000);
					logger.info("User Account Administration Tool page presented.");
					
					//Verify User Registration Created
					
					Test.wait_until_element_present(By.name("field_membership_status_value"),"Registering");
					Test.wait_For(5000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(1)"),"Smith , John");
					Test.wait_For(3000);
					//Test.verify_email_address_of_registered_user();
					Test.wait_For(3000);
					Test.expected_value_verification("ICRP - Operations Manager");
					Test.wait_For(3000);
					Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > div > div > div.view-content > div > table > tbody > tr > td.views-field.views-field-nothing-1 > a"),"Review");
					Test.wait_For(3000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6)"),"Registering");
					logger.info("Created Registered user is listed in User Account Administration Tool page. ");
					
					//Click Review and Verify User Info
					
					Test.verify_user_info_when_clicking_review_button();
					Test.wait_For(3000);
					
					//Verify Can Upload Library Files is Checked
					
					Test.verify_upload_files_checkbox_is_checked();
					Test.wait_For(2000);
					
					//Verify Following or Not Checked
					Test.verify_Blocked_checkbox_is_not_checked();
					Test.wait_For(2000);
					Test.verify_Active_checkbox_is_not_checked();
					Test.wait_For(2000);
					Test.verify_Manager_checkbox_is_not_checked();
					Test.wait_For(2000);
					Test.verify_Partner_checkbox_is_not_checked();
					
					//Select Active and Manager Radio Buttons
					Test.click_Active_Radio();
					Test.wait_For(2000);
					Test.click_Manager_Checkbox();
					Test.wait_For(2000);
					
					//Click Save Button
					
					Test.clickLink(By.id("edit-submit"));
					Test.wait_For(5000);
					
					//Verify Confirmation Message
					
					Test.wait_until_element_present(By.cssSelector("html.js body.toolbar-themes.toolbar-has-tabs.toolbar-has-icons.toolbar-themes-admin-theme--seven.user-logged-in.path-user-account-administration-tool.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.highlighted div.region.region-highlighted div div.alert.alert-success.alert-dismissible"),"         User account for John Smith  has been saved and is currently active.   ");
					
					
					
					Test.wait_For(7000);
					
					//Select Active Status
					Test.selectStatus("Active");
					Test.clickLink(By.cssSelector("#edit-submit-user-account-administration-tool"));
					Test.wait_For(5000);
					
					//Verify User is Listed
					
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(6)"),"Registering");
					Test.wait_For(5000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(1)"),"Smith , John");
					Test.wait_For(3000);
					//Test.verify_email_address_of_registered_user();
					Test.wait_For(3000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(3)"),"ICRP - Operations Manager");
					Test.wait_For(3000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(5) > a:nth-child(1)"),"Review");
					Test.wait_For(3000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(6)"),"Active");
					Test.wait_For(3000);
					Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(4)"),"Manager");
					logger.info("Created and Active Registered user is listed in User Account AdministrationTool page. ");
					
					
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
					//Test Name: User Application - Submit And Active For Manager and Partner Roles
					@Test
					public void ICRP_User_Application_Submit_And_Active_For_Manager_and_Partner_Roles() throws Exception{
						String testName = "User Application - Submit And Active For Manager and Partner Roles";
						String testDesc = "User Application - Submit And Active For Manager and Partner Roles";
						try{
							logger.info("---------------Begin Test case: " + testName + "--------------");
							Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
							Test.launchSite();
							Test.wait_For(5000);
							
							
							//Verify Join ICRP and User Application page
							Test.clickLink(By.linkText("Join ICRP"));
							Test.wait_For(2000);
							Test.clickLink(By.linkText("User Registration"));
							Test.wait_For(2000);
							Test.wait_until_element_present(By.name("Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures."),"Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures.");
							Test.expected_vs_actual_verification("User Registration");
							Test.wait_For(2000);
							
							//Fill out all required fields for the User Registration
							
							Test.form_fill_user_registration(First_Name,Last_Name,Organization);
							Test.wait_For(2000);
							Test.enter_random_user_email();
							
							//Click Create New Account
							
							//Test.clickLink(By.xpath("/html/body/div[1]/div/div/section/div[3]/div/div/form/div[5]/button"));
							Test.clickLink(By.id("edit-submit"));
							Test.wait_For(4000);
							logger.info("Click create new account button");
							
							//Verify Confirmation Message
							//Test.expected_value_verification("Thank you for applying");
							//Test.actual_with_expected_xpath_text_verification("In the meantime, a welcome message with further instructions has been sent to your email address.","/html/body/div/div/section/div[1]/div/div/div");
							Test.wait_For(5000);
							
							//Login as Manager
							
							Test.Login_enter_manager_cred_from_json();
							//Verify First Login Page
							Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
							Test.expected_vs_actual_verification("ICRP Partner");
							Test.wait_For(5000);
							Test.clickLink(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(1) > a"));
						
							logger.info("Logged In as Manager");
							
							//Select User Account Administration Tool
							
							Test.clickLink(By.linkText("Admin"));
							Test.wait_For(5000);
							Test.clickLink(By.linkText("User Account Administration Tool"));
							Test.wait_For(5000);
							Test.wait_until_element_present(By.name("User Account Administration Tool"),"User Account Administration Tool");
							Test.expected_vs_actual_verification("Organization");
							Test.wait_For(5000);
							logger.info("User Account Administration Tool page presented.");
							
							//Verify User Registration Created
							
							Test.wait_until_element_present(By.name("field_membership_status_value"),"Registering");
							Test.wait_For(5000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(1)"),"Smith , John");
							Test.wait_For(3000);
							//Test.verify_email_address_of_registered_user();
							Test.wait_For(3000);
							Test.expected_value_verification("ICRP - Operations Manager");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > div > div > div.view-content > div > table > tbody > tr > td.views-field.views-field-nothing-1 > a"),"Review");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6)"),"Registering");
							logger.info("Created Registered user is listed in User Account Administration Tool page. ");
							
							//Click Review and Verify User Info
							
							Test.verify_user_info_when_clicking_review_button();
							Test.wait_For(3000);
							
							//Verify Can Upload Library Files is Checked
							
							Test.verify_upload_files_checkbox_is_checked();
							Test.wait_For(2000);
							
							//Verify Following or Not Checked
							Test.verify_Blocked_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Active_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Manager_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Partner_checkbox_is_not_checked();
							
							//Select Active and Manager Radio Buttons
							Test.click_Active_Radio();
							Test.wait_For(2000);
							Test.click_Manager_Checkbox();
							Test.wait_For(2000);
							Test.click_Partner_Checkbox();
							Test.wait_For(2000);
							
							//Click Save Button
							
							Test.clickLink(By.id("edit-submit"));
							Test.wait_For(5000);
							
							//Verify Confirmation Message
							
							Test.wait_until_element_present(By.cssSelector("html.js body.toolbar-themes.toolbar-has-tabs.toolbar-has-icons.toolbar-themes-admin-theme--seven.user-logged-in.path-user-account-administration-tool.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.highlighted div.region.region-highlighted div div.alert.alert-success.alert-dismissible"),"         User account for John Smith  has been saved and is currently active.   ");
							
							
							
							Test.wait_For(7000);
							
							//Select Active Status
							Test.selectStatus("Active");
							Test.clickLink(By.cssSelector("#edit-submit-user-account-administration-tool"));
							Test.wait_For(5000);
							
							//Verify User is Listed
							
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(6)"),"Registering");
							Test.wait_For(5000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(1)"),"Smith , John");
							Test.wait_For(3000);
							//Test.verify_email_address_of_registered_user();
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(3)"),"ICRP - Operations Manager");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(5) > a:nth-child(1)"),"Review");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(6)"),"Active");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(15) > td:nth-child(4))"),"Manager, Partner ");
							logger.info("Created and Active Registered user is listed in User Account AdministrationTool page. ");
							
							
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
					//Test Name: User Application - Submit And Active For Partner
					@Test
					public void ICRP_User_Application_Submit_And_Active_For_Partner_Role() throws Exception{
						String testName = "User Application - Submit And Active For Partner";
						String testDesc = "User Application - Submit And Active For Partner";
						try{
							logger.info("---------------Begin Test case: " + testName + "--------------");
							Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
							Test.launchSite();
							Test.wait_For(5000);
							
							
							//Verify Join ICRP and User Application page
							Test.clickLink(By.linkText("Join ICRP"));
							Test.wait_For(2000);
							Test.clickLink(By.linkText("User Registration"));
							Test.wait_For(2000);
							Test.wait_until_element_present(By.name("Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures."),"Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures.");
							Test.expected_vs_actual_verification("User Registration");
							Test.wait_For(2000);
							
							//Fill out all required fields for the User Registration
							
							Test.form_fill_user_registration(First_Name,Last_Name,Organization);
							Test.wait_For(2000);
							Test.enter_random_user_email();
							
							//Click Create New Account
							
							//Test.clickLink(By.xpath("/html/body/div[1]/div/div/section/div[3]/div/div/form/div[5]/button"));
							Test.clickLink(By.id("edit-submit"));
							Test.wait_For(4000);
							logger.info("Click create new account button");
							
							//Verify Confirmation Message
							//Test.expected_value_verification("Thank you for applying");
							//Test.actual_with_expected_xpath_text_verification("In the meantime, a welcome message with further instructions has been sent to your email address.","/html/body/div/div/section/div[1]/div/div/div");
							Test.wait_For(5000);
							
							//Login as Manager
							
							Test.Login_enter_manager_cred_from_json();
							//Verify Welcome ICRP Partner Page
							Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-9 div.region.region-content h1"));
							Test.expected_vs_actual_verification("Welcome ICRP Partner");
							Test.wait_For(5000);
							logger.info("Logged In as Manager");
							
							//Select User Account Administration Tool
							
							Test.clickLink(By.linkText("Admin"));
							Test.wait_For(5000);
							Test.clickLink(By.linkText("User Account Administration Tool"));
							Test.wait_For(5000);
							Test.wait_until_element_present(By.name("User Account Administration Tool"),"User Account Administration Tool");
							Test.expected_vs_actual_verification("Organization");
							Test.wait_For(5000);
							logger.info("User Account Administration Tool page presented.");
							
							//Verify User Registration Created
							
							Test.wait_until_element_present(By.name("field_membership_status_value"),"Registering");
							Test.wait_For(5000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(1)"),"Smith , John");
							Test.wait_For(3000);
							//Test.verify_email_address_of_registered_user();
							Test.wait_For(3000);
							Test.expected_value_verification("ICRP - Operations Manager");
							logger.info("Verify User Organization");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > div > div > div.view-content > div > table > tbody > tr > td.views-field.views-field-nothing-1 > a"),"Review");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6)"),"Registering");
							logger.info("Created Registered user is listed in User Account Administration Tool page. ");
							
							//Click Review and Verify User Info
							
							Test.verify_user_info_when_clicking_review_button();
							Test.wait_For(3000);
							
							//Verify Can Upload Library Files is Checked
							
							Test.verify_upload_files_checkbox_is_checked();
							Test.wait_For(2000);
							
							//Verify Following or Not Checked
							Test.verify_Blocked_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Active_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Manager_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Partner_checkbox_is_not_checked();
							
							//Select Active and Manager Radio Buttons
							Test.click_Active_Radio();
							Test.wait_For(2000);
							Test.click_Partner_Checkbox();
							Test.wait_For(2000);
							
							//Click Save Button
							
							Test.clickLink(By.id("edit-submit"));
							Test.wait_For(5000);
							
							//Verify Confirmation Message
							
							Test.wait_until_element_present(By.cssSelector("html.js body.toolbar-themes.toolbar-has-tabs.toolbar-has-icons.toolbar-themes-admin-theme--seven.user-logged-in.path-user-account-administration-tool.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.highlighted div.region.region-highlighted div div.alert.alert-success.alert-dismissible"),"         User account for John Smith  has been saved and is currently active.   ");
							
							
							
							Test.wait_For(7000);
							
							//Select Active Status
							Test.selectStatus("Active");
							Test.clickLink(By.cssSelector("#edit-submit-user-account-administration-tool"));
							Test.wait_For(5000);
							
							//Verify User is Listed
							
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(6)"),"Registering");
							Test.wait_For(5000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(1)"),"Smith , John");
							Test.wait_For(3000);
							//Test.verify_email_address_of_registered_user();
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(3)"),"ICRP - Operations Manager");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(5) > a:nth-child(1)"),"Review");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(6)"),"Active");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(17) > td:nth-child(4)"),"     Partner             ");
							logger.info("Created and Active Registered user is listed in User Account AdministrationTool page. ");
							
							
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
					
					//S.N.: 4
					//Test Name: User Application - Submit And Block
					@Test
					public void ICRP_User_Application_Submit_And_Blocked_For_Partner_Role() throws Exception{
						String testName = "User Application - Submit And Block";
						String testDesc = "User Application - Submit And Block";
						try{
							logger.info("---------------Begin Test case: " + testName + "--------------");
							Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
							Test.launchSite();
							Test.wait_For(5000);
							
							
							//Verify Join ICRP and User Application page
							Test.clickLink(By.linkText("Join ICRP"));
							Test.wait_For(2000);
							Test.clickLink(By.linkText("User Registration"));
							Test.wait_For(2000);
							Test.wait_until_element_present(By.name("Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures."),"Please enter your details below to register to use the ICRP partner site. Note that only members of partner funding organizations are eligible for access to the partner site and by applying for access you agree to abide by the ICRP's Policies and Procedures.");
							Test.expected_vs_actual_verification("User Registration");
							Test.wait_For(2000);
							
							//Fill out all required fields for the User Registration
							
							Test.form_fill_user_registration(First_Name,Last_Name,Organization);
							Test.wait_For(2000);
							Test.enter_random_user_email();
							
							//Click Create New Account
							
							//Test.clickLink(By.xpath("/html/body/div[1]/div/div/section/div[3]/div/div/form/div[5]/button"));
							Test.clickLink(By.id("edit-submit"));
							Test.wait_For(4000);
							logger.info("Click create new account button");
							
							//Verify Confirmation Message
							//Test.expected_value_verification("Thank you for applying");
							//Test.actual_with_expected_xpath_text_verification("In the meantime, a welcome message with further instructions has been sent to your email address.","/html/body/div/div/section/div[1]/div/div/div");
							Test.wait_For(5000);
							
							//Login as Manager
							
							Test.Login_enter_manager_cred_from_json();
							//Verify Welcome ICRP Partner Page
							Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-9 div.region.region-content h1"));
							Test.expected_vs_actual_verification("Welcome ICRP Partner");
							Test.wait_For(5000);
							logger.info("Logged In as Manager");
							
							//Select User Account Administration Tool
							
							Test.clickLink(By.linkText("Admin"));
							Test.wait_For(5000);
							Test.clickLink(By.linkText("User Account Administration Tool"));
							Test.wait_For(5000);
							Test.wait_until_element_present(By.name("User Account Administration Tool"),"User Account Administration Tool");
							Test.expected_vs_actual_verification("Organization");
							Test.wait_For(5000);
							logger.info("User Account Administration Tool page presented.");
							
							//Verify User Registration Created
							
							Test.wait_until_element_present(By.name("field_membership_status_value"),"Registering");
							Test.wait_For(5000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(1)"),"Smith , John");
							Test.wait_For(3000);
							//Test.verify_email_address_of_registered_user();
							Test.wait_For(3000);
							Test.expected_value_verification("ICRP - Operations Manager");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > div > div > div.view-content > div > table > tbody > tr > td.views-field.views-field-nothing-1 > a"),"Review");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6)"),"Registering");
							logger.info("Created Registered user is listed in User Account Administration Tool page. ");
							
							//Click Review and Verify User Info
							
							Test.verify_user_info_when_clicking_review_button();
							Test.wait_For(3000);
							
							//Verify Can Upload Library Files is Checked
							
							Test.verify_upload_files_checkbox_is_checked();
							Test.wait_For(2000);
							
							//Verify Following or Not Checked
							Test.verify_Blocked_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Active_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Manager_checkbox_is_not_checked();
							Test.wait_For(2000);
							Test.verify_Partner_checkbox_is_not_checked();
							
							//Select Active and Manager Radio Buttons
							Test.wait_For(2000);
							Test.click_Blocked_Radio();
							Test.wait_For(2000);
							Test.click_Partner_Checkbox();
							Test.wait_For(2000);
							
							//Click Save Button
							
							Test.clickLink(By.id("edit-submit"));
							Test.wait_For(5000);
							
							//Verify Confirmation Message
							
							Test.wait_until_element_present(By.cssSelector("html.js body.toolbar-themes.toolbar-has-tabs.toolbar-has-icons.toolbar-themes-admin-theme--seven.user-logged-in.path-user-account-administration-tool.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.highlighted div.region.region-highlighted div div.alert.alert-success.alert-dismissible"),"         User account for John Smith  has been saved and is currently blocked.   ");
							logger.info("Blocked user account confirmation message is presented.");
							
							
							Test.wait_For(7000);
							
							//Select Blocked Status
							Test.selectStatus("Blocked");
							Test.clickLink(By.cssSelector("#edit-submit-user-account-administration-tool"));
							Test.wait_For(5000);
							
							//Verify User is Listed
							
							Test.wait_until_element_present(By.cssSelector("#edit-field-membership-status-value"),"Blocked");
							Test.wait_For(5000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(6) > td:nth-child(1)"),"Smith , John");
							Test.wait_For(3000);
							//Test.verify_email_address_of_registered_user();
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(3)"),"ICRP - Operations Manager");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(5) > a:nth-child(1)"),"Review");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(6)"),"Blocked");
							Test.wait_For(3000);
							Test.wait_until_element_present(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(4)"),"     Partner             ");
							logger.info("Created and Blocked Registered user is listed in User Account AdministrationTool page. ");
							
							
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