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

public class TestCSO {
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
	
	public TestCSO(){
		BaseTestMethods.appRelease = "ICRP";
		BaseTestMethods.releaseDesc = "Established in 2000, International Cancer Research Partnership (ICRP) is a unique alliance of cancer organizations working together to enhance global collaboration and strategic coordination of research.";
	}	
		
/////// CSO ///////////////
	
		//S.N.: 1
		//Test Name: Validate CSO
		@Test
		public void ICRP_Validate_CSO() throws Exception{
			String testName = "Validate CSO";
			String testDesc = "Validate CSO";
			try{
				logger.info("---------------Begin Test case: " + testName + "--------------");
				Test.setupBeforeSuite(seleniumBrowser , seleniumUrl, testName, testDesc);
				Test.launchSite();
				Test.wait_For(5000);
			
				//Verify Common Scientific Online Page
				Test.clickLink(By.linkText("ICRP Data"));
				Test.wait_For(5000);
				Test.clickLink(By.linkText("Common Scientific Outline (CSO)"));
				Test.wait_For(5000);
				Test.wait_until_element_present(By.name("Common Scientific Outline (CSO)"),"Common Scientific Outline (CSO)");
				Test.expected_vs_actual_verification("Research included in this category looks at the biology of how cancer starts and progresses as well as normal biology relevant to these processes");
				Test.wait_For(5000);
			
				
				//Click First Example Button
				
				Test.clickLink(By.cssSelector("#cso-1-1-ex1"));  //1st Example for 1.1 Normal Functioning
				//Test.GoToNewTabWindow();
				Test.wait_For(5000);
				Test.switchToChildBrowserWindow();
				//Test.wait_For(1000);
				Test.verifyUrl("https://www.icrpartnership-test.org/project/funding-details/119837");
				Test.wait_For(5000);
				//Test.GoToPreviousTabWindow();
				Test.switchToParentBrowserWindow();
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("#cso-3-6-ex2")); //2nd Example for 3.6 Resources and Infrastructure Related to Prevention
				Test.wait_For(3000);
				//Test.GoToNewTabWindow();		
				//Test.wait_For(5000);
				Test.switchToChildBrowserWindow();
				Test.verifyUrl("https://www.icrpartnership-test.org/project/funding-details/26469");
				//Test.GoToPreviousTabWindow();
				Test.switchToParentBrowserWindow();
				Test.wait_For(5000);
				Test.clickLink(By.cssSelector("#cso-6-5-ex1")); //1st Example for 6.5 Education and Communication Research
				//Test.GoToNewTabWindow();
				Test.switchToChildBrowserWindow();
				Test.switchToChildBrowserWindow();
				Test.switchToChildBrowserWindow();
				Test.wait_For(5000);
				Test.verifyUrl("https://www.icrpartnership-test.org/project/funding-details/27483");
				Test.GoToPreviousTabWindow();
				//Test.switchToParentBrowserWindow();
				//Test.switchToParentBrowserWindow();
				//Test.switchToParentBrowserWindow();
				Test.wait_For(5000);
				//Test.clickLink(By.cssSelector(".quickedit-field > p:nth-child(120) > a:nth-child(1)"));  //Click Back to Top
				Test.clickLink(By.xpath("/html/body/div/div/section/div[2]/article/div/div/div[2]/div/div/div/p[46]/a"));
				Test.clickLink(By.cssSelector("#downloadPanel > a:nth-child(19)"));  //Under Download Select Cancer Type List
				Test.wait_For(2000);
				Test.verifyUrl("https://www.icrpartnership-test.org/cancer-type-list");
				Test.expected_vs_actual_verification("The ICRP Partners code all awards in the database to one or more of the following cancer types:");
				Test.wait_until_element_present(By.cssSelector("#cancer-type-list > div > table > thead > tr > th:nth-child(1) > div"),"Cancer Type");
				
				
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