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

public class TestForumAddThread {
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
	
	//Form Fill the Add New Thread page
	public static String Subject = "New Thread Subject for Forum";            //Required
	public static String Post = "This is a new Post for the new thread in the selected Forum.";   //Required
	public static String Summary = "New Thread Summary for Forum"; 
	
	public static String alternative_text = "This is a new Image";
	
	public static String link_url = "https://www.icrpartnership-test.org";

	//Application CSS Configuration
	public static String appCSSUserActions = "td.sidebarContent";
	
	public TestForumAddThread(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// Forum - Add Thread ///////////////
	

	//S.N.: 1
	//Test Name: Forum - Add A New Open Thread With All Fields
	@Test
	public void ICRP_Forum_Add_A_New_Open_Thread_With_All_Fields() throws Exception{
		String testName = "Forum - Add A New Open Thread With All Fields";
		String testDesc = "Forum - Add A New Open Thread With All Fields";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
			Test.expected_vs_actual_verification("Welcome ICRP Partner");
			Test.wait_For(5000);
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Select a Forum
			
			Test.clickLink(By.linkText("Partner News and Announcements"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("#main-forum-content > div > table > tbody > tr > td:nth-child(2) > a"),"Add New Thread");
			Test.wait_For(1000);
			logger.info("Forum Selected");
			
			//Click Add New Tread
			
			Test.clickLink(By.linkText("Add New Thread"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Add New Thread");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("News, announcements or job posts from your organization that may be of interest to the wider partnership.");
			logger.info("Add New Thread page is presented for the selected Forum");
			
			//Fill Out Add New Thread Fields
			Test.wait_For(1000);
			Test.form_fill_add_new_thread(Subject);
			Test.wait_For(1000);
			Test.clickLink(By.cssSelector("#edit-body-wrapper > div > div.form-item.js-form-item.form-type-textarea.js-form-type-textarea.form-item-body-0-value.js-form-item-body-0-value > span > button"));
			Test.wait_For(1000);
			Test.form_fill_add_new_thread_summary(Summary);
			Test.wait_For(1000);
			Test.enterPost(Post);
			Test.wait_For(1000);
			
			//Click Add New Thread
			
			Test.clickLink(By.cssSelector("#edit-submit"));
			
			//Verify Confirmation message after Adding New Thread to Forum
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Forum topic New Thread Subject for Forum has been created.");
			Test.wait_For(1000);
			logger.info("New Thread is created for the selected Forum");
			
			//Verify Thread on the Forum Page
			
			Test.wait_until_element_present(By.cssSelector(".thread-edit > a:nth-child(1)"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".btn"),"Post Reply");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".comment__content > div:nth-child(1) > p:nth-child(2)"),"New Thread Subject for Forum");
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td:nth-child(3) > div:nth-child(1) > div:nth-child(1) > b:nth-child(1)"),"New Thread Subject for Forum");
			Test.wait_For(1000);
			logger.info("Newly created thread is listed next to selected Forum on Forum Page.");
			
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
	//Test Name: Forum - Add A New Open Thread With Only Required Fields
	@Test
	public void ICRP_Forum_Add_A_New_Open_Thread_With_Only_Required_Fields() throws Exception{
		String testName = "Forum - Add A New Open Thread With Only Required Fields";
		String testDesc = "Forum - Add A New Open Thread With Only Required Fields";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
			Test.expected_vs_actual_verification("Welcome ICRP Partner");
			Test.wait_For(5000);
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Select a Forum
			
			Test.clickLink(By.linkText("Partner News and Announcements"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("#main-forum-content > div > table > tbody > tr > td:nth-child(2) > a"),"Add New Thread");
			Test.wait_For(1000);
			logger.info("Forum Selected");
			
			//Click Add New Tread
			
			Test.clickLink(By.linkText("Add New Thread"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Add New Thread");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("News, announcements or job posts from your organization that may be of interest to the wider partnership.");
			logger.info("Add New Thread page is presented for the selected Forum");
			
			//Fill Out Add New Thread Fields
			Test.wait_For(1000);
			Test.form_fill_add_new_thread(Subject);
			Test.wait_For(1000);
			Test.enterPost(Post);
			Test.wait_For(1000);
			
			//Click Add New Thread
			
			Test.clickLink(By.cssSelector("#edit-submit"));
			
			//Verify Confirmation message after Adding New Thread to Forum
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Forum topic New Thread Subject for Forum has been created.");
			Test.wait_For(1000);
			logger.info("New Thread is created for the selected Forum");
			
			//Verify Thread on the Forum Page
			
			Test.wait_until_element_present(By.cssSelector(".thread-edit > a:nth-child(1)"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".btn"),"Post Reply");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".comment__content > div:nth-child(1) > p:nth-child(2)"),"New Thread Subject for Forum");
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td:nth-child(3) > div:nth-child(1) > div:nth-child(1) > b:nth-child(1)"),"New Thread Subject for Forum");
			Test.wait_For(1000);
			logger.info("Newly created thread is listed next to selected Forum on Forum Page.");
			
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
	//Test Name: Forum - Add A New Thread With An Image
	@Test
	public void ICRP_Forum_Add_A_New_Thread_With_An_Image() throws Exception{
		String testName = "Forum - Add A New Thread With An Image";
		String testDesc = "Forum - Add A New Thread With An Image";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
			Test.expected_vs_actual_verification("Welcome ICRP Partner");
			Test.wait_For(5000);
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Select a Forum
			
			Test.clickLink(By.linkText("Partner News and Announcements"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("#main-forum-content > div > table > tbody > tr > td:nth-child(2) > a"),"Add New Thread");
			Test.wait_For(1000);
			logger.info("Forum Selected");
			
			//Click Add New Tread
			
			Test.clickLink(By.linkText("Add New Thread"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Add New Thread");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("News, announcements or job posts from your organization that may be of interest to the wider partnership.");
			logger.info("Add New Thread page is presented for the selected Forum");
			
			//Fill Out Add New Thread Fields
			Test.wait_For(1000);
			Test.form_fill_add_new_thread(Subject);
			Test.wait_For(3000);
			logger.info("Subject Entered");
			Test.click_add_image_button();
			Test.wait_For(3000);
			//Test.enterPost(Post);
			Test.switchToChildBrowser();
			//Test.GoToNewTabWindow();
			Test.wait_For(5000);
			Test.choose_image_upload();
			Test.wait_For(1000);
			logger.info("Image Selected");
			Test.form_fill_insert_image_alternative_text(alternative_text);
			Test.wait_For(2000);
			logger.info("Alternate Text Entered");
			
			Test.clickLink(By.cssSelector("#drupal-modal > div > div > div.modal-footer > button"));
			
			Test.switchToParentBrowser();
			//Test.GoToPreviousTabWindow();
			Test.wait_For(2000);
			
			//Click Add New Thread
			
			//Test.clickLink(By.xpath("/html/body/div[1]/div/section/div[2]/div[3]/div/div/form/div[7]/button"));
			Test.clickLink(By.cssSelector("html.js body.user-logged-in.path-node.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div.row div.col-md-10.col-md-offset-1 div.well form#node-forum-form.node-forum-form.node-form div#edit-actions.form-actions.form-group.js-form-wrapper.form-wrapper button#edit-submit.button.button--primary.js-form-submit.form-submit.btn-success.btn"));
			
			//Verify Confirmation message after Adding New Thread to Forum
			Test.wait_For(1000);
			//Test.expected_vs_actual_verification("Forum topic New Thread Subject for Forum has been created.");
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Forum topic New Thread Subject for Forum has been created.");
			
			Test.wait_For(5000);
			logger.info("New Thread is created for the selected Forum");
			
			//Verify Thread on the Forum Page
			
			Test.wait_until_element_present(By.cssSelector(".thread-edit > a:nth-child(1)"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".btn"),"Post Reply");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".comment__content > div:nth-child(1) > p:nth-child(2)"),"New Thread Subject for Forum");
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td:nth-child(3) > div:nth-child(1) > div:nth-child(1) > b:nth-child(1)"),"New Thread Subject for Forum");
			Test.wait_For(1000);
			logger.info("Newly created thread is listed next to selected Forum on Forum Page.");
			
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
	//Test Name: Forum - Forum - Add A New Thread With Links
	@Test
	public void ICRP_Forum_Add_A_New_Thread_With_Links() throws Exception{
		String testName = "Forum - Add A New Thread With Links";
		String testDesc = "Forum - Add A New Thread With Links";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("#manager-navbar-collapse > ul.nav.navbar-nav.navbar-right > li > a"));
			Test.expected_vs_actual_verification("Welcome ICRP Partner");
			Test.wait_For(5000);
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Select a Forum
			
			Test.clickLink(By.linkText("Partner News and Announcements"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("#main-forum-content > div > table > tbody > tr > td:nth-child(2) > a"),"Add New Thread");
			Test.wait_For(1000);
			logger.info("Forum Selected");
			
			//Click Add New Tread
			
			Test.clickLink(By.linkText("Add New Thread"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Add New Thread");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("News, announcements or job posts from your organization that may be of interest to the wider partnership.");
			logger.info("Add New Thread page is presented for the selected Forum");
			
			//Fill Out Add New Thread Fields
			Test.wait_For(1000);
			Test.form_fill_add_new_thread(Subject);
			Test.wait_For(1000);
			Test.click_add_links_button();
			Test.wait_For(3000);
			//Test.enterPost(Post);
			Test.switchToChildBrowser();
			//Test.GoToNewTabWindow();
			Test.wait_For(1000);
			Test.form_fill_insert_links_url(link_url);
			Test.wait_For(1000);
			
			Test.clickLink(By.cssSelector("#drupal-modal > div > div > div.modal-footer > button"));
			
			Test.switchToParentBrowser();
			////Test.GoToPreviousTabWindow();
			Test.wait_For(4000);
			//Click Add New Thread
			
			//Test.clickLink(By.xpath("/html/body/div[1]/div/section/div[2]/div[3]/div/div/form/div[7]/button"));
			//Test.clickLink(By.cssSelector("#edit-submit"));
			Test.clickLink(By.id("edit-submit"));
			
			
			//Verify Confirmation message after Adding New Thread to Forum
			Test.wait_For(1000);
			//Test.expected_vs_actual_verification("Forum topic New Thread Subject for Forum has been created.");
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Forum topic New Thread Subject for Forum has been created.");
			
			Test.wait_For(5000);
			logger.info("New Thread is created for the selected Forum");
			
			//Verify Thread on the Forum Page
			
			Test.wait_until_element_present(By.cssSelector(".thread-edit > a:nth-child(1)"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".btn"),"Post Reply");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector(".comment__content > div:nth-child(1) > p:nth-child(2)"),"New Thread Subject for Forum");
			
			//Verify Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td:nth-child(3) > div:nth-child(1) > div:nth-child(1) > b:nth-child(1)"),"New Thread Subject for Forum");
			Test.wait_For(1000);
			logger.info("Newly created thread is listed next to selected Forum on Forum Page.");
			
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