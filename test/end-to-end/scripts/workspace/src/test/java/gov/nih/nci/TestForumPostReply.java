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
import org.openqa.selenium.remote.RemoteWebDriver;

import gov.nih.nci.HelperMethods.BaseTestMethods;
import gov.nih.nci.HelperMethods.BaseMethods;

import org.junit.*;
import org.apache.log4j.Logger;

public class TestForumPostReply {
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
	
	public TestForumPostReply(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// Forum - Add Thread ///////////////
	

	//S.N.: 1
	//Test Name: Forum - Post A Reply To A Thread
	@Test
	public void ICRP_Forum_Post_A_Reply_To_A_Thread() throws Exception{
		String testName = "Forum - Post A Reply To A Thread";
		String testDesc = "Forum - Post A Reply To A Thread";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
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
			
			//Click Post Reply to a Forum Thread
			
			Test.clickLink(By.cssSelector("tr.odd:nth-child(1) > td:nth-child(2) > span:nth-child(1) > div:nth-child(1) > a:nth-child(1)"));  //Click on Thread to Reply To
			
			Test.clickLink(By.linkText("Post Reply"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Post Reply");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Thread:");
			
			//Fill Out Post Reply Fields
			
			Test.wait_For(1000);
			Test.enterPostReplyMessage();
			Test.wait_For(2000);
		
			//Click Post Reply
			
			Test.clickLink(By.cssSelector("#edit-submit"));
			
			//Verify Confirmation message after Reply has been Posted
			Test.wait_For(2000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Your comment has been posted.");
			Test.wait_For(1000);
			logger.info("Reply is posted to the selected thread");
			
			//Verify Reply on the Thread Page
			
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > div > section > article > table > tbody:nth-child(1) > tr > td > span.pull-right > nav > div > ul > li.comment-edit > a"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > div > section > article > table > tbody:nth-child(1) > tr > td > span.pull-right > nav > div > ul > li.comment-delete > a"),"Delete");
			Test.wait_For(3000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > header > table:nth-child(4) > tbody > tr > td:nth-child(1)"),"Replies: ");
			
			//Verify On Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td.last-reply > div:nth-child(1) > p"),"This is a reply message to the selected thread in a forum.");
			Test.wait_For(1000);
			logger.info("Newly posted reply is listed next to selected Forum on Forum Page.");
			
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
	//Test Name: Forum - Post A Reply With An Image
	@Test
	public void ICRP_Forum_Post_A_Reply_With_An_Image() throws Exception{
		String testName = "Forum - Post A Reply With An Image";
		String testDesc = "Forum - Post A Reply With An Image";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
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
			
			//Click Post Reply to a Forum Thread
			
			Test.clickLink(By.cssSelector("#forum-topic-7 > tbody > tr:nth-child(1) > td:nth-child(2) > span > div.forum-thread-title > a"));  //Click on Thread to Reply To
			
			Test.clickLink(By.linkText("Post Reply"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Post Reply");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Thread:");
			
			//Fill Out Post Reply Fields
			
			Test.wait_For(1000);
			Test.enterPostReplyMessage();
			Test.wait_For(1000);
			Test.click_add_image_button();
			Test.wait_For(3000);
			Test.switchToChildBrowser();
			//Test.GoToNewTabWindow();
			Test.wait_For(2000);
			Test.choose_image_upload();
			Test.wait_For(1000);
			Test.form_fill_insert_image_alternative_text(alternative_text);
			logger.info("Alternative Text");
			Test.wait_For(4000);
			
			//Test.clickLink(By.xpath("/html/body/div[4]/div/div/div[3]/button"));
			Test.clickLink(By.cssSelector("html.js body.user-logged-in.path-comment.has-glyphicons.modal-open div#drupal-modal.modal.fade.in div.modal-dialog div.modal-content div.modal-footer button.button.js-form-submit.form-submit.btn-success.btn.icon-before"));
			logger.info("Clicked Save Button");
			
			Test.switchToParentBrowser();
			//Test.GoToPreviousTabWindow();
			Test.wait_For(4000);
			
			//Click Post Reply
			logger.info("clicking Post Reply");
			Test.clickLink(By.cssSelector("#edit-submit"));
			
			//Verify Confirmation message after Reply has been Posted
			Test.wait_For(3000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Your comment has been posted.");
			Test.wait_For(1000);
			logger.info("Reply is posted to the selected thread");
			
			//Verify Reply on the Thread Page
			
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > div > section > article > table > tbody:nth-child(1) > tr > td > span.pull-right > nav > div > ul > li.comment-edit > a"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > div > section > article > table > tbody:nth-child(1) > tr > td > span.pull-right > nav > div > ul > li.comment-delete > a"),"Delete");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > header > table:nth-child(4) > tbody > tr > td:nth-child(1)"),"Replies: ");
			
			//Verify On Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td.last-reply > div:nth-child(1) > p"),"This is a reply message to the selected thread in a forum.");
			Test.wait_For(1000);
			logger.info("Newly posted reply is listed next to selected Forum on Forum Page.");
			
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
	//Test Name: Forum - Post A Reply With Links
	@Test
	public void ICRP_Forum_Post_A_Reply_With_Links() throws Exception{
		String testName = "Forum - Post A Reply With Links";
		String testDesc = "Forum - Post A Reply With Links";
		try{
			logger.info("---------------Begin Test case: " + testName + "--------------");
			Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
			Test.launchSite();
			Test.login(ManagerUserName, ManagerPassword, "pass");
			//Verify Welcome ICRP Partner Page
			Test.verifyLogin(By.cssSelector("html.js body.user-logged-in.path-frontpage.page-node-type-page.has-glyphicons div.main-container.container.js-quickedit-main-content div.row div.col-sm-12 div.region.region-header nav.navbar.navbar-inverse div.container-fluid div#manager-navbar-collapse.collapse.navbar-collapse ul.nav.navbar-nav.navbar-right li.dropdown a.dropdown-toggle"));
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
			
			//Click Post Reply to a Forum Thread
			
			Test.clickLink(By.cssSelector("#forum-topic-7 > tbody > tr:nth-child(1) > td:nth-child(2) > span > div.forum-thread-title > a"));  //Click on Thread to Reply To
			Test.wait_For(2000);
			Test.clickLink(By.linkText("Post Reply"));
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Post Reply");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Partner News and Announcements");
			Test.wait_For(1000);
			Test.expected_vs_actual_verification("Thread:");
			
			//Fill Out Post Reply Fields
			
			Test.wait_For(1000);
			Test.enterPostReplyMessage();
			Test.wait_For(1000);
			Test.click_add_links_button();
			Test.wait_For(3000);
			Test.switchToChildBrowser();
			//Test.GoToNewTabWindow();
			Test.wait_For(1000);
			Test.form_fill_insert_links_url(link_url);
			Test.wait_For(1000);
			
			//Test.clickLink(By.xpath("/html/body/div[4]/div/div/div[3]/button"));
			Test.clickLink(By.cssSelector("html.js body.user-logged-in.path-comment.has-glyphicons.modal-open div#drupal-modal.modal.fade.in div.modal-dialog div.modal-content div.modal-footer button.button.js-form-submit.form-submit.btn-success.btn.icon-before"));
			logger.info("clicked Save Button");
			
			Test.switchToParentBrowser();
			//Test.GoToPreviousTabWindow();
		
			//Click Post Reply
			logger.info("clicking Post Reply");
			Test.wait_For(2000);
			Test.clickLink(By.cssSelector("#edit-submit"));
			
			
			//Verify Confirmation message after Reply has been Posted
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.highlighted > div > div > div > h4"),"Your comment has been posted.");
			Test.wait_For(1000);
			logger.info("Reply with links is posted to the selected thread");
			
			//Verify Reply on the Thread Page
			
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > div > section > article > table > tbody:nth-child(1) > tr > td > span.pull-right > nav > div > ul > li.comment-edit > a"),"Edit");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > div > section > article > table > tbody:nth-child(1) > tr > td > span.pull-right > nav > div > ul > li.comment-delete > a"),"Delete");
			Test.wait_For(1000);
			Test.wait_until_element_present(By.cssSelector("body > div > div > section > div.region.region-content > article > header > table:nth-child(4) > tbody > tr > td:nth-child(1)"),"Replies: ");
			
			//Verify On Forum Page
			Test.clickLink(By.linkText("Forum"));
			Test.wait_For(5000);
			Test.wait_until_element_present(By.name("To start viewing messages, select the forum that you want to visit from the selection below."),"To start viewing messages, select the forum that you want to visit from the selection below.");
			Test.expected_vs_actual_verification("ICRP Partnership Forum");
			Test.wait_For(5000);
			logger.info("Forum Page is presented.");
			
			//Verify New Thread is Listed
			
			Test.wait_until_element_present(By.cssSelector("#forum-list-7 > td.last-reply > div:nth-child(1) > p"),"This is a reply message to the selected thread in a forum.");
			Test.wait_For(1000);
			logger.info("Newly posted reply with links is listed next to selected Forum on Forum Page.");
			
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