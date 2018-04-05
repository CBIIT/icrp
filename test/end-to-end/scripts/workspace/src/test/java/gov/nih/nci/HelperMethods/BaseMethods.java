package gov.nih.nci.HelperMethods;

import static org.junit.Assert.fail;

import org.junit.Assert;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.interactions.HasInputDevices;
import org.openqa.selenium.interactions.Mouse;
import org.openqa.selenium.internal.Locatable; 
import org.apache.log4j.Logger;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.security.SecureRandom;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
import java.util.UUID;

//import com.jacob.com.*;
//import com.jacob.activeX.*;

//import autoitx4java.*;

import org.apache.commons.io.IOUtils;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;
//import org.json.simple.parser.JSONParser;

import org.apache.poi.ss.usermodel.Workbook;

public class BaseMethods extends BaseTestMethods{
	private static Logger logger=Logger.getLogger("BaseMethods");
	public BaseMethods(){}	
	
	/*
	 * This method launches the ICRP website 	
	 */
		public void launchSite() throws TestExecutionException{
			boolean retVal;
			if (seleniumBrowser == "ie"){
				click(By.id("overridelink"));
				try {
					implicitwait(20);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector("#anonymous-navbar > ul > li:nth-child(3) > a"));
				logger.info("Loading page condition is: ["+ getUIVal +"]");
				if (getUIVal == true){
					break;
				}
			}
			retVal = verifyTitle("International Cancer Research Partnership");
			captureScreenshot(dir+"/snapshots/LoginPage.png");
			
			if(retVal == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Launches the caNanoLab site","launchSite","Website launched successfully","Pass");
				stepCount++;
			}else{
				logger.error("ERROR: Error Launching the Web site");
				oPDF.enterBlockSteps(bTable,stepCount,"Launches the caNanoLab site","launchSite","Website launch failed.","Fail", "LoginPage.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail("ERROR: Error Launching the Web site");
			}
		}
		/*
		 * 
		 */
		
		//Navigate back and forward on a Page
		
		public void navigate_to() throws TestExecutionException{
			
			selenium.navigate().to("https://www.icrpartnership-test.org/");

		}
		
		public void navigate_back() throws TestExecutionException{
			  //To navigate back (Same as clicking on browser back button)
			selenium.navigate().back();
		}
		
		public void navigate_forward() throws TestExecutionException{
			
			  //To navigate forward (Same as clicking on browser forward button)
			selenium.navigate().forward();
		}
		
		
		//Retrieve login credentials from external JSON file.
		
	    public static JSONObject parseJSONFile(String filename) throws JSONException, Exception {
		        String content = new String(Files.readAllBytes(Paths.get(filename)));
		        return new JSONObject(content);
		    }
		
		
		public void Login_enter_manager_cred_from_json() throws Exception, JSONException {
			
			click(By.cssSelector("#block-anonymoususermenu > div:nth-child(1) > div:nth-child(2) > div:nth-child(2) > a:nth-child(1)"));
			wait_For(2000);
	        // String filename = "C://My Frameworks//WebDriver//Application//ICRP//Credentials//credentials.json";
			String filename = "/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/credentials.json";
	        JSONObject jsonObject = parseJSONFile(filename);
	        
	        String managername = (String) jsonObject.get("manager_name");
	        String managerpassword = (String) jsonObject.get("manager_password");
	        
	        enter(By.name("name"), managername);
	        wait_For(1000);
	        logger.info("Manager Name Entered");
	        enter(By.name("pass"), managerpassword);
	        wait_For(1000);
	        logger.info("Manager Password Entered");
	        click(By.cssSelector("#edit-submit"));
	        wait_For(1000);
	        logger.info("Login Button Clicked");
	        }
		
		public void Login_enter_Partner1_cred_from_json() throws Exception, JSONException {
			
			click(By.cssSelector("#block-anonymoususermenu > div:nth-child(1) > div:nth-child(2) > div:nth-child(2) > a:nth-child(1)"));
			wait_For(2000);
	        // String filename = "C://My Frameworks//WebDriver//Application//ICRP//Credentials//credentials.json";
			String filename = "/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/credentials.json";
	        JSONObject jsonObject = parseJSONFile(filename);
	        
	        String partner1name = (String) jsonObject.get("partner1_name");
	        String partner1password = (String) jsonObject.get("partner1_password");
	        
	        enter(By.name("name"), partner1name);
	        wait_For(1000);
	        logger.info("Manager Name Entered");
	        enter(By.name("pass"), partner1password);
	        wait_For(1000);
	        logger.info("Manager Password Entered");
	        click(By.cssSelector("#edit-submit"));
	        wait_For(1000);
	        logger.info("Login Button Clicked");
	        }
		
		public void Login_enter_Partner2_cred_from_json() throws Exception, JSONException {
			
			click(By.cssSelector("#block-anonymoususermenu > div:nth-child(1) > div:nth-child(2) > div:nth-child(2) > a:nth-child(1)"));
			wait_For(2000);
	        // String filename = "C://My Frameworks//WebDriver//Application//ICRP//Credentials//credentials.json";
			String filename = "/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/credentials.json";
	        JSONObject jsonObject = parseJSONFile(filename);
	        
	        String partner2name = (String) jsonObject.get("partner2_name");
	        String partner2password = (String) jsonObject.get("partner2_password");
	        
	        enter(By.name("name"), partner2name);
	        wait_For(1000);
	        logger.info("Manager Name Entered");
	        enter(By.name("pass"), partner2password);
	        wait_For(1000);
	        logger.info("Manager Password Entered");
	        click(By.cssSelector("#edit-submit"));
	        wait_For(1000);
	        logger.info("Login Button Clicked");
	        }
		
		public void verifyLink(By by, String expectedPage) throws TestExecutionException{
			click(by);
			captureScreenshot(dir+"/snapshots/"+expectedPage+".png");
			boolean retVal = isTextPresent(expectedPage);
			if (retVal == true){ 
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of links","verifyLink","Successfully verified link: "+by,"Pass", expectedPage+".png");
				stepCount++;
			}else{	
				System.out.println("Error link:");
				TestExecutionException e = new TestExecutionException("Error link");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of links: "+e+"" ,"verifyLink","Verification of link  failed. link: "+by,"Fail", expectedPage+".png");
				stepCount++;
				setupAfterSuite();
				Assert.fail("Verification of link "+ by + " failed");
			}			
		}
		/*
		 * This function looks for a specific LINK on the  page 
		 */
		public void verifyLinkOnThePage(By by) throws TestExecutionException{
			boolean retVal1 = isDisplayed(by);
			boolean retVal2 = isEnabled(by);
			if (retVal1 == true && retVal2 == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","verifyLinkOnThePage","Verification successful for "+ by,"Pass");
				stepCount++;				
			}else {
				logger.error("Hyperlink verification failed");
				TestExecutionException e = new TestExecutionException("Verification of Link failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","verifyLinkOnThePage","Verification failed for " + by,"Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * This function looks for a specific LINK on the  page 
		 */
		public void verifyElementOnThePage(By by) throws TestExecutionException{
			boolean retVal1 = isDisplayed(by);
			boolean retVal2 = isEnabled(by);
			if (retVal1 == true && retVal2 == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Element","verifyElementOnThePage","Verification successful for "+ by,"Pass");
				stepCount++;				
			}else {
				logger.error("Hyperlink verification failed");
				TestExecutionException e = new TestExecutionException("Verification of Element failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","verifyElementOnThePage","Verification failed for " + by,"Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * This method verify a specific LINK not present on the page 
		 */
		public void verifyLinkNotPresentOnThePage(By by) throws TestExecutionException{
			boolean retVal1 = isNotDisplayed(by);
			boolean retVal2 = isNotEnabled(by);
			if (retVal1 == true && retVal2 == true){
				logger.error("Link does not exists verification failed");
				TestExecutionException e = new TestExecutionException("Link present in the page and Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Link does not exists Verification failed","verifyLinkNotPresentOnThePage","Link exists in the page and link verification failed for " + by,"Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}else {
				logger.info("Successfully Verified link: ["+ by +"] does not exists on the page");
				oPDF.enterBlockSteps(bTable,stepCount,"Link dose not exists in the page verification","verifyLinkNotPresentOnThePage", "["+ by +"] Link dose not exists in the page and verification successful","Pass");
				stepCount++;
			}
		}
		/*
		 * This method will click next until a specific value presents on the page  
		 */
		public void click_next_result_page_link_until(String gLinkVal) throws TestExecutionException{
			int rCount = 10000;
			for (int i=1;i<rCount;i++){
				boolean utilVal = false;
				utilVal = isDisplayedTrue(By.linkText(gLinkVal));
				if (utilVal == true){
				  logger.info("Found Link: ["+ gLinkVal +"] on the current page");	
				  boolean retVal1 = isDisplayed(By.linkText(gLinkVal));
				  boolean retVal2 = isEnabled(By.linkText(gLinkVal));
				  //click(By.linkText(gLinkVal));
				if (retVal1 == true && retVal2 == true){
					oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","click_next_result_page_link_until","Verification successful for "+ gLinkVal,"Pass");
					stepCount++;
					break;
				}
				}else {
					logger.info("Unable to find Link: ["+ gLinkVal +"] on the current page. Clicking Next");
					boolean boolNLink1 = isDisplayed(By.linkText("Â»"));
					boolean boolNLink2 = isEnabled(By.linkText("Â»"));
					if (boolNLink1 == true && boolNLink2 == true){
					    click(By.linkText("Â»"));
					    int pageLinkNm = i+1;
					    logger.info("Displaying result page number: ["+ pageLinkNm +"]");
					}else {
						logger.error("Hyperlink verification failed");
						TestExecutionException e = new TestExecutionException("Verification of Link failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","click_next_result_page_link_until","Verification failed for " + gLinkVal,"Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());			
					}
				    }							
			   }
			}
		
		
		/*
		 * This function looks for a specific LINK on the  page and perform a click action
		 */
		public void clickLink(By by) throws TestExecutionException{
			boolean retVal1 = isDisplayed(by);
			boolean retVal2 = isEnabled(by);
			if (retVal1 == true && retVal2 == true){
				try {
					_wait(200);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				click(by);
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","clickLink","Verification and Click action successful for "+ by,"Pass");
				stepCount++;				
			}else {
				logger.error("Link verification failed");
				TestExecutionException e = new TestExecutionException("Verification of Link failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","clickLink","Verification and Click action failed for " + by,"Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * This method verifies the privacy policy on email message
		 */
		public void check_page_source_code (String srcVerInf, String frntVerInf) throws TestExecutionException {
			
			boolean retVal1 = isTextPresent(frntVerInf);
			boolean retVal2 = selenium.getPageSource().contains(srcVerInf);
			
			if (retVal1 == false || retVal2 == false){
				captureScreenshot(dir+"/snapshots/scInfo.png");
				logger.error("Source Code verifications failed");
				TestExecutionException e = new TestExecutionException("Source code verifications failed in Front end or source page");
				oPDF.enterBlockSteps(bTable,stepCount,"Source Code verification","check_page_source_code","Verification failed","Fail", "scInfo.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}else {
				captureScreenshot(dir+"/snapshots/scInfo.png");
				logger.info("Source: '"+ srcVerInf +"' and front end page: '"+ frntVerInf +"' Version info verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Source Code verification","check_page_source_code","Source Code: ["+srcVerInf+"] Verification successful","Pass", "scInfo.png");
				stepCount++;								
			}			
		}
		/*
		 * This method verify the search result
		 */
		public void expected_string_verification (String gExStVeri) throws TestExecutionException {
			
			boolean retVal1 = isTextPresent(gExStVeri);
			
			if (retVal1 == false){
				captureScreenshot(dir+"/snapshots/searchVerification.png");
				logger.error("Search result verifications failed");
				TestExecutionException e = new TestExecutionException("Search result verifications failed. System unable to display : '"+ gExStVeri +"' search results");
				oPDF.enterBlockSteps(bTable,stepCount,"Searcg Result Verification","expected_string_verification","Verification failed. System unable to display : '"+ gExStVeri +"' search results","Fail", "searchVerification.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}else {
				logger.info("Search result verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Fields verification","expected_string_verification","Verification successful for: ["+ gExStVeri +"]","Pass");
				stepCount++;								
			}			
		}
		/*
		 * This method verify the search result
		 */
		public void search_result_verification (String gSearchRslt) throws TestExecutionException {
			
			boolean retVal1 = isTextPresent(gSearchRslt);
			String imgName = gSearchRslt.replaceAll("\\r||\\n", "");
			if (retVal1 == false){
				captureScreenshot(dir+"/snapshots/"+imgName+"searchVerification.png");
				logger.error("Search result verifications failed");
				TestExecutionException e = new TestExecutionException("Search result verifications failed. System unable to display : '"+ gSearchRslt +"' search results");
				oPDF.enterBlockSteps(bTable,stepCount,"Searcg Result Verification","search_result_verification","Verification failed. System unable to display : '"+ gSearchRslt +"' search results","Fail", imgName+"searchVerification.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}else {
				logger.info("Search result verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Fields verification","search_result_verification","Verification successful for: ["+ gSearchRslt +"]","Pass");
				stepCount++;								
			}			
		}
		/*
		 * This method verify specific value on the page
		 */
		public void expected_value_verification (String gExpectedVal) throws TestExecutionException {
			
			boolean retVal1 = isTextPresent(gExpectedVal);
			
			if (retVal1 == false){
				captureScreenshot(dir+"/snapshots/expectedValVerification.png");
				logger.error("Expected Value Verifications Failed");
				TestExecutionException e = new TestExecutionException("Verifications failed. System unable to display expected:'"+ gExpectedVal +"' value in the page");
				oPDF.enterBlockSteps(bTable,stepCount,"Expected Value Verification","expected_value_verification","Verification failed. System unable to display expected: '"+ gExpectedVal +"' value in the page","Fail", "expectedValVerification.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());				
			}else {
				logger.info("Expected Value Verification Passed");
				oPDF.enterBlockSteps(bTable,stepCount,"Expected Value Verification","expected_value_verification","Verification Passed. System displays expected: '"+ gExpectedVal +"' value in the page","Pass");
				stepCount++;								
			}			
		}		
		/*
		 * This method verify specific value not present on the page
		 */
		public void not_expected_value_verification (String gExpectedVal) throws TestExecutionException {
			
			boolean retVal1 = isTextNotPresent(gExpectedVal);
			
			if (retVal1 == false){
				captureScreenshot(dir+"/snapshots/notExpectedValVerification.png");
				logger.error("Not Expected Value Verifications Failed");
				TestExecutionException e = new TestExecutionException("System displays:'"+ gExpectedVal +"' value in the page. Verifications failed.");
				oPDF.enterBlockSteps(bTable,stepCount,"Not Expected Value Verification","not_expected_value_verification","System displays: '"+ gExpectedVal +"' value in the page. Verification failed.","Fail", "notExpectedValVerification.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}else {
				logger.info("Expected Value Verification Passed");
				oPDF.enterBlockSteps(bTable,stepCount,"Expected Value Verification","not_expected_value_verification","Verification Passed. System displays expected: '"+ gExpectedVal +"' value in the page","Pass");
				stepCount++;								
			}			
		}
		/*
		 * This method click on the result link by Vocabulary name 
		 */
		public void select_link_by_name (String gVocabularyVal) throws TestExecutionException {
			int rCount = getRowCount(By.xpath("//*[@id='main-area_960']/div[2]/table/tbody/tr[4]/td/table/tbody"));
			logger.info("row count: "+ rCount +"");
			String rCellData = null;
			       rCount = rCount + 1; 
			for (int i=2;i<rCount;i++){
				String vocabularyNm = "//*[@id='main-area_960']/div[2]/table/tbody/tr[4]/td/table/tbody/tr["+ i +"]/td[2]";
				rCellData = getText(By.xpath(vocabularyNm));
				logger.info("row count:"+ i +" value is: "+ rCellData +"");
				
				if (rCellData.equals(gVocabularyVal)) {
					String buildPath = "//*[@id='main-area_960']/div[2]/table/tbody/tr[4]/td/table/tbody/tr["+ i +"]/td[1]/a";
					click(By.xpath(buildPath));
					logger.info("Identified : ["+ gVocabularyVal +"] value in row number: ["+ i +"]");
					try {
						_wait(300);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					break;
				}
			}
		}
		/*
		 * This method count total result row from each page 
		 */
		public void search_result_count_total () throws TestExecutionException {
			int rCount = getRowCount(By.xpath("//*[@id='main-area_960']/div[3]/div[1]/table/tbody/tr/td/table/tbody"));
				rCount = rCount - 1; 
			logger.info("Total result count on the application page: "+ rCount +"");
			String resultCountFromRow = ""+rCount+"";
			String getTotalResltCount = getText(By.xpath("//div[@id='main-area_960']/div[3]/div[2]/form/table/tbody/tr/td/b"));
			logger.info("Result count information from application page: ["+ getTotalResltCount +"]");
			String valSplt = getTotalResltCount;
           	String[] parts = valSplt.split(" ");
            String part4 = parts[3];
            //logger.info(part4);
			if (resultCountFromRow.equals(part4)) {
				logger.info("Application Result count: ["+getTotalResltCount+"] and Total actual displayed result count: ["+resultCountFromRow+"] matched successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Result Count verification","total_result_count","Application Result count: ["+getTotalResltCount+"] and Total actual displayed result count: ["+resultCountFromRow+"] matched successfully","Pass");
				stepCount++;		
			}else {
				captureScreenshot(dir+"/snapshots/"+getTotalResltCount+".png");
				logger.error("Application Result count: ["+getTotalResltCount+"] and Total actual displayed result count: ["+resultCountFromRow+"] did not match");
				TestExecutionException e = new TestExecutionException("Result count verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Result count Verification","total_result_count","Application Result count: ["+getTotalResltCount+"] and Total actual displayed result count: ["+resultCountFromRow+"] match failed","Fail", getTotalResltCount+".png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());	
			}
		}
		/*
		 * This method for time to wait	
		 */
		public void wait_For (int timeVal) throws TestExecutionException {
			try {
				_wait(timeVal);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			logger.info("Wait Time: ["+ timeVal +"]");
		}
		/*
		 * This method clicks on the home link
		 */
		public void goHome() throws TestExecutionException{
			click(By.linkText("HOME"));
		}
		
		public void goAppLoginPage() throws TestExecutionException{
			boolean retVal1 = isDisplayed(By.xpath("//a[contains(@href, '/caNanoLab/#/')]"));
			if (retVal1 == true){
				click(By.xpath("//a[contains(@href, '/caNanoLab/#/')]"));
				boolean retVal2 = isDisplayed(By.linkText("Online Help"));
				if (retVal2 == true){
				   logger.info("Successfully Located Home Page Logo");
				}else{
				   logger.error("Home Page logo Verification Failed");	
				}
			}else {
				captureScreenshot(dir+"/snapshots/"+ retVal1+".png");
				logger.error("Home Page logo Verification Failed");
				TestExecutionException e = new TestExecutionException("Home Page logo Verification Failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Home Page logo Verification Failed","goAppLoginPage","Home Page logo Verification Failed","Fail", retVal1+".png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void writeRestdPass(String getEnv, String getResetPassVal) {
		    String buildFilePath = "C://My_Frameworks_creds//UserCred//Applications//caNanoLab//passRest_"+ getEnv +".txt"; 
		    String f = buildFilePath;
		    try {
		        FileWriter fr = new FileWriter(f);
		        BufferedWriter br = new BufferedWriter(fr);
		        br.write(getResetPassVal); 
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		}
		/*
		 * 
		 */
		public String readPassRest(String getEnv) {
		    String textCred = "";
		    String buildFilePath = "C://My_Frameworks_creds//UserCred//Applications//caNanoLab//passRest_"+ getEnv +".txt"; 
		    String f = buildFilePath;
		    int read, N = 1024 * 1024;
		    char[] buffer = new char[N];
		    try {
		        FileReader fr = new FileReader(f);
		        BufferedReader br = new BufferedReader(fr);
		        while(true) {
		            read = br.read(buffer, 0, N);
		            textCred += new String(buffer, 0, read);
		            if(read < N) {
		                break;
		            }
		        }
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		   return textCred;
		}
		/*
		 * 
		 */
		private static char rndCharUpper() {
			Random r = new Random();
			char c = (char)(r.nextInt(26) + 'A');
		    return c;
		}
		/*
		 * 
		 */
		private static char rndCharLower() {
			Random r = new Random();
			char c = (char)(r.nextInt(26) + 'a');
		    return c;
		}
		/*
		 * 
		 */
		private static char rndSpclCharLower() {
			Random r = new Random();
			char c = (char)(r.nextInt(1) + '@');
		    return c;
		}
		/*
		 * 
		 */
		public String new_pass_without_password_policy() {
				String generateNewPass = "";
				//String timeFrmt = DateHHMMSS2();
				//String dateFrmt = Date_day();
				//String monthFrmt = Date_Month();
				int getRandNmbr = randInt(11111111, 99999999);
				//char rndChracterU = rndCharUpper();
				//char rndChracterL1 = rndCharLower();
				//char rndChracterU1 = rndCharUpper();
				//char rndChracterUpr = rndCharUpper();
				//char rndChracterL = rndCharLower();
				//char rndSpclChracter = rndSpclCharLower();
				generateNewPass = "" + getRandNmbr + "";
			   return generateNewPass;
		}
		/*
		 * 
		 */
		public String new_pass() {
				String generateNewPass = "";
				//String timeFrmt = DateHHMMSS2();
				//String dateFrmt = Date_day();
				//String monthFrmt = Date_Month();
				int getRandNmbr = randInt(12, 99999);
				char rndChracterU = rndCharUpper();
				char rndChracterL1 = rndCharLower();
				char rndChracterU1 = rndCharUpper();
				char rndChracterUpr = rndCharUpper();
				char rndChracterL = rndCharLower();
				char rndSpclChracter = rndSpclCharLower();
				logger.info("rndChracterU:["+rndChracterU);
				logger.info("rndChracterL:["+rndChracterL);
				generateNewPass = "" + getRandNmbr + ""+ rndChracterU + ""+ rndChracterL1 + "" + rndChracterU1 + ""  + rndSpclChracter + "" + rndChracterL + "" + rndChracterUpr +"";
			   return generateNewPass;
		}
		/*
		 * 
		 */
		public void reset_password(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), getUserName);
						enter(By.id("old_password"), getPassRestVal);
						enter(By.id("new_password"), getNewPwdVal);
						enter(By.id("confirm_new_password"), getNewPwdVal);
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_password_reset_successful(getUserName);
						writeRestdPass(getTierVal, getNewPwdVal);
						
					}
					
				}
			}
		}
		/*
		 * 
		 */
		public void reset_password_confirm_new_password(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), getUserName);
						enter(By.id("old_password"), getPassRestVal);
						enter(By.id("new_password"), getNewPwdVal);
						enter(By.id("confirm_new_password"), "");
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_reset_password_confirm_new_password(getUserName);
					}
					
				}
			}
		}
		/*
		 *  
		 */
		public void verify_reset_password_confirm_new_password(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean LoginID = false;
			boolean OldPass = false;
			boolean NewPass = false;
			boolean ConfPass = false;
			boolean ErrMsg = false;
			for (int r=2;r<loadCount;r++){
				//LoginID = isTextPresent("LOGIN ID is required");
				//OldPass = isTextPresent("OLD PASSWORD is required");
				//NewPass = isTextPresent("NEW PASSWORD is required");
				ConfPass = isTextPresent("CONFIRM NEW PASSWORD is required");
				ErrMsg = isTextPresent("NEW PASSWORD and CONFIRM PASSWORD do not match");
				if (LoginID == false && OldPass == false && NewPass == false && ConfPass == true && ErrMsg == true){
					logger.info("Password Reset Confirmed New Password Filed verification successful");
					oPDF.enterBlockSteps(bTable, stepCount, "Confirmed New Password Filed verification", "verify_reset_password_confirm_new_password", "Password Reset Confirmed New Password Filed verification successful", "Pass");
					stepCount++;
					break;
				}
			}
			if (LoginID == true && OldPass == true && NewPass == true && ConfPass == false && ErrMsg == false){
					logger.error("Password Reset Confirmed New Password Filed verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset Confirmed New Password Filed verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Confirmed New Password Filed verification", "verify_reset_password_confirm_new_password", "Password Reset Confirmed New Password Filed verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void reset_password_without_password_policy_unsuccessful(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass_without_password_policy();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), getUserName);
						enter(By.id("old_password"), getPassRestVal);
						enter(By.id("new_password"), getNewPwdVal);
						enter(By.id("confirm_new_password"), getNewPwdVal);
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_reset_password_policy(getUserName);
					}
					
				}
			}
		}
		/*
		 *  
		 */
		public void verify_reset_password_policy(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean LoginID = false;
			boolean OldPass = false;
			boolean NewPass = false;
			boolean ConfPass = false;
			boolean ErrMsg = false;
			for (int r=2;r<loadCount;r++){
				//LoginID = isTextPresent("LOGIN ID is required");
				//OldPass = isTextPresent("Login ID is required");
				//NewPass = isTextPresent("NEW PASSWORD is required");
				//ConfPass = isTextPresent("CONFIRM NEW PASSWORD is required");
				ErrMsg = isTextPresent("Password must contain 1 upper case letter, 1 lower case letter, 1 symbol and be 8 or more characters in length");
				if (LoginID == false && OldPass == false && NewPass == false && ConfPass == false && ErrMsg == true){
					logger.info("Password Reset Policy verification successful");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Policy verification", "verify_reset_password_policy", "Password Reset Policy verification Passed", "Pass");
					stepCount++;
					break;
				}
			}
			if (LoginID == true && OldPass == true && NewPass == true && ConfPass == true && ErrMsg == false){
					logger.error("Password Reset Policy verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset Policy verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Policy verification", "verify_reset_password_policy", "Password Reset Policy verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void reset_password_login_id_field_required(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), "");
						enter(By.id("old_password"), getPassRestVal);
						enter(By.id("new_password"), getNewPwdVal);
						enter(By.id("confirm_new_password"), getNewPwdVal);
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_reset_password_login_id_required(getUserName);
					}
					
				}
			}
		}
		/*
		 *  
		 */
		public void verify_reset_password_login_id_required(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean LoginID = false;
			boolean OldPass = false;
			boolean NewPass = false;
			boolean ConfPass = false;
			boolean ErrMsg = false;
			for (int r=2;r<loadCount;r++){
				LoginID = isTextPresent("LOGIN ID is required");
				//OldPass = isTextPresent("Login ID is required");
				//NewPass = isTextPresent("NEW PASSWORD is required");
				//ConfPass = isTextPresent("CONFIRM NEW PASSWORD is required");
				//ErrMsg = isTextPresent("NEW PASSWORD and CONFIRM PASSWORD do not match");
				if (LoginID == true && OldPass == false && NewPass == false && ConfPass == false && ErrMsg == false){
					logger.info("Password Reset Login ID Filed verification successful");
					oPDF.enterBlockSteps(bTable, stepCount, "Login ID Filed verification", "verify_reset_password_login_id_required", "Password Reset Login ID Field verification successful", "Pass");
					stepCount++;
					break;
				}
			}
			if (LoginID == false && OldPass == true && NewPass == true && ConfPass == true && ErrMsg == true){
					logger.error("Password Reset Login ID Filed verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset Login ID Filed verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Login ID Filed verification", "verify_reset_password_login_id_required", "Password Reset Login ID Field verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void reset_password_old_password_field_required(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), getUserName);
						enter(By.id("old_password"), "");
						enter(By.id("new_password"), getNewPwdVal);
						enter(By.id("confirm_new_password"), getNewPwdVal);
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_reset_password_old_password_required(getUserName);
					}
					
				}
			}
		}
		/*
		 *  
		 */
		public void verify_reset_password_old_password_required(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean LoginID = false;
			boolean OldPass = false;
			boolean NewPass = false;
			boolean ConfPass = false;
			boolean ErrMsg = false;
			for (int r=2;r<loadCount;r++){
				//LoginID = isTextPresent("LOGIN ID is required");
				OldPass = isTextPresent("OLD PASSWORD is required");
				//NewPass = isTextPresent("NEW PASSWORD is required");
				//ConfPass = isTextPresent("CONFIRM NEW PASSWORD is required");
				//ErrMsg = isTextPresent("NEW PASSWORD and CONFIRM PASSWORD do not match");
				if (LoginID == false && OldPass == true && NewPass == false && ConfPass == false && ErrMsg == false){
					logger.info("Password Reset Old Password Filed verification successful");
					oPDF.enterBlockSteps(bTable, stepCount, "Old Password Filed verification", "verify_reset_password_old_password_required", "Password Reset old Password Field verification successful", "Pass");
					stepCount++;
					break;
				}
			}
			if (LoginID == true && OldPass == false && NewPass == true && ConfPass == true && ErrMsg == true){
					logger.error("Password Reset old Password Filed verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset old Password Filed verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Old Password Filed verification", "verify_reset_password_old_password_required", "Password Reset old Password Field verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void reset_password_new_password_field_required(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), getUserName);
						enter(By.id("old_password"), getPassRestVal);
						enter(By.id("new_password"), "");
						enter(By.id("confirm_new_password"), getNewPwdVal);
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_reset_password_new_password_required(getUserName);
					}
					
				}
			}
		}
		/*
		 *  
		 */
		public void verify_reset_password_new_password_required(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean LoginID = false;
			boolean OldPass = false;
			boolean NewPass = false;
			boolean ConfPass = false;
			boolean ErrMsg = false;
			for (int r=2;r<loadCount;r++){
				//LoginID = isTextPresent("LOGIN ID is required");
				//OldPass = isTextPresent("OLD PASSWORD is required");
				NewPass = isTextPresent("NEW PASSWORD is required");
				//ConfPass = isTextPresent("CONFIRM NEW PASSWORD is required");
				//ErrMsg = isTextPresent("NEW PASSWORD and CONFIRM PASSWORD do not match");
				if (LoginID == false && OldPass == false && NewPass == true && ConfPass == false && ErrMsg == false){
					logger.info("Password Reset New Password Filed verification successful");
					oPDF.enterBlockSteps(bTable, stepCount, "New Password Filed verification", "verify_reset_password_confirm_new_password", "Password Reset New Password Field verification successful", "Pass");
					stepCount++;
					break;
				}
			}
			if (LoginID == true && OldPass == true && NewPass == false && ConfPass == true && ErrMsg == true){
					logger.error("Password Reset New Password Filed verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset New Password Filed verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "New Password Filed verification", "verify_reset_password_confirm_new_password", "Password Reset New Password Field verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void reset_password_with_same_pass(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
			if (getUserName.isEmpty()==false){
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				if (getUserName.isEmpty()==false){
					String getPassRestVal = readPassRest(getTierVal);
					String getNewPwdVal = new_pass();
					logger.info("Old Password:["+getPassRestVal);
					logger.info("New Password:["+getNewPwdVal);
					if (getPassRestVal.isEmpty()==false){
						enter(By.name("reset_loginId"), getUserName);
						enter(By.id("old_password"), getPassRestVal);
						enter(By.id("new_password"), getPassRestVal);
						enter(By.id("confirm_new_password"), getPassRestVal);
					}
					if (getResetPassSubmit.isEmpty()==false){
						click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
						verify_password_reset_unsuccessful(getUserName);
						//writeRestdPass(getTierVal, getNewPwdVal);
						
					}
					
				}
			}
		}
		/*
		 * 
		 */
		public void reset_password_fields_required(String getUserName, String getTierVal, String getResetPassSubmit) throws TestExecutionException{
				element_display(By.name("reset_loginId"));
				element_display(By.id("old_password"));
				element_display(By.id("new_password"));
				element_display(By.id("confirm_new_password"));
				element_display(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				String getPassRestVal = "";
				enter(By.name("reset_loginId"), getUserName);
				enter(By.id("old_password"), getPassRestVal);
				enter(By.id("new_password"), getPassRestVal);
				enter(By.id("confirm_new_password"), getPassRestVal);
				click(By.cssSelector(".resetBlock tbody tr:nth-child(5) input"));
				verify_password_reset_field_required(getUserName);

		}
		/*
		 *  
		 */
		public void verify_password_reset_field_required(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean LoginID = false;
			boolean OldPass = false;
			boolean NewPass = false;
			boolean ConfPass = false;
			boolean ErrMsg = false;
			for (int r=2;r<loadCount;r++){
				LoginID = isTextPresent("LOGIN ID is required");
				OldPass = isTextPresent("OLD PASSWORD is required");
				NewPass = isTextPresent("NEW PASSWORD is required");
				ConfPass = isTextPresent("CONFIRM NEW PASSWORD is required");
				ErrMsg = isTextPresent("NEW PASSWORD and OLD PASSWORD must not be the same");
				if (LoginID == true && OldPass == true && NewPass == true && ConfPass == true && ErrMsg == true){
					logger.info("Password Reset Required Filed verification successful");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Required Filed verification successful", "verify_password_reset_field_required", "Password Reset Required Filed verification successful", "Pass");
					stepCount++;
					break;
				}
			}
			if (LoginID == false && OldPass == false && NewPass == false && ConfPass == false && ErrMsg == false){
					logger.error("Password Reset Required Filed verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset Required Filed verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Required Filed verification", "verify_password_reset_field_required", "Password Reset Required Filed verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 *  
		 */
		public void verify_password_reset_unsuccessful(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean getItemDisplay = false;
			String getPassResetMsg = null;
			for (int r=2;r<loadCount;r++){
				getItemDisplay = isDisplayedTrue(By.id("resetErrors"));
				logger.info("Waiting for display element:["+getItemDisplay+"]");
				if (getItemDisplay == true){
					getPassResetMsg = getText(By.id("resetErrors")).replaceAll("\\n", "");
					if (getPassResetMsg.contains("NEW PASSWORD and OLD PASSWORD must not be the same")){
					logger.info("System identified expected error message \"NEW PASSWORD and OLD PASSWORD must not be the same\"");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Verification", "verify_password_reset_unsuccessful", "User: ["+getUserNameVal+"] unable to reset password with the same existing password. verification successful", "Pass");
					stepCount++;
					break;
					}
				}
			}
			getItemDisplay = isDisplayedTrue(By.id("resetErrors"));
			if (getItemDisplay == true){
				getPassResetMsg = getText(By.id("resetErrors")).replaceAll("\\n", "");
				if (getPassResetMsg.equals("Password successfully changed")){
					logger.error("Password Reset Verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset Verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Verification", "verify_password_reset_unsuccessful", "User: ["+getUserNameVal+"] able to reset password with the same existing password. verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getItemDisplay == false){
					logger.error("Password Reset Verification Failed");
					TestExecutionException e = new TestExecutionException("Password Reset Verification Failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Verification", "verify_password_reset_unsuccessful", "User: ["+getUserNameVal+"] able to reset password with the same existing password. verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
			}
		}
		/*
		 *  
		 */
		public void verify_password_reset_successful(String getUserNameVal) throws TestExecutionException {
			int loadCount = 1000;
			boolean getItemDisplay = false;
			String getPassResetMsg = null;
			for (int r=2;r<loadCount;r++){
				getItemDisplay = isDisplayedTrue(By.cssSelector(".ng-pristine.ng-valid.ng-binding"));
				logger.info("Waiting for display element:["+getItemDisplay+"]");
				if (getItemDisplay == true){
					getPassResetMsg = getText(By.cssSelector(".ng-pristine.ng-valid.ng-binding")).replaceAll("\\n", "");
					if (getPassResetMsg.equals("Password successfully changed")){
					logger.info("Successfully password changed");
					oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Verification", "verify_password_reset_successful", "Password reset Verification Successfully for ["+getUserNameVal+"] user", "Pass");
					stepCount++;
					break;
					}
				}
			}
			if (getItemDisplay == false){
				logger.error("Password Reset Verification Failed");
				TestExecutionException e = new TestExecutionException("Password Reset Verification Failed");
				oPDF.enterBlockSteps(bTable, stepCount, "Password Reset Verification", "verify_password_reset_successful", "Password Reset Verification failed for ["+getUserNameVal+"]", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public String readDoc() {
		    String textCred = "";
		    String f = "C://My_Frameworks_creds//UserCred//Applications//ICRP//uCred.txt";
		    int read, N = 1024 * 1024;
		    char[] buffer = new char[N];
		    try {
		        FileReader fr = new FileReader(f);
		        BufferedReader br = new BufferedReader(fr);
		        while(true) {
		            read = br.read(buffer, 0, N);
		            textCred += new String(buffer, 0, read);
		            if(read < N) {
		                break;
		            }
		        }
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		   return textCred;
		}
		
		public void login(String uname, String pword, String expRes) throws TestExecutionException {
			
			click(By.cssSelector("#block-anonymoususermenu > div:nth-child(1) > div:nth-child(2) > div:nth-child(2) > a:nth-child(1)"));
			wait_For(2000);
			enter(By.name("name"),uname);
			enter(By.name("pass"),pword);
			wait_For(1000);
			click(By.cssSelector("#edit-submit"));
			wait_For(5000);
		}
		
	public void form_fill_org_info(String Organizations_Address1,String Organizations_Address2,String City, String Zip_Postal_Code, String Description_of_Org, String Brief_Derscription_of_Research, String Year_when_initiated_research) throws TestExecutionException {
			
			//enter(By.name("organization_name"),Organizations_Name);
			enter(By.name("organization_address_1"),Organizations_Address1);
			enter(By.name("organization_address_2"),Organizations_Address2);
			enter(By.name("city"),City);
			enter(By.name("zip_postal_code"),Zip_Postal_Code);
			enter(By.name("description_of_the_organization"),Description_of_Org);
			enter(By.name("brief_description_of_research"),Brief_Derscription_of_Research);
			enter(By.name("year_initiated"),Year_when_initiated_research);
			wait_For(5000);
		}
		
	public void form_fill_random_organization_name() throws TestExecutionException {
		
		
		final String randomOrganization = "Organization #"+ new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new Date());
		WebElement organization = selenium.findElement(By.id("edit-organization-name"));
		organization.sendKeys(randomOrganization);
		wait_For(3000);
		String randomEmailEntered = getText(By.cssSelector("#edit-organization-name"));
		
	}
	
	public void form_fill_contact_person_info(String Contact_Address1,String Contact_Address2,String Contact_City_Town,String Contact_ZipCode) throws TestExecutionException {
		
		click(By.cssSelector("#edit-contact-person-s-information > div.panel-heading > a"));
		enter(By.name("contact_person[address]"),Contact_Address1);
		enter(By.name("contact_person[address_2]"),Contact_Address2);
		enter(By.name("contact_person[city]"),Contact_City_Town);
		enter(By.name("contact_person[postal_code]"),Contact_ZipCode);
		wait_For(2000);
	}
	
	
	public void form_fill_add_partner_info (String Sponsor_Code,String Website,String Map_Coordinates,String Longitude, String Note) throws TestExecutionException {
		
		//enter(By.id("partner-sponsor-code"),Sponsor_Code);
		//enter(By.id("partner-website"),Website);  
		enter(By.cssSelector("div.margin-bottom:nth-child(6) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > div:nth-child(1) > div:nth-child(1) > input:nth-child(1)"),Map_Coordinates);
		enter(By.cssSelector("div.form-group-sm:nth-child(2) > div:nth-child(1) > input:nth-child(1)"),Longitude);
		enter(By.id("partner-note"),Note);
		wait_For(2000);
	}
	
	public void form_fill_sponsor_code (String Sponsor_Code) throws TestExecutionException {
		
		enter(By.id("partner-sponsor-code"),Sponsor_Code);
		
		wait_For(2000);
		}
	
	
	public void form_fill_Ex_Dir_Pres_Chair(String Name,String Position,String Telephone_Number,String Email, String Confirm_Email) throws TestExecutionException {
		
		enter(By.name("name"),Name);
		enter(By.name("position"),Position);
		enter(By.name("telephone_number"),Telephone_Number);
		enter(By.name("email[mail_1]"),Email);
		enter(By.name("email[mail_2]"),Confirm_Email);
		wait_For(5000);
	}
		
	public void form_fill_user_registration(String First_Name,String Last_Name,String Organization) throws TestExecutionException {
		
		enter(By.name("field_first_name[0][value]"),First_Name);
		enter(By.name("field_last_name[0][value]"),Last_Name);
		enter(By.name("field_organization[0][target_id]"),Organization);
		wait_For(5000);
	}
	
	public void enter_random_user_email() throws TestExecutionException {
		//final String randomEmail =  randomEmail();
		
		final String randomEmail = "icrptester+" + new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new Date()) + "@gmail.com";
		WebElement email = selenium.findElement(By.id("edit-mail"));
		email.sendKeys(randomEmail);
		wait_For(3000);
		String randomEmailEntered = getText(By.cssSelector("#edit-mail"));
	}
	
	public void checkExportErrorRecordsButton() throws TestExecutionException {
		WebElement button = selenium.findElement(By.cssSelector("#uncontrolled-tabs-pane-2 > div > div:nth-child(2) > div:nth-child(4) > button"));
				if (button.isEnabled())
				{
				    button.click();
				}
				else{
					System.out.println("Export Error Record Button Is Disabled");
				}
		
	}
	
	
	
	
	public void enter_current_calendar_date() throws TestExecutionException {
		
		final String currentCalDate = new SimpleDateFormat("MM/dd/yyyy").format(new Date());
		WebElement calDate = selenium.findElement(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div > div > form > div.col-lg-4.col-xs-12 > div:nth-child(1) > div > div > input"));
		calDate.sendKeys(currentCalDate);
		wait_For(3000);
		String currCalDateEntered = getText(By.cssSelector("#uncontrolled-tabs-pane-1 > div > div:nth-child(1) > div > div > form > div.col-lg-4.col-xs-12 > div:nth-child(1) > div > div > input"));
		
		
	}
	
	
	
		//private static String randomEmail() {
		 //  return SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new Date());
	       //return "ICRPUser-" + UUID.randomUUID().toString() + "google.com";
	//    }
	
	public void enter_random_sponsor_code() throws TestExecutionException {
		//final String randomEmail =  randomEmail();
		
		final String randomSponsorCode = "9999" + new SimpleDateFormat("dd.HH.mm.ss").format(new Date());
		WebElement sponsorcode = selenium.findElement(By.id("partner-sponsor-code"));
		sponsorcode.sendKeys(randomSponsorCode);
		wait_For(3000);
		logger.info("Sponsor Code Entered");
		String randomSponsorCodeEntered = getText(By.cssSelector("#partner-sponsor-code"));
		
		
	}
		//private static String randomEmail() {
		 //  return SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new Date());
	       //return "ICRPUser-" + UUID.randomUUID().toString() + "google.com";
	//    }
	
	
	
	
	
	
		public void form_fill_add_new_thread(String Subject) throws TestExecutionException {
			
			enter(By.name("title[0][value]"),Subject);
		    
			wait_For(5000);
		}
		
		public void form_fill_add_new_thread_summary(String Summary) throws TestExecutionException {
			
			enter(By.name("body[0][summary]"),Summary);
		    
			wait_For(5000);
		}
		
		
		public void form_fill_insert_image_alternative_text(String alternative_text) throws TestExecutionException {
			
			enter(By.name("attributes[alt]"),alternative_text);
		    
			wait_For(5000);
		}
		
		public void form_fill_insert_links_url(String url) throws TestExecutionException {
			
			enter(By.name("attributes[href]"),url);
		    
			wait_For(5000);
		}
		
		
		
		public void verify_email_address_of_registered_user() throws TestExecutionException {
			
			String RegisteredUserEmail = getText(By.cssSelector("td.views-field:nth-child(2)"));
			
			if("RegisteredUserEmail".equals("randomEmailEntered"))
			   {
			      System.out.println("Email is correct");
			   }
			 else
			  {
			      System.out.println("Incorrect email");
			  }
		}
	
	public void verify_user_info_when_clicking_review_button() throws TestExecutionException {
			
			String UserName1 = getText(By.cssSelector("tbody > tr:nth-child(1) > td.views-field.views-field-field-last-name.is-active.views-field-field-first-name"));
			String UserEmail1 = getText(By.cssSelector("tbody > tr:nth-child(1) > td.views-field.views-field-mail"));
			String UserOrganization1 =getText(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(3)"));
			
			click(By.cssSelector(".table > tbody:nth-child(2) > tr:nth-child(1) > td:nth-child(5) > a:nth-child(1)"));
			wait_For(3000);
			wait_until_element_present(By.cssSelector("#user-review-form > h1"),"User Review");
			
			String FirstName = getAttribute(By.id("edit-first-name"),"value");
			String LastName = getAttribute(By.id("edit-last-name"),"value");
			String Organization = getAttribute(By.id("edit-organization"),"value");
			String Email = getAttribute(By.id("edit-email"),"value");
			
			if("UserName1".contains("FirstName"))
			   {
			      System.out.println("First Name is correct");
			   }
			 else
			  {
			      System.out.println("User Info does not match with what is listed on the User Administration Tool page.");
			  }
			
			/*if("UserName1".contains("LastName"))
			   {
			      System.out.println("Last Name is correct");
			   }
			 else
			  {
			      System.out.println("User Info does not match with what is listed on the User Administration Tool page.");
			  }
			
			if("UserEmail1".equals("Email"))
			   {
			      System.out.println("Email is correct");
			   }
			 else
			  {
			      System.out.println("User Info does not match with what is listed on the User Administration Tool page.");
			  }
			
			if("UserOrganization1"=="Organization")
			   {
			      System.out.println("Organization is correct");
			   }
			 else
			  {
			      System.out.println("User Info does not match with what is listed on the User Administration Tool page.");
			  }*/
		}
	
	public void verify_Partner_added_to_List() throws TestExecutionException {
			
		String PartnerOrganization = new Select(selenium.findElement(By.id("select-partner"))).getFirstSelectedOption().getText();
		
	    //String PartnerOrganization = getAttribute(By.id("select-partner"),"value");
		
		//String partnerOrganization = selenium.findElement(By.id("select-partner")).getAllSelectedOptions().get(0).getText();

		System.out.println(PartnerOrganization);
		  
		clickLink(By.xpath("//button[contains(text(),'Save')]"));
		wait_For(4000);
		
		wait_until_element_present(By.cssSelector("#add-partner > div > div > div.container > div:nth-child(1) > div"),"This partner has been successfully saved. You can go to Current Partners to view a list of current ICRP partners.");
			  	
		click(By.cssSelector("#manager-navbar-collapse > ul:nth-child(1) > li:nth-child(3) > a"));
		wait_For(3000);
		click(By.linkText("Current Partners"));
		wait_For(3000);
		click(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > div > ul.nav.nav-tabs > li:nth-child(2) > a")); //Click List Partners
		wait_For(3000);
		
		if(selenium.getPageSource().contains(PartnerOrganization)){
			
			System.out.println("Partner Is Listed");
		}else{
			System.out.println("Partner Not Listed");
		}
		}
	
	public void testClickSaveButton() throws TestExecutionException {
				
		selenium.manage().window().maximize() ;
		
		WebElement element = selenium.findElement(By.xpath("//button[contains(text(),'Save')]"));
		((JavascriptExecutor) selenium).executeScript("arguments[0].scrollIntoView(true);", element);
		try {
			implicitwait(20);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		selenium.findElement(By.xpath("//button[contains(text(),'Save')]")).click();
		
		//check_page_source_code("This partner has been successfully saved. You can go to Current Partners to view a list of current ICRP partners.","This partner has been successfully saved. You can go to Current Partners to view a list of current ICRP partners.");

	
	}
	
	
	public void verify_upload_files_checkbox_is_checked() throws TestExecutionException {
	
		boolean enabled = selenium.findElement(By.name("upload_files")).isEnabled();

		if(enabled)

		{
			System.out.println("Already checked");
		}
		else

		{
			logger.error("Box is not Checked and should be.");
		}
	
	}
	
	public void verify_Blocked_checkbox_is_not_checked() throws TestExecutionException {
		
		boolean enabled = selenium.findElement(By.cssSelector("#edit-status-0")).isEnabled();

	    if(!enabled)

	    {
	    	logger.error("Box is Checked and should NOT be.");
	    }
	    else

	    {
	    	System.out.println("Box verified to be Not checked");
	    }
		
		}
		
	
	public void verify_Active_checkbox_is_not_checked() throws TestExecutionException {
		
		boolean enabled = selenium.findElement(By.cssSelector("#edit-status-1")).isEnabled();

	    if(!enabled)

	    {
	    	logger.error("Box is Checked and should NOT be.");
	    }
	    else

	    {
	    	System.out.println("Box verified to be Not checked");
	    }
		
		}

	public void verify_Manager_checkbox_is_not_checked() throws TestExecutionException {
		
		boolean enabled = selenium.findElement(By.cssSelector("#edit-roles-manager")).isEnabled();

	    if(!enabled)

	    {
	    	logger.error("Box is Checked and should NOT be.");
	    }
	    else

	    {
	    	System.out.println("Box verified to be Not checked");
	    }
		
		}
	
	public void verify_Partner_checkbox_is_not_checked() throws TestExecutionException {
		
		boolean enabled = selenium.findElement(By.cssSelector("#edit-roles-partner")).isEnabled();

	    if(!enabled)

	    {
	    	logger.error("Box is Checked and should NOT be.");
	    }
	    else

	    {
	    	System.out.println("Box verified to be Not checked");
	    }
		
		}
	
	
	
	
	public void edit_library_file_required_fields(String File,String FileTitle,String Description) throws TestExecutionException {
		
		enter(By.name("display_name"),File);
		wait_For(2000);
		enter(By.cssSelector("html.js body.user-logged-in.path-library.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div#library.tab-content.admin div#library-edit.tab-pane.active form div#library-parameters div.folder input"),FileTitle);
		wait_For(2000);
		enter(By.name("description"),Description);
		wait_For(5000);
	}
	
	
    public void form_fill_research_investment_budget_info(String current_annual,String reporting_period,String approx_number_of_project, String Current_annual_operating_budget) throws TestExecutionException {
		
    	click(By.cssSelector("#edit-research-investment-budget-information > div.panel-heading > a"));
    	enter(By.name("current_annual_research_investment_budget"),current_annual);
		enter(By.name("reporting_period"),reporting_period);
		enter(By.name("number_of_projects_funded_per_annum"),approx_number_of_project);
		enter(By.name("current_annual_operating_budget"),Current_annual_operating_budget);
		wait_For(5000);
	}
    
    public void form_fill_create_library_file(String title,String description) throws TestExecutionException {
		
    	enter(By.cssSelector("div.folder:nth-child(6) > input:nth-child(2)"),title);
    	wait_For(2000);
		enter(By.name("description"),description);
		wait_For(2000);
	}
	
    public void enter_country(String option) throws TestExecutionException {
		
		//enter(By.cssSelector("body > div.main-container.container.js-quickedit-main-content > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel.ng-tns-c9-2 > div.ui-panel-content.ng-trigger.ng-trigger-visibilityChanged > ui-select:nth-child(12) > div > div.select-input-container.default > div > input"),option);
    	enter(By.cssSelector("html.js body.user-logged-in.path-db-search.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content icrp-root div icrp-search-page div.row div.col-sm-3 icrp-search-form form.ng-untouched.ng-valid.ng-dirty ui-panel.ng-tns-c9-2 div.ui-panel-content.ng-trigger.ng-trigger-visibilityChanged ui-select.ng-untouched.ng-valid.ng-dirty div.select-container.default div.select-input-container.default div input.select-input.default"),option);
	}
	
    public void enter_award_code(String option) throws TestExecutionException {
		
		enter(By.id("award_code"),option);	
	}
	
    public void enter_funding_year_begin(String option) throws TestExecutionException {
		
		enter(By.cssSelector("#fundingYear"),option);	
	}
	
    public void enter_funding_year_end(String option) throws TestExecutionException {
		
		enter(By.cssSelector("#uncontrolled-tabs-pane-3 > div > div > div:nth-child(1) > div.panel.panel-default.category-panel.form-group > div:nth-child(2) > div:nth-child(1) > div:nth-child(2) > input:nth-child(3)"),option);	
	}
	
    public void enter_import_notes() throws TestExecutionException {
		
		final String enterImportNotes = "This import was processed by the test automation on " + new SimpleDateFormat("MM/dd/yyyy").format(new Date());
		WebElement notes = selenium.findElement(By.id("importNotes"));
		notes.sendKeys(enterImportNotes);
		wait_For(3000);
		String importNotesEntered = getText(By.cssSelector("#importNotes"));
		
	}
    

    
	/*	
		public void login(String uname, String pword, String expRes) throws TestExecutionException {
			boolean retVal;
			
			String valSplt = readDoc();
           	String[] parts = valSplt.split(",");
            String part1 = parts[0];
            String part2 = parts[1];
            String part3 = parts[2];
            String part4 = parts[3];
          
            try {
				_wait(100);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			if (uname == "curatorUserName" && pword == "curatorPassword"){
				uname = null;
            	pword = null;
				uname = part1;
            	pword = part2;
            } else if (uname == "researcherUserName" && pword == "researcherPassword"){
				uname = null;
				pword = null;
				uname = part3;
            	pword = part4;
			} else {
				//Do nothing
				//logger.error("Please ensure a valid sets Credential in the User Credential notepad file");
			}
            
			
			try {
				_wait(100);
			} catch (Exception e3) {
				// TODO Auto-generated catch block
				e3.printStackTrace();
			}
			if (uname == "curatorUserName" && pword == "invalidpwd"){
				uname = null;
				uname = part1;
			} else if (uname == "researcherUserName" && pword == "invalidpwd"){
				uname = null;
				uname = part3;
			} else {
				//Do nothing
				//logger.error("Please ensure valid and invalid username or password scenarios");
			}
			
			
			try {
				_wait(100);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			if (pword == "reslcasepass"){
	        	pword = null;
	        	uname = null;
	        	uname = part3;
				String passlower = part4;
				String lcasepass = passlower.toUpperCase();
				logger.info(""+ lcasepass +"");
				pword = lcasepass;
			} else if (pword == "curlcasepass"){
	        	pword = null;
	        	uname = null;
	        	uname = part1;
				String passlower = part2;
				String lcasepass = passlower.toLowerCase();
				logger.info(""+ lcasepass +"");
	        	pword = lcasepass;
			} else if (pword == "invalidpwd"){
	        	pword = null;
	        	pword = "invalidpwd";
			} else if (uname == "invalid"){
				uname = null;
				uname = "invalid";
			} else {
				//Do nothing
				//logger.error("Please ensure valid and invalid username or password scenarios");
			}
			
	
			enter(By.name("loginId"),uname);
			enter(By.name("password"),pword);
			click(By.cssSelector(".loginBlock>tbody>tr>td>input[type=\"submit\"]"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector("#maincontent > table > tbody > tr:nth-child(1) > td > table > tbody > tr > th:nth-child(8) > a"));
				logger.info("Login successful condition is: ["+ getUIVal +"]");
				if (getUIVal == true){
					break;
				}
			}
			wait_until_element_present(By.cssSelector("#maincontent > table > tbody > tr:nth-child(1) > td > table > tbody > tr > th:nth-child(8) > a"), "SAMPLES");
			captureScreenshot(dir+"/snapshots/HomePageAfterLogin.png");
			if (expRes.equals("pass")){
				retVal = isTextPresent("Logged in as " + uname.toLowerCase());
				if (retVal == true){ 
					//verifyLogin(By.cssSelector(".subMenuPrimaryTitle"));
					verifyLogin(By.linkText("HOME"));
					//verifyLogin(By.linkText("WORKFLOW"));
					//verifyLogin(By.linkText("PROTOCOLS"));
					//verifyLogin(By.linkText("SAMPLES"));
					//verifyLogin(By.linkText("PUBLICATIONS"));
					//verifyLogin(By.linkText("GROUPS"));
					//verifyLogin(By.linkText("CURATION"));
					//verifyLogin(By.linkText("MY WORKSPACE"));
					//verifyLogin(By.linkText("MY FAVORITES"));
					//verifyLogin(By.linkText("LOGOUT"));
					oPDF.enterBlockSteps(bTable,stepCount,"Login to the caNanoLab site","login","Successfully logged-in to caNanoLab","Pass");
					stepCount++;
				}else{	
					logger.error("Error loggin into the Web site.");
					TestExecutionException e = new TestExecutionException("Error logging into the Web site.");
					oPDF.enterBlockSteps(bTable,stepCount,"Login to the caNanoLab site","login","Login failed.","Fail", "HomePageAfterLogin.png");
					stepCount++;
					setupAfterSuite();
					Assert.fail(e.getMessage());

				}
			}else if (expRes.equals("fail")){
				retVal = isTextPresent("Bad credentials");
				if (retVal == true){ 
					oPDF.enterBlockSteps(bTable,stepCount,"Verification of invalid login","login","Successfully verified invalid login","Pass");
					stepCount++;
				}else {
					TestExecutionException e = new TestExecutionException("Verification of invalid login failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Verification of invalid login","login","Invalid Login verification failed.","Fail", "HomePageAfterLogin.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
									
				}
			}
		}
		
		*/
		/*
		 * This method verify the search result
		 */
		public void expected_vs_actual_verification (String gExpectedVal) throws TestExecutionException {
			boolean retVal1 = isTextPresent(gExpectedVal);
			if (retVal1 == true){
				logger.info("Expected:["+ gExpectedVal +"] and Actual: ["+ gExpectedVal +" return value is " + retVal1 +"] verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Fields verification","expected_vs_actual_verification","Expected:["+ gExpectedVal +"] and Actual: ["+ retVal1 +"] verification successful","Pass");
				stepCount++;	
			}else {
				captureScreenshot(dir+"/snapshots/"+ gExpectedVal+".png");
				logger.error("Expected:["+ gExpectedVal +"] and Actual: ["+gExpectedVal +" return value is " + retVal1 +"] verification");
				TestExecutionException e = new TestExecutionException("Search result verifications failed. System unable to display : '"+ gExpectedVal +"' search results");
				oPDF.enterBlockSteps(bTable,stepCount,"Searcg Result Verification","search_result_verification", "Expected:["+ gExpectedVal +"] and Actual: ["+ retVal1 +"] verification Failed","Fail", gExpectedVal+".png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());							
			}			
		}
		/*
		 * This function looks for a specific LINK on the  page 
		 */
		public void verifyLogin(By by) throws TestExecutionException{
			boolean retVal1 = isDisplayed(by);
			boolean retVal2 = isEnabled(by);
			if (retVal1 == true && retVal2 == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of login page","verifyLogin","Verification successful for "+ by,"Pass");
				stepCount++;				
			}else {
				logger.error("Login page verification failed");
				TestExecutionException e = new TestExecutionException("Verification of login page failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of login page","verifyLogin","Verification failed for " + by,"Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}
		}
		
		/*
		 * This function verifies the home page sidebar content
		 */
		public void verifySideBarContent(By by,String expectedText, String page) throws TestExecutionException{
			captureScreenshot(dir+"/snapshots/"+page+".png");
			String ActualText = getText(by).replaceAll("(\\r|\\n)", "");
			boolean retVal = verifyText(ActualText, expectedText);
			if (retVal == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of sidebar content text","verifySideBarContent","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification of sidebar content failed");
				TestExecutionException e = new TestExecutionException("Verification of sidebar content text failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of sidebar content text","verifySideBarContent","Verification failed. Actual text: "+ ActualText + "\r Expected text: "+ expectedText,"Fail", page+".png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}
		}
		/*
		 * This method verifies the Actual text with Expected text content from ID
		 */		
		public void actual_with_expected_id_text_verification(String expectedText, String gElement) throws TestExecutionException {
			captureScreenshot(dir+"/snapshots/idSanpshot.png");
			String actualVal = getText(By.id(gElement));
			logger.info("Identified Actual value:["+ actualVal +"] from home page");
			boolean retVal = verifyText(getText(By.id(gElement)), expectedText);
			if (retVal == true){
				logger.info("Verification successful for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				oPDF.enterBlockSteps(bTable,stepCount,"ID Text Verification","actual_with_expected_id_text_verification","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification Failed for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				TestExecutionException e = new TestExecutionException("Verification of Welcome content text failed");
				oPDF.enterBlockSteps(bTable,stepCount,"ID Text Verification","actual_with_expected_id_text_verification","Verification failed","Fail", "idSanpshot.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}
		}
		
		/*
		 * This method verifies the Actual text with Expected text content from ID
		 */		
		public void actual_with_expected_cssSelector_text_verification(String expectedText, String gElement) throws TestExecutionException {
			captureScreenshot(dir+"/snapshots/idSanpshot.png");
			String actualVal = getText(By.cssSelector(gElement));
			logger.info("Identified Actual value:["+ actualVal +"] from home page");
			boolean retVal = verifyText(getText(By.cssSelector(gElement)), expectedText);
			if (retVal == true){
				logger.info("Verification successful for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				oPDF.enterBlockSteps(bTable,stepCount,"ID Text Verification","actual_with_expected_id_text_verification","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification Failed for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				TestExecutionException e = new TestExecutionException("Verification of Welcome content text failed");
				oPDF.enterBlockSteps(bTable,stepCount,"ID Text Verification","actual_with_expected_id_text_verification","Verification failed","Fail", "idSanpshot.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}
		}
		
		
		
		
		/*
		 * This method verifies the Actual text with Expected text content from XPath
		 */		
		public void actual_with_expected_xpath_text_verification(String expectedText, String gElement) throws TestExecutionException {
			captureScreenshot(dir+"/snapshots/xpathTextSanapshot.png");
			String actualVal = getText(By.xpath(gElement)).replaceAll("(\\n)", "");
			logger.info("Identified Actual value:["+ actualVal +"] from home page");
			boolean retVal = verifyText(getText(By.xpath(gElement)).replaceAll("(\\n)", ""), expectedText);
			if (retVal == true){
				logger.info("Verification successful for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				oPDF.enterBlockSteps(bTable,stepCount,"XPath Text Verification","actual_with_expected_xpath_text_verification","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification Failed for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				TestExecutionException e = new TestExecutionException("Verification of Welcome content text failed");
				oPDF.enterBlockSteps(bTable,stepCount,"XPath Text Verification","actual_with_expected_xpath_text_verification","Verification failed","Fail", "xpathTextSanapshot.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}
		}
		/*
		 * This method verifies the Actual text with Expected text content from CSS
		 */		
		public void actual_with_expected_css_text_verification(String expectedText, String gElement) throws TestExecutionException {
			captureScreenshot(dir+"/snapshots/cssSnapshot.png");
			String actualVal = getText(By.cssSelector(gElement));
			logger.info("Identified Actual value:["+ actualVal +"] from home page");
			boolean retVal = verifyText(getText(By.cssSelector(gElement)), expectedText);
			if (retVal == true){
				logger.info("Verification successful for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				oPDF.enterBlockSteps(bTable,stepCount,"CSS Text Verification","actual_with_expected_css_text_verification","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification Failed for Expected value:["+ expectedText +"] with Actual value: ["+ actualVal +"] in ["+ gElement +"]");
				TestExecutionException e = new TestExecutionException("Verification of Welcome content text failed");
				oPDF.enterBlockSteps(bTable,stepCount,"CSS Text Verification","actual_with_expected_css_text_verification","Verification failed","Fail", "cssSnapshot.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}
		}
		/*
		 * This method verifies the home/login page Welcome content
		 */		
		public void verifyWelcomeContent(String expectedText, String page) throws TestExecutionException {
			captureScreenshot(dir+"/snapshots/"+page+".png");
			String actualVal = getText(By.cssSelector("div.welcomeContent"));
			logger.info("Identified Actual value:["+ actualVal +"] from home page");
			boolean retVal = verifyText(getText(By.cssSelector("div.welcomeContent")), expectedText);
			if (retVal == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Welcome content text","verifyWelcomeContent","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification of welcome content failed");
				TestExecutionException e = new TestExecutionException("Verification of Welcome content text failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Welcome content text","verifyWelcomeContent","Verification failed","Fail", page+".png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}
		}
		/*
		 * This method logout from 
		 */
		public void logout () throws TestExecutionException {
			click(By.linkText("Log out"));
			try {
				_wait(1000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			captureScreenshot(dir+"/snapshots/home.png");
			String text = getText(By.xpath("/html/body/header/div[2]/div/section/div/div[2]/div[2]/a"));
			
			boolean retVal = verifyText(text,"log in");
			if (retVal == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of LOGOUT","logout","Verification successful","Pass");
				stepCount++;				
			}else {
				logger.error("Verification of logout failed");
				TestExecutionException e = new TestExecutionException("Verification of LOGOUT failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of LOGOUT","logout","Verification failed","Fail", "home.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}			
		}
		/*
		 * 
		 */
		public void chooseLoginOptions (String option) throws TestExecutionException {
			select("name", "userActions",option);
			click(By.cssSelector(".sidebarSectionNoTop tbody tr:nth-child(3) .sidebarContent .btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseLoginOptions","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chooseSampleOptions (String option) throws TestExecutionException {
			select("id", "nameOperand",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseSampleOptions","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chooseCompNanoEntityOptions (String option) throws TestExecutionException {
			select("id", "nanomaterialEntityTypes",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseCompNanoEntityOptions","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chooseCompFuncEntityOptions (String option) throws TestExecutionException {
			select("id", "functionalizingEntityTypes",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseCompFuncEntityOptions","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chooseFunctionOptions (String option) throws TestExecutionException {
			select("id", "functionTypes",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseCompFuncEntityOptions","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseSamplesForPublicationOption (String option) throws TestExecutionException {
			select("id", "matchedSampleSelect",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseSamplesForPublicationOption","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseAccessUserName (String option) throws TestExecutionException {
			select("id", "matchedUserNameSelect",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseAccessUserName","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseAccessPublication (String option) throws TestExecutionException {
			select("id", "roleName",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseAccessPublication","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chooseSampleOrganizationName (String option) throws TestExecutionException {
			select("cssSelector", "select.ng-pristine.ng-valid", option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseSampleOrganizationName","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chooseSampleRole (String option) throws TestExecutionException {
			select("cssSelector", "#role > select.ng-pristine.ng-valid", option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chooseSampleRole","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void keyPressEnter () throws TestExecutionException {
			try {
	            Robot robot = new Robot();
	            robot.delay(5000);
	            robot.keyPress(KeyEvent.VK_ENTER);
	            robot.delay(200);
	        } catch (AWTException e) {
	            e.printStackTrace();
	        }
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","keyPressEnter","Action Enter selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void addSampleKeyword (String option) throws TestExecutionException {
	    enter(By.id("newKeyword"), option);
	    click(By.xpath("//button[@type='button']"));
	    logger.info("Keyword: " + option + " has been added to the sample");
		    try {
				_wait(30);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.info("Unable to add Keyword to the Sample");
				e.printStackTrace();
			}
		}
		/*
		 * 
		 */
		public void choseNanomaterialEntity (String option) throws TestExecutionException {
			select("id", "type",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseNanomaterialEntity","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseBiopolymerType (String option) throws TestExecutionException {
			select("id", "biopolymerType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseBiopolymerType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseComposingElementType (String option) throws TestExecutionException {
			select("id", "elementType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseComposingElementType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		public void chosePubChemDataSource (String option) throws TestExecutionException {
			select("id", "pubChemDataSource",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chosePubChemDataSource","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseAmountUnit (String option) throws TestExecutionException {
			select("id", "elementValueUnit",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseAmountUnit","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseMolecularFormulaType (String option) throws TestExecutionException {
			select("id", "molFormulaType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseMolecularFormulaType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseElementFunctionType (String option) throws TestExecutionException {
			select("id", "functionType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseElementFunctionType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseProtocolType (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "type",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseProtocolType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseProtocolName (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "nameOperand",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseProtocolName","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseProtocolAbbreviation (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "abbreviationOperand",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseProtocolAbbreviation","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseProtocolFileTitle (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "titleOperand",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseProtocolFileTitle","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseImagingModalityType (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "imagingModality",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseImagingModalityType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseFileTypeForSample (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "fileType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFileTypeForSample","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void chosePrimaryOrganization (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "otherSamples",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFileTypeForSample","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseFunctionalizingEntityType (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "type",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFunctionalizingEntityType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseFunctionalizingPubChemDataSource (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "pubChemDataSource",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","chosePubChemDataSource","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseFunctionalizingAmountUnit (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "feUnit",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFunctionalizingAmountUnit","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseFunctionalizingMolecularFormulaType (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "mfType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFunctionalizingMoleqularFormulaType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choseFunctionalizingActivationMethod (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "feaMethod",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFunctionalizingActivationMethod","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void verifyFileds (String option) throws TestExecutionException {
			String checkFileds1 = option;
		    boolean retVal1 = isTextPresent(checkFileds1);
		    captureScreenshot(dir+"/snapshots/objectFields.png"); 
			if (retVal1 == true){
				logger.info("System verified [ " + checkFileds1 +  " ] fields in the application screen");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification","Fields Presents","Fields: [''"+ option + "''] verification is passed","Pass", "objectFields.png");
				stepCount++;
			} else {
				logger.error("System unable to verify [ " + checkFileds1 +  " ] fields in the application screen");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification","Fields Presents","Fields: [''"+ option + "''] verification is failed","Fail", "objectFields.png");
				stepCount++;
				TestExecutionException e = new TestExecutionException("Verification failed [ " + checkFileds1 +  " ]");
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void choseFunctionalizingFunctionType (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "functionType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFunctionalizingActivationMethod","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 		
		 */
		public void choseFunctionalizingFileType (String option) throws TestExecutionException {
			wait_For(2000);
			select("id", "fileType",option);
			logger.info("Dropdown value: ["+ option +"] selected");
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","choseFunctionalizingFileType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void accessToThe(String accessUsrID, String accessUsrInfo) throws TestExecutionException {
			click(By.id("addAccess"));
			click(By.id("byUser"));
			click(By.id("browseIcon2"));
			wait_For(1000);
			choseAccessUserName(accessUsrID);
			wait_For(2000);
			choseAccessPublication("read update delete");
			String curaAccess = accessUsrInfo;
			if (curaAccess == "canano_res") {
				click(By.cssSelector("input[type=\"button\"]"));
			} else {
				click(By.cssSelector("div > input[type=\"button\"]"));
			}
			wait_For(7000);
			logger.info("User: "+ accessUsrID + " has been added to the access control");
		}
		/*
		 * Navigate to sample search page from Manage Samples page
		 */
		public void navigate_to_sample_search_page() throws TestExecutionException {
			click(By.linkText("SAMPLES"));
			wait_For(3000);
			click(By.linkText("Search Existing Samples"));
		}
		/*
		 * Navigate to protocol search page from Manage Protocol page
		 */
		public void navigate_to_protocol_search_page() throws TestExecutionException {
			click(By.linkText("PROTOCOLS"));
			logger.info("Manage Protocol page");
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "Manage Protocols");
			click(By.linkText("Search Existing Protocols"));
			logger.info("Clicking Search Existing Protocols link");
		}
		/*
		 * Navigate to publication search page from Manage publication page
		 */
		public void navigate_to_publication_search_page() throws TestExecutionException {
			click(By.linkText("PUBLICATIONS"));
			logger.info("Manage Publication page");
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "Manage Publications");
			click(By.linkText("Search Existing Publications"));
			logger.info("Clicking Search Existing Publications link");
		}
		/*
		 * 
		 */
		public void navigate_to_public_sample_search_results_from_browseCananoLabSection() throws TestExecutionException {
			String linktxt = getText(By.cssSelector(".gridtableHomePage tbody tr:nth-child(3) td:nth-child(2) div span a"));
			click(By.cssSelector(".gridtableHomePage tbody tr:nth-child(3) td:nth-child(2) div span a"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search Results");
			}catch (Exception e){	
			}
			oPDF.enterBlockSteps(bTable,stepCount,"search all publically available samples","navigate_to_public_sample_search_results_from_browseCananoLabSection","Link "+ linktxt + " clicked","Pass");
			stepCount++;
		}
		/*
		 * 
		 */
		public void navigate_to_sample_search_from_Home_page() throws TestExecutionException {
			//click(By.xpath("//table/tbody/tr[3]/td[1]/table/tbody/tr[1]/td[2]/a"));
			click(By.cssSelector("html body.ng-scope div.container table tbody tr td#maincontent.mainContent table tbody tr td.mainContent.ng-scope div.ng-scope table tbody tr td.mainContentHomePage table.gridtableHomePage tbody tr.alt td table.gridtableNoBorder tbody tr td a"));
			wait_For(4000);
		}
		/*
		 * 
		 */
		public void navigate_to_submit_a_new_sample_page() throws TestExecutionException {
			click(By.linkText("SAMPLES"));
			logger.info("Manage Samples page");
			wait_until_element_present(By.cssSelector("html body.ng-scope div.container table tbody tr td#maincontent.mainContent table tbody tr td.mainContent.ng-scope div.spacer.ng-scope table.contentTitle tbody tr th"), "Manage Samples");
			click(By.linkText("Create a New Sample"));
			logger.info("Clicking Submit a New Sample link");
		}
		/*
		 * 
		 */
		public void navigate_to_sample_general_info() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(3) td"));
			wait_until_element_present(By.cssSelector(".cellLabel.ng-binding label"), "Keywords");
			int loadGICount = 1000;
			for (int g=1;g<loadGICount;g++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector(".cellLabel.ng-binding label"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * Composition
		 */
		public void navigate_to_sample_composition() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(4) td"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector(".nanomaterial_entity .summaryViewNoGrid.dataTable.ng-scope tbody tr th a"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * Navigate to composition nanomaterial entity
		 */
		public void navigate_to_sample_composition_nanomaterial_entity() throws TestExecutionException {
			click(By.cssSelector(".nanomaterial_entity .summaryViewNoGrid.dataTable.ng-scope tbody tr th a"));
			element_load(By.id("type"));
			element_load(By.id("otherSamples"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector("ng-include .submissionView.ng-scope:nth-child(1) tbody tr:nth-child(1) td:nth-child(1)"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * Navigate to composition functionalizing entity
		 */
		public void navigate_to_sample_composition_functionalizing_entity() throws TestExecutionException {
			click(By.cssSelector(".functionalizing_entity .summaryViewNoGrid.dataTable.ng-scope tbody tr th a"));
			element_load(By.id("type"));
			element_load(By.id("functionType"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector("ng-include .submissionView.ng-scope:nth-child(1) tbody tr:nth-child(1) td:nth-child(1)"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * Navigate to composition chemical association
		 */
		public void navigate_to_sample_composition_chamical_association() throws TestExecutionException {
			click(By.cssSelector(".chemical_association .summaryViewNoGrid.dataTable.ng-scope tbody tr th a"));
			element_load(By.id("type"));
			element_load(By.id("compositionTypeA"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector("ng-include .submissionView.ng-scope:nth-child(1) tbody tr:nth-child(1) td:nth-child(1)"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * Navigate to composition file
		 */
		public void navigate_to_sample_composition_file() throws TestExecutionException {
			click(By.cssSelector(".composition_file .summaryViewNoGrid.dataTable.ng-scope tbody tr th a"));
			element_load(By.id("fileType"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector(".submissionView tbody tr td div table tbody tr:nth-child(5) td:nth-child(1)"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * Characterization
		 */
		public void navigate_to_sample_characterization() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(5) td"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector(".dataTable.ng-scope:nth-child(4) tbody tr:nth-child(1) td:nth-child(1) div:nth-child(2) button"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * 
		 */
		public void navigate_to_sample_publication() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(6) td"));
			int loadCount = 1000;
			for (int c=1;c<loadCount;c++){
				boolean getUIVal = isDisplayedTrue(By.cssSelector(".dataTable.ng-scope:nth-child(4) tbody tr:nth-child(1) td:nth-child(1) div:nth-child(2) button"));
				if (getUIVal == true){
					break;
				}
			}
		}
		/*
		 * 
		 */
		public void navigate_to_COMPOSITION_page() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(4) td"));
			wait_For(4000);
		}
		/*
		 * 
		 */
		public void navigate_to_CHARACTERIZATION_page() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(5) td"));
			wait_For(4000);
		}
		/*
		 * 
		 */
		public void navigate_to_PUBLICATION_page() throws TestExecutionException {
			click(By.cssSelector(".sideMenu table tbody tr:nth-child(6) td"));
			wait_For(10000);
		}
		/*
		 * 
		 */
		public void navigate_to_copy_an_existing_sample_page() throws TestExecutionException {
			click(By.linkText("SAMPLES"));
			click(By.linkText("Copy an Existing Sample"));
		}
		/*
		 * 		
		 */
		public void navigate_to_myworksapce_page() throws TestExecutionException {
			click(By.linkText("MY WORKSPACE"));
			wait_For(3000);
			String getMyWorkSpace = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getMyWorkSpace.equals("My Workspace")){
				logger.info("My Workspace Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_myworksapce_page","My Workspace Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("My Workspace Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_myworksapce_page","My Workspace Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 		
		 */
		public void wait_until_search_samples_table_data_load() throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Primary Point of Contact");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Composition");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Functions");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Characterizations");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Data Availability");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(8)"), "Created Date");
			int rCount = 10000000;
			long startSampleTableLoadTransaction = System.currentTimeMillis();
			for (int i=1;i<rCount;i++){
				boolean getRmChaVal = isDisplayedTrue(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(1)"));
				if (getRmChaVal==true){
					long endSampleTableLoadTransaction = System.currentTimeMillis();
					long timeToLoadTheSampleTable = TimeUnit.MILLISECONDS.toSeconds(endSampleTableLoadTransaction - startSampleTableLoadTransaction);
					logger.info("Samples table loaded Successfully and Samples search result loading time is:["+ timeToLoadTheSampleTable +"] Seconds");
					oPDF.enterBlockSteps(bTable,stepCount, "Sample Search Results Data Load Verification", "wait_until_search_samples_table_data_load", "Samples table loaded Successfully and Samples search result loading time is:["+ timeToLoadTheSampleTable +"] Seconds", "Pass");
					stepCount++;
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void wait_until_search_protocol_table_data_load() throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Protocol Type");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Protocol Abbreviation");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Version");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Protocol File");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Created Date");
			int rCount = 10000000;
			long startSampleTableLoadTransaction = System.currentTimeMillis();
			for (int i=1;i<rCount;i++){
				boolean getRmChaVal = isDisplayedTrue(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(1)"));
				if (getRmChaVal==true){
					long endSampleTableLoadTransaction = System.currentTimeMillis();
					long timeToLoadTheSampleTable = TimeUnit.MILLISECONDS.toSeconds(endSampleTableLoadTransaction - startSampleTableLoadTransaction);
					logger.info("Protocol table loaded Successfully and Protocol search result loading time is:["+ timeToLoadTheSampleTable +"] Seconds");
					oPDF.enterBlockSteps(bTable,stepCount, "Protocol Search Results Data Load Verification", "wait_until_search_protocol_table_data_load", "Protocol table loaded Successfully and Samples search result loading time is:["+ timeToLoadTheSampleTable +"] Seconds", "Pass");
					stepCount++;
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void wait_until_my_samples_table_data_load() throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(3)"), "Sample Submission Status");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(5)"), "Sample Access");
			int rCount = 100000;
			long startSampleTableLoadTransaction = System.currentTimeMillis();
			for (int i=1;i<rCount;i++){
				boolean getRmChaVal = isDisplayedTrue(By.cssSelector(".table.sample tbody tr:nth-child(2) td:nth-child(1)"));
				if (getRmChaVal==true){
					long endSampleTableLoadTransaction = System.currentTimeMillis();
					long timeToLoadTheSampleTable = TimeUnit.MILLISECONDS.toSeconds(endSampleTableLoadTransaction - startSampleTableLoadTransaction);
					logger.info("My Workspace Sample data loaded into the my samples table Successfully and My Samples loading time is:["+ timeToLoadTheSampleTable +"] Seconds");
					oPDF.enterBlockSteps(bTable,stepCount, "Sample data load verification", "wait_until_my_samples_table_data_load", "My Workspace Sample data loaded into the my samples table Successfully and My Samples loading time is:["+ timeToLoadTheSampleTable +"] Seconds", "Pass");
					stepCount++;
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void wait_until_my_protocols_table_data_load() throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(2)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(3)"), "Protocol Submission Status");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(5)"), "Protocol Access");
			int rCount = 100000;
			long startProtocolTableLoadTransaction = System.currentTimeMillis();
			for (int i=1;i<rCount;i++){
				boolean getRmChaVal = isDisplayedTrue(By.cssSelector(".table.protocol tbody tr:nth-child(2) td:nth-child(1)"));
				if (getRmChaVal==true){
					long endProtocolTableLoadTransaction = System.currentTimeMillis();
					long timeToLoadTheProtocolTable = TimeUnit.MILLISECONDS.toSeconds(endProtocolTableLoadTransaction - startProtocolTableLoadTransaction);
					logger.info("My worksapce protocols data loaded into the my protocol table Successfully and My Protocols loading time is:["+ timeToLoadTheProtocolTable +"] Seconds");
					oPDF.enterBlockSteps(bTable,stepCount,"Protocols data load verification","wait_until_my_protocols_table_data_load", "My worksapce protocols data loaded into the my protocol table Successfully and My Protocols loading time is:["+ timeToLoadTheProtocolTable +"] Seconds","Pass");
					stepCount++;
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void wait_until_my_publications_table_data_load() throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(2)"), "Publication ID");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(3)"), "Publication Title");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(4)"), "Publication Submission Status");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(5)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(6)"), "Publication Access");
			int rCount = 100000;
			long startPublicationsTableLoadTransaction = System.currentTimeMillis();
			for (int i=1;i<rCount;i++){
				boolean getRmChaVal = isDisplayedTrue(By.cssSelector(".table.publication tbody tr:nth-child(2) td:nth-child(1)"));
				if (getRmChaVal==true){
					long endPublicationsTableLoadTransaction = System.currentTimeMillis();
					long timeToLoadThePublicationsTable = TimeUnit.MILLISECONDS.toSeconds(endPublicationsTableLoadTransaction - startPublicationsTableLoadTransaction);
					logger.info("My workspace publications data loaded into the my publication table Successfully and My Publications loading time is:["+ timeToLoadThePublicationsTable +"] Seconds");
					oPDF.enterBlockSteps(bTable,stepCount,"Publications data load verification","wait_until_my_publications_table_data_load", "My workspace publications data loaded into the my publication table Successfully and My Publications loading time is:["+ timeToLoadThePublicationsTable +"] Seconds","Pass");
					stepCount++;
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void view_my_workspace_protocol(String getProtocolName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(2)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(3)"), "Protocol Submission Status");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(5)"), "Protocol Access");
			int rCount = getRowCount(By.cssSelector(".table.protocol"));
			for (int i=2;i<rCount;i++){
				String protocolTableCellData = null;
					   protocolTableCellData = getText(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
				if (protocolTableCellData.contains(getProtocolName)){
					logger.info("Expected Value:["+ getProtocolName +"] and Actual value: ["+ protocolTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(1)"));
					wait_For(9000);
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol View Actions verification","view_my_workspace_protocol","My Workspace Protocol:["+ protocolTableCellData +"] View action performed Successfully","Pass");
					stepCount++;
					boolean getNewWndoVal = verify_protocol_view();
					if (getNewWndoVal == true){
						oPDF.enterBlockSteps(bTable,stepCount,"Protocol View Window verification","view_my_workspace_protocol","My Workspace Protocol:["+ protocolTableCellData +"] displayed Successfully","Pass");
					} else if(getNewWndoVal == false) {	
						logger.error("Unable to display my protocol. Please verify the My Protocol view link");
						TestExecutionException e = new TestExecutionException("Protocol view verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Protocol view verification failed","verify_sample_edit","Unable to display my protocols from My Worksapce", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public boolean verify_new_window() throws TestExecutionException {
			try{
				parentWindowHandler = selenium.getWindowHandle();
				Set<String> handles = selenium.getWindowHandles(); // get all window handles
				Iterator<String> iterator = handles.iterator();
				while (iterator.hasNext()){
				    subWindowHandler = iterator.next();
				}
				selenium.switchTo().window(subWindowHandler); // switch to popup window
				return true;
			}catch(NoSuchElementException e){
				logger.error("ERROR: "+ e.getMessage());
				return false;
			}
		}
		/*
		 * 		
		 */
		public boolean verify_protocol_view() throws TestExecutionException {
			try{
				parentWindowHandler = selenium.getWindowHandle();
				Set<String> handles = selenium.getWindowHandles(); // get all window handles
				Iterator<String> iterator = handles.iterator();
				while (iterator.hasNext()){
				    subWindowHandler = iterator.next();
				}
				selenium.switchTo().window(subWindowHandler); // switch to popup window
				return true;
			}catch(NoSuchElementException e){
				logger.error("ERROR: "+ e.getMessage());
				return false;
			}
		}
		/*
		 * 		
		 */
		public void view_my_workspace_samples(String getSampleName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(3)"), "Sample Submission Status");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(5)"), "Sample Access");
			int rCount = getRowCount(By.cssSelector(".table.sample"));
			for (int i=2;i<rCount;i++){
				String sampleTableCellData = null;
					   sampleTableCellData = getText(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.contains(getSampleName)){
					logger.info("Expected Value:["+ getSampleName +"] and Actual value: ["+ sampleTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(1)"));
					wait_For(5000);
					oPDF.enterBlockSteps(bTable,stepCount,"Sample View Actions verification","view_my_workspace_samples","My Workspace Sample:["+ sampleTableCellData +"] View action performed Successfully","Fail");
					stepCount++;
					verify_sample_view(sampleTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_sample_view(String getSampleName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".summaryViewNoGrid tbody tr th:nth-child(4)"), "Role");
			String getSampleNameVal = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(1) .ng-binding"));
			logger.info("Expected Sample:["+ getSampleName +"]. Actual Sample identified as:["+ getSampleNameVal +"].");
			if (getSampleNameVal.equals(getSampleName)){
				logger.error("Expected Sample:["+ getSampleName +"] and Actual Sample:["+ getSampleNameVal +"] match found on the sample edit field");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample View verification","verify_sample_view","My Workspace Sample:["+ getSampleNameVal +"] displayed Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected Sample:["+ getSampleName +"] and Actual Sample:["+ getSampleNameVal +"] match NOT Found and system unable to display sample from My Worksapce");
				TestExecutionException e = new TestExecutionException("Sample Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Edit verification","verify_sample_edit","Expected Sample:["+ getSampleName +"] and Actual Sample:["+ getSampleNameVal +"] match NOT Found and system unable to display sample from My Worksapce", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 		
		 */
		public void edit_my_workspace_protocol(String getProtocolName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(2)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(3)"), "Protocol Submission Status");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(5)"), "Protocol Access");
			int rCount = getRowCount(By.cssSelector(".table.protocol"));
			for (int i=2;i<rCount;i++){
				String protocolTableCellData = null;
					   protocolTableCellData = getText(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
				if (protocolTableCellData.contains(getProtocolName)){
					logger.info("Expected Value:["+ getProtocolName +"] and Actual value: ["+ protocolTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(2)"));
					wait_For(9000);
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol Edit Actions verification","edit_my_workspace_protocol","My Workspace Protocol:["+ protocolTableCellData +"] Edit action performed Successfully","Pass");
					stepCount++;
					verify_protocol_edit(protocolTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_protocol_edit(String getProtocolName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".editTableWithGrid.ng-scope tbody tr th:nth-child(2)"), "Access");
			String getProtocolNameVal = getAttribute(By.cssSelector("#protocolName"), "value");
			logger.info("Expected Protocol:["+ getProtocolName +"]. Actual Protocol identified as:["+ getProtocolNameVal +"].");
			if (getProtocolNameVal.equals(getProtocolName)){
				logger.error("Expected Protocol:["+ getProtocolName +"] and Actual Protocol:["+ getProtocolNameVal +"] match found on the Protocol edit field");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocol Edit verification","verify_protocol_edit","My Workspace Protocol:["+ getProtocolNameVal +"] Edited Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected Protocol:["+ getProtocolName +"] and Actual Protocol:["+ getProtocolNameVal +"] match NOT Found on the Protocol edit field");
				TestExecutionException e = new TestExecutionException("Protocol Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocol Edit verification","verify_protocol_edit","Expected Protocol:["+ getProtocolName +"] and Actual Protocol:["+ getProtocolNameVal +"] match NOT Found on the Protocol edit field", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 		
		 */
		public void edit_my_workspace_samples(String getSampleName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(3)"), "Sample Submission Status");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(5)"), "Sample Access");
			int rCount = getRowCount(By.cssSelector(".table.sample"));
			for (int i=2;i<rCount;i++){
				String sampleTableCellData = null;
					   sampleTableCellData = getText(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.contains(getSampleName)){
					logger.info("Expected Value:["+ getSampleName +"] and Actual value: ["+ sampleTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(2)"));
					wait_For(5000);
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Edit Actions verification","edit_my_workspace_samples","My Workspace Sample:["+ sampleTableCellData +"] Edit action performed Successfully","Pass");
					stepCount++;
					verify_sample_edit(sampleTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_sample_edit(String getSampleName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".cellLabel.ng-binding label"), "Keywords");
			String getSampleNameVal = getAttribute(By.cssSelector("#sampleName"), "value");
			logger.info("Expected Sample:["+ getSampleName +"]. Actual Sample identified as:["+ getSampleNameVal +"].");
			if (getSampleNameVal.equals(getSampleName)){
				logger.error("Expected Sample:["+ getSampleName +"] and Actual Sample:["+ getSampleNameVal +"] match found on the sample edit field");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Edit verification","verify_sample_edit","My Workspace Sample:["+ getSampleNameVal +"] Edited Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected Sample:["+ getSampleName +"] and Actual Sample:["+ getSampleNameVal +"] match NOT Found on the sample edit field");
				TestExecutionException e = new TestExecutionException("Sample Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Edit verification","verify_sample_edit","Expected Sample:["+ getSampleName +"] and Actual Sample:["+ getSampleNameVal +"] match NOT Found on the sample edit field", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 	Publication Edit	
		 */
		public void edit_my_workspace_publication(String getPublicationName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(2)"), "Publication ID");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(3)"), "Publication Title");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(4)"), "Publication Submission Status");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(5)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(6)"), "Publication Access");			
			int rCount = getRowCount(By.cssSelector(".table.publication"));
			for (int i=2;i<rCount;i++){
				String publicationTableCellData = null;
					   publicationTableCellData = getText(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(3)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ publicationTableCellData +"]");
				if (publicationTableCellData.contains(getPublicationName)){
					logger.info("Expected Value:["+ getPublicationName +"] and Actual value: ["+ publicationTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(1)"));
					wait_For(9000);
					oPDF.enterBlockSteps(bTable,stepCount,"Publication Edit Actions verification","edit_my_workspace_publication","My Workspace Publication:["+ publicationTableCellData +"] edit action performed Successfully","Pass");
					stepCount++;
					verify_publication_edit(publicationTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_publication_edit(String getPublicationName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".submissionView tbody tr:nth-child(2) .cellLabel:nth-child(1) label"), "PubMed ID");
			int rCount = 10000000;
			long startPublicationsTableLoadTransaction = System.currentTimeMillis();
			for (int i=1;i<rCount;i++){
				String getPublicationNameVal = getAttribute(By.id("publicationForm.title"), "value");
				if (getPublicationNameVal != null){
					long endPublicationsTableLoadTransaction = System.currentTimeMillis();
					long timeToLoadThePublicationsTable = TimeUnit.MILLISECONDS.toSeconds(endPublicationsTableLoadTransaction - startPublicationsTableLoadTransaction);
					logger.info("My workspace publications data loaded into the my publication table Successfully and My Publications loading time is:["+ timeToLoadThePublicationsTable +"] Seconds");
					oPDF.enterBlockSteps(bTable,stepCount,"Publications data load verification","verify_publication_edit", "Publications data loaded into the my publication edit field Successfully and My Publication loading time is:["+ timeToLoadThePublicationsTable +"] Seconds","Pass");
					stepCount++;
					break;
				}
			}
			String getPublicaNameVal = getAttribute(By.id("publicationForm.title"), "value");
			logger.info("Expected Publication:["+ getPublicationName +"]. Actual Publication identified as:["+ getPublicaNameVal +"].");
			if (getPublicaNameVal.equals(getPublicationName)){
				logger.error("Expected Publication:["+ getPublicationName +"] and Actual Publication:["+ getPublicaNameVal +"] match found on the Publication edit field");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Edit verification","verify_Publication_edit","My Workspace Publication:["+ getPublicaNameVal +"] Edited Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected Publication:["+ getPublicationName +"] and Actual Publication:["+ getPublicaNameVal +"] match NOT Found on the Publication edit field");
				TestExecutionException e = new TestExecutionException("Publication Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Edit verification","verify_Publication_edit","Expected Publication:["+ getPublicationName +"] and Actual Publication:["+ getPublicaNameVal +"] match NOT Found on the Publication edit field", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 	Publication Delete	
		 */
		public void delete_my_workspace_publication(String getPublicationName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(2)"), "Publication ID");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(3)"), "Publication Title");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(4)"), "Publication Submission Status");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(5)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(6)"), "Publication Access");			
			int rCount = getRowCount(By.cssSelector(".table.publication"));
			for (int i=2;i<rCount;i++){
				String publicationTableCellData = null;
					   publicationTableCellData = getText(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(3)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ publicationTableCellData +"]");
				if (publicationTableCellData.contains(getPublicationName)){
					logger.info("Expected Value:["+ getPublicationName +"] and Actual value: ["+ publicationTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(2)"));
					checkAlertOK();
					wait_For(9000);
					oPDF.enterBlockSteps(bTable,stepCount,"Publication Delete Actions verification","delete_my_workspace_Publications","My Workspace Publication:["+ publicationTableCellData +"] delete action performed Successfully","Pass");
					stepCount++;
					verify_publication_deleted_successfully(publicationTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_publication_deleted_successfully(String getPublicationName) throws TestExecutionException {
			goHome();
			wait_For(2000);
			navigate_to_myworksapce_page();
			wait_until_my_samples_table_data_load();
			wait_until_my_protocols_table_data_load();
			wait_until_my_publications_table_data_load();
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(2)"), "Publication Name");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(3)"), "Publication Submission Status");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(5)"), "Publication Access");
			int rCount = getRowCount(By.cssSelector(".table.publication"));
			boolean getPublicationVal = false;
			String publicationTableCellData = null;
			for (int i=2;i<rCount;i++){
					   publicationTableCellData = null;
					   publicationTableCellData = getText(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(3)"));
					   logger.info("Curent row:["+ i +"] and Identified value:["+ publicationTableCellData +"]");
				if (publicationTableCellData.equals(getPublicationName)){
					logger.error("Identified Publication:["+ publicationTableCellData +"] on the My Publications result table row number:["+ i +"] in My Workspace page");
					TestExecutionException e = new TestExecutionException("Publication Delete verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Publication Delete verification","verify_Publication_deleted_successfully","Identified Publication:["+ publicationTableCellData +"] on the My Publications result table row number:["+ i +"] in My Workspace page and delete verification is Failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
					getPublicationVal = true;
					break;
				}
			}
			if (getPublicationVal == true){
				logger.error("Publication:["+ publicationTableCellData +"] deleted successfully from My Workspace page");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Delete verification","verify_Publication_deleted_successfully","My Workspace Publication:["+ publicationTableCellData +"] deleted Successfully","Pass");
				stepCount++;
			}
		}
		/*
		 * 	Protocol Delete	
		 */
		public void delete_my_workspace_protocols(String getProtocolName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(2)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(3)"), "Protocol Submission Status");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(5)"), "Protocol Access");
			int rCount = getRowCount(By.cssSelector(".table.protocol"));
			for (int i=2;i<rCount;i++){
				String protocolTableCellData = null;
					   protocolTableCellData = getText(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
				if (protocolTableCellData.contains(getProtocolName)){
					logger.info("Expected Value:["+ getProtocolName +"] and Actual value: ["+ protocolTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(3)"));
					checkAlertOK();
					wait_For(9000);
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol Delete Actions verification","delete_my_workspace_protocols","My Workspace Protocol:["+ protocolTableCellData +"] delete action performed Successfully","Pass");
					stepCount++;
					verify_protocol_deleted_successfully(protocolTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_protocol_deleted_successfully(String getProtocolName) throws TestExecutionException {
			goHome();
			wait_For(2000);
			navigate_to_myworksapce_page();
			wait_until_my_protocols_table_data_load();
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(2)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(3)"), "Protocol Submission Status");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.protocol tbody tr th:nth-child(5)"), "Protocol Access");
			int rCount = getRowCount(By.cssSelector(".table.protocol"));
			boolean getSampleVal = false;
			String protocolTableCellData = null;
			for (int i=2;i<rCount;i++){
					   protocolTableCellData = null;
					   protocolTableCellData = getText(By.cssSelector(".table.protocol tbody tr:nth-child("+ i +") td:nth-child(2)"));
					   logger.info("Curent row:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
				if (protocolTableCellData.equals(getProtocolName)){
					logger.error("Identified Protocol:["+ protocolTableCellData +"] on the My Protocols result table row number:["+ i +"] in My Workspace page");
					TestExecutionException e = new TestExecutionException("Protocol Delete verificatio failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol Delete verification","verify_protocol_deleted_successfully","Identified Protocol:["+ protocolTableCellData +"] on the My Protocols result table row number:["+ i +"] in My Workspace page and delete verification is Failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
					getSampleVal = true;
					break;
				}
			}
			if (getSampleVal == true){
				logger.error("Protocol:["+ protocolTableCellData +"] deleted successfully from My Workspace page");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocol Delete verification","verify_protocol_deleted_successfully","My Workspace Protocol:["+ protocolTableCellData +"] deleted Successfully","Pass");
				stepCount++;
			}
		}
		/*
		 * 	Sample Delete	
		 */
		public void delete_my_workspace_samples(String getSampleName) throws TestExecutionException {
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(3)"), "Sample Submission Status");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(5)"), "Sample Access");
			int rCount = getRowCount(By.cssSelector(".table.sample"));
			for (int i=2;i<rCount;i++){
				String sampleTableCellData = null;
					   sampleTableCellData = getText(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.contains(getSampleName)){
					logger.info("Expected Value:["+ getSampleName +"] and Actual value: ["+ sampleTableCellData +"] identified in row number: ["+ i +"]");
					clickLink(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(3)"));
					checkAlertOK();
					wait_For(9000);
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Delete Actions verification","delete_my_workspace_samples","My Workspace Sample:["+ sampleTableCellData +"] delete action performed Successfully","Pass");
					stepCount++;
					verify_sample_deleted_successfully(sampleTableCellData);
					break;
				}
			}
		}
		/*
		 * 		
		 */
		public void verify_sample_deleted_successfully(String getSampleName) throws TestExecutionException {
			goHome();
			wait_For(2000);
			navigate_to_myworksapce_page();
			wait_until_my_samples_table_data_load();
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(3)"), "Sample Submission Status");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(4)"), "Created Date");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(5)"), "Sample Access");
			int rCount = getRowCount(By.cssSelector(".table.sample"));
			boolean getSampleVal = false;
			String sampleTableCellData = null;
			for (int i=2;i<rCount;i++){
					   sampleTableCellData = null;
					   sampleTableCellData = getText(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(2)"));
					   logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.equals(getSampleName)){
					logger.error("Identified Sample:["+ sampleTableCellData +"] on the My Samples result table row number:["+ i +"] in My Workspace page and Delete verification is failed");
					TestExecutionException e = new TestExecutionException("Sample Delete verificatio failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Delete verification","verify_sample_deleted_successfully","Identified Sample:["+ sampleTableCellData +"] on the My Samples result table row number:["+ i +"] in My Workspace page and delete verification is Failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
					getSampleVal = true;
					break;
				}
			}
			if (getSampleVal == true){
				logger.info("Sample:["+ sampleTableCellData +"] deleted successfully from My Workspace page");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Delete verification","verify_sample_deleted_successfully","My Workspace Sample:["+ sampleTableCellData +"] deleted Successfully","Pass");
				stepCount++;
			}
		}
		/*
		 * Publication Remove from my workspace
		 */
		public void remove_my_favorites_publication_all() throws TestExecutionException {
			navigate_to_favorites_page();
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			boolean getMyFavRetVal = isDisplayedTrue(By.cssSelector(".table.publication.ng-scope"));
			if (getMyFavRetVal == true){
				wait_until_element_present(By.cssSelector(".table.publication.ng-scope tbody tr th:nth-child(1)"), "Actions");
				wait_until_element_present(By.cssSelector(".table.publication.ng-scope tbody tr th:nth-child(2)"), "Publication Title");
				int rCount = getRowCount(By.cssSelector(".table.publication"));
				boolean getTabVal = isDisplayedTrue(By.cssSelector(".table.publication.ng-scope tbody tr:nth-child(2) td:nth-child(1) a:nth-child(4)"));
				if (getTabVal == true){
					for (int i=2;i<rCount;i++){
								clickLink(By.cssSelector(".table.publication.ng-scope tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
								checkAlertOK();
								wait_For(5000);
					}
				}
			}
		}
		/*
		 * Protocol Remove from my workspace
		 */
		public void remove_my_favorites_protocol_all() throws TestExecutionException {
			navigate_to_favorites_page();
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			boolean getMyFavRetVal = isDisplayedTrue(By.cssSelector(".table.protocol.ng-scope"));
			if (getMyFavRetVal == true){
				wait_until_element_present(By.cssSelector(".table.protocol.ng-scope tbody tr th:nth-child(1)"), "Actions");
				wait_until_element_present(By.cssSelector(".table.protocol.ng-scope tbody tr th:nth-child(2)"), "Protocol Name");
				int rCount = getRowCount(By.cssSelector(".table.protocol.ng-scope"));
				boolean getTabVal = isDisplayedTrue(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child(2) td:nth-child(1) a:nth-child(4)"));
				if (getTabVal == true){
					for (int i=2;i<rCount;i++){
								clickLink(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
								checkAlertOK();
								wait_For(5000);
					}
				}
			}
		}
		/*
		 * Sample Remove from my workspace
		 */
		public void remove_my_favorites_sample_all() throws TestExecutionException {
			navigate_to_favorites_page();
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			boolean getMyFavRetVal = isDisplayedTrue(By.cssSelector(".table.sample.ng-scope"));
				if (getMyFavRetVal == true){
				wait_until_element_present(By.cssSelector(".table.sample.ng-scope tbody tr th:nth-child(1)"), "Actions");
				wait_until_element_present(By.cssSelector(".table.sample.ng-scope tbody tr th:nth-child(2)"), "Sample Name");
				int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope"));
				boolean getTabVal = isDisplayedTrue(By.cssSelector(".table.sample.ng-scope tbody tr:nth-child(2) td:nth-child(1) a:nth-child(4)"));
				if (getTabVal == true){
					for (int i=2;i<rCount;i++){
								clickLink(By.cssSelector(".table.sample.ng-scope tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
								checkAlertOK();
								wait_For(5000);
								rCount = rCount - 1;
					}
				}
			}
		}
		/*
		 * Publication Add to Favorites
		 */
		public void publication_add_to_favorites(String getPublicationNameVal, String getMyFavVerificationYesOrNo, String getViewOrEditOrRemove) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Bibliography Info");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Publication Type");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Research Category");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Associated Sample Names");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Description");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Publication Status");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(8)"), "Created Date");
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
				rCount = rCount - 2;
			String publicationTableCellData = null;
			for (int i=1;i<rCount;i++){
				publicationTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ publicationTableCellData +"]");
				String valSplt = publicationTableCellData.replace(". ", "###");
				logger.info("valSplt:["+valSplt);
	           	String[] parts = valSplt.split("###");
	            String part1 = parts[1];
				logger.info("part1["+part1);
				logger.info("Curent row:["+ i +"] and Identified Publication title is value:["+ part1 +"]");
				
				if (part1.contains(getPublicationNameVal)){
					clickLink(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(3)"));
					String getFavStatusVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", " ");
					       logger.info("=========================================================================");
						   logger.info("Actions Column Status:["+getFavStatusVal);
						   logger.info("=========================================================================");
					String getBuildString = "Edit "+ publicationTableCellData +" has already been added to your favorites"; 
						   //logger.info("getBuildString:["+getBuildString);
					String getSccssConfVal = "Edit Added to Favorites"; 
					if (getFavStatusVal.equals(getBuildString)){
						publicationTableCellData = null;
						publicationTableCellData = "result has been already added to the my favorites";
						logger.info("Current row number:["+ i +"] and ["+publicationTableCellData);
					}
					if (getFavStatusVal.equals(getSccssConfVal)){
						verify_publication_add_to_favorites(part1);
						logger.info("publicationTableCellData info:["+part1);
						//start getMyFavVerificationYesOrNo verification
						if (getMyFavVerificationYesOrNo.isEmpty()==false){
							if (getMyFavVerificationYesOrNo.equals("yes")) {
							navigate_to_favorites_page();
							verify_my_favorites_publication(part1, getViewOrEditOrRemove);
							}
						}
						//end getMyFavVerificationYesOrNo verification
						break;
					}
				}
			    parts = null;
			    part1 = null;
			}
		}
		/*
		 * 
		 */
		public void verify_my_favorites_publication(String getPublicationNameSearchVal, String getValViewOrEditOrRemove) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.publication tbody tr th:nth-child(2)"), "Publication Title");
			int rCount = getRowCount(By.cssSelector(".table.publication"));
			    rCount = rCount + 1;
			String expPublicationTableCellData = null;
			for (int r=2;r<rCount;r++){
				expPublicationTableCellData = getText(By.cssSelector(".table.publication tbody tr:nth-child("+ r +") td:nth-child(2)"));
				if (r == rCount && expPublicationTableCellData != getPublicationNameSearchVal){
					logger.error("User unable to add the Publication to the My Favorites page");
					TestExecutionException e = new TestExecutionException("Publication Add to the my Favorites page verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol Add to the Favorites verification","verify_my_favorites_protocol", "Publication:["+ expPublicationTableCellData +"] added to the my favorites list failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			String publicationTableCellData = null;
			for (int i=2;i<rCount;i++){
				publicationTableCellData = getText(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ publicationTableCellData +"]");
				if (publicationTableCellData.equals(getPublicationNameSearchVal)){
					logger.info("Match found on the row number:["+ i +"] and Identified value:["+ publicationTableCellData +"]");
					logger.info("Publication has been added to the My Favorites successfully");
					oPDF.enterBlockSteps(bTable,stepCount,"Publication Add to Favorites page verification","verify_my_favorites_publication","Publication:["+ publicationTableCellData +"] add to the my favorites page Successfully","Pass");
					stepCount++;
					if (getValViewOrEditOrRemove.equals("view")){
						clickLink(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(1)"));
						wait_For(2000);
						boolean getNewWndoVal = verify_new_window();
						if (getNewWndoVal == true){
							oPDF.enterBlockSteps(bTable,stepCount,"Publication View Window verification","verify_my_favorites_publication","My Favorites Publication:["+ publicationTableCellData +"] displayed Successfully","Pass");
						} else if(getNewWndoVal == false) {	
							logger.error("Unable to display my Publication. Please verify the My Publication view link");
							TestExecutionException e = new TestExecutionException("Publication view verification failed");
							oPDF.enterBlockSteps(bTable,stepCount,"Publication view verification failed","verify_my_favorites_publication","Unable to display my publication from My favorites", "Fail");
							stepCount++;
							setupAfterSuite();	
							Assert.fail(e.getMessage());
						}
					}
					if (getValViewOrEditOrRemove.equals("edit")){
						clickLink(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(2)"));
						element_load(By.id("category"));
						verify_publication_edit_val(getPublicationNameSearchVal);
					}					
					if (getValViewOrEditOrRemove.equals("remove")){
						clickLink(By.cssSelector(".table.publication tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
						checkAlertOK();
						wait_For(5000);
						verify_publication_remove_by_name(getPublicationNameSearchVal);
					}
					break;
				}
		    }
		}
		/*
		 * 
		 */
		public void verify_publication_edit_val(String getPublicationNameEditVal) throws TestExecutionException {
			load_text_box_value(By.id("publicationForm.title"), "value", 1000);
			String getPublicationNameVal = getAttribute(By.id("publicationForm.title"), "value");
			logger.info("getPublicationNameVal:["+getPublicationNameVal);
			if (getPublicationNameVal.equals(getPublicationNameEditVal)){
				logger.info("Successfully Edited Publication from My Fovorites");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Edit verification","verify_publication_edit_val","My Favorites Publication Edited Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected Publication:["+ getPublicationNameEditVal +"] and Actual Publication:["+ getPublicationNameVal +"] match NOT Found on the Publication edit field");
				TestExecutionException e = new TestExecutionException("Publication Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"publication Edit verification","verify_publication_edit_val","Expected Publication:["+ getPublicationNameEditVal +"] and Actual Publication:["+ getPublicationNameVal +"] match NOT Found on the Publication edit field", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void verify_publication_remove_by_name(String getPublicationNameEditVal) throws TestExecutionException {
			boolean getTableVal = isDisplayedTrue(By.cssSelector(".table.publication"));
			logger.info("getTableVal:["+getTableVal);
			if (getTableVal == false){
				logger.info("Successfully Removed Publication from My Fovorites");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication remove verification","verify_publication_remove_by_name","My Favorites Publication removed Successfully","Pass");
				stepCount++;
			}
			if (getTableVal == true){
				int rmFCount = getRowCount(By.cssSelector(".table.publication"));
				int iRCount = rmFCount;
				if (iRCount != 0){
					iRCount = iRCount + 1;
				}
				String publicationTableCellDataFailed = null;
				for (int h=2;h<iRCount;h++){
					publicationTableCellDataFailed = getText(By.cssSelector(".table.publication tbody tr:nth-child("+ h +") td:nth-child(2)"));
					logger.info("Curent row:["+ h +"] and Identified value:["+ publicationTableCellDataFailed +"]");
					if (publicationTableCellDataFailed.equals(getPublicationNameEditVal)){
						logger.error("Publication match found:["+ publicationTableCellDataFailed +"], Remove verification failed");
						TestExecutionException e = new TestExecutionException("Publication Remove verification");
						oPDF.enterBlockSteps(bTable,stepCount,"publication remove verification","verify_publication_remove_by_name","Publication match found:["+ publicationTableCellDataFailed +"], Remove verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
						break;
					}
					if (h == rmFCount){
						if (publicationTableCellDataFailed != getPublicationNameEditVal){
							logger.info("Successfully Removed Publication from My Fovorites");
							oPDF.enterBlockSteps(bTable,stepCount,"Publication remove verification","verify_publication_remove_by_name","My Favorites Publication removed Successfully","Pass");
							stepCount++;	
						}
					}
				}
			}
		}
		/*
		 * 
		 */
		public void load_text_box_value(By by, String getAttriVal, int countNm) throws TestExecutionException {
			int loadCount = countNm;
			for (int c=2;c<loadCount;c++){
				String getEditVal = getAttribute(by, getAttriVal);
				if (getEditVal.isEmpty()==false){
					break;
				}
			}
		}
		/*
		 * 
		 */
		public void verify_publication_add_to_favorites(String getPublicationNameSearchVal) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Bibliography Info");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Publication Type");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Research Category");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Associated Sample Names");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Description");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Publication Status");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(8)"), "Created Date");
			int rVCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
				rVCount = rVCount - 2;
			String currPublicationTableCellData = null;
			for (int i=1;i<rVCount;i++){
				currPublicationTableCellData = null;
				currPublicationTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ currPublicationTableCellData +"]");
				String valSplt1 = currPublicationTableCellData.replace(". ", "###");
				logger.info("valSplt:["+valSplt1);
	           	String[] parts = valSplt1.split("###");
	            String part1a = parts[1];
				logger.info("Actual:["+part1a+"]");
				logger.info("Expected:["+getPublicationNameSearchVal+"]");
				if (part1a.equals(getPublicationNameSearchVal)){
					logger.info("Match found on the row number:["+ i +"] and Identified value:["+ currPublicationTableCellData +"]");
					String getAddtoFavStatusVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", " ");
						   logger.info("Current row number is:["+ i +"] and the Add to Favorites status is:["+getAddtoFavStatusVal+"]");
					String getSuccessConfVal = "Edit Added to Favorites"; 
					if (getAddtoFavStatusVal.equals(getSuccessConfVal)){
						logger.info("Publication has been added to the My Favorites successfully");
						oPDF.enterBlockSteps(bTable,stepCount,"Publication Add to Favorites verification","verify_publication_add_to_favorites","Publication:["+ currPublicationTableCellData +"] add to favorites Successfully added to the my favorites","Pass");
						stepCount++;
						break;
					}
					if (getAddtoFavStatusVal != getSuccessConfVal){
						logger.error("User unable to add the Publication:["+ currPublicationTableCellData +"] to the My Favorites list");
						TestExecutionException e = new TestExecutionException("Publication Add to the Favorites verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Publication Add to the Favorites verification","verify_publication_add_to_favorites","Publication:["+ currPublicationTableCellData +"] add to favorites action failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
						break;
					}
				}
			    parts = null;
			    part1a = null;
		     }
		}
		/*
		 * Protocol Add to Favorites
		 */
		public void protocol_add_to_favorites(String getProtocolNameVal, String getMyFavVerificationYesOrNo, String getViewOrEditOrRemove) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Protocol Type");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Protocol Abbreviation");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Version");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Protocol File");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Created Date");
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String protocolTableCellData = null;
			for (int i=1;i<rCount;i++){
				protocolTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(3)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
				if (protocolTableCellData.contains(getProtocolNameVal)){
					clickLink(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
					String getFavStatusVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", " ");
						   logger.info("Actions Column Status:["+getFavStatusVal);
					String getBuildString = "Edit  "+ protocolTableCellData +" has already been added to your favorites"; 
						   //logger.info("getBuildString:["+getBuildString);
					String getSccssConfVal = "Edit  Added to Favorites"; 
					if (getFavStatusVal.equals(getBuildString)){
						protocolTableCellData = null;
						protocolTableCellData = "result has been already added to the my favorites";
						logger.info("Current row number:["+ i +"] and ["+protocolTableCellData);
					}
					if (getFavStatusVal.equals(getSccssConfVal)){
						verify_protocol_add_to_favorites(protocolTableCellData);
						logger.info("protocolTableCellData info:["+protocolTableCellData);
						//start getMyFavVerificationYesOrNo verification
						if (getMyFavVerificationYesOrNo.isEmpty()==false){
							if (getMyFavVerificationYesOrNo.equals("yes")) {
							navigate_to_favorites_page();
							verify_my_favorites_protocol(protocolTableCellData, getViewOrEditOrRemove);
							}
						}
						//end getMyFavVerificationYesOrNo verification
						break;
					}
				}
			}
		}
		/*
		 * 
		 */
		public void verify_my_favorites_protocol(String getProtocolNameSearchVal, String getValViewOrEditOrRemove) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			wait_until_element_present(By.cssSelector(".table.protocol.ng-scope tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.protocol.ng-scope tbody tr th:nth-child(2)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.protocol.ng-scope tbody tr th:nth-child(3)"), "Protocol File Title");
			int rCount = getRowCount(By.cssSelector(".table.protocol.ng-scope"));
			    rCount = rCount + 1;
			String expProtocolTableCellData = null;
			for (int r=2;r<rCount;r++){
				expProtocolTableCellData = getText(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ r +") td:nth-child(2)"));
				if (r == rCount && expProtocolTableCellData != getProtocolNameSearchVal){
					logger.error("User unable to add the Protocol to the My Favorites page");
					TestExecutionException e = new TestExecutionException("Protocol Add to the my Favorites page verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol Add to the Favorites verification","verify_my_favorites_protocol", "Protocol:["+ expProtocolTableCellData +"] added to the my favorites list failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			String protocolTableCellData = null;
			for (int i=2;i<rCount;i++){
				protocolTableCellData = getText(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
				if (protocolTableCellData.equals(getProtocolNameSearchVal)){
					logger.info("Match found on the row number:["+ i +"] and Identified value:["+ protocolTableCellData +"]");
					logger.info("Protocol has been added to the My Favorites successfully");
					oPDF.enterBlockSteps(bTable,stepCount,"Protocol Add to Favorites page verification","verify_my_favorites_protocol","Protocol:["+ protocolTableCellData +"] add to the my favorites page Successfully","Pass");
					stepCount++;
					if (getValViewOrEditOrRemove.equals("view")){
						clickLink(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(1)"));
						wait_For(2000);
						boolean getNewWndoVal = verify_new_window();
						if (getNewWndoVal == true){
							oPDF.enterBlockSteps(bTable,stepCount,"Protocol View Window verification","verify_my_favorites_protocol","My Favorites Protocol:["+ protocolTableCellData +"] displayed Successfully","Pass");
						} else if(getNewWndoVal == false) {	
							logger.error("Unable to display my Protocol. Please verify the My Protocol view link");
							TestExecutionException e = new TestExecutionException("Protocol view verification failed");
							oPDF.enterBlockSteps(bTable,stepCount,"Protocol view verification failed","verify_my_favorites_protocol","Unable to display my Protocol from My favorites", "Fail");
							stepCount++;
							setupAfterSuite();	
							Assert.fail(e.getMessage());
						}
					}
					if (getValViewOrEditOrRemove.equals("edit")){
						clickLink(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(2)"));
						element_load(By.id("type"));
						verify_protocol_edit_val(getProtocolNameSearchVal);
					}					
					if (getValViewOrEditOrRemove.equals("remove")){
						clickLink(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
						checkAlertOK();
						wait_For(5000);
						verify_protocol_remove_by_name(getProtocolNameSearchVal);
					}
					break;
				}
		    }
		}
		/*
		 * 
		 */
		public void verify_protocol_edit_val(String getProtocolNameEditVal) throws TestExecutionException {
			load_text_box_value(By.id("protocolName"), "value", 1000);
			String getprotocolNameVal = getAttribute(By.id("protocolName"), "value");
			logger.info("getprotocolNameVal:["+getprotocolNameVal);
			if (getprotocolNameVal.equals(getProtocolNameEditVal)){
				logger.info("Successfully Edited Protocol from My Fovorites");
				oPDF.enterBlockSteps(bTable,stepCount,"protocol Edit verification","verify_protocol_edit_val","My Favorites protocol Edited Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected protocol:["+ getProtocolNameEditVal +"] and Actual protocol:["+ getprotocolNameVal +"] match NOT Found on the protocol edit field");
				TestExecutionException e = new TestExecutionException("protocol Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"protocol Edit verification","verify_protocol_edit_val","Expected protocol:["+ getProtocolNameEditVal +"] and Actual protocol:["+ getprotocolNameVal +"] match NOT Found on the protocol edit field", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void verify_protocol_remove_by_name(String getprotocolNameEditVal) throws TestExecutionException {
			boolean getTableValproto = isDisplayedTrue(By.cssSelector(".table.protocol.ng-scope"));
			logger.info("getTableValproto:["+getTableValproto);
			if (getTableValproto == false){
				logger.info("Successfully Removed protocol from My Fovorites");
				oPDF.enterBlockSteps(bTable,stepCount,"protocol remove verification","verify_protocol_remove_by_name","My Favorites protocol removed Successfully","Pass");
				stepCount++;
			}
			if (getTableValproto == true){
				int rmFProtoCount = getRowCount(By.cssSelector(".table.protocol.ng-scope"));
				int iRProtoCount = rmFProtoCount;
				if (iRProtoCount != 0){
					iRProtoCount = iRProtoCount + 1;
				}
				String protocolTableCellDataFailed = null;
				for (int p=2;p<iRProtoCount;p++){
					protocolTableCellDataFailed = getText(By.cssSelector(".table.protocol.ng-scope tbody tr:nth-child("+ p +") td:nth-child(2)"));
					logger.info("Curent row:["+ p +"] and Identified value:["+ protocolTableCellDataFailed +"]");
					if (protocolTableCellDataFailed.equals(getprotocolNameEditVal)){
						logger.error("protocol match found:["+ protocolTableCellDataFailed +"], Remove verification failed");
						TestExecutionException e = new TestExecutionException("protocol Remove verification");
						oPDF.enterBlockSteps(bTable,stepCount,"protocol remove verification","verify_protocol_remove_by_name","protocol match found:["+ protocolTableCellDataFailed +"], Remove verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
						break;
					}
					if (p == rmFProtoCount){
						if (protocolTableCellDataFailed != getprotocolNameEditVal){
							logger.info("Successfully Removed protocol from My Fovorites");
							oPDF.enterBlockSteps(bTable,stepCount,"protocol remove verification","verify_protocol_remove_by_name","My Favorites protocol removed Successfully","Pass");
							stepCount++;	
						}
					}
				}
			}
		}
		/*
		 * 
		 */
		public void verify_protocol_add_to_favorites(String getProtocolNameSearchVal) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Protocol Type");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Protocol Name");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Protocol Abbreviation");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Version");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Protocol File");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Created Date");
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String currProtocolTableCellData = null;
			for (int i=1;i<rCount;i++){
				currProtocolTableCellData = null;
				currProtocolTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(3)"));
				logger.info("Verifying current row:["+ i +"] and Identified value:["+ currProtocolTableCellData +"]");
				if (currProtocolTableCellData.equals(getProtocolNameSearchVal)){
					logger.info("Match found on the row number:["+ i +"] and Identified value:["+ currProtocolTableCellData +"]");
					String getAddtoFavStatusVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", " ");
						   logger.info("Current row number is:["+ i +"] and the Add to Favorites status is:["+getAddtoFavStatusVal+"]");
					String getSuccessConfVal = "Edit  Added to Favorites"; 
					if (getAddtoFavStatusVal.equals(getSuccessConfVal)){
						logger.info("Protocol has been added to the My Favorites successfully");
						oPDF.enterBlockSteps(bTable,stepCount,"Protocol Add to Favorites verification","verify_protocol_add_to_favorites","Protocol:["+ currProtocolTableCellData +"] add to favorites Successfully added to the my favorites","Pass");
						stepCount++;
						break;
					}
					if (!getAddtoFavStatusVal.equals(getSuccessConfVal)){
						logger.error("User unable to add the Protocol:["+ currProtocolTableCellData +"] to the My Favorites list");
						TestExecutionException e = new TestExecutionException("Protocol Add to the Favorites verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Protocol Add to the Favorites verification","verify_protocol_add_to_favorites","Protocol:["+ currProtocolTableCellData +"] add to favorites action failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
						break;
					}
				}
		     }
		}
		/*
		 * 
		 */
		public void sample_add_to_favorites(String getSampleNameVal, String getMyFavVerificationYesOrNo, String getViewOrEditOrRemove) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Primary Point of Contact");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Composition");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Functions");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Characterizations");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Data Availability");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(8)"), "Created Date");
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String sampleTableCellData = null;
			for (int i=1;i<rCount;i++){
				sampleTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.contains(getSampleNameVal)){
					clickLink(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(3)"));
					String getFavStatusVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", " ");
						   logger.info("getFavStatusVal:["+getFavStatusVal);
					String getBuildString = "Edit "+ sampleTableCellData +" has already been added to your favorites"; 
						   //logger.info("getBuildString:["+getBuildString);
					String getSccssConfVal = "Edit Added to Favorites"; 
					if (getFavStatusVal.equals(getBuildString)){
						sampleTableCellData = null;
						sampleTableCellData = "It has been already added to the my favorites";
						logger.info("sampleTableCellData:["+sampleTableCellData);
					}
					if (getFavStatusVal.equals(getSccssConfVal)){
						verify_sample_add_to_favorites(sampleTableCellData);
						logger.info("sampleTableCellData info:["+sampleTableCellData);
						//start getMyFavVerificationYesOrNo verification
						if (getMyFavVerificationYesOrNo.isEmpty()==false){
							if (getMyFavVerificationYesOrNo.equals("yes")) {
							navigate_to_favorites_page();
							verify_my_favorites_sample(sampleTableCellData, getViewOrEditOrRemove);
							}
						}
						//end getMyFavVerificationYesOrNo verification
						break;
					}
				}
			}
		}
		/*
		 * 
		 */
		public void verify_my_favorites_sample(String getSampleNameSearchVal, String getValViewOrEditOrRemove) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			int rCount = getRowCount(By.cssSelector(".table.sample"));
			    rCount = rCount + 1;
			String sampleTableCellData = null;
			for (int i=2;i<rCount;i++){
				sampleTableCellData = getText(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.equals(getSampleNameSearchVal)){
					logger.info("Match found on the row number:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
					logger.info("Sample has been added to the My Favorites successfully");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Add to Favorites page verification","verify_my_favorites_sample","Sample:["+ sampleTableCellData +"] add to the my favorites page Successfully","Pass");
					stepCount++;
					if (getValViewOrEditOrRemove.equals("view")){
						clickLink(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(1)"));
						wait_until_element_present(By.cssSelector(".summaryViewNoGrid tbody tr th:nth-child(4)"), "Role");
					}
					if (getValViewOrEditOrRemove.equals("edit")){
						clickLink(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(2)"));
						wait_until_element_present(By.cssSelector(".cellLabel.ng-binding label"), "Keywords");
						verify_sample_edit_val(getSampleNameSearchVal);
					}					
					if (getValViewOrEditOrRemove.equals("remove")){
						clickLink(By.cssSelector(".table.sample tbody tr:nth-child("+ i +") td:nth-child(1) a:nth-child(4)"));
						checkAlertOK();
						wait_For(5000);
						verify_sample_remove_by_name(getSampleNameSearchVal);
					}
					break;
				}
		     }
		}
		/*
		 * 
		 */
		public void verify_sample_edit_val(String getSampleNameEditVal) throws TestExecutionException {
			load_text_box_value(By.id("sampleName"), "value", 1000);
			String getsampleNameVal = getAttribute(By.id("sampleName"), "value");
			logger.info("getsampleNameVal:["+getsampleNameVal);
			if (getsampleNameVal.equals(getSampleNameEditVal)){
				logger.info("Successfully Edited sample from My Fovorites");
				oPDF.enterBlockSteps(bTable,stepCount,"sample Edit verification","verify_my_favorites_sample","My Favorites sample Edited Successfully","Pass");
				stepCount++;
			} else {
				logger.error("Expected sample:["+ getSampleNameEditVal +"] and Actual sample:["+ getsampleNameVal +"] match NOT Found on the sample edit field");
				TestExecutionException e = new TestExecutionException("sample Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample Edit verification","verify_my_favorites_sample","Expected sample:["+ getSampleNameEditVal +"] and Actual sample:["+ getsampleNameVal +"] match NOT Found on the sample edit field", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void verify_sample_remove_by_name(String getsampleNameEditVal) throws TestExecutionException {
			boolean getTableValSampl = isDisplayedTrue(By.cssSelector(".table.sample"));
			logger.info("getTableValSampl:["+getTableValSampl);
			if (getTableValSampl == false){
				logger.info("Successfully Removed sample from My Fovorites");
				oPDF.enterBlockSteps(bTable,stepCount,"sample remove verification","verify_sample_remove_by_name","My Favorites sample removed Successfully","Pass");
				stepCount++;
			}
			if (getTableValSampl == true){
				int rmFSamplCount = getRowCount(By.cssSelector(".table.sample"));
				int iRSamplCount = rmFSamplCount;
				if (iRSamplCount != 0){
					iRSamplCount = iRSamplCount + 1;
				}
				String sampleTableCellDataFailed = null;
				for (int k=2;k<iRSamplCount;k++){
					sampleTableCellDataFailed = getText(By.cssSelector(".table.sample tbody tr:nth-child("+ k +") td:nth-child(2)"));
					logger.info("Curent row:["+ k +"] and Identified value:["+ sampleTableCellDataFailed +"]");
					if (sampleTableCellDataFailed.equals(getsampleNameEditVal)){
						logger.error("sample match found:["+ sampleTableCellDataFailed +"], Remove verification failed");
						TestExecutionException e = new TestExecutionException("sample Remove verification");
						oPDF.enterBlockSteps(bTable,stepCount,"sample remove verification","verify_sample_remove_by_name","sample match found:["+ sampleTableCellDataFailed +"], Remove verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
						break;
					}
					if (k == rmFSamplCount){
						if (sampleTableCellDataFailed != getsampleNameEditVal){
							logger.info("Successfully Removed sample from My Fovorites");
							oPDF.enterBlockSteps(bTable,stepCount,"sample remove verification","verify_sample_remove_by_name","My Favorites sample removed Successfully","Pass");
							stepCount++;	
						}
					}
				}
			}
		}
		/*
		 * 
		 */
		public void verify_sample_add_to_favorites(String getSampleNameSearchVal) throws TestExecutionException {
			//wait_until_element_present(By.cssSelector("table.sample.ng-scope.ng-table thead tr th:nth-child(1)"), "");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"), "Sample Name");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"), "Primary Point of Contact");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"), "Composition");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"), "Functions");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"), "Characterizations");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"), "Data Availability");
			wait_until_element_present(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(8)"), "Created Date");
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String sampleTableCellData = null;
			for (int i=1;i<rCount;i++){
				sampleTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(2)"));
				logger.info("Curent row:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
				if (sampleTableCellData.equals(getSampleNameSearchVal)){
					logger.info("Match found on the row number:["+ i +"] and Identified value:["+ sampleTableCellData +"]");
					String getFavStatusVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", " ");
						   logger.info("getFavStatusVal:["+getFavStatusVal);
					String getSccssConfVal = "Edit success"; 
					if (getFavStatusVal.equals(getSccssConfVal)){
						logger.info("Sample has been added to the My Favorites successfully");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Add to Favorites verification","verify_sample_add_to_favorites","Sample:["+ sampleTableCellData +"] add to favorites Successfully added to the my favorites","Pass");
						stepCount++;
						break;
					}
					if (getFavStatusVal != getSccssConfVal){
						logger.error("User unable to add the sample to the My Favorites");
						TestExecutionException e = new TestExecutionException("Sample Add to the Favorites verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Add to the Favorites verification","verify_sample_add_to_favorites","Sample:["+ sampleTableCellData +"] add to favorites action failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
						break;
					}
				}
		     }
		}
		/*
		 * 		
		 */
		public void navigate_to_favorites_page() throws TestExecutionException {
			click(By.linkText("MY FAVORITES"));
			// need to change the table name once updated
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "My Favorites");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(1)"), "Actions");
			wait_until_element_present(By.cssSelector(".table.sample tbody tr th:nth-child(2)"), "Sample Name");
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("My Favorites")){
				logger.info("My Favorites Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_favorites_page","My Favorites Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("My Favorites Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_favorites_page","My Favorites Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 
		 */
		public void navigate_to_groups_page() throws TestExecutionException {
			click(By.linkText("GROUPS"));
			// need to change the table name once updated
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "Manage Community");
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("Manage Community")){
				logger.info("Manage Community Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_groups_page","Manage Community Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("Manage Community Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_groups_page","Manage Community Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 
		 */
		public void navigate_to_manage_collaboration_groups_page() throws TestExecutionException {
			click(By.linkText("Manage Collaboration Groups"));
			// need to change the table name once updated
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "Manage Collaboration Groups");
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(1)"), "Name");
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(2)"), "Description");
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(3)"), "Owner");
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("Manage Collaboration Groups")){
				logger.info("Manage Collaboration Groups Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_manage_collaboration_groups_page","Manage Collaboration Groups Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("Manage Collaboration Groups Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_manage_collaboration_groups_page","Manage Collaboration Groups Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 		
		 */
		public void navigate_to_samples_page() throws TestExecutionException {
			click(By.linkText("SAMPLES"));
			wait_For(3000);
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("Manage Samples")){
				logger.info("Manage Sample Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_samples_page","Manage Sample Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("Manage Sample Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_samples_page","Manage Sample Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 
		 */
		public void navigate_to_submit_samples_page() throws TestExecutionException {
			click(By.linkText("Submit a New Sample"));
			wait_For(3000);
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("Submit Samples")){
				logger.info("Submit Sample Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_submit_samples_page","Submit Sample Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("Submit Sample Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_submit_samples_page","Submit Sample Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 
		 */
		public void navigate_to_copy_samples_page() throws TestExecutionException {
			click(By.linkText("Copy an Existing Sample"));
			wait_For(3000);
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("Copy Samples")){
				logger.info("Copy Sample Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_copy_samples_page","Copy Sample Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("Copy Sample Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_copy_samples_page","Copy Sample Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/*
		 * 
		 */
		public void navigate_to_search_existing_samples_page() throws TestExecutionException {
			click(By.linkText("Search Existing Samples"));
			wait_For(3000);
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			if (getManageSamples.equals("Samples Search")){
				logger.info("Search Sample Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_search_existing_samples_page","Search Sample Naviagation successful","Pass");
				stepCount++;						
			}else {
				logger.error("Search Sample Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification","navigate_to_search_existing_samples_page","Search Sample Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/************************************************
		 * 	caNanoLab >> Read >> Sample Name
		 ************************************************/
		public void navigate_to_advanced_sample_search_page() throws TestExecutionException {
			click(By.linkText("Advanced Sample Search"));
			wait_For(3000);
			String getManageSamples = getText(By.cssSelector(".contentTitle tbody tr th"));
			logger.info("Advanced["+ getManageSamples +"]");
			if (getManageSamples.equals("Advanced Sample Search")){
				logger.info("Advanced Sample Search Navigation Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification", "navigate_to_advanced_sample_search_page", "Search Sample Naviagation successful", "Pass");
				stepCount++;						
			}else {
				logger.error("Advanced Sample Search Navigation failed");
				TestExecutionException e = new TestExecutionException("Navigation failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Navigation verification", "navigate_to_advanced_sample_search_page", "Search Sample Naviagation failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());					
			}
		}
		/************************************************
		 * 	caNanoLab >> Search Verification
		 ************************************************/
		public void cananolab_search_verification(String verRsltFind, String verSerchTerm, String verNoSearchResult) throws TestExecutionException{
			wait_For(5000);
			element_display(By.cssSelector(".contentTitle tbody tr th"));
			element_load_by_expected_value(By.cssSelector(".contentTitle tbody tr th"), "Search Results");
			boolean verfCond = isTextPresent("No Search Results");
			if (verfCond == false){
				element_display(By.cssSelector(".table.sample.ng-scope.ng-table"));
				String readSrchTrm = read_sample_name();
				boolean gglLikSrchTabl = isDisplayed(By.cssSelector(".table.sample.ng-scope.ng-table"));
				//Result Table Exists
				if (gglLikSrchTabl == true){
					verify_google_like_search();
					// Verify Result Match
					// Find
					if (verRsltFind.equals("Find")){
						int pgCount = 100;
						int n = 0;
						int b = 0;
						for(b=1;b<pgCount;b++){
							int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
							rCount = rCount - 2;
							String ggleSearchData = null;
							String expData = null;
							for (n=1;n<rCount;n++){
								ggleSearchData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+n+") td:nth-child(3)")).toLowerCase();
								expData = readSrchTrm.toLowerCase();
								logger.info("Identified Name value as:["+ ggleSearchData +"] from the table row number:["+ n +"]");
								if (ggleSearchData.contains(expData)){
									break;
								}
						     }//n
						if (ggleSearchData.contains(expData)){
							logger.info("Successfully verified the Search value:["+readSrchTrm+"] on the search result table");
							oPDF.enterBlockSteps(bTable,stepCount,"Search verification", "cananolab_search_verification", "Successfully verified the Searched value:["+readSrchTrm+"] on the search result table, Verification Passed", "Pass");
							stepCount++;
							break;
						}
						if (!ggleSearchData.contains(expData)){
						  if (rCount == n){
							String strPgNmbr = ""+b+"";
							boolean pLnkDisp = isDisplayed(By.linkText(strPgNmbr));
							boolean pLnkEnbl = isEnabled(By.linkText(strPgNmbr));
							if (pLnkDisp == false && pLnkEnbl == false){
								logger.error("Unable to find match:["+readSrchTrm+"] on the search result table");
								TestExecutionException e = new TestExecutionException("Search Verification failed");
								oPDF.enterBlockSteps(bTable,stepCount,"Search verification", "cananolab_search_verification", "Unable to find match:["+ggleSearchData+"] on the search result table, Verification failed", "Fail");
								stepCount++;
								setupAfterSuite();	
								Assert.fail(e.getMessage());
								break;
							} else if (pLnkDisp == true && pLnkEnbl == true){
								click(By.linkText(strPgNmbr));
								n = 0;
							}
						  }
						}
						
					}//b
					}//Find
				}//Result Table Exists
			} else if (verfCond == true){
				//No Search Result
				if (verNoSearchResult.equals("No Search Results")){
					boolean srchRtrnValue = isTextPresent("No Search Results");
					if (srchRtrnValue == true){
						logger.info("No Search Results Verification successful");
						oPDF.enterBlockSteps(bTable,stepCount,"No Search Result verification", "cananolab_search_verification", "Search term:["+verSerchTerm+"] does not exists and [No Search Results] verification successful, Verification Passed", "Pass");
						stepCount++;
					} else if (srchRtrnValue == false){
						logger.error("No Search Results Verification failed");
						TestExecutionException e = new TestExecutionException("No Search Results Verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"No Search Result verification", "cananolab_search_verification", "Search term:["+verSerchTerm+"] does exists and [No Search Results] verification failed, Verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}
				}//No Search Result
			}
		}
		private enum GoogleLikeSearchTable {
		    Actions, Type, Name, CreatedDate, Description;
		}
		/************************************************
		 * 	caNanoLab >> Google like Search >> Sort
		 ************************************************/
		public void cananolab_search_sort_verify_by(String getSortVal) throws TestExecutionException {
			element_display(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String value = getSortVal;
			GoogleLikeSearchTable colNmToSort = GoogleLikeSearchTable.valueOf(value);
			switch(colNmToSort) {
			  case Actions:
				  logger.error("Actions column can not be utilize for sorting");
			      break;
			  case Type:
				  logger.info("Verifying Google Like search result sorting functionality by Type column");
				  verify_sort_by_type();
			      break;
			  case Name:
				  logger.info("Verifying Google Like search result sorting functionality by Name column");
			      verify_sort_by_name();
			      break;
			  case CreatedDate:
				  logger.info("Verifying Google Like search result sorting functionality by Created Date column");
				  verify_sort_by_created_date();
			      break;
			  case Description:
				  logger.info("Verifying Google Like search result sorting functionality by Description column");
				  verify_sort_by_description();
			      break;
			 default:
				  logger.error("Wrong inputs! Please verify inputes are matching with following inputes: Actions, Type, Name, CreatedDate, Description");
	              break;
			}
		}
		/************************************************
		 * 	caNanoLab >> Google like Search >> Sort >> Name
		 ************************************************/
		public void verify_sort_by_name() throws TestExecutionException {
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(3)"), "Name");
			String getNameVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(3)"));
			logger.info("getNameVal["+getNameVal);
			if (getNameVal.isEmpty()==false){
				click(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(3)"));
				wait_For(3000);
			}
			int loadCount = 1000;
			String getCurntVal = null;
			for(int l=1;l<loadCount;l++){
				getCurntVal = null;
				getCurntVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(3)"));
				logger.info("getCurntVal["+getCurntVal);
				if (!getNameVal.equals(getCurntVal)){
				break;
				}
			}
			if (!getNameVal.equals(getCurntVal)){
				logger.info("Name Sort Verification successful on the caNanoLab Search results page");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_name", "Name Sort Verification successful on the caNanoLab Search results page, Verification Passed", "Pass");
				stepCount++;
			} else if(getNameVal.equals(getCurntVal)){
				logger.error("Name Sort Verification failed on the caNanoLab Search results page");
				TestExecutionException e = new TestExecutionException("Sort Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_name", "Name Sort Verification failed on the caNanoLab Search results page, Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	caNanoLab >> Google like Search >> Sort >> Type
		 ************************************************/
		public void verify_sort_by_type() throws TestExecutionException {
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(2)"), "Type");
			String getTypeVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(2)"));
			logger.info("getTypeVal["+getTypeVal);
			if (getTypeVal.isEmpty()==false){
				click(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(2)"));
				wait_For(3000);
			}
			int loadTypeCount = 1000;
			String getCurntTypeVal = null;
			for(int l=1;l<loadTypeCount;l++){
				getCurntTypeVal = null;
				getCurntTypeVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(2)"));
				logger.info("getCurntTypeVal["+getCurntTypeVal);
				if (!getTypeVal.equals(getCurntTypeVal)){
				break;
				}
			}
			if (!getTypeVal.equals(getCurntTypeVal)){
				logger.info("Type Sort Verification successful on the caNanoLab Search results page");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_type", "Type Sort Verification successful on the caNanoLab Search results page, Verification Passed", "Pass");
				stepCount++;
			} else if(getTypeVal.equals(getCurntTypeVal)){
				logger.error("Type Sort Verification failed on the caNanoLab Search results page");
				TestExecutionException e = new TestExecutionException("Sort Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_type", "Type Sort Verification failed on the caNanoLab Search results page, Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	caNanoLab >> Google like Search >> Sort >> Created Date
		 ************************************************/
		public void verify_sort_by_created_date() throws TestExecutionException {
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(4)"), "Created Date");
			String getCreatedDateVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(4)"));
			logger.info("getCreatedDateVal["+getCreatedDateVal);
			if (getCreatedDateVal.isEmpty()==false){
				click(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(4)"));
				wait_For(3000);
			}
			int loadCreatedDateCount = 1000;
			String getCurntCrtdDatVal = null;
			for(int l=1;l<loadCreatedDateCount;l++){
				getCurntCrtdDatVal = null;
				getCurntCrtdDatVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(4)"));
				logger.info("getCurntCrtdDatVal["+getCurntCrtdDatVal);
				if (!getCreatedDateVal.equals(getCurntCrtdDatVal)){
				break;
				}
			}
			if (!getCreatedDateVal.equals(getCurntCrtdDatVal)){
				logger.info("Created Date Sort Verification successful on the caNanoLab Search results page");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_created_date", "Created Date Sort Verification successful on the caNanoLab Search results page, Verification Passed", "Pass");
				stepCount++;
			} else if(getCreatedDateVal.equals(getCurntCrtdDatVal)){
				logger.error("Created Date Sort Verification failed on the caNanoLab Search results page");
				TestExecutionException e = new TestExecutionException("Sort Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_created_date", "Created Date Sort Verification failed on the caNanoLab Search results page, Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	caNanoLab >> Google like Search >> Sort >> Description
		 ************************************************/
		public void verify_sort_by_description() throws TestExecutionException {
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(5)"), "Description");
			String getDescVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(5)"));
			logger.info("getDescVal["+getDescVal);
			if (getDescVal.isEmpty()==false){
				click(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(5)"));
				wait_For(3000);
			}
			int loadDescCount = 1000;
			String getDescptnVal = null;
			for(int l=1;l<loadDescCount;l++){
				getDescptnVal = null;
				getDescptnVal = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(5)"));
				logger.info("getDescptnVal["+getDescptnVal);
				if (!getDescVal.equals(getDescptnVal)){
				break;
				}
			}
			if (!getDescVal.equals(getDescptnVal)){
				logger.info("Description Sort Verification successful on the caNanoLab Search results page");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_description", "Description Sort Verification successful on the caNanoLab Search results page, Verification Passed", "Pass");
				stepCount++;
			} else if(getDescVal.equals(getDescptnVal)){
				logger.error("Description Sort Verification failed on the caNanoLab Search results page");
				TestExecutionException e = new TestExecutionException("Sort Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sort verification", "verify_sort_by_description", "Description Sort Verification failed on the caNanoLab Search results page, Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	caNanoLab >> search
		 ************************************************/
		public void cananolab_search(String vSearchEle, 
									 String getSearchTerm, 
									 String getSearchVal,
									 String getSrchRsltVerifYes,
									 String getRsltMatch,
									 String getActions) throws TestExecutionException {
			//Verify caNanoLab Search
			if (vSearchEle.isEmpty()==false){
				if (vSearchEle.equals("Yes")){
					element_display(By.id("keywordsearch"));
					element_display(By.cssSelector(".btn.btn-success.btn-xs.keyword_search"));
				}
			}
			//Enter Search Term
			if (getSearchTerm.isEmpty()==false){
				if (getSearchTerm.equals("Read")){
					String readSampleVal = read_sample_name();
					enter(By.id("keywordsearch"), readSampleVal);
				} else {
					enter(By.id("keywordsearch"), getSearchTerm);
				}
			}
			//Search
			if (getSearchVal.isEmpty()==false){
				if (getSearchVal.equals("Search")){
				click(By.cssSelector(".btn.btn-success.btn-xs.keyword_search"));
				}
			}
			//Verify Search
			if (getSrchRsltVerifYes.isEmpty()==false){
			if (getSrchRsltVerifYes.equals("Yes")){
				element_display(By.cssSelector(".table.sample.ng-scope.ng-table"));
				boolean googleLikeSearchTable = isDisplayed(By.cssSelector(".table.sample.ng-scope.ng-table"));
				if (googleLikeSearchTable == true){
					verify_google_like_search();
					// Verify Result Match
					if (getRsltMatch.equals("Yes")){
						int pgCount = 100;
						int i = 0;
						int p = 0;
						for(p=1;p<pgCount;p++){
							int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
							rCount = rCount - 2;
							String ggleSearchData = null;
							String compData = null;
								for (i=1;i<rCount;i++){
									ggleSearchData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(3)")).toLowerCase();
									compData = getSearchTerm.toLowerCase();
									logger.info("Identified Name value as:["+ ggleSearchData +"] from the table row number:["+ i +"]");
									if (ggleSearchData.contains(compData)){
										logger.info("Successfully verified the Search value:["+getSearchTerm+"] on the search result table");
										oPDF.enterBlockSteps(bTable,stepCount,"Search verification", "cananolab_search", "Successfully verified the Searched value:["+getSearchTerm+"] on the search result table, Verification Passed", "Pass");
										stepCount++;
										if (getActions.equals("View")){
											click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) div > div:nth-child(1) > a"));
										}
										if (getActions.equals("Edit")){
											click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) div > div:nth-child(2) > a"));
										}
										if (getActions.equals("Add to Favorites")){
											click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(1) a:nth-child(2)"));
										}
										break;
									}
							     }//i
						if (ggleSearchData.contains(compData)){	
							break;
						}
						if (!ggleSearchData.contains(compData)){
							if (rCount == i){
								String convPgNmbr = ""+p+"";
								boolean pgeLnkDis = isDisplayed(By.linkText(convPgNmbr));
								boolean pgeLnkEnb = isEnabled(By.linkText(convPgNmbr));
								if (pgeLnkDis == true && pgeLnkEnb == true){
									click(By.linkText(convPgNmbr));
									i = 0;
								}
								if (pgeLnkDis == false && pgeLnkEnb == false){
									logger.error("Unable to find match:["+ggleSearchData+"] on the search result table");
									TestExecutionException e = new TestExecutionException("Search Verification failed");
									oPDF.enterBlockSteps(bTable,stepCount,"Search verification", "cananolab_search", "Unable to find match:["+ggleSearchData+"] on the search result table, Verification failed", "Fail");
									stepCount++;
									setupAfterSuite();	
									Assert.fail(e.getMessage());
									break;
								}
							}
						}
						
					}//p
				}
				}
			}
			}
			//End Verify Search
		}
		/************************************************
		 * 	caNanoLab >> Manage Collaboration Groups >> Add
		 ************************************************/
		public void add_new_collaboration_group(String getCollbrtnGrpAdd, 
												String getCollbGrpName,
												String getCollbGrpDesc,
												String getAddUser,
												String getUserLoginName,
												String getSubmitOrCancel) throws TestExecutionException {
			if (getCollbrtnGrpAdd.isEmpty()==false){
				if (getCollbrtnGrpAdd.equals("Add")){
					click(By.cssSelector("#maincontent > table > tbody > tr:nth-child(2) > td > div.spacer.ng-scope > div > table.submissionView > tbody > tr:nth-child(4) > td:nth-child(2) > button"));
					element_load_by_expected_value(By.cssSelector("#maincontent > table > tbody > tr:nth-child(2) > td > div.spacer.ng-scope > div > table.submissionView > tbody > tr:nth-child(3) > td > table > tbody > tr:nth-child(1) > th"), "Collaboration Group Information");
					element_display(By.id("groupName"));
					element_display(By.id("groupDescription"));
					element_display(By.id("addUser"));
				}
			}
			//Group Name
			String geneCollbGrName = null;
			String geneCollbGrDesc = null;
			if (getCollbGrpName.isEmpty()==false){
				enter(By.id("groupName"), getCollbGrpName);
				write_group_name(getCollbGrpName);
			} else {
				geneCollbGrName = group_name();
				enter(By.id("groupName"), geneCollbGrName);
				write_group_name(geneCollbGrName);
				getCollbGrpName = geneCollbGrName;
			}
			//Group Description
			if (getCollbGrpDesc.isEmpty()==false){
				enter(By.id("groupDescription"), getCollbGrpDesc);
			} else if (getCollbGrpDesc.isEmpty()==true){
				geneCollbGrDesc = group_desc();
				enter(By.id("groupDescription"), geneCollbGrDesc);
			}
			//Add user
			if (getAddUser.equals("Add")){
				if (getUserLoginName.isEmpty()==false){
					click(By.id("addUser"));
					element_display(By.id("loginName"));
					wait_For(1000);
					enter(By.id("loginName"), getUserLoginName);
					click(By.cssSelector(".promptbox tbody tr:nth-child(1) td:nth-child(3) button"));
					select("id", "roleName", "read");
				}else{
					int totlUsr = 10;
					for (int u=1;u<totlUsr;u++){
						click(By.id("addUser"));
						element_display(By.id("loginName"));
						wait_For(1000);
						click(By.cssSelector(".promptbox tbody tr:nth-child(1) td:nth-child(3) button"));
						wait_For(5000);
						element_load(By.cssSelector(".invisibleTable tbody tr:nth-child(1) td:nth-child(2) #loginName"));
						String getUserLoginNameVal = getText(By.cssSelector(".invisibleTable tbody tr:nth-child(1) td:nth-child(2) #loginName")).replaceAll("\\n", "###");
						String getUserLoginNameVal1 = getText(By.cssSelector(".invisibleTable tbody tr:nth-child(1) td:nth-child(2) #loginName")).replaceAll("\\n", " ");
						logger.info("User Login Identified Lists:["+ getUserLoginNameVal +"]");
						String [] partsSampleUserVal = getUserLoginNameVal.split("###");
						String partsSampleUserVal1 = partsSampleUserVal[u];
						logger.info("User Login Identified:["+ partsSampleUserVal1 +"]");
						select("cssSelector", ".invisibleTable tbody tr:nth-child(1) td:nth-child(2) #loginName", partsSampleUserVal1);
						wait_For(1000);
						String loadLoginVal = getAttribute(By.cssSelector(".promptbox tbody tr:nth-child(1) td:nth-child(2) .ng-pristine.ng-valid"), "value");
						if (loadLoginVal.equals("LevineD")){
							select("id", "roleName", "read");
							wait_For(2000);
							click(By.cssSelector(".promptbox  tbody:nth-child(1)  tr:nth-child(2)  td:nth-child(2)  div:nth-child(1)  button:nth-child(2)"));
							wait_For(25000);
							click(By.cssSelector(".subSubmissionView > tbody:nth-child(1) > tr:nth-child(6) > td:nth-child(2) > button:nth-child(2)"));
							element_display_false(By.id("roleName"));
							
							wait_For(25000);
							break;
						} else {
							select("id", "roleName", "read update delete");
							wait_For(2000);
							click(By.cssSelector(".promptbox  tbody:nth-child(1)  tr:nth-child(2)  td:nth-child(2)  div:nth-child(1)  button:nth-child(2)"));
							wait_For(25000);
							element_display_false(By.id("roleName"));
						}
					}
				}
			}
			//Delete - until fix the bug
			//{{{{{{
			
			//Group Name
				enter(By.id("groupName"), geneCollbGrName);
			//Group Description
				enter(By.id("groupDescription"), geneCollbGrDesc);
			
			//}}}}}}
			
			//Submit or Cancel
			if (getSubmitOrCancel.equals("Submit")){
				int preCount = getRowCount(By.cssSelector(".editTableWithGrid"));
				click(By.cssSelector(".subSubmissionView tbody tr:nth-child(6) td:nth-child(2) button:nth-child(2)"));
				element_display_false(By.cssSelector(".subSubmissionView tbody tr:nth-child(6) td:nth-child(2) button:nth-child(2)"));
				wait_For(25000);
				verify_group_add_successful(getCollbGrpName, preCount);
			}
		}
		/************************************************
		 * 	caNanoLab >> Verify >> Add Group
		 ************************************************/
		public void verify_group_add_successful(String expCollbGroupNm, int getCount) throws TestExecutionException {
			int iteration = 1000;
			int loadCount = getCount;
			logger.info("loadCount:["+loadCount);
			int rCount = 0;
			for (int l=0;l<iteration;l++){
				rCount = 0;
				rCount = getRowCount(By.cssSelector(".editTableWithGrid"));
				logger.info("rCount:["+rCount+" loadCount:["+loadCount);
				if (rCount > loadCount){
					break;
				}
			}
			rCount = rCount + 1;
			wait_For(30000);
			String getCollbGrpActulNM = null;
			    for (int i=1;i<rCount;i++){
			    	getCollbGrpActulNM = getText(By.cssSelector(".editTableWithGrid tbody tr:nth-child("+i+") td:nth-child(1)")).replaceAll("\\n", " ");
			    	logger.info("getCollbGrpActulNM:["+getCollbGrpActulNM);
			    	if (getCollbGrpActulNM.equals(expCollbGroupNm)){
						logger.info("Successfully added collaboration Group as :["+ expCollbGroupNm +"]");
						oPDF.enterBlockSteps(bTable,stepCount,"Adding Collaboration Group verification", "verify_group_add_successful", "Successfully added collaboration Group as :["+ expCollbGroupNm +"], Verification Passed", "Pass");
						stepCount++;
						break;
			    	}
			    }
		    	if (!getCollbGrpActulNM.equals(expCollbGroupNm)){
					logger.error("Unable to add a collaboration Group as :["+ expCollbGroupNm +"]");
					TestExecutionException e = new TestExecutionException("Adding Collaboration Group Verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Adding Collaboration Group verification", "verify_group_add_successful", "Unable to add a collaboration Group as :["+ expCollbGroupNm +"], Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
		    	}
		}
		/************************************************
		 * 	caNanoLab >> String >> User Login Name
		 ************************************************/
		public String user_login_name(String getULogName) {
			   String grpUName = "";
				grpUName = "" + getULogName + "";
			   return grpUName;
		}
		/************************************************
		 * 	caNanoLab >> Generate >> Group Name
		 ************************************************/
		public String group_name() {
			   String grpName = "";
				String timeFrmt = DateHHMMSS2();
				String dateFrmt = Date_day();
				String monthFrmt = Date_Month();
				grpName = "Test " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
			   return grpName;
		}
		/************************************************
		 * 	caNanoLab >> Generate >> Group Description
		 ************************************************/
		public String group_desc() {
			   String grpDesc = "";
				String timeFrmt = DateHHMMSS2();
				String dateFrmt = Date_day();
				String monthFrmt = Date_Month();
				grpDesc = "This is a test group created on " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
			   return grpDesc;
		}
		/************************************************
		 * 	caNanoLab >> Write >> Group Name
		 ************************************************/
		public void write_group_name(String getGrpNamVal) {
		    String filePath = new File("").getAbsolutePath().toString();
		    logger.info("filePath["+filePath);
		    String rplcFilePath = filePath.replace("\\", "//");
		    logger.info("rplcFilePath["+rplcFilePath);
		    String buildPath = ""+rplcFilePath+"//AppConf//collbrtnGroups//collaborationGroup.txt";
		    logger.info("buildPath["+buildPath); 
		    String f = buildPath;
		    try {
		        FileWriter fr = new FileWriter(f);
		        BufferedWriter br = new BufferedWriter(fr);
		        br.write(getGrpNamVal); 
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		}
		/************************************************
		 * 	caNanoLab >> Read >> Group Name
		 ************************************************/
		public String read_group_name() {
		    String filePath = new File("").getAbsolutePath().toString();
		    logger.info("filePath["+filePath);
		    String rplcFilePath = filePath.replace("\\", "//");
		    logger.info("rplcFilePath["+rplcFilePath);
		    String buildPath = ""+rplcFilePath+"//AppConf//collbrtnGroups//collaborationGroup.txt";
		    logger.info("buildPath["+buildPath); 
		    String textCred = "";
		    String f = buildPath;
		    int read, N = 1024 * 1024;
		    char[] buffer = new char[N];
		    try {
		        FileReader fr = new FileReader(f);
		        BufferedReader br = new BufferedReader(fr);
		        while(true) {
		            read = br.read(buffer, 0, N);
		            textCred += new String(buffer, 0, read);
		            if(read < N) {
		                break;
		            }
		        }
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		   return textCred;
		}
		/************************************************
		 * 	caNanoLab >> Write >> Sample Name
		 ************************************************/
		public void write_sample_name(String getSampNmVal) {
		    String filePath = new File("").getAbsolutePath().toString();
		    logger.info("filePath["+filePath);
		    String rplcFilePath = filePath.replace("\\", "//");
		    logger.info("rplcFilePath["+rplcFilePath);
		    String buildPath = ""+rplcFilePath+"//AppConf//nmSamples//submitSampleName.txt";
		    logger.info("buildPath["+buildPath); 
		    String f = buildPath;
		    try {
		        FileWriter fr = new FileWriter(f);
		        BufferedWriter br = new BufferedWriter(fr);
		        br.write(getSampNmVal); 
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		}
		/************************************************
		 * 	caNanoLab >> Read >> Sample Name
		 ************************************************/
		public String read_sample_name() {
		    String filePath = new File("").getAbsolutePath().toString();
		    logger.info("filePath["+filePath);
		    String rplcFilePath = filePath.replace("\\", "//");
		    logger.info("rplcFilePath["+rplcFilePath);
		    String buildPath = ""+rplcFilePath+"//AppConf//nmSamples//submitSampleName.txt";
		    logger.info("buildPath["+buildPath); 
		    String textCred = "";
		    String f = buildPath;
		    int read, N = 1024 * 1024;
		    char[] buffer = new char[N];
		    try {
		        FileReader fr = new FileReader(f);
		        BufferedReader br = new BufferedReader(fr);
		        while(true) {
		            read = br.read(buffer, 0, N);
		            textCred += new String(buffer, 0, read);
		            if(read < N) {
		                break;
		            }
		        }
		        br.close();
		    } catch(Exception ex) {
		        ex.printStackTrace();
		    }
		   return textCred;
		}
		/*
		 * 
		 */
		public void verify_google_like_search() throws TestExecutionException {	
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(1)"), "Actions");
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(2)"), "Type");
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(3)"), "Name");
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(4)"), "Created Date");
			element_load_by_expected_value(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(5)"), "Description");
		}
		/*
		 * 
		 */
		public void advanced_sample_search(String getSampleORPOCName, String getSampCriContainsOrEqual, String getSampleCriteriaName, String getSampCriAddOrReset, 
										   String getSampleCriteriaEdit, String getSampleORPOCNameEdit, String getSampCriContainsOrEqualEdit, String getSampleCriteriaNameEdit, String getSampCriAddOrResetOrRemoveEdit,
										   String getCompositionCriteriaFilterA, String getCompositionCriteriaFilterB, String getCompositionCriteriaContainsOrEqual, String getCompositionCriteriaName, String getCompositionCriteriaAddOrReset,
										   String getCompositionCriteriaAEdit, String getCompositionCriteriaFilterAEdit, String getCompositionCriteriaFilterBEdit, String getCompositionCriteriaContainsOrEqualEdit, String getCompositionCriteriaNameEdit, String getCompositionCriteriaAddOrResetOrRemoveEdit,
										   String getCharacterizationCriteriaFilterA, String getCharacterizationCriteriaFilterB, String getCharacterizationCriteriaFilterC, 
										   String getCharacterizationCriteriaFilterD, String getCharacterizationCriteriaFilterE, String getCharacterizationCriteriaFilterF, 
										   String getCharacterizationCriteriaAddOrReset, String getCharacterizationCriteriaEdit,   
										   String getCharacterizationCriteriaFilterAEdit, String getCharacterizationCriteriaFilterBEdit, String getCharacterizationCriteriaFilterCEdit, 
										   String getCharacterizationCriteriaFilterDEdit, String getCharacterizationCriteriaFilterEEdit, String getCharacterizationCriteriaFilterFEdit,
										   String getCharacterizationCriteriaAddOrResetOrRemove, String getSearchOrReset, 
										   String verifySearchSampleValYesOrNo, String getContainsOrEqual, String selectSearchSampleValYesOrNo) throws TestExecutionException {
			String getAdvancedSampleSearch = getText(By.cssSelector(".submissionView tbody tr:nth-child(1) th:nth-child(1)"));
			logger.info("getAdvancedSampleSearch:["+getAdvancedSampleSearch);
			//Sample Criteria
			if (getSampleORPOCName.isEmpty()==false){
				wait_For(4000);
				select("id", "nameType", getSampleORPOCName);
			}
			if (getSampCriContainsOrEqual.isEmpty()==false){
				wait_For(3000);
				select("id", "sampleOperand", getSampCriContainsOrEqual);
			}
			if (getSampleCriteriaName.isEmpty()==false){
				enter(By.id("name"), getSampleCriteriaName);
			}
			if (getSampCriAddOrReset.isEmpty()==false){
				wait_For(3000);
				if (getSampCriAddOrReset.equals("Add")){
					click(By.id("sampleAdd"));
					wait_For(3000);
				}
				if (getSampCriAddOrReset.equals("Reset")){
					click(By.id("sampleReset"));
					wait_For(3000);
				}
			}
			if (getSampleCriteriaEdit.isEmpty()==false){
				if (getSampleCriteriaEdit.equals("Edit")){
					click(By.id("sampleEdit"));
					wait_For(3000);
					if (getSampleCriteriaEdit.equals("Edit")){
						String getSampleTextAttribt = getAttribute(By.id("name"), "value");
						logger.info("getSampleTextAttribt:["+getSampleTextAttribt);
						if (getSampleTextAttribt.isEmpty()==false){
							logger.info("Sample Criteria Edit successful to the Advanced Search Query");
							oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria Edit successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
							stepCount++;
						} else if (getSampleTextAttribt.isEmpty()==true){
							logger.error("Sample Criteria failed to Edit to the Advanced Search Query");
							TestExecutionException e = new TestExecutionException("Sample Criteria failed to Edit to the Advanced Search Query");
							oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to Edit to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
							stepCount++;
							setupAfterSuite();	
							Assert.fail(e.getMessage());
						}
					}
					if (getSampleORPOCNameEdit.isEmpty()==false){
						getSampleORPOCName = null;
						getSampleORPOCName = ""+ getSampleORPOCNameEdit +"";
						wait_For(3000);
						select("id", "nameType", getSampleORPOCNameEdit);
					}
					if (getSampCriContainsOrEqualEdit.isEmpty()==false){
						getSampCriContainsOrEqual = null;
						getSampCriContainsOrEqual = ""+ getSampCriContainsOrEqualEdit +"";
						wait_For(3000);
						select("id", "sampleOperand", getSampCriContainsOrEqualEdit);
					}
					if (getSampleCriteriaNameEdit.isEmpty()==false){
						getSampleCriteriaName = null; 
						getSampleCriteriaName = ""+ getSampleCriteriaNameEdit +""; 
						wait_For(3000);
						enter(By.id("name"), getSampleCriteriaNameEdit);
					}
					if (getSampCriAddOrResetOrRemoveEdit.isEmpty()==false){
						wait_For(3000);
						if (getSampCriAddOrResetOrRemoveEdit.equals("Add")){
							click(By.id("sampleAdd"));
							wait_For(3000);
							boolean getSampCriteria = isDisplayedTrue(By.cssSelector("#samplePattern td:nth-child(1)"));
							if (getSampCriteria == true){
								String getSampleCriteriaSampleName = getText(By.cssSelector("#samplePattern td:nth-child(3)")).replaceAll("\\n", "");
									logger.info("getSampleCriteriaSampleName["+getSampleCriteriaSampleName);
								String getSampleCriteriaSampleSelectContainsName = getText(By.cssSelector("#samplePattern td:nth-child(2)")).replaceAll("\\n", "");
									logger.info("getSampleCriteriaSampleSelectContainsName["+getSampleCriteriaSampleSelectContainsName);
								String getSampleCriteriaSampleSelectSampleName = getText(By.cssSelector("#samplePattern td:nth-child(1)")).replaceAll("\\n", "");
									logger.info("getSampleCriteriaSampleSelectSampleName["+getSampleCriteriaSampleSelectSampleName);
								if (getSampleCriteriaSampleName.equals(getSampleCriteriaName) 
									&& getSampleCriteriaSampleSelectContainsName.equals(getSampCriContainsOrEqual)	
									&& getSampleCriteriaSampleSelectSampleName.equals(getSampleORPOCName)){
									logger.info("Sample Criteria Added successful to the Advanced Search Query");
									logger.info("Expected:["+getSampleCriteriaSampleName +"] Actual: ["+ getSampleCriteriaName +"]");
									logger.info("Expected:["+getSampleCriteriaSampleSelectContainsName +"] Actual: ["+ getSampCriContainsOrEqual +"]");
									logger.info("Expected:["+getSampleCriteriaSampleSelectSampleName +"] Actual: ["+ getSampleORPOCName +"]");
									oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria Added successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
									stepCount++;						
								}else {
									logger.error("Sample Criteria failed to add to the Advanced Search Query");
									logger.info("Expected:["+getSampleCriteriaSampleName +"] Actual: ["+ getSampleCriteriaName +"]");
									logger.info("Expected:["+getSampleCriteriaSampleSelectContainsName +"] Actual: ["+ getSampCriContainsOrEqual +"]");
									logger.info("Expected:["+getSampleCriteriaSampleSelectSampleName +"] Actual: ["+ getSampleORPOCName +"]");
									TestExecutionException e = new TestExecutionException("Sample Criteria failed to add to the Advanced Search Query");
									oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
									stepCount++;
									setupAfterSuite();	
									Assert.fail(e.getMessage());					
								}
							} else {
								logger.error("Sample Criteria failed to add to the Advanced Search Query");
								TestExecutionException e = new TestExecutionException("Sample Criteria failed to add to the Advanced Search Query");
								oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
								stepCount++;
								setupAfterSuite();	
								Assert.fail(e.getMessage());
							}
						}
						if (getSampCriAddOrResetOrRemoveEdit.equals("Reset")){
							click(By.id("sampleReset"));
							wait_For(3000);
						}
						if (getSampCriAddOrResetOrRemoveEdit.equals("Remove")){
							click(By.id("sampleRemove"));
							wait_For(5000);
						}
					}
				}
			}
			if (getSampCriAddOrReset.equals("Add") && getSampCriAddOrResetOrRemoveEdit.isEmpty() == true){
				boolean getSampCriteria = isDisplayedTrue(By.cssSelector("#samplePattern td:nth-child(1)"));
				if (getSampCriteria == true){
					String getSampleCriteriaSampleName = getText(By.cssSelector("#samplePattern td:nth-child(3)")).replaceAll("\\n", "");
						logger.info("getSampleCriteriaSampleName["+getSampleCriteriaSampleName);
					String getSampleCriteriaSampleSelectContainsName = getText(By.cssSelector("#samplePattern td:nth-child(2)")).replaceAll("\\n", "");
						logger.info("getSampleCriteriaSampleSelectContainsName["+getSampleCriteriaSampleSelectContainsName);
					String getSampleCriteriaSampleSelectSampleName = getText(By.cssSelector("#samplePattern td:nth-child(1)")).replaceAll("\\n", "");
						logger.info("getSampleCriteriaSampleSelectSampleName["+getSampleCriteriaSampleSelectSampleName);
					if (getSampleCriteriaSampleName.equals(getSampleCriteriaName) 
						&& getSampleCriteriaSampleSelectContainsName.equals(getSampCriContainsOrEqual)	
						&& getSampleCriteriaSampleSelectSampleName.equals(getSampleORPOCName)){
						logger.info("Sample Criteria Added successful to the Advanced Search Query");
						logger.info("Expected:["+getSampleCriteriaSampleName +"] Actual: ["+ getSampleCriteriaName +"]");
						logger.info("Expected:["+getSampleCriteriaSampleSelectContainsName +"] Actual: ["+ getSampCriContainsOrEqual +"]");
						logger.info("Expected:["+getSampleCriteriaSampleSelectSampleName +"] Actual: ["+ getSampleORPOCName +"]");
						oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria Added successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
						stepCount++;						
					}else {
						logger.error("Sample Criteria failed to add to the Advanced Search Query");
						logger.info("Expected:["+getSampleCriteriaSampleName +"] Actual: ["+ getSampleCriteriaName +"]");
						logger.info("Expected:["+getSampleCriteriaSampleSelectContainsName +"] Actual: ["+ getSampCriContainsOrEqual +"]");
						logger.info("Expected:["+getSampleCriteriaSampleSelectSampleName +"] Actual: ["+ getSampleORPOCName +"]");
						TestExecutionException e = new TestExecutionException("Sample Criteria failed to add to the Advanced Search Query");
						oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());					
					}
				} else {
					logger.error("Sample Criteria failed to add to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Sample Criteria failed to add to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getSampCriAddOrReset.equals("Reset")){
				String getSampleTextAttribt = getAttribute(By.id("name"), "value");
				logger.info("getSampleTextAttribt:["+getSampleTextAttribt);
				if (getSampleTextAttribt.isEmpty()==true){
					logger.info("Sample Criteria Reset successful to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria Reset successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
					stepCount++;
				} else if (getSampleTextAttribt.isEmpty()==false){
					logger.error("Sample Criteria failed to Reset to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Sample Criteria failed to Reset to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to Reset to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getSampCriAddOrResetOrRemoveEdit.equals("Remove")){
				String getRemSampleTextAttribt = getAttribute(By.id("name"), "value");
				boolean getRmSampVal = isDisplayedTrue(By.cssSelector("#samplePattern td:nth-child(3)"));
				logger.info("getSampleTextAttribt:["+getRemSampleTextAttribt);
				if (getRemSampleTextAttribt.isEmpty()==true && getRmSampVal == false){
					logger.info("Sample Criteria Remove successful to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria Remove successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
					stepCount++;
				} else if (getRemSampleTextAttribt.isEmpty()==false && getRmSampVal == true){
					logger.error("Sample Criteria failed to Remove to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Sample Criteria failed to Remove to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Criteria failed to Remove to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			//Composition Criteria
			if (getCompositionCriteriaFilterA.isEmpty()==false){
				select("id", "compType", getCompositionCriteriaFilterA);
				wait_For(3000);
			}
			if (getCompositionCriteriaFilterB.isEmpty()==false){
				wait_For(3000);
				select("id", "entityType", getCompositionCriteriaFilterB);
			}
			if (getCompositionCriteriaContainsOrEqual.isEmpty()==false){
				select("id", "compOperand", getCompositionCriteriaContainsOrEqual);
				wait_For(300);
			}
			if (getCompositionCriteriaName.isEmpty()==false){
				enter(By.id("chemicalName"), getCompositionCriteriaName);
			}
			if (getCompositionCriteriaAddOrReset.isEmpty()==false){
				wait_For(3000);
				if (getCompositionCriteriaAddOrReset.equals("Add")){
					click(By.id("compositionAdd"));
					wait_For(3000);
				}
				if (getCompositionCriteriaAddOrReset.equals("Reset")){
					click(By.id("compositionReset"));
					wait_For(3000);
				}
			}
			if (getCompositionCriteriaAEdit.isEmpty()==false){
				if (getCompositionCriteriaAEdit.equals("Edit")){
					click(By.id("compositionEdit"));
					wait_For(3000);
					if (getCompositionCriteriaAEdit.equals("Edit")){
						String getCompTextAttribt = getAttribute(By.id("chemicalName"), "value");
						logger.info("getCompTextAttribt:["+getCompTextAttribt);
						if (getCompTextAttribt.isEmpty()==false){
							logger.info("Composition Criteria Edit successful to the Advanced Search Query");
							oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria Edit successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
							stepCount++;	
						} else if (getCompTextAttribt.isEmpty()==true){
							logger.error("Composition Criteria failed to Edit to the Advanced Search Query");
							TestExecutionException e = new TestExecutionException("Composition Criteria failed to Edit to the Advanced Search Query");
							oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to Edit to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
							stepCount++;
							setupAfterSuite();	
							Assert.fail(e.getMessage());
						}
					}
					if (getCompositionCriteriaFilterAEdit.isEmpty()==false){
						getCompositionCriteriaFilterA = null;
						getCompositionCriteriaFilterA = ""+ getCompositionCriteriaFilterAEdit +"";
						select("id", "compType", getCompositionCriteriaFilterAEdit);
						wait_For(3000);
					}
					if (getCompositionCriteriaFilterBEdit.isEmpty()==false){
						getCompositionCriteriaFilterB = null;
						getCompositionCriteriaFilterB = ""+ getCompositionCriteriaFilterBEdit +"";
						wait_For(3000);
						select("id", "entityType", getCompositionCriteriaFilterBEdit);
					}
					if (getCompositionCriteriaContainsOrEqualEdit.isEmpty()==false){
						getCompositionCriteriaContainsOrEqual = null;
						getCompositionCriteriaContainsOrEqual = ""+ getCompositionCriteriaContainsOrEqualEdit +"";
						select("id", "compOperand", getCompositionCriteriaContainsOrEqualEdit);
						wait_For(300);
					}
					if (getCompositionCriteriaName.isEmpty()==false){
						getCompositionCriteriaName = null;
						getCompositionCriteriaName = ""+ getCompositionCriteriaNameEdit +"";
						enter(By.id("chemicalName"), getCompositionCriteriaNameEdit);
					}
					if (getCompositionCriteriaAddOrResetOrRemoveEdit.isEmpty()==false){
						wait_For(3000);
						if (getCompositionCriteriaAddOrResetOrRemoveEdit.equals("Add")){
							click(By.id("compositionAdd"));
							wait_For(3000);
							boolean getCompCriteria = isDisplayedTrue(By.cssSelector("#compPattern td:nth-child(1)"));
							if (getCompCriteria == true){
								String getValgetCompositionCriteriaFilterA = getText(By.cssSelector("#compPattern td:nth-child(1)")).replaceAll("\\n", "");
									logger.info("getValgetCompositionCriteriaFilterA["+getValgetCompositionCriteriaFilterA);
								String getValgetCompositionCriteriaFilterB = getText(By.cssSelector("#compPattern td:nth-child(2)")).replaceAll("\\n", "");
									logger.info("getValgetCompositionCriteriaFilterB["+getValgetCompositionCriteriaFilterB);
								String getValgetCompositionCriteriaContainsOrEqual = getText(By.cssSelector("#compPattern td:nth-child(3)")).replaceAll("\\n", "");
									logger.info("getValgetCompositionCriteriaContainsOrEqual["+getValgetCompositionCriteriaContainsOrEqual);
								String getValgetCompositionCriteriaName = getText(By.cssSelector("#compPattern td:nth-child(4)")).replaceAll("\\n", "");
									logger.info("getValgetCompositionCriteriaName["+getValgetCompositionCriteriaName);
								if (getValgetCompositionCriteriaFilterA.equals(getCompositionCriteriaFilterA) 
								 && getValgetCompositionCriteriaFilterB.equals(getCompositionCriteriaFilterB)
								 && getValgetCompositionCriteriaContainsOrEqual.equals(getCompositionCriteriaContainsOrEqual)
								 && getValgetCompositionCriteriaName.equals(getCompositionCriteriaName)) {
									logger.info("Composition Criteria Added successful to the Advanced Search Query");
									logger.info("Expected:["+getValgetCompositionCriteriaFilterA +"] Actual: ["+ getCompositionCriteriaFilterA +"]");
									logger.info("Expected:["+getValgetCompositionCriteriaFilterB +"] Actual: ["+ getCompositionCriteriaFilterB +"]");
									logger.info("Expected:["+getValgetCompositionCriteriaContainsOrEqual +"] Actual: ["+ getCompositionCriteriaContainsOrEqual +"]");
									logger.info("Expected:["+getValgetCompositionCriteriaName +"] Actual: ["+ getCompositionCriteriaName +"]");
									oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria Added successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
									stepCount++;						
								}else {
									logger.error("Composition Criteria failed to add to the Advanced Search Query");
									logger.info("Expected:["+getValgetCompositionCriteriaFilterA +"] Actual: ["+ getCompositionCriteriaFilterA +"]");
									logger.info("Expected:["+getValgetCompositionCriteriaFilterB +"] Actual: ["+ getCompositionCriteriaFilterB +"]");
									logger.info("Expected:["+getValgetCompositionCriteriaContainsOrEqual +"] Actual: ["+ getCompositionCriteriaContainsOrEqual +"]");
									logger.info("Expected:["+getValgetCompositionCriteriaName +"] Actual: ["+ getCompositionCriteriaName +"]");
									TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
									oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
									stepCount++;
									setupAfterSuite();	
									Assert.fail(e.getMessage());					
								}
							} else {
								logger.error("Composition Criteria failed to add to the Advanced Search Query");
								TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
								oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
								stepCount++;
								setupAfterSuite();	
								Assert.fail(e.getMessage());
							}
						}
						if (getCompositionCriteriaAddOrResetOrRemoveEdit.equals("Reset")){
							click(By.id("compositionReset"));
							wait_For(3000);
						}
						if (getCompositionCriteriaAddOrResetOrRemoveEdit.equals("Remove")){
							click(By.id("compositionRemove"));
							wait_For(5000);
						}
					}
				}
			}
			if (getCompositionCriteriaAddOrReset.equals("Add") && getCompositionCriteriaAddOrResetOrRemoveEdit.isEmpty() == true){
				boolean getCompCriteria = isDisplayedTrue(By.cssSelector("#compPattern td:nth-child(1)"));
				if (getCompCriteria == true){
					String getValgetCompositionCriteriaFilterA = getText(By.cssSelector("#compPattern td:nth-child(1)")).replaceAll("\\n", "");
						logger.info("getValgetCompositionCriteriaFilterA["+getValgetCompositionCriteriaFilterA);
					String getValgetCompositionCriteriaFilterB = getText(By.cssSelector("#compPattern td:nth-child(2)")).replaceAll("\\n", "");
						logger.info("getValgetCompositionCriteriaFilterB["+getValgetCompositionCriteriaFilterB);
					String getValgetCompositionCriteriaContainsOrEqual = getText(By.cssSelector("#compPattern td:nth-child(3)")).replaceAll("\\n", "");
						logger.info("getValgetCompositionCriteriaContainsOrEqual["+getValgetCompositionCriteriaContainsOrEqual);
					String getValgetCompositionCriteriaName = getText(By.cssSelector("#compPattern td:nth-child(4)")).replaceAll("\\n", "");
						logger.info("getValgetCompositionCriteriaName["+getValgetCompositionCriteriaName);
					if (getValgetCompositionCriteriaFilterA.equals(getCompositionCriteriaFilterA) 
					 && getValgetCompositionCriteriaFilterB.equals(getCompositionCriteriaFilterB)
					 && getValgetCompositionCriteriaContainsOrEqual.equals(getCompositionCriteriaContainsOrEqual)
					 && getValgetCompositionCriteriaName.equals(getCompositionCriteriaName)) {
						logger.info("Composition Criteria Added successful to the Advanced Search Query");
						logger.info("Expected:["+getValgetCompositionCriteriaFilterA +"] Actual: ["+ getCompositionCriteriaFilterA +"]");
						logger.info("Expected:["+getValgetCompositionCriteriaFilterB +"] Actual: ["+ getCompositionCriteriaFilterB +"]");
						logger.info("Expected:["+getValgetCompositionCriteriaContainsOrEqual +"] Actual: ["+ getCompositionCriteriaContainsOrEqual +"]");
						logger.info("Expected:["+getValgetCompositionCriteriaName +"] Actual: ["+ getCompositionCriteriaName +"]");
						oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria Added successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
						stepCount++;						
					}else {
						logger.error("Composition Criteria failed to add to the Advanced Search Query");
						logger.info("Expected:["+getValgetCompositionCriteriaFilterA +"] Actual: ["+ getCompositionCriteriaFilterA +"]");
						logger.info("Expected:["+getValgetCompositionCriteriaFilterB +"] Actual: ["+ getCompositionCriteriaFilterB +"]");
						logger.info("Expected:["+getValgetCompositionCriteriaContainsOrEqual +"] Actual: ["+ getCompositionCriteriaContainsOrEqual +"]");
						logger.info("Expected:["+getValgetCompositionCriteriaName +"] Actual: ["+ getCompositionCriteriaName +"]");
						TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
						oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());					
					}
				} else {
					logger.error("Composition Criteria failed to add to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getCompositionCriteriaAddOrReset.equals("Reset")){
				String getCompTextAttribt = getAttribute(By.id("chemicalName"), "value");
				logger.info("getCompTextAttribt:["+getCompTextAttribt);
				if (getCompTextAttribt.isEmpty()==true){
					logger.info("Composition Criteria Reset successful to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria Reset successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
					stepCount++;	
				} else if (getCompTextAttribt.isEmpty()==false){
					logger.error("Composition Criteria failed to Reset to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Composition Criteria failed to Reset to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to Reset to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getCompositionCriteriaAddOrResetOrRemoveEdit.equals("Remove")){
				String getCompTextAttribt = getAttribute(By.id("chemicalName"), "value");
				boolean getRmVal = isDisplayedTrue(By.cssSelector("#compPattern td:nth-child(1)"));
				logger.info("getCompTextAttribt:["+getCompTextAttribt);
				if (getCompTextAttribt.isEmpty()==true && getRmVal == false){
					logger.info("Composition Criteria Remove successful to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria Remove successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
					stepCount++;	
				} else if (getCompTextAttribt.isEmpty()==false){
					logger.error("Composition Criteria failed to Remove to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Composition Criteria failed to Remove to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Composition Criteria failed to Remove to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			//Characterization Criteria 
			if (getCharacterizationCriteriaFilterA.isEmpty()==false){
				select("id", "charType", getCharacterizationCriteriaFilterA);
				wait_For(4000);
			}
			if (getCharacterizationCriteriaFilterB.isEmpty()==false){
				select("id", "charName", getCharacterizationCriteriaFilterB);
				wait_For(4000);
			}
			if (getCharacterizationCriteriaFilterC.isEmpty()==false){
				select("id", "datumName", getCharacterizationCriteriaFilterC);
				wait_For(4000);
				//molecular weight
				if (getCharacterizationCriteriaFilterD.isEmpty()==false){
					select("id", "charOperand", getCharacterizationCriteriaFilterD);
				}
				if (getCharacterizationCriteriaFilterE.isEmpty()==false){
					enter(By.id("datumValue"), getCharacterizationCriteriaFilterE);
				}
				if (getCharacterizationCriteriaFilterF.isEmpty()==false){
					select("id", "datumValueUnit", getCharacterizationCriteriaFilterF);
				}
			}
			if (getCharacterizationCriteriaAddOrReset.isEmpty()==false){
				wait_For(3000);
				if (getCharacterizationCriteriaAddOrReset.equals("Add")){
					click(By.id("characterizationAdd"));
					wait_For(3000);
				}
				if (getCharacterizationCriteriaAddOrReset.equals("Reset")){
					click(By.id("characterizationReset"));
					wait_For(3000);
				}
			}
			if (getCharacterizationCriteriaEdit.isEmpty()==false) {
				if (getCharacterizationCriteriaEdit.equals("Edit")){
					click(By.id("characterizationEdit"));
					wait_For(3000);
					if (getCharacterizationCriteriaEdit.equals("Edit")){
						String getCharactTextAttribt = getAttribute(By.id("datumValue"), "value");
						logger.info("getCharactTextAttribt:["+getCharactTextAttribt);
						if (getCharactTextAttribt.isEmpty()==false){
							logger.info("Characterization Criteria Edit is successful to the Advanced Search Query");
							oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria Edit is successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
							stepCount++;		
						} else if (getCharactTextAttribt.isEmpty()==true){
							logger.error("Characterization Criteria failed to Edit to the Advanced Search Query");
							TestExecutionException e = new TestExecutionException("Composition Criteria failed to Edit to the Advanced Search Query");
							oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to Edit to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
							stepCount++;
							setupAfterSuite();	
							Assert.fail(e.getMessage());
						}
					}
					if (getCharacterizationCriteriaFilterAEdit.isEmpty()==false){
						getCharacterizationCriteriaFilterA = null;
						getCharacterizationCriteriaFilterA = ""+ getCharacterizationCriteriaFilterAEdit +"";
						select("id", "charType", getCharacterizationCriteriaFilterAEdit);
						wait_For(4000);
					}
					if (getCharacterizationCriteriaFilterBEdit.isEmpty()==false){
						getCharacterizationCriteriaFilterB = null;
						getCharacterizationCriteriaFilterB = ""+ getCharacterizationCriteriaFilterBEdit +"";
						select("id", "charName", getCharacterizationCriteriaFilterBEdit);
						wait_For(4000);
					}
					if (getCharacterizationCriteriaFilterCEdit.isEmpty()==false){
						getCharacterizationCriteriaFilterC = null;
						getCharacterizationCriteriaFilterC = ""+ getCharacterizationCriteriaFilterCEdit +"";
						select("id", "datumName", getCharacterizationCriteriaFilterCEdit);
						wait_For(4000);
						//molecular weight
						if (getCharacterizationCriteriaFilterDEdit.isEmpty()==false){
							getCharacterizationCriteriaFilterD = null;
							getCharacterizationCriteriaFilterD = ""+ getCharacterizationCriteriaFilterDEdit +"";
							select("id", "charOperand", getCharacterizationCriteriaFilterDEdit);
						}
						if (getCharacterizationCriteriaFilterEEdit.isEmpty()==false){
							getCharacterizationCriteriaFilterE = null;
							getCharacterizationCriteriaFilterE = ""+ getCharacterizationCriteriaFilterEEdit +"";
							enter(By.id("datumValue"), getCharacterizationCriteriaFilterEEdit);
						}
						if (getCharacterizationCriteriaFilterFEdit.isEmpty()==false){
							getCharacterizationCriteriaFilterF = null;
							getCharacterizationCriteriaFilterF = ""+ getCharacterizationCriteriaFilterFEdit +"";
							select("id", "datumValueUnit", getCharacterizationCriteriaFilterFEdit);
						}
					}
					if (getCharacterizationCriteriaAddOrResetOrRemove.isEmpty()==false){
						wait_For(3000);
						if (getCharacterizationCriteriaAddOrResetOrRemove.equals("Add")){
							click(By.id("characterizationAdd"));
							wait_For(3000);
							boolean getCharactCriteria = isDisplayedTrue(By.cssSelector("#charPattern td:nth-child(1)"));
							if (getCharactCriteria == true){
								String getValgetCharacterizationCriteriaFilterA = getText(By.cssSelector("#charPattern td:nth-child(1)")).replaceAll("\\n", "");
									logger.info("getValgetCharacterizationCriteriaFilterA["+getValgetCharacterizationCriteriaFilterA);
								String getValgetCharacterizationCriteriaFilterB = getText(By.cssSelector("#charPattern td:nth-child(2)")).replaceAll("\\n", "");
									logger.info("getValgetCharacterizationCriteriaFilterB["+getValgetCharacterizationCriteriaFilterB);
								String getValgetCharacterizationCriteriaFilterC = getText(By.cssSelector("#charPattern td:nth-child(3)")).replaceAll("\\n", "");
									logger.info("getValgetCharacterizationCriteriaFilterC["+getValgetCharacterizationCriteriaFilterC);
								String getValgetCharacterizationCriteriaFilterD = getText(By.cssSelector("#charPattern td:nth-child(4)")).replaceAll("\\n", "");
									logger.info("getValgetCharacterizationCriteriaFilterD["+getValgetCharacterizationCriteriaFilterD);
								String getValgetCharacterizationCriteriaFilterE = getText(By.cssSelector("#charPattern td:nth-child(5)")).replaceAll("\\n", "");
									logger.info("getValgetCharacterizationCriteriaFilterE["+getValgetCharacterizationCriteriaFilterE);
								String getValgetCharacterizationCriteriaFilterF = getText(By.cssSelector("#charPattern td:nth-child(6)")).replaceAll("\\n", "");
									logger.info("getValgetCharacterizationCriteriaFilterF["+getValgetCharacterizationCriteriaFilterF);
								String replaceVal1 = getCharacterizationCriteriaFilterC.replaceAll("\\W", "");
									logger.info("replaceVal1:"+replaceVal1);
								getCharacterizationCriteriaFilterC = null;
								getCharacterizationCriteriaFilterC = ""+ replaceVal1 +"";
									logger.info("getCharacterizationCriteriaFilterC:"+getCharacterizationCriteriaFilterC);
								if (getValgetCharacterizationCriteriaFilterA.contains(getCharacterizationCriteriaFilterA) 
								 && getValgetCharacterizationCriteriaFilterB.contains(getCharacterizationCriteriaFilterB)
								 && getValgetCharacterizationCriteriaFilterC.contains(getCharacterizationCriteriaFilterC)
								 && getValgetCharacterizationCriteriaFilterD.contains(getCharacterizationCriteriaFilterD)
								 && getValgetCharacterizationCriteriaFilterE.contains(getCharacterizationCriteriaFilterE)
								 && getValgetCharacterizationCriteriaFilterF.contains(getCharacterizationCriteriaFilterF)){
									logger.info("Characterization Criteria Added successful to the Advanced Search Query");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterA +"] Actual: ["+ getCharacterizationCriteriaFilterA +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterB +"] Actual: ["+ getCharacterizationCriteriaFilterB +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterC +"] Actual: ["+ getCharacterizationCriteriaFilterC +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterD +"] Actual: ["+ getCharacterizationCriteriaFilterD +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterE +"] Actual: ["+ getCharacterizationCriteriaFilterE +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterF +"] Actual: ["+ getCharacterizationCriteriaFilterF +"]");
									oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria Added successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
									stepCount++;						
								}else {
									logger.error("Characterization Criteria failed to add to the Advanced Search Query");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterA +"] Actual: ["+ getCharacterizationCriteriaFilterA +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterB +"] Actual: ["+ getCharacterizationCriteriaFilterB +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterC +"] Actual: ["+ getCharacterizationCriteriaFilterC +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterD +"] Actual: ["+ getCharacterizationCriteriaFilterD +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterE +"] Actual: ["+ getCharacterizationCriteriaFilterE +"]");
									logger.info("Expected:["+getValgetCharacterizationCriteriaFilterF +"] Actual: ["+ getCharacterizationCriteriaFilterF +"]");
									TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
									oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
									stepCount++;
									setupAfterSuite();	
									Assert.fail(e.getMessage());					
								}
							} else {
								logger.error("Composition Criteria failed to add to the Advanced Search Query");
								TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
								oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
								stepCount++;
								setupAfterSuite();	
								Assert.fail(e.getMessage());
							}
						}
						if (getCharacterizationCriteriaAddOrResetOrRemove.equals("Reset")){
							click(By.id("characterizationReset"));
							wait_For(3000);
						}
						if (getCharacterizationCriteriaAddOrResetOrRemove.equals("Remove")){
							click(By.id("characterizationRemove"));
							wait_For(3000);
						}
					}

				}
			}
			if (getCharacterizationCriteriaAddOrReset.equals("Add") && getCharacterizationCriteriaAddOrResetOrRemove.isEmpty() == true){
				boolean getCharactCriteria = isDisplayedTrue(By.cssSelector("#charPattern td:nth-child(1)"));
				if (getCharactCriteria == true){
					String getValgetCharacterizationCriteriaFilterA = getText(By.cssSelector("#charPattern td:nth-child(1)")).replaceAll("\\n", "");
						logger.info("getValgetCharacterizationCriteriaFilterA["+getValgetCharacterizationCriteriaFilterA);
					String getValgetCharacterizationCriteriaFilterB = getText(By.cssSelector("#charPattern td:nth-child(2)")).replaceAll("\\n", "");
						logger.info("getValgetCharacterizationCriteriaFilterB["+getValgetCharacterizationCriteriaFilterB);
					String getValgetCharacterizationCriteriaFilterC = getText(By.cssSelector("#charPattern td:nth-child(3)")).replaceAll("\\n", "");
						logger.info("getValgetCharacterizationCriteriaFilterC["+getValgetCharacterizationCriteriaFilterC);
					String getValgetCharacterizationCriteriaFilterD = getText(By.cssSelector("#charPattern td:nth-child(4)")).replaceAll("\\n", "");
						logger.info("getValgetCharacterizationCriteriaFilterD["+getValgetCharacterizationCriteriaFilterD);
					String getValgetCharacterizationCriteriaFilterE = getText(By.cssSelector("#charPattern td:nth-child(5)")).replaceAll("\\n", "");
						logger.info("getValgetCharacterizationCriteriaFilterE["+getValgetCharacterizationCriteriaFilterE);
					String getValgetCharacterizationCriteriaFilterF = getText(By.cssSelector("#charPattern td:nth-child(6)")).replaceAll("\\n", "");
						logger.info("getValgetCharacterizationCriteriaFilterF["+getValgetCharacterizationCriteriaFilterF);
					String replaceVal1 = getCharacterizationCriteriaFilterC.replaceAll("\\W", "");
						logger.info("replaceVal1:"+replaceVal1);
					getCharacterizationCriteriaFilterC = null;
					getCharacterizationCriteriaFilterC = ""+ replaceVal1 +"";
						logger.info("getCharacterizationCriteriaFilterC:"+getCharacterizationCriteriaFilterC);
					if (getValgetCharacterizationCriteriaFilterA.equals(getCharacterizationCriteriaFilterA) 
					 && getValgetCharacterizationCriteriaFilterB.equals(getCharacterizationCriteriaFilterB)
					 && getValgetCharacterizationCriteriaFilterC.equals(getCharacterizationCriteriaFilterC)
					 && getValgetCharacterizationCriteriaFilterD.equals(getCharacterizationCriteriaFilterD)
					 && getValgetCharacterizationCriteriaFilterE.equals(getCharacterizationCriteriaFilterE)
					 && getValgetCharacterizationCriteriaFilterF.equals(getCharacterizationCriteriaFilterF)){
						logger.info("Characterization Criteria Added successful to the Advanced Search Query");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterA +"] Actual: ["+ getCharacterizationCriteriaFilterA +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterB +"] Actual: ["+ getCharacterizationCriteriaFilterB +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterC +"] Actual: ["+ getCharacterizationCriteriaFilterC +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterD +"] Actual: ["+ getCharacterizationCriteriaFilterD +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterE +"] Actual: ["+ getCharacterizationCriteriaFilterE +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterF +"] Actual: ["+ getCharacterizationCriteriaFilterF +"]");
						oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria Added successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
						stepCount++;						
					}else {
						logger.error("Characterization Criteria failed to add to the Advanced Search Query");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterA +"] Actual: ["+ getCharacterizationCriteriaFilterA +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterB +"] Actual: ["+ getCharacterizationCriteriaFilterB +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterC +"] Actual: ["+ getCharacterizationCriteriaFilterC +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterD +"] Actual: ["+ getCharacterizationCriteriaFilterD +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterE +"] Actual: ["+ getCharacterizationCriteriaFilterE +"]");
						logger.info("Expected:["+getValgetCharacterizationCriteriaFilterF +"] Actual: ["+ getCharacterizationCriteriaFilterF +"]");
						TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
						oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());					
					}
				} else {
					logger.error("Characterization Criteria failed to add to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Composition Criteria failed to add to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to add to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getCharacterizationCriteriaAddOrReset.equals("Reset")){
				boolean getCharactTextAttribt = isDisplayedTrue(By.id("datumValue"));
				logger.info("getCharactTextAttribt:["+getCharactTextAttribt);
				if (getCharactTextAttribt == false){
					logger.info("Characterization Criteria Reset successful to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria Reset successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
					stepCount++;		
				} else if (getCharactTextAttribt == true){
					logger.error("Characterization Criteria failed to Reset to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Composition Criteria failed to Reset to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to Reset to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			if (getCharacterizationCriteriaAddOrResetOrRemove.equals("Remove")){
				boolean getRmChaVal = isDisplayedTrue(By.cssSelector("#charPattern td:nth-child(1)"));
				if (getRmChaVal == false){
					logger.info("Characterization Criteria Remove successful to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria Reset successful to the Advanced Search Query", "advanced_sample_search", "Verification successful", "Pass");
					stepCount++;		
				} else if (getRmChaVal == true){
					logger.error("Characterization Criteria failed to Remove to the Advanced Search Query");
					TestExecutionException e = new TestExecutionException("Composition Criteria failed to Reset to the Advanced Search Query");
					oPDF.enterBlockSteps(bTable, stepCount, "Characterization Criteria failed to Reset to the Advanced Search Query", "advanced_sample_search", "Verification failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
			//Search or Reset
			if (getSearchOrReset.isEmpty()==false){
				if (getSearchOrReset.equals("Search")){
					click(By.id("search"));
					wait_For(7000);
				} else if (getSearchOrReset.equals("Reset")){
					click(By.id("reset"));
					wait_For(3000);
				}
			}
			//Search verification
			//verify_advanced_sample_search_result_count();
			if (verifySearchSampleValYesOrNo.equals("Yes") && selectSearchSampleValYesOrNo.isEmpty()==true){
				verify_advanced_sample_search(getContainsOrEqual, getSampleCriteriaName, "");
			}
			if (verifySearchSampleValYesOrNo.equals("Yes") && selectSearchSampleValYesOrNo.equals("Yes")){
				verify_advanced_sample_search(getContainsOrEqual, getSampleCriteriaName, selectSearchSampleValYesOrNo);
			}
		}
		/*
		 * Advanced sample search submit method
		 */
		public void advanced_sample_search_submit (String getSearchOrReset) throws TestExecutionException {
			if (getSearchOrReset.isEmpty()==false){
				if (getSearchOrReset.equals("Search")){
					click(By.id("search"));
					wait_For(7000);
				} else if (getSearchOrReset.equals("Reset")){
					click(By.id("reset"));
					wait_For(3000);
				}
			}
		}
		/*
		 * 
		 */
		public void verify_advanced_sample_search_result_characterization(String getCharacterizationCriteriaA, String getCharacterizationCriteriaB, String getCharacterizationCriteriaC) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th:nth-child(1)"), "Sample Name");
			}catch (Exception e){
			}
			String buildTbleColumnNm = ""+ getCharacterizationCriteriaA +""+ getCharacterizationCriteriaB +""+ getCharacterizationCriteriaC +"";
			logger.info("Expected:["+ buildTbleColumnNm +"]");
			String getTableHeaderA = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th:nth-child(1)"));
			String getTableHeaderB = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th:nth-child(2)")).replaceAll("\\n", " ");
			logger.info("Actual:["+ getTableHeaderB +"]");
			int resRowCount = 0;
	    	resRowCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
	    	int totalResultCountFromPage = resRowCount - 3;  
	    		logger.info("Total Result Count:["+ totalResultCountFromPage +"]");
	    	if (totalResultCountFromPage >= 1 && getTableHeaderA.equals("Sample Name") && getTableHeaderB.contains(buildTbleColumnNm)) {
				logger.info("Sample Search Verification Successful from Advanced search page");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification successful from Advanced search page", "verify_advanced_sample_search_result_count", "Verification successful", "Pass");
				stepCount++;
	    	} else {
				logger.error("Sample Search Verification Failed from Advanced search page");
				TestExecutionException e = new TestExecutionException("Sample Search Verification Failed from Advanced search page");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification Failed from Advanced search page", "verify_advanced_sample_search_result_count", "Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
	    	}
		}
		/*
		 * 
		 */
		public void verify_advanced_sample_search_result_function() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th:nth-child(1)"), "Sample Name");
			}catch (Exception e){
			}
			String getTableHeaderA = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th:nth-child(1)"));
			String getTableHeaderB = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th:nth-child(2)"));
			int resRowCount = 0;
	    	resRowCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
	    	int totalResultCountFromPage = resRowCount - 3;  
	    		logger.info("Total Result Count:["+ totalResultCountFromPage +"]");
	    	if (totalResultCountFromPage >= 1 && getTableHeaderA.equals("Sample Name") && getTableHeaderB.equals("function")) {
				logger.info("Sample Search Verification Successful from Advanced search page");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification successful from Advanced search page", "verify_advanced_sample_search_result_count", "Verification successful", "Pass");
				stepCount++;
	    	} else {
				logger.error("Sample Search Verification Failed from Advanced search page");
				TestExecutionException e = new TestExecutionException("Sample Search Verification Failed from Advanced search page");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification Failed from Advanced search page", "verify_advanced_sample_search_result_count", "Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
	    	}
		}
		/*
		 * 
		 */
		public void verify_advanced_sample_search_result_count() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th"), "Sample Name");
			}catch (Exception e){
			}
			int resRowCount = 0;
	    	resRowCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
	    	int totalResultCountFromPage = resRowCount - 3;  
	    		logger.info("Total Result Count:["+ totalResultCountFromPage +"]");
	    	if (totalResultCountFromPage >= 1) {
				logger.info("Sample Search Verification Successful from Advanced search page");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification successful from Advanced search page", "verify_advanced_sample_search_result_count", "Verification successful", "Pass");
				stepCount++;
	    	} else {
				logger.error("Sample Search Verification Failed from Advanced search page");
				TestExecutionException e = new TestExecutionException("Sample Search Verification Failed from Advanced search page");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification Failed from Advanced search page", "verify_advanced_sample_search_result_count", "Verification failed", "Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
	    	}
		}
		/*
		 * 
		 */
		public void verify_advanced_sample_search(String getContainsOrEqual, String getSearchSampleName, String getSelectFlag) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr th"), "Sample Name");
			}catch (Exception e){
			}
			int resRowCount = 0;
		    	resRowCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
		    int totalResultCountFromPage = resRowCount - 2;    
		    	logger.info("Total Result Count:["+ totalResultCountFromPage +"]");
		    if 	(getContainsOrEqual.equals("contains")){
				for (int r=2;r<resRowCount;r++){
					String getTableCellData = null;
					getTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ r +") td:nth-child(1)")).replaceAll("\\n", "");
					logger.info("Identified value:["+ getTableCellData +"] from search result page");
					if (getTableCellData.contains(getSearchSampleName)){
						logger.info("Sample Search Verification successful from Advanced search page");
						oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification successful from Advanced search page", "verify_advanced_sample_search", "Verification successful", "Pass");
						stepCount++;
						if (getSelectFlag.isEmpty()==false){
							if (getSelectFlag.equals("Yes")){
								//click sample name link
								click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ r +") td:nth-child(1) a"));
							}
						}
						break;
					}
				}
		    } else if (getContainsOrEqual.equals("equals")) {
				for (int r=2;r<resRowCount;r++){
					String getTableCellData = null;
					getTableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ r +") td:nth-child(1)")).replaceAll("\\n", "");
					logger.info("Identified value:["+ getTableCellData +"] from search result page");
					if (getTableCellData.equals(getSearchSampleName)){
						logger.info("Sample Search Verification successful from Advanced search page");
						oPDF.enterBlockSteps(bTable, stepCount, "Sample Search Verification successful from Advanced search page", "verify_advanced_sample_search", "Verification successful", "Pass");
						stepCount++;
						if (getSelectFlag.isEmpty()==false){
							if (getSelectFlag.equals("Yes")){
								//click sample name link
								click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ r +") td:nth-child(1) a"));
							}
						}
						break;
					}
				}
		    }
		}
		/************************************************
		 * 	NCTN >> element load by expected value 	
		 ************************************************/
		public void element_load_by_expected_value(By by, String getExpectedVal) throws TestExecutionException {
			int loadCount = 1000;
			String getItemLoad = null;
			for (int r=2;r<loadCount;r++){
				getItemLoad = getText(by).replaceAll("\\n", "");
				logger.info("Waiting for element values:["+getItemLoad+"]");
				if (getItemLoad.contains(getExpectedVal)){
					logger.info("System Identified Element:["+by+"] and current load value is:["+getItemLoad+"] and expected value is:["+getExpectedVal+"], Verification Successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_load_by_expected_value", "System Identified Element:["+by+"] and current load value is:["+getItemLoad+"] and expected value is:["+getExpectedVal+"], Verification Successful", "Pass");
					stepCount++;	
					break;
				}
			}
			if (!getItemLoad.equals(getExpectedVal)){
				logger.error("System Identified Element:["+by+"] and current load value is:["+getItemLoad+"] and expected value is:["+getExpectedVal+"], Verification Failed");
				TestExecutionException e = new TestExecutionException("Element:["+by+"] verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_load_by_expected_value","System Identified Element:["+by+"] and current display value is:["+getItemLoad+"] and expected value is:["+getExpectedVal+"], Verification Failed","Fail");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	NCTN >> element load 	
		 ************************************************/
		public void element_load(By by) throws TestExecutionException {
			int loadCount = 1000;
			String getItemLoad = null;
			for (int r=2;r<loadCount;r++){
				getItemLoad = getText(by).replaceAll("\\n", "");
				logger.info("Waiting for element values:["+getItemLoad+"]");
				if (getItemLoad.isEmpty()==false){
					logger.info("System Identified Element:["+by+"] and current load value is:["+getItemLoad+"], Verification Successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_load", "System Identified Element:["+by+"] and current load value is:["+getItemLoad+"], Verification Successful", "Pass");
					stepCount++;	
					break;
				}
			}
			if (getItemLoad.isEmpty()==true){
				logger.error("System Identified Element:["+by+"] and current load value is:["+getItemLoad+"], Verification Failed");
				TestExecutionException e = new TestExecutionException("Element:["+by+"] verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_load","System Identified Element:["+by+"] and current display value is:["+getItemLoad+"], Verification Failed","Fail");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	NCTN >> element display
		 ************************************************/
		public void element_display(By by) throws TestExecutionException {
			int loadCount = 15000;
			boolean getItemDisplay = false;
			for (int r=2;r<loadCount;r++){
				getItemDisplay = isDisplayedTrue(by);
				logger.info("Waiting for display element:["+getItemDisplay+"]");
				if (getItemDisplay == true){
					logger.info("System Identified Element:["+by+"] current display status is:["+getItemDisplay+"], Verification Successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_display","System Identified Element:["+by+"] current display status is:["+getItemDisplay+"], Verification Successful","Pass");
					stepCount++;	
					break;
				}
			}
			if (getItemDisplay == false){
				logger.error("System unable to Identified Element:["+by+"] and current display status is:["+getItemDisplay+"], Verification Failed");
				TestExecutionException e = new TestExecutionException("Element:["+by+"] verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_display","System unable to Identified Element:["+by+"] and current display status is:["+getItemDisplay+"], Verification Failed","Fail");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	NCTN >> element display
		 ************************************************/
		public void element_display_false(By by) throws TestExecutionException {
			int loadCount = 500;
			boolean getItemDisplay = true;
			for (int r=2;r<loadCount;r++){
				getItemDisplay = isDisplayedTrue(by);
				logger.info("Waiting for display element:["+getItemDisplay+"]");
				if (getItemDisplay == false){
					logger.info("System Identified Element:["+by+"] current display status is:["+getItemDisplay+"], Verification Successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_display","System Identified Element:["+by+"] current display status is:["+getItemDisplay+"], Verification Successful","Pass");
					stepCount++;	
					break;
				}
			}
			if (getItemDisplay == true){
				logger.error("System unable to Identified Element:["+by+"] and current display status is:["+getItemDisplay+"], Verification Failed");
				TestExecutionException e = new TestExecutionException("Element:["+by+"] verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_display","System unable to Identified Element:["+by+"] and current display status is:["+getItemDisplay+"], Verification Failed","Fail");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());
			}
		}
		/************************************************
		 * 	NCTN >> element enabled
		 ************************************************/
		public void element_enabled(By by) throws TestExecutionException {
			int loadCount = 10000;
			boolean getItemEnable = false;
			for (int r=2;r<loadCount;r++){
				getItemEnable = isEnabledTrue(by);
				logger.info("Waiting for element:["+by+"] current enable status:["+getItemEnable+"]");
				if (getItemEnable == true){
					logger.info("System Identified Element:["+by+"] current enable status:["+getItemEnable+"], Verification Successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_enabled","System Identified Element:["+by+"] current enable status:["+getItemEnable+"], Verification Successful","Pass");
					stepCount++;	
					break;
				}
			}
			if (getItemEnable == false){
				logger.error("System Identified Element:["+by+"] current enable status is:["+getItemEnable+"], Verification Failed");
				TestExecutionException e = new TestExecutionException("Element:["+by+"] verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Element verification","element_enabled","System Identified Element:["+by+"] current enable status is:["+getItemEnable+"], Verification Failed","Fail");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * This method search for protocol
		 */
		public void publication_search (String getPublicationType, 
										String getResearcherCategory, 
										String getPubmedID, 
										String getDigitalObjectID,
										String getPublicationTitleFilter,
										String getPublicationTitle,
										String getAuthors,
										String getKeywords,
										String getSampleNameFilter,
										String getSampleName,
										String getCompositionNanomaterialEntity,
										String getCompositionFunctionalizingEntity,
										String getFunction,
										String getSearchOrReset,
										String getVerificationYes) throws TestExecutionException {
			wait_For(2000);
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "Publication Search");
			element_load(By.name("category"));
			//Publication Type
			if (getPublicationType.isEmpty()==false){
				wait_For(1000);
				select("cssSelector", "select[name=\"category\"]", getPublicationType);
			}
			//Research Category
			if (getResearcherCategory.equals("animal")){
				check(By.cssSelector("#researchArea:nth-child(1)"));
			}
			if (getResearcherCategory.equals("cell line")){
				check(By.cssSelector("#researchArea:nth-child(3)"));
			}
			if (getResearcherCategory.equals("characterization")){
				check(By.cssSelector("#researchArea:nth-child(5)"));
			}
			if (getResearcherCategory.equals("clinical trials")){
				check(By.cssSelector("#researchArea:nth-child(7)"));
			}
			if (getResearcherCategory.equals("in vitro")){
				check(By.cssSelector("#researchArea:nth-child(9)"));
			}
			if (getResearcherCategory.equals("in vivo")){
				check(By.cssSelector("#researchArea:nth-child(11)"));
			}
			if (getResearcherCategory.equals("synthesis")){
				check(By.cssSelector("#researchArea:nth-child(13)"));
			}
			//PubMed ID
			if(getPubmedID.isEmpty()==false){
				enter(By.id("pubMedId"), getPubmedID);
			}
			//Digital Object ID
			if(getDigitalObjectID.isEmpty()==false){
				enter(By.id("digitalObjectId"), getDigitalObjectID);
			}
			//Publication Title
			if (getPublicationTitleFilter.isEmpty()==false){
				select("id", "titleOperand", getPublicationTitleFilter);
			}
			if (getPublicationTitle.isEmpty()==false){
				enter(By.id("title"), getPublicationTitle);
			}
			//Authors
			if (getAuthors.isEmpty()==false){
				enter(By.id("authorsStr"), getAuthors);
			}
			//keywords
			if (getKeywords.isEmpty()==false){
				enter(By.id("keywordsStr"), getKeywords);
			}
			//Sample Name
			if (getSampleNameFilter.isEmpty()==false){
				select("id", "nameOperand", getSampleNameFilter);
			}
			if (getSampleName.isEmpty()==false){
				enter(By.id("sampleName"), getSampleName);
			}
			//Composition Nanomaterial Entity
			if (getCompositionNanomaterialEntity.isEmpty()==false){
				select("id", "nanomaterialEntityTypes", getCompositionNanomaterialEntity);
			}
			//Composition Functionalizing Entity
			if (getCompositionFunctionalizingEntity.isEmpty()==false){
				select("id", "functionalizingEntityTypes", getCompositionFunctionalizingEntity);
			}
			//Function
			if (getFunction.isEmpty()==false){
				select("id", "functionTypes", getFunction);
			}
			//Search
			if (getSearchOrReset.isEmpty()==false){
				if(getSearchOrReset.equals("search")){
					click(By.cssSelector(".invisibleTable tbody tr:nth-child(2) td input:nth-child(2)")); //Search
				}
				if (getSearchOrReset.equals("reset")){
					click(By.cssSelector(".invisibleTable tbody tr:nth-child(2) td input:nth-child(1)")); //Reset
				}
			}
			//Results verification
			if (getVerificationYes.equals("yes")){
				int loadCount = 100000;
				boolean getResultsVal = false;
				for (int r=2;r<loadCount;r++){
					getResultsVal = isDisplayedTrue(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(1) a:nth-child(1)"));
					if (getResultsVal == true){
						logger.info("Publication search results displayed successfully on the Publication Search Results page");
						logger.info("Publication Search Results Table Verification Successful");
						oPDF.enterBlockSteps(bTable, stepCount, "Publication Search Results Verification", "publication_search", "Publication Search Results Table Verification Successful", "Pass");
						stepCount++;
						break;
					}
				}
				if (getResultsVal == false){
					logger.error("Publication Search Results Table Verification failed");
					TestExecutionException e = new TestExecutionException("Publication Search Results Verification failed");
					oPDF.enterBlockSteps(bTable, stepCount, "Publication Search Results Verification", "publication_search", "Publication Search Results Table Verification Failed", "Fail");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		/*
		 * This method search for protocol
		 */
		public void protocol_search (String getProtocolType, 
				                     String getProtocolNameFilter, String getProtocolName, 
				                     String getProtocolAbbreviationFilter, String getProtocolAbbreviation, 
				                     String getProtocolFileTitleFilter, String getProtocolFileTitle, 
				                     String getSearchOrReset, String getSearchVerifyYesOrNo) throws TestExecutionException {
			wait_For(2000);
			wait_until_element_present(By.cssSelector(".contentTitle tbody tr th"), "Protocol Search");
			//wait_until_element_present(By.cssSelector(".submissionView tbody tr:nth-child(1) .cellLabel:nth-child(1)"), "Protocol Search");
			if (getProtocolType.isEmpty()==false){
				select("id", "type", getProtocolType);
			}
			if (getProtocolNameFilter.isEmpty()==false){
				select("id", "nameOperand", getProtocolNameFilter);
			}
			if (getProtocolName.isEmpty()==false){
				enter(By.id("protocolName"), getProtocolName);
			}
			if (getProtocolAbbreviationFilter.isEmpty()==false){
				select("id", "abbreviationOperand", getProtocolAbbreviationFilter);
			}
			if (getProtocolAbbreviation.isEmpty()==false){
				enter(By.id("protocolAbbreviation"), getProtocolAbbreviation);
			}
			if (getProtocolFileTitleFilter.isEmpty()==false){
				select("id", "titleOperand", getProtocolFileTitleFilter);
			}
			if (getProtocolFileTitle.isEmpty()==false){
				enter(By.id("fileTitle"), getProtocolFileTitle);
			}
			getSearchOrReset = getSearchOrReset.toLowerCase();
			if (getSearchOrReset.equals("search")){
				click(By.cssSelector(".invisibleTable tbody tr:nth-child(2) td input:nth-child(2)")); // Search button
			}
			if (getSearchOrReset.equals("reset")){
				click(By.cssSelector(".invisibleTable tbody tr:nth-child(2) td input:nth-child(1)")); // Reset button
				wait_For(1000);
				if (getSearchOrReset.equals("reset")){
					String getProtocolTextAttribt = getAttribute(By.id("protocolName"), "value");
					logger.info("getProtocolTextAttribt:["+getProtocolTextAttribt);
					if (getProtocolTextAttribt.isEmpty()==false){
						logger.error("Protocol search Reset verification failed");
						TestExecutionException e = new TestExecutionException("Protocol search Reset verification failed");
						oPDF.enterBlockSteps(bTable, stepCount, "Protocol Search Reset verification failed", "protocol_search", "Protocol Search Reset verification failed", "Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					} else if (getProtocolTextAttribt.isEmpty()==true){
						logger.info("Protocol Search  Reset verification successful");
						oPDF.enterBlockSteps(bTable, stepCount, "Protocol SearchReset verification successful", "protocol_search", "Protocol Search Reset verification successful", "Pass");
						stepCount++;
					}
				}
			}
			if (getSearchVerifyYesOrNo.isEmpty()==false){
				if (getSearchVerifyYesOrNo.equals("yes")){
					wait_until_search_protocol_table_data_load();
					boolean getProtoSearchVal = isDisplayedTrue(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child(1) td:nth-child(1)"));
					if (getProtoSearchVal == true){
						logger.info("Protocol Search Result Verification successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Protocol Search Result verification","protocol_search","Protocol Search Result Verification successful","Pass");
						stepCount++;
					} else if (getProtoSearchVal == false){
						logger.error("Protocol Search Result Verification failed");
						TestExecutionException e = new TestExecutionException("Protocol Search Result Verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Protocol Search Result verification","protocol_search","Protocol Search Result Verification failed","Fail");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}
				}
			}
			
		}	
		/*
		 * This method search for sample
		 */
		public void samples_search_simple (String keyword, String SampleNameDropDown, String SampleName, String SamplePointofDropDown, String SamplePointof, String NanomaterialEntity, String FunctionalizingEntity, String Function, String CharacterizationType, String Characterization, String SearchOrReset) throws TestExecutionException {
			String btnVerification = "input[type=\"submit\"]"; // Submit button verification
			boolean retVal2 = verifyElementIsTrueOrFalse(By.id("keywords")); // Keyword Text Box
			boolean retVal3 = verifyElementIsTrueOrFalse(By.id("nameOperand")); //Drop down
			boolean retVal4 = verifyElementIsTrueOrFalse(By.id("sampleName")); // Sample Name Text Box
			boolean retVal5 = verifyElementIsTrueOrFalse(By.id("pocOperand")); //Drop down
			boolean retVal6 = verifyElementIsTrueOrFalse(By.id("samplePOC")); // Sample Point of Contact Text Box
			boolean retVal7 = verifyElementIsTrueOrFalse(By.cssSelector("#nanomaterialEntityTypes"));
			boolean retVal8 = verifyElementIsTrueOrFalse(By.cssSelector("#functionalizingEntityTypes"));
			boolean retVal9 = verifyElementIsTrueOrFalse(By.cssSelector("#functionTypes"));
			boolean retVal10 = verifyElementIsTrueOrFalse(By.xpath("//select[@id='charType']"));
			boolean retVal11 = verifyElementIsTrueOrFalse(By.cssSelector("#charName"));
			boolean retVal1 = verifyElementIsTrueOrFalse(By.cssSelector(btnVerification));
			boolean retVal12 = verifyElementIsTrueOrFalse(By.cssSelector("input[type=\"reset\"]"));
			
			boolean gkeyword = keyword.isEmpty();
			boolean gSampleNameDropDown = SampleNameDropDown.isEmpty();
			boolean gSampleName = SampleName.isEmpty();
			boolean gSamplePointofDropDown = SamplePointofDropDown.isEmpty();
			boolean gSamplePointof = SamplePointof.isEmpty();
			boolean gNanomaterialEntity = NanomaterialEntity.isEmpty();
			boolean gFunctionalizingEntity = FunctionalizingEntity.isEmpty();
			boolean gFunction = Function.isEmpty();
			boolean gCharacterizationType = CharacterizationType.isEmpty();
			boolean gCharacterization = Characterization.isEmpty();
			boolean gSearchOrReset = SearchOrReset.isEmpty();
			
			if (gkeyword == false){
				enter(By.id("keywords"),keyword);
			}
			if (gSampleNameDropDown == false){
				select("id","nameOperand", SampleNameDropDown);
			}
			if (gSampleName == false){
				enter(By.id("sampleName"), SampleName);
			}
			if (gSamplePointofDropDown == false){
				select("id","pocOperand", SamplePointofDropDown);
			}
			if (gSamplePointof == false){
			    enter(By.id("samplePOC"), SamplePointof);
			}
			if (gNanomaterialEntity == false){
				select("cssSelector", "#nanomaterialEntityTypes", NanomaterialEntity);
			}
			if (gFunctionalizingEntity == false){
				select("cssSelector", "#functionalizingEntityTypes", FunctionalizingEntity);
			}
			if (gFunction == false){
				select("cssSelector", "#functionTypes", Function);
			}
			if (gCharacterizationType == false){
				select("cssSelector", "#charType", CharacterizationType);
			}
			if (gCharacterization == false){
				try {
					_wait(10000);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				select("cssSelector", "#charName", Characterization);
			}
			if (gSearchOrReset == false){
				String lSearchOrReset = SearchOrReset.toLowerCase();
				logger.info("Submit or Reset option selected as:["+lSearchOrReset+"]");
				if (lSearchOrReset == "search"){
					click(By.cssSelector(btnVerification));
					try {
						_wait(7000);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				} else if (lSearchOrReset == "reset"){
					click(By.cssSelector("input[type=\"reset\"]"));
					if (getText(By.id("keywords")).isEmpty() && getText(By.id("sampleName")).isEmpty() && getText(By.id("samplePOC")).isEmpty()) {
						captureScreenshot(dir+"/snapshots/resetSampleSearchPage.png");
						logger.info("Reset of Sample Search fields validation successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Reset fields verification","samples_search_simple","Reset fields successful","Pass");
						stepCount++;						
					}else {
						captureScreenshot(dir+"/snapshots/resetSampleSearchPage.png");
						logger.error("Reset fields verification in Sample Search page failed");
						TestExecutionException e = new TestExecutionException("Reset fields verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Reset fields verification","samples_search_simple","Verification failed","Fail", "resetSampleSearchPage.png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());					
					}
				} else {
					logger.info("Please specify the Search or Reset option for Search");
				}	
			}
			captureScreenshot(dir+"/snapshots/sampleSearchPage.png");
			if (retVal1 == true || retVal2 == true || retVal3 == true || retVal4 == true || retVal5 == true || retVal6 == true || retVal7 == true || retVal8 == true || retVal9 == true || retVal10 == true || retVal11 == true || retVal12 == true) {
				logger.info("Sample Search fields verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Search fields verification","samples_search_simple","Sample Search fields verification successful","Pass");
				stepCount++;
			} else {
				logger.error("Sample Search fields verification failed");
				TestExecutionException e = new TestExecutionException("Sample Search fields verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Search fields verification","samples_search_simple","Sample Search fields verification failed","Fail", "sampleSearchPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void samples_search_by_keywords (String keyword) throws TestExecutionException {
			enter(By.id("keywords"),keyword);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples search by keywords","samples_search_by_keywords","Searching samples by keywords","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void samples_contains_search_by_sample_name (String sampleName) throws TestExecutionException {
			select("id","nameOperand","contains");
			enter(By.id("sampleName"),sampleName);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples contains-search by sample name","samples_contains_search_by_sample_name","Searching (contains) samples by sample name","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void samples_equals_search_by_sample_name (String sampleName) throws TestExecutionException {
			select("id","nameOperand","equals");
			enter(By.id("sampleName"),sampleName);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples equals-search by sample name","samples_equals_search_by_sample_name","Searching (equals) samples by sample name","Pass", "searchPage.png");
			stepCount++;
		}		
		/*
		 * 
		 */
		public void samples_equals_search_by_sample_poc (String sampleName) throws TestExecutionException {
			select("cssSelector","#pocOperand","equals");
			enter(By.cssSelector("#samplePOC"),sampleName);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples equals-search by sample poc","samples_equals_search_by_sample_poc","Searching (equals) samples by sample point of contact","Pass", "searchPage.png");
			stepCount++;
		}	
		/*
		 * 
		 */
		public void samples_contains_search_by_sample_poc (String sampleName) throws TestExecutionException {
			select("cssSelector","#pocOperand","contains");
			enter(By.cssSelector("#samplePOC"),sampleName);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples contains-search by sample poc","samples_contains_search_by_sample_poc","Searching (contains) samples by sample point of contact","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void samples_search_by_nanomaterial_entity (String nanoMatEntity) throws TestExecutionException{
			select("cssSelector", "#nanomaterialEntityTypes",nanoMatEntity);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples search by nanomaterial entity composition","samples_search_by_nanomaterial_entity","Searching samples by nanomaterial entity composition","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void samples_search_by_functionalizing_entity (String funcEntity) throws TestExecutionException{
			select("cssSelector", "#functionalizingEntityTypes",funcEntity);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples search by functionalizing entity composition","samples_search_by_functionalizing_entity","Searching samples by functionalizing entity composition","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void samples_search_by_function_types (String funcTypes) throws TestExecutionException{
			select("cssSelector", "#functionTypes",funcTypes);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples search by function type composition","samples_search_by_function_types","Searching samples by function types composition","Pass", "searchPage.png");
			stepCount++;
		}		
		/*
		 * 
		 */
		public void samples_search_by_characterization_types (String charTypes) throws TestExecutionException{
			select("cssSelector", "#charType",charTypes);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples search by characterization types","samples_search_by_characterization_types","Searching samples by characterization types","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void samples_search_by_characterization (String charTypes, String characters) throws TestExecutionException{
			select("cssSelector", "#charType",charTypes);
			try {
				implicitwait(30);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			select("cssSelector", "#charName", characters);
			captureScreenshot(dir+"/snapshots/searchPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"samples search by characterization","samples_search_by_characterization","Searching samples by characterization","Pass", "searchPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void submitSampleSearch () throws TestExecutionException {
			click(By.cssSelector(".invisibleTable>tbody>tr>td>input[type='submit']"));
			try{
				waitUntil(By.cssSelector("html body.ng-scope div.container table tbody tr td#maincontent.mainContent table tbody tr td.mainContent.ng-scope div.spacer.ng-scope table.contentTitle tbody tr th"),"Sample Search Results");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/searchResultPage.png");
			oPDF.enterBlockSteps(bTable,stepCount,"submit sample saerch","submitSampleSearch","Submit Sample Search","Pass", "searchResultPage.png");
			stepCount++;
		}
		/*
		 * 
		 */
		public void resetSampleSearch () throws TestExecutionException {
			click(By.cssSelector(".invisibleTable>tbody>tr>td>input[type='reset']"));
			captureScreenshot(dir+"/snapshots/resetSampleSearchPage.png");
			if (getText(By.id("keywords")).isEmpty() && getText(By.id("sampleName")).isEmpty() &&  getText(By.id("samplePOC")).isEmpty() && getSelected(By.id("functionalizingEntityTypes")).equals(null) && getSelected(By.id("functionTypes")).equals(null) && getSelected(By.id("charType")).equals(null)) {
				logger.info("Reset Sample search fields validation successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Reset sample search fields verification","resetSampleSearch","Reset fields successful","Pass");
				stepCount++;						
			}else {
				logger.error("Sample search Reset fields validation failed");
				TestExecutionException e = new TestExecutionException("Reset fields verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Reset sample search fields verification","sample search","Verification failed","Fail", "resetSampleSearchPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());				
			}
		}
		/*
		 * 
		 */
		//THE CONTENT TITLE WITH SEARCH RESULTS for example, 187 items found. IS NOT GETTING DISPLAYED AS IN PROD. CURRENTLY THERE IS A SIMPLE TITLE. 
		//USE THIS FUNCTION IN THE TESTS WHEN IT IS MADE AVAILABLE. 
		public void sample_search_results_verification (String expRes) throws TestExecutionException {
			boolean retVal = isTextPresent_regExp(By.cssSelector(".contentTitle>tbody>tr>th"), expRes);
			captureScreenshot(dir+"/snapshots/searchResultPage.png");
			if (retVal == false){
				logger.error("sample search results verification failed");
				TestExecutionException e = new TestExecutionException("sample search results verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","sample_search_results_verification","sample search results verification failed","Fail", "searchResultPage.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
								
			}else {
				logger.info("sample search results verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","sample_search_results_verification","sample search results verification successful","Pass");
				stepCount++;				
			}	
		}
		/*
		 * 
		 */
		public void sample_search_results_verification () throws TestExecutionException {
			boolean retVal = isTextPresent_regExp(By.cssSelector(".contentTitle>tbody>tr>th"), "Sample Search Results");
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			captureScreenshot(dir+"/snapshots/searchResultPage.png");
			if (retVal == false || rCount < 3){
				logger.error("sample search results verification failed");
				TestExecutionException e = new TestExecutionException("sample search results verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","sample_search_results_verification","sample search results verification failed","Fail", "searchResultPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}else {
				logger.info("sample search results verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","sample_search_results_verification","sample search results verification successful","Pass");
				stepCount++;				
			}	
		}
		/*
		 * This method verifies the Sample Search Result
		 */
		public void verify_sample_search_results (String gSearchHeader, int gResultCount) throws TestExecutionException {
			waitUntilElementVisible(By.cssSelector(".contentTitle>tbody>tr>th"));
			waitUntilElementIsPresents(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String getSearchResultHeader = getText(By.cssSelector(".contentTitle>tbody>tr>th"));
			sample_result_table_header_verification();
			logger.info("Identified Search Result title as["+ getSearchResultHeader +"]");		
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			rCount = rCount - 2;
			logger.info("Result count on the Search result page:["+ rCount +"]");
			captureScreenshot(dir+"/snapshots/searchResultPage.png");
			if (getSearchResultHeader == gSearchHeader || rCount >= gResultCount){
				logger.info("sample search results verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","sample_search_results_verification","sample search results verification successful","Pass");
				stepCount++;
			}else {
				logger.error("sample search results verification failed");
				TestExecutionException e = new TestExecutionException("sample search results verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","sample_search_results_verification","sample search results verification failed","Fail", "searchResultPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}	
		}
		/*
		 * 
		 */
		public void sample_search_error_verification () throws TestExecutionException {
			boolean retVal = isTextPresent_regExp(By.xpath("//div[@ng-if='message']"), "No samples were found for the given parameters.");
			captureScreenshot(dir+"/snapshots/searchResultPage.png");
			if (retVal == false){
				logger.error("sample search error verification failed");
				TestExecutionException e = new TestExecutionException("sample search error verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search error verification","sample_search_error_verification","sample search error verification failed","Fail", "searchResultPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}else {
				logger.info("sample search results verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search error verification","sample_search_error_verification","sample search error verification successful","Pass");
				stepCount++;				
			}	
		}
		/*
		 * 
		 */
		public void sample_result_table_header_verification() throws TestExecutionException {
			String tableCellData = null;
			tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead")).replaceAll("\\n", " ");
			logger.info("Identified Search Result Table Header Values as:["+tableCellData+"]");
			String SearchResultTableHeader = "Actions "
											+ "Sample Name "
											+ "Primary Point of Contact "
											+ "Composition "
											+ "Functions "
											+ "Characterizations "
											+ "Data Availability "
											+ "Created Date";
			String tableHeaderCell1 = null;
			tableHeaderCell1 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(1)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell1 +"]");
			String tableHeaderCell2 = null;
			tableHeaderCell2 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(2)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell2 +"]");
			String tableHeaderCell3 = null;
			tableHeaderCell3 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(3)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell3 +"]");
			String tableHeaderCell4 = null;
			tableHeaderCell4 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(4)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell4 +"]");
			String tableHeaderCell5 = null;
			tableHeaderCell5 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(5)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell5 +"]");
			String tableHeaderCell6 = null;
			tableHeaderCell6 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(6)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell6 +"]");
			String tableHeaderCell7 = null;
			tableHeaderCell7 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(7)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell7 +"]");
			String tableHeaderCell8 = null;
			tableHeaderCell8 = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr th:nth-child(8)"));
			logger.info("Identified Table Header: ["+ tableHeaderCell8 +"]");
			captureScreenshot(dir+"/snapshots/sampleSearchResultPage.png");
			if (tableCellData.equals(SearchResultTableHeader)) {
				logger.info("Sample search result Table Header verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample search result Table Header verification","sample_result_table_header_verification","Sample search results header verification successful","Pass");
				stepCount++;	
			}else {
				logger.error("Sample search result Table Header verification failed");
				TestExecutionException e = new TestExecutionException("Sample search result Table Header verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"view sample details verification","sample_result_table_header_verification","view sample details verification failed","Fail", "sampleSearchResultPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());		
			}
		}
		/*
		 * This method look for the match on the search result table
		 */
		public void click_next_result_page_until_backup(String getContainsSampleName) throws TestExecutionException{
			int rCount = 1000;
			for (int i=1;i<rCount;i++){
				int resRowCount = 0;
				    resRowCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
				int totalResultCountFromPage = resRowCount - 2;    
				int buildPageNumber = i;
				    logger.info("Total Result Count:["+ totalResultCountFromPage +"] From Search Result Page:["+ buildPageNumber +"]");
					for (int r=1;r<resRowCount;r++){
						String tableCellData = null;
						String actualVal = null;
						int currentRowCountVal = r ;
						tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ r +") td:nth-child(2)"));
						actualVal = tableCellData;
						boolean getVal = actualVal.contains(getContainsSampleName);				
						logger.info("Current row number:["+ currentRowCountVal +"] and Identified table cell value: ["+ tableCellData +"]");
						logger.info("Result identified status is:[" + getVal +"]");
					if (getVal == true){
						oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","click_next_result_page_link_until","Verification successful for "+ getContainsSampleName,"Pass");
						stepCount++;
						break;
					}else if (currentRowCountVal == totalResultCountFromPage) {
						logger.info("Unable to find match with the expected value: ["+ getContainsSampleName +"]");
					    int pageLinkNm = r;
					    int gNextPage = pageLinkNm + 1;
						boolean boolNLink1 = isDisplayed(By.xpath("//a[contains(text(),'ï¿½')]"));
						boolean boolNLink2 = isEnabled(By.xpath("//a[contains(text(),'ï¿½')]"));
						boolean boolNLink3 = verifyElementIsTrueOrFalse(By.xpath("//a[contains(text(),'"+gNextPage+"')]"));
						if (boolNLink1 == true && boolNLink2 == true && boolNLink3 == true){
						    click(By.xpath("//a[contains(text(),'ï¿½')]"));
						    try {
								_wait(3000);
							} catch (Exception e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						    r = 0;
						    logger.info("Displaying result page number: ["+ pageLinkNm +"]");
						} 
					}
					}
			}
		}
		/*
		 * This method display logger information 
		 */
		public void display_log_info(String getInfo) throws TestExecutionException{
			logger.info("Currently running:"+ getInfo +"");
		}
		/*
		 * This method look for the match on the search result table
		 */
		public void click_next_result_page_until(String getContainsSampleName) throws TestExecutionException{
				int resRowCount = 0;
				    resRowCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
				int totalResultCountFromPage = resRowCount - 2;    
				    logger.info("Total Result Count:["+ totalResultCountFromPage +"]");				    
					for (int r=1;r<resRowCount;r++){
						String tableCellData = null;
						String actualVal = null;
						int currentRowCountVal = r ;
						tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+ r +") td:nth-child(2)"));
						actualVal = tableCellData;
						boolean getVal = actualVal.contains(getContainsSampleName);				
						logger.info("Current row number:["+ currentRowCountVal +"] and Identified table cell value: ["+ tableCellData +"]");
						logger.info("Result identified status is:[" + getVal +"]");
					if (getVal == true){
						oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","click_next_result_page_link_until","Verification successful for "+ getContainsSampleName,"Pass");
						stepCount++;
						break;
					}else if (currentRowCountVal == totalResultCountFromPage) {
						logger.info("Unable to find match with the expected value: ["+ getContainsSampleName +"]");
					    int pageLinkNm = r;
					    int gNextPage = pageLinkNm + 1;					    
						boolean boolNLink1 = isDisplayed(By.xpath("//a[contains(text(),'ï¿½')]"));
						boolean boolNLink2 = isEnabled(By.xpath("//a[contains(text(),'ï¿½')]"));
						//boolean boolNLink3 = verifyElementIsTrueOrFalse(By.xpath("//a[contains(text(),'"+gNextPage+"')]"));
						if (boolNLink1 == true && boolNLink2 == true){
						    click(By.xpath("//a[contains(text(),'ï¿½')]"));
						    try {
								_wait(3000);
							} catch (Exception e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						    r = 0;
						    logger.info("Displaying result page number: ["+ pageLinkNm +"]");
						} 
					}
					}
		}
		/*
		 * This method verify search result sample name which contains the sample name
		 */
		public void verify_sample_name_contains_from_search_results_page(String sampleName) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;			
			captureScreenshot(dir+"/snapshots/"+ sampleName +".png");
			for (int i=1;i<rCount;i++){
				String buildExpectedValue = null;
				buildExpectedValue = sampleName;
				String actualVal = null;
				String diff = null;
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(2)"));
				actualVal = tableCellData;
				diff = actualVal.substring(sampleName.length());
				logger.info("Identified difference: [" + diff +"]");
				buildExpectedValue = "" + buildExpectedValue + diff +"";
				logger.info("Expected Value:[" + buildExpectedValue +"]");
				int currentRowCountVal = i ;
				int subtrTableHeader = rCount - 2;
				logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
				if (tableCellData.equals(buildExpectedValue)) {
					//click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					logger.info("System identified expected sample name value:["+ tableCellData +"] matched with actual sample name value:["+ tableCellData +"]");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Successful","Pass", sampleName +".png");
					stepCount++;
					boolean retVal = verifyText(buildExpectedValue, tableCellData);
					logger.info("Verify result status:["+ retVal +"]");
					if (retVal == false){
						logger.error("Sample Search Result verification failed");
						TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}else if (retVal == true){
						logger.info("Sample Search Result Verification Successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","view_sample_details_from_search_results_page","view sample details verification successful","Pass");
						stepCount++;				
					}
					break;
				} else if (subtrTableHeader == currentRowCountVal) {
					logger.error("Sample Search Result verification failed");
					TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		/*
		 * This method will verify the composition information from the sample search table.
		 */
		public void verify_sample_composition_contains_from_search_results_page(String expCompostion) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;			
			captureScreenshot(dir+"/snapshots/"+ expCompostion +".png");
			for (int i=1;i<rCount;i++){
				String buildExpectedValue = null;
				buildExpectedValue = expCompostion;
				String actualVal = null;
				String diff = null;
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(4)")).replaceAll("\\n", " ");
				actualVal = tableCellData;
				diff = actualVal.substring(expCompostion.length());
				logger.info("Identified difference: [" + diff +"]");
				buildExpectedValue = "" + buildExpectedValue + diff +"";
				logger.info("Expected Value:[" + buildExpectedValue +"]");
				int currentRowCountVal = i ;
				int subtrTableHeader = rCount - 2;
				logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
				if (tableCellData.equals(buildExpectedValue)) {
					//click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					logger.info("System identified expected sample composition value:["+ tableCellData +"] matched with actual sample composition value:["+ tableCellData +"]");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition Search Result Verification","verify_sample_composition_contains_from_search_results_page","Sample Composition Search Result Verification Successful","Pass", expCompostion +".png");
					stepCount++;
					boolean retVal = verifyText(buildExpectedValue, tableCellData);
					logger.info("Verify result status:["+ retVal +"]");
					if (retVal == false){
						logger.error("Sample Composition Search Result verification failed");
						TestExecutionException e = new TestExecutionException("Sample Composition Search Result verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition Search Result verification","verify_sample_composition_contains_from_search_results_page","Sample Composition Search Result Verification Failed","Fail", expCompostion +".png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}else if (retVal == true){
						logger.info("Sample Composition Search Result Verification Successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition Search Result Verification","view_sample_details_from_search_results_page","Sample Composition Search Result Verification successful","Pass");
						stepCount++;				
					}
					break;
				} else if (subtrTableHeader == currentRowCountVal) {
					logger.error("Sample Search Result verification failed");
					TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Composition Search Result Verification Failed","Fail", expCompostion +".png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		
		/*
		 * This method will verify the primary point of contact information from the sample search table.
		 */
		public void verify_sample_poc_contains_from_search_results_page(String primaryPOC) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;			
			captureScreenshot(dir+"/snapshots/"+ primaryPOC +".png");
			for (int i=1;i<rCount;i++){
				String buildExpectedValue = null;
				buildExpectedValue = primaryPOC;
				String actualVal = null;
				String diff = null;
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(3)")).replaceAll("\\n", " ");
				actualVal = tableCellData;
				diff = actualVal.substring(primaryPOC.length());
				logger.info("Identified difference: [" + diff +"]");
				buildExpectedValue = "" + buildExpectedValue + diff +"";
				logger.info("Expected Value:[" + buildExpectedValue +"]");
				int currentRowCountVal = i ;
				int subtrTableHeader = rCount - 2;
				logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
				if (tableCellData.equals(buildExpectedValue)) {
					//click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					logger.info("System identified expected sample name value:["+ tableCellData +"] matched with actual sample name value:["+ tableCellData +"]");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Successful","Pass", primaryPOC +".png");
					stepCount++;
					boolean retVal = verifyText(buildExpectedValue, tableCellData);
					logger.info("Verify result status:["+ retVal +"]");
					if (retVal == false){
						logger.error("Sample Search Result verification failed");
						TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}else if (retVal == true){
						logger.info("Sample Search Result Verification Successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","view_sample_details_from_search_results_page","view sample details verification successful","Pass");
						stepCount++;				
					}
					break;
				} else if (subtrTableHeader == currentRowCountVal) {
					logger.error("Sample Search Result verification failed");
					TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		/*
		 * This method will verify the primary point of contact information from the sample search table and click view link.
		 */
		public void click_view_link_by_sample_poc_contains_name(String primaryPOC) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;
			
			captureScreenshot(dir+"/snapshots/"+ primaryPOC +".png");
			for (int i=1;i<rCount;i++){
				String buildExpectedValue = null;
				buildExpectedValue = primaryPOC;
				String actualVal = null;
				String diff = null;
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(3)")).replaceAll("\\n", " ");
				actualVal = tableCellData;
				diff = actualVal.substring(primaryPOC.length());
				logger.info("Identified difference: [" + diff +"]");
				buildExpectedValue = "" + buildExpectedValue + diff +"";
				logger.info("Expected Value:[" + buildExpectedValue +"]");
				int currentRowCountVal = i ;
				int subtrTableHeader = rCount - 2;
				logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
				if (tableCellData.equals(buildExpectedValue)) {
					click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					logger.info("System identified expected sample name value:["+ tableCellData +"] matched with actual sample name value:["+ tableCellData +"]");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Successful","Pass", primaryPOC +".png");
					stepCount++;
					boolean retVal = verifyText(buildExpectedValue, tableCellData);
					logger.info("Verify result status:["+ retVal +"]");
					if (retVal == false){
						logger.error("Sample Search Result verification failed");
						TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}else if (retVal == true){
						logger.info("Sample Search Result Verification Successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","view_sample_details_from_search_results_page","view sample details verification successful","Pass");
						stepCount++;				
					}
					break;
				} else if (subtrTableHeader == currentRowCountVal) {
					logger.error("Sample Search Result verification failed");
					TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		/*
		 * This method click on the view link by sample name
		 */
		public void click_view_link_by_sample_name_contains(String expSampleName) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;			
			captureScreenshot(dir+"/snapshots/"+ expSampleName +".png");
			for (int i=1;i<rCount;i++){
				String buildExpectedValue = null;
				buildExpectedValue = expSampleName;
				String actualVal = null;
				String diff = null;
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(2)")).replaceAll("\\n", " ");
				actualVal = tableCellData;
				diff = actualVal.substring(expSampleName.length());
				logger.info("Identified difference: [" + diff +"]");
				buildExpectedValue = "" + buildExpectedValue + diff +"";
				logger.info("Expected Value:[" + buildExpectedValue +"]");
				int currentRowCountVal = i ;
				int subtrTableHeader = rCount - 2;
				logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
				if (tableCellData.equals(buildExpectedValue)) {
					click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					logger.info("System identified expected sample name value:["+ tableCellData +"] matched with actual sample name value:["+ tableCellData +"]");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","click_view_link_by_sample_name_contains","Successfully click on the sample:["+ tableCellData +"]'s view hyperlink","Pass", expSampleName +".png");
					stepCount++;
					boolean retVal = verifyText(buildExpectedValue, tableCellData);
					logger.info("Verify result status:["+ retVal +"]");
					if (retVal == false){
						logger.error("Sample Search Result verification failed");
						TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","click_view_link_by_sample_name_contains","Uanble to click on the sample:["+ tableCellData +"]'s view hyperlink","Fail", expSampleName+".png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}else if (retVal == true){
						logger.info("Sample Search Result Verification Successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","click_view_link_by_sample_name_contains","Successfully click on the sample:["+ tableCellData +"]'s view hyperlink","Pass");
						stepCount++;				
					}
					break;
				} else if (subtrTableHeader == currentRowCountVal) {
					logger.error("Sample Search Result verification failed");
					TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","click_view_link_by_sample_name_contains","Unable to click on the sample:["+ tableCellData +"]'s view hyperlink","Fail", expSampleName+".png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		
		/*
		 * This method verify search result sample name which contains the sample name
		 */
		public void verify_sample_name_equals_from_search_results_page(String sampleName) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;
			String buildExpectedValue = sampleName;
			captureScreenshot(dir+"/snapshots/"+ sampleName +".png");
			for (int i=1;i<rCount;i++){
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(2)"));
				String actualVal = "";
				actualVal = tableCellData;
				String diff = actualVal.substring(sampleName.length());
				logger.info("Identified difference: [" + diff +"]");
				buildExpectedValue = "" + buildExpectedValue + diff +"";
				logger.info("Expected Value:[" + buildExpectedValue +"]");
				int currentRowCountVal = i ;
				int subtrTableHeader = rCount - 2;
				logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
				if (tableCellData.equals(sampleName)) {
					//click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					logger.info("System identified expected sample name value:["+ tableCellData +"] matched with actual sample name value:["+ tableCellData +"]");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Successful","Pass", sampleName +".png");
					stepCount++;
					boolean retVal = verifyText(sampleName, tableCellData);
					logger.info("Verify result status:["+ retVal +"]");
					if (retVal == false){
						logger.error("Sample Search Result verification failed");
						TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());
					}else if (retVal == true){
						logger.info("Sample Search Result Verification Successful");
						oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result Verification","view_sample_details_from_search_results_page","view sample details verification successful","Pass");
						stepCount++;				
					}
					break;
				} else if (subtrTableHeader == currentRowCountVal) {
					logger.error("Sample Search Result verification failed");
					TestExecutionException e = new TestExecutionException("Sample Search Result verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Search Result verification","verify_sample_name_from_search_results_page","Sample Search Result Verification Failed","Fail", "sampleDetailsPage.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}
		}
		/*
		 * Sample Composition Tabs verification
		 */
		public void verify_sample_composition_tabs(String getNanomaterialEntity, String getFunctionalizingEntity) throws TestExecutionException {
			String gNanomaterialEntity = null;
			String gFunctionalizingEntity = null;			
			gNanomaterialEntity = getText(By.xpath("//table[@id='summarySection'][2].1.0")).replaceAll("\\n", " ");
			gFunctionalizingEntity = getText(By.cssSelector(".characterization.ng-binding:nth-child(2)"));			
			logger.info("gNanomaterialEntity["+gNanomaterialEntity);
			logger.info("gFunctionalizingEntity["+gFunctionalizingEntity);				
		}
		/*
		 * Sample Tabs navigations
		 */
		public void navigate_sample_tabs(String getNavigateVal) throws TestExecutionException {
			String gGeneralInfo = null;
			String gComposition  = null;
			String gCharacterization = null;
			String gPublication = null;
			//Tabs
			gGeneralInfo = getText(By.cssSelector(".liNav li:nth-child(1)"));
			gComposition  = getText(By.cssSelector(".liNav li:nth-child(2)"));
			gCharacterization = getText(By.cssSelector(".liNav li:nth-child(3)"));
			gPublication = getText(By.cssSelector(".liNav li:nth-child(4)"));
			if (gGeneralInfo.equals("General Info") && gComposition.equals("Composition") && gCharacterization.equals("Characterization") && gPublication.equals("Publication")) {
				logger.info("Sample Tabs verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Tabs Verification","verify_sample_tabs","Sample Tabs:"
						+ "["+ gGeneralInfo +" and "+ gComposition +" and "+ gCharacterization +" and "+ gPublication +"] verfication successful","Pass");
				stepCount++;
			} else {
				captureScreenshot(dir+"/snapshots/sampleGeneralTab.png");
				logger.error("Sample General info Lables verification failed");
				TestExecutionException e = new TestExecutionException("Sample Tabs verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Tabs verification","verify_sample_tabs","Sample Tabs:"
						+ "["+ gGeneralInfo +" and "+ gComposition +" and "+ gCharacterization +" and "+ gPublication +"] verfication Failed","Fail", "sampleGeneralTab.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}			
			if (getNavigateVal.isEmpty() == false) {
				if (getNavigateVal == "General Info"){
					click(By.cssSelector(".liNav li:nth-child(1) a"));
				} else if (getNavigateVal == "Composition") {
					click(By.cssSelector(".liNav li:nth-child(2) a"));
				} else if (getNavigateVal == "Characterization") {
					click(By.cssSelector(".liNav li:nth-child(3) a"));
				} else if (getNavigateVal == "Publication") {
					click(By.cssSelector(".liNav li:nth-child(4) a"));
				} else {
					captureScreenshot(dir+"/snapshots/TabNavigate.png");
					logger.error("Sample Tab Navigation Failed");
					TestExecutionException e = new TestExecutionException("Sample Tab Navigation Failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Tab Navigation Failed","navigate_sample_tabs","Sample Tabs:["+ getNavigateVal +"] Navigation Failed","Fail", "TabNavigate.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
				}
			}			
		}
		/*
		 * Smaple Tabs verification
		 */
		public void verify_sample_tabs() throws TestExecutionException {
			String gGeneralInfo = null;
			String gComposition  = null;
			String gCharacterization = null;
			String gPublication = null;
			//Tabs
			gGeneralInfo = getText(By.cssSelector(".liNav li:nth-child(1)"));
			gComposition  = getText(By.cssSelector(".liNav li:nth-child(2)"));
			gCharacterization = getText(By.cssSelector(".liNav li:nth-child(3)"));
			gPublication = getText(By.cssSelector(".liNav li:nth-child(4)"));
			if (gGeneralInfo.equals("General Info") && gComposition.equals("Composition") && gCharacterization.equals("Characterization") && gPublication.equals("Publication")) {
				logger.info("Sample Tabs verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Tabs Verification","verify_sample_tabs","Sample Tabs:"
						+ "["+ gGeneralInfo +" and "+ gComposition +" and "+ gCharacterization +" and "+ gPublication +"] verfication successful","Pass");
				stepCount++;
			} else {
				captureScreenshot(dir+"/snapshots/sampleGeneralTab.png");
				logger.error("Sample General info Lables verification failed");
				TestExecutionException e = new TestExecutionException("Sample Tabs verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Tabs verification","verify_sample_tabs","Sample Tabs:"
						+ "["+ gGeneralInfo +" and "+ gComposition +" and "+ gCharacterization +" and "+ gPublication +"] verfication Failed","Fail", "sampleGeneralTab.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * verify_sample_general_info
		 */
		public void verify_sample_general_info(String getSampleName, String getCreatedDate, String getKeywords, String getPrimaryContact, String getContactPerson, String getOrganization, String getRole) throws TestExecutionException {
			//Verify the Samples tabs
			verify_sample_tabs();
			String gSampleNameTag = null;
			String gCreatedDateTag = null;
			String gKeywordsTag = null;
			String gPointsOfContactTag = null;
			String gPrimaryContactTag = null;
			String gContactPersonTag = null;
			String gOrganizationTag = null;
			String gRoleTag = null;
			gSampleNameTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(1) .cellLabel:nth-child(1)"));
			logger.info("gSampleNameTag["+ gSampleNameTag +"]");
			gCreatedDateTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(2) .cellLabel:nth-child(1)"));
			logger.info("gCreatedDateTag["+ gCreatedDateTag +"]");
			gKeywordsTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(3) .cellLabel:nth-child(1)"));
			logger.info("gKeywordsTag["+ gKeywordsTag +"]");
			gPointsOfContactTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(4) .cellLabel:nth-child(1)"));
			logger.info("gPointsOfContactTag["+ gPointsOfContactTag +"]");
			gPrimaryContactTag = getText(By.cssSelector(".invisibleTable tbody tr th:nth-child(1)"));
			logger.info("gPrimaryContactTag["+ gPrimaryContactTag +"]");
			gContactPersonTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(1) .cellLabel:nth-child(2)"));
			logger.info("gContactPersonTag["+ gContactPersonTag +"]");
			gOrganizationTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(1) .cellLabel:nth-child(3)"));
			logger.info("gOrganizationTag["+ gOrganizationTag +"]");
			gRoleTag = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(1) .cellLabel:nth-child(4)"));
			logger.info("gRoleTag["+ gRoleTag +"]");
			if (gSampleNameTag.equals("Sample Name") && gCreatedDateTag.equals("Created Date") && gKeywordsTag.equals("Keywords") && gPointsOfContactTag.equals("Point of Contact") && gPrimaryContactTag.equals("Primary Contact?") && gContactPersonTag.equals("Contact Person") && gOrganizationTag.equals("Organization") && gRoleTag.equals("Role")) {
				logger.info("Sample General info Lables verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Verification","verify_sample_general_info","Sample General Info Label:"
						+ "["+ gSampleNameTag +" and "+ gCreatedDateTag +" and "+ gKeywordsTag +" and "+ gPointsOfContactTag +" and "
								+ ""+ gPrimaryContactTag +" and "+ gContactPersonTag +" and "+ gOrganizationTag +" and "+ gRoleTag +"] verfication successfull","Pass");
				stepCount++;
			} else {
				captureScreenshot(dir+"/snapshots/sampleGeneralInfo.png");
				logger.error("Sample General info Lables verification failed");
				TestExecutionException e = new TestExecutionException("Sample General info Lables verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Lables verification","verify_sample_general_info","Sample General Info Label:"
						+ "["+ gSampleNameTag +" and "+ gCreatedDateTag +" and "+ gKeywordsTag +" and "+ gPointsOfContactTag +" and "
								+ ""+ gPrimaryContactTag +" and "+ gContactPersonTag +" and "+ gOrganizationTag +" and "+ gRoleTag +"] verfication Failed","Fail", "sampleGeneralInfo.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
			}
			String gSampleNameVal = null;
			String gCreatedDateVal = null;
			String gKeywordsVal = null;
			//String gPointsOfContactVal = null;
			String gPrimaryContactVal = null;
			String gContactPersonVal = null;
			String gOrganizationVal = null;
			String gRoleVal = null;
			gSampleNameVal = getText(By.cssSelector(".summaryViewNoGrid tbody .summaryViewNoGrid tbody tr:nth-child(1) .ng-binding"));
			logger.info("gSampleNameVal["+ gSampleNameVal +"]");
			gCreatedDateVal = getText(By.cssSelector(".summaryViewNoGrid .summaryViewNoGrid tbody tr:nth-child(2) td:nth-child(2) "));
			logger.info("gCreatedDateVal["+ gCreatedDateVal +"]");
			gKeywordsVal = getText(By.cssSelector(".summaryViewNoGrid .summaryViewNoGrid tbody div.ng-binding:nth-child(1)")).replaceAll("\\n", " ");
			logger.info("gKeywordsVal["+ gKeywordsVal +"]");
			//gPointsOfContactVal = getText(By.cssSelector(""));
			gPrimaryContactVal = getText(By.cssSelector(".invisibleTable tbody tr td:nth-child(1)"));
			logger.info("gPrimaryContactVal["+ gPrimaryContactVal +"]");
			gContactPersonVal = getText(By.cssSelector(".invisibleTable tbody tr td:nth-child(2)")).replaceAll("\\n", " ");
			logger.info("gContactPersonVal["+ gContactPersonVal +"]");
			gOrganizationVal = getText(By.cssSelector(".invisibleTable tbody tr td:nth-child(3)")).replaceAll("\\n", " ");
			logger.info("gOrganizationVal["+ gOrganizationVal +"]");
			gRoleVal = getText(By.cssSelector(".invisibleTable tbody tr td:nth-child(4)"));
			logger.info("gRoleVal["+ gRoleVal +"]");
			//Sample Name
			captureScreenshot(dir+"/snapshots/sampleGeneralInfoSNM.png");
			if (getSampleName.isEmpty() == false){
				if (gSampleNameVal.equals(getSampleName)){
					logger.info("Sample General info Sample Name verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Sample Name Verification","verify_sample_general_info","Sample General Info Expected: ["+ getSampleName +"] with Actual:["+ gSampleNameVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("Sample General info Lables verification failed");
					TestExecutionException e = new TestExecutionException("Sample General info Lables verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Sample Name verification","verify_sample_general_info","Sample General Info Expected: ["+ getSampleName +"] with Actual:["+ gSampleNameVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
			//Created Date
			if (getCreatedDate.isEmpty() == false){
				if (gCreatedDateVal.equals(getCreatedDate)){
					logger.info("Sample General Info Created Date Verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Created Date Verification","verify_sample_general_info","Sample General Info Expected: ["+ getCreatedDate +"] with Actual:["+ gCreatedDateVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("SSample General Info Created Date Verification failed");
					TestExecutionException e = new TestExecutionException("Sample General Info Created Date Verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Created Date Verification verification","verify_sample_general_info","Sample General Info Expected: ["+ getCreatedDate +"] with Actual:["+ gCreatedDateVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
			//Keyword
			if (getKeywords.isEmpty() == false){
				if (gKeywordsVal.contains(getKeywords)){
					logger.info("Sample General info Keywords verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Keywords verification","verify_sample_general_info","Sample General Info Expected: ["+ getKeywords +"] with Actual:["+ gKeywordsVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("Sample General info Keywords verification failed");
					TestExecutionException e = new TestExecutionException("Sample General info Keywords verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Keywords verification","verify_sample_general_info","Sample General Info Expected: ["+ getKeywords +"] with Actual:["+ gKeywordsVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
			//Primary Contact
			if (getPrimaryContact.isEmpty() == false){
				if (gPrimaryContactVal.equals(getPrimaryContact)){
					logger.info("Sample General info Primary Contact verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Primary Contact Verification","verify_sample_general_info","Sample General Info Expected: ["+ getPrimaryContact +"] with Actual:["+ gPrimaryContactVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("Sample General info Primary Contact verification failed");
					TestExecutionException e = new TestExecutionException("Sample General info Primary Contact verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Primary Contact verification","verify_sample_general_info","Sample General Info Expected: ["+ getPrimaryContact +"] with Actual:["+ gPrimaryContactVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
			//Contact Person
			if (getContactPerson.isEmpty() == false){
				if (gContactPersonVal.contains(getContactPerson)){
					logger.info("Sample General info Contact Person verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Contact Person Verification","verify_sample_general_info","Sample General Info Expected: ["+ getContactPerson +"] with Actual:["+ gContactPersonVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("Sample General info Contact Person verification failed");
					TestExecutionException e = new TestExecutionException("Sample General info Contact Person verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Contact Person verification","verify_sample_general_info","Sample General Info Expected: ["+ getContactPerson +"] with Actual:["+ gContactPersonVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
			//Organization
			if (getOrganization.isEmpty() == false){
				if (gOrganizationVal.contains(getOrganization)){
					logger.info("Sample General info Organization verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Organization Verification","verify_sample_general_info","Sample General Info Expected: ["+ getOrganization +"] with Actual:["+ gOrganizationVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("Sample General info Organization verification failed");
					TestExecutionException e = new TestExecutionException("Sample General info Organization verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Organization verification","verify_sample_general_info","Sample General Info Expected: ["+ getOrganization +"] with Actual:["+ gOrganizationVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
			//Role
			if (getRole.isEmpty() == false){
				if (gRoleVal.equals(getRole)){
					logger.info("Sample General info Role verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info Role Verification","verify_sample_general_info","Sample General Info Expected: ["+ getRole +"] with Actual:["+ gRoleVal +"] verfication successful","Pass");
					stepCount++;
				} else {
					logger.error("Sample General info Role verification failed");
					TestExecutionException e = new TestExecutionException("Sample General info Role verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample General info Role verification","verify_sample_general_info","Sample General Info Expected: ["+ getRole +"] with Actual:["+ gRoleVal +"] verfication Failed","Fail", "sampleGeneralInfoSNM.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());	
			}
			}
		}
		
		/*
		 * This method verify the Sample search result page
		 */
		public void view_sample_details_from_search_results_page(String sampleName) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;
			for (int i=1;i<rCount;i++){
				tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(2)"));
				if (tableCellData.equals(sampleName)) {
					click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) a"));
					break;
				}
			}
			waitUntil(By.cssSelector(".backButtonNote"), "* Please use the back button located above. The browser back button will not function properly.");
			waitUntil(By.cssSelector(".summaryViewNoGrid .summaryViewNoGrid tbody tr:nth-child(1) td"), sampleName);
			captureScreenshot(dir+"/snapshots/sampleDetailsPage.png");
			boolean retVal = isTextPresent_regExp(By.cssSelector(".contentTitle tbody tr th"),"Sample "+sampleName);
			
			if (retVal == false){
				logger.error("view sample details verification failed");
				TestExecutionException e = new TestExecutionException("view sample details verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"view sample details verification","view_sample_details_from_search_results_page","view sample details verification failed","Fail", "sampleDetailsPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}else {
				logger.info("view sample details verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"view sample details verification","view_sample_details_from_search_results_page","view sample details verification successful","Pass");
				stepCount++;				
			}
		}
		/*
		 * 
		 */
		public void view_data_availability_chart_from_sample_search_results_page(String sampleName, String dataAvail) throws TestExecutionException {
			int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			String tableCellData = null;
				for (int i=1;i<rCount;i++){
					tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(2)"));
					if (tableCellData.equals(sampleName)) {
						click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(7) a"));
						break;
					}
				}
				try {
					_wait(3000);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			boolean retVal = isTextPresent_regExp(By.cssSelector("table.summaryViewWithGrid tbody tr:nth-child(1) th"),dataAvail);
			captureScreenshot(dir+"/snapshots/dataAvailabilityPage.png");
			click(By.cssSelector(".btn.btn-warning.btn-modal:nth-child(1)")); //click on close button
			if (retVal == false){
				logger.error("view Data Availability verification failed");
				TestExecutionException e = new TestExecutionException("view sample details verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"view Data Availability verification","view_data_availability_chart_from_sample_search_results_page","view Data Availability verification failed","Fail", "dataAvailabilityPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());	
			}else {
				logger.info("view Data Availability verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"view Data Availability verification","view_data_availability_chart_from_sample_search_results_page","view Data Availability verification successful","Pass");
				stepCount++;				
			}			
		}
		/*
		 * 
		 */
		public void verifyPage(By by, String text) throws TestExecutionException{
			String actualtext = getText(by);
			boolean retVal = verifyText(actualtext, text);
			captureScreenshot(dir+"/snapshots/"+text+".png");
			if (retVal == false){
				logger.error("Page verification failed. Found - "+ actualtext + ". Expected text - "+ text);
				TestExecutionException e = new TestExecutionException("page verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification failed","Fail", text+".png");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());
						
			}else {
				logger.info("Page verification successful. Text " + text + " found.");
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification successful","Pass");
				stepCount++;				
			}
			
		}
		/*
		 * This method verifies the User Registration
		 */
		public void userRegistration (String title, String firstName, String lastName, String email, String phone, String Organization, String fax, String Description, String userGrpEmail, String action) throws TestExecutionException {
			chooseLoginOptions("Register for a login account");
			//click(By.cssSelector("button[type=submit]"));
			click(By.xpath("//button[@type='submit']"));
			try {
				implicitwait(10);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			boolean retVal1 = isTextPresent("Enter a valid First Name.");
			boolean retVal2 = isTextPresent("Enter a valid Last Name.");
			boolean retVal3 = isTextPresent("Enter a valid Email.");
			boolean retVal4 = isTextPresent("Enter a valid Phone.");
			boolean retVal5 = isTextPresent("Enter Organization Name.");
			captureScreenshot(dir+"/snapshots/userRegistrationPage.png");
			if (retVal1 == false || retVal2 == false || retVal3 == false || retVal4 == false || retVal5 == false){
				logger.error("Required fields verification failed");
				TestExecutionException e = new TestExecutionException("Required fields verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Required fields verification","userRegistration","Verification failed","Fail", "userRegistrationPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}else {
				logger.info("Required fields verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Required fields verification","userRegistration","Verification successful","Pass");
				stepCount++;								
			}
			select("id","title",title);
			enter(By.id("first name"), firstName);
			enter(By.id("last name"), lastName);
			enter(By.id("email"), email);
			enter(By.id("phone"), phone);
			enter(By.id("organization"), Organization);
			enter(By.id("fax"), fax);
			enter(By.id("description"), Description);
			if(userGrpEmail.isEmpty()){
			}else {
				check(By.id("register user group list"));
			}
			if (action.equals("submit")){
				//click(By.cssSelector("button[type=submit]"));
				click(By.xpath("//button[@type='submit']"));
				try {
					_wait(3000);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				String objConfMsg="p.ng-scope.ng-binding"; // registration submit confirmation message
				boolean retConMsg = verifyElementIsTrueOrFalse(By.cssSelector(objConfMsg));
				if (retConMsg == true){
				String expectedVal ="Your registration request has been sent to the administrator for assignment of your User ID and Password. You should receive this information via e-mail within one business day from time of submission.";
				logger.info("User Registration Confirmation Expected:["+ expectedVal +"]");
				String actualVal = getText(By.cssSelector("p.ng-scope.ng-binding")).replaceAll("(\\n)", "");
				logger.info("User Registration Actual Confirmation:["+ actualVal +"]");
				captureScreenshot(dir+"/snapshots/submitUserRegistrationPage.png");
					if (actualVal.equals(expectedVal)){
						logger.info("Registration successful");
						oPDF.enterBlockSteps(bTable,stepCount,"User Registration","userRegistration","User Registration successful","Pass");
						stepCount++;						
					}else {
						logger.error("Registration failed");
						TestExecutionException e = new TestExecutionException("Reset fields verification failed");
						oPDF.enterBlockSteps(bTable,stepCount,"User Registration","userRegistration","User Registration failed","Fail", "submitUserRegistrationPage.png");
						stepCount++;
						setupAfterSuite();	
						Assert.fail(e.getMessage());						
					}
				}
		      }else if(action.equals("reset")){
				//click(By.cssSelector("button[type=button]"));
				click(By.xpath("//button[@type='button']"));
				try {
					implicitwait(20);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				captureScreenshot(dir+"/snapshots/resetUserRegistrationPage.png");
				if (getText(By.id("first name")).isEmpty() && getText(By.id("last name")).isEmpty() && getText(By.id("email")).isEmpty() && getText(By.id("phone")).isEmpty() && getText(By.id("organization")).isEmpty() && getText(By.id("fax")).isEmpty() && getText(By.id("description")).isEmpty()) {
					logger.info("Reset of registration page fields validation successful");
					oPDF.enterBlockSteps(bTable,stepCount,"Reset fields verification","userRegistration","Reset fields successful","Pass");
					stepCount++;						
				}else {
					logger.error("Reset fields verification in registration page failed");
					TestExecutionException e = new TestExecutionException("Reset fields verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Reset fields verification","userRegistration","Verification failed","Fail", "resetUserRegistrationPage.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());					
				}
			}
		}
		/*
		 * Registration Errors verification
		 */
		public void verifyUserRegistrationErrors () throws TestExecutionException {
			boolean retVal1 = isTextPresent("First Name can only contain letters.");
			boolean retVal2 = isTextPresent("Last Name can only contain letters.");
			boolean retVal3 = isTextPresent("Email is invalid");
			boolean retVal4 = isTextPresent("Phone Number format is invalid.");
			boolean retVal5 = isTextPresent("Fax format is invalid.");	
			captureScreenshot(dir+"/snapshots/userRegistrationErrorPage.png");
			if (retVal1 == false || retVal2 == false || retVal3 == false || retVal4 == false || retVal5 == false){
				logger.error("Field verifications in registration page failed");
				TestExecutionException e = new TestExecutionException("Field verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Fields verification","verifyUserRegistrationErrors","Verification failed","Fail", "userRegistrationErrorPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());		
			}else {
				logger.info("Required fields verification in registration page successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Fields verification","verifyUserRegistrationErrors","Verification successful","Pass");
				stepCount++;								
			}			
		}
		/*
		 * 
		 */
		public void switchToChildBrowser() throws TestExecutionException{
			try {
				implicitwait(10);
			} catch (Exception e) {
				e.printStackTrace();
			}
			switchToChildBrowserWindow();
		}
		/*
		 * 
		 */
		public void switchToParentBrowser() throws TestExecutionException{
			switchToParentBrowserWindow();
		}
		/*
		 * 
		 */
		public void closePopupBrowser() throws TestExecutionException{
			switchToParentAfterClosingChildWindow();
		}
		/*
		 * 
		 */
		public void verifyUrl(String expectedUrl) throws TestExecutionException {
			String actualUrl = "";
			actualUrl = getUrl();
			boolean retVal = verifyText(actualUrl, expectedUrl);
			captureScreenshot(dir+"/snapshots/urlVerification.png");
			if (retVal == false){
				logger.error("URL verification failed for url - "+ expectedUrl +". Found - " + actualUrl);
				TestExecutionException e = new TestExecutionException("page verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification failed","Fail", "urlVerification.png");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());			
			}else {
				logger.info("URL verification successful for url - "+expectedUrl);
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification successful","Pass");
				stepCount++;				
			}			
		}
		/*
		 * 
		 */
		public void verifyUrlWithSessionID(String expectedUrl) throws TestExecutionException {
			// Expected URL should be until Session ID for the Browser 
			String actualUrl = "";
			actualUrl = getUrl();
			String diff = actualUrl.substring(expectedUrl.length());
			logger.info("Identified Session ID: [" + diff +"]");
			String buildExpectedURL = "" + expectedUrl + diff +"";
			logger.info("Expected URL:[" + buildExpectedURL +"]");
			boolean retVal = verifyText(actualUrl, buildExpectedURL);
			if (retVal == true){
				logger.info("URL verification successful for url - "+buildExpectedURL);
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification successful","Pass");
				stepCount++;
			}else {
				captureScreenshot(dir+"/snapshots/verifyUrlWithSessionID.png");
				logger.error("URL verification failed for url - "+ buildExpectedURL +". Found - " + actualUrl);
				TestExecutionException e = new TestExecutionException("page verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification failed","Fail", "verifyUrlWithSessionID.png");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());	
			}			
		}
		protected String getBrowserUrl() throws TestExecutionException{
			try{
				Thread.sleep(speed);
				_wait(1000);
				String url = selenium.getCurrentUrl();
				return url;
			}catch(Exception e){
				logger.error("ERROR: " + e.getMessage());
				return null;
			}
		}
		public void click_go() throws TestExecutionException {
			click(By.cssSelector(".loginBlock>tbody>tr>td>input[type=\"submit\"]"));
			wait_For(10000);
		}
		public void verifyPopupPage(By by, String text) throws TestExecutionException {
			click(by);
			try {
				_wait(10000);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			switchToChildBrowser();
			try {
				implicitwait(100);
			} catch (Exception e1) {
				e1.printStackTrace();
			}
			String gTimeVal = DateHHMMSS2();
			boolean retVal = isTextPresent(text);
			captureScreenshot(dir+"/snapshots/textVerificaton"+ gTimeVal +".png");
			if (retVal == false){
				logger.error("Pop-up Page verification failed. Expected text - "+ text + " not found.");
				TestExecutionException e = new TestExecutionException("page verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification failed","Fail", "textVerificaton"+ gTimeVal +".png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());		
			}else {
				logger.info("Page verification successful. Found - "+ text);
				oPDF.enterBlockSteps(bTable,stepCount,"Page verification","verifyPage","Verification successful","Pass");
				stepCount++;				
			}			
		}
		/*
		 * 
		 */
		public void verifyUserSession(String uname, String pwd, String browserType) throws TestExecutionException{
			login(uname,pwd, "ttran");
			click(By.linkText("PROTOCOLS"));
			try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//click(By.linkText("Submit a New Protocol"));
			String protocolPageUrl = getUrl();
			logger.info("Current URL: ["+ protocolPageUrl +"]");
			verifyLinkOnThePage(By.linkText("Create a New Protocol"));
			logger.info("Closing current Browser window");
			close();
			openNewBrowserWindow(browserType);
			logger.info("Open new Browser window");
			navigateTo(protocolPageUrl);
			try {
				_wait(4000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			verifyLinkNotPresentOnThePage(By.linkText("Create a New Protocol"));
			//Need to verify with the Dev team if below seeion out message is not expected
			//boolean retVal = isTextPresent("User is not logged in or session is expired.  Please log in.");
			boolean retVal1 = isNotDisplayed(By.linkText("Create  New Protocol"));
			boolean retVal2 = isNotEnabled(By.linkText("Create a New Protocol"));
			captureScreenshot(dir+"/snapshots/loginErrorPage.png");
			if (retVal1 == true && retVal2 == true){
				logger.error("Login session verification failed");
				TestExecutionException e = new TestExecutionException("Login session verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Login session verification","verifyUserSession","Session verification failed","Fail", "loginErrorPage.png");
				stepCount++;
				setupAfterSuite();		
				Assert.fail(e.getMessage());	
			}else {
				logger.info("Login session verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Login session verification","verifyUserSession","Session verification successful","Pass");
				stepCount++;				
			}
		}
		/*
		 * 
		 */
		public void Verify_caNanoLab_Browse_cananoLab_section_content(String searchProto, String searchSamp, String searchPub) throws TestExecutionException {
			verifyPage(By.cssSelector(".welcomeTitle"),"Welcome to caNanoLab");
			captureScreenshot(dir+"/snapshots/sampleCompositionPage.png");
			boolean retVal1  = isTextPresent(searchProto);
			boolean retVal2  = isTextPresent(searchSamp);
			boolean retVal3  = isTextPresent(searchPub);
			click(By.linkText("Search Protocols"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Protocol Search");
				captureScreenshot(dir+"/snapshots/ProtocolSearchPage.png");
			}catch (Exception e){
			}	
			goHome();
			click(By.linkText("Search Samples"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search");
				captureScreenshot(dir+"/snapshots/SampleSearchPage.png");
			}catch (Exception e){
			}	
			goHome();
			click(By.linkText("Search Publications"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search");
				captureScreenshot(dir+"/snapshots/PublicationSearchPage.png");
			}catch (Exception e){
			}	
			goHome();
			
			if (retVal1 == false || retVal2 == false || retVal3 == false){
				logger.error("Browse caNanoLab Section verification failed");
				TestExecutionException e = new TestExecutionException("Browse caNanoLab Section verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Browse caNanoLab Section verification","Verify_caNanoLab_Browse_cananoLab_section_content","Browse caNanoLab Section verification failed","Fail", "browseSectionPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());
							
			}else {
				logger.info("Browse caNanoLab Section verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Browse caNanoLab Section verification","Verify_caNanoLab_Browse_cananoLab_section_content","Browse caNanoLab Section verification successful","Pass");
				stepCount++;				
			}
		}
		/*
		 * 
		 */
		public void view_sample_composition_from_search_results_page(String sampleName) throws TestExecutionException {
			navigate_to_COMPOSITION_page();
			waitUntilElementVisible(By.cssSelector(".ng-isolate-scope>ul li:nth-child(2) a"));
			captureScreenshot(dir+"/snapshots/sampleCompositionPage.png");
			boolean retVal1  = isTextPresent_regExp(By.cssSelector(".mainContent.ng-scope .contentTitle:nth-child(1) tbody tr th.ng-binding"), "Sample "+sampleName+" Composition");
			int siz = selenium.findElements(By.cssSelector(".ng-isolate-scope>ul li")).size();
			logger.info("Number of tabs: " + siz);
			for (int i=2;i<=siz;i++){
				click(By.cssSelector(".ng-isolate-scope>ul li:nth-child("+i+") a"));
				try {
					_wait(3000);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				click(By.cssSelector(".ng-isolate-scope>ul li:nth-child(1) a")); //Click: All tab 
				try {
					_wait(3000);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				boolean retVal2 = isTextPresent_regExp(By.cssSelector(".summaryViewNoGrid.dataTable.ng-scope tbody tr th.heading:nth-child(1)"),"Nanomaterial Entity");
				if (retVal1 == false || retVal2 == false){
					logger.error("view sample composition verification failed");
					TestExecutionException e = new TestExecutionException("view sample composition verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"view sample composition verification","view_sample_composition_from_search_results_page","view sample composition verification failed","Fail", "sampleCompositionPage.png");
					stepCount++;
					setupAfterSuite();	
					Assert.fail(e.getMessage());
								
				}else {
					logger.info("view sample composition verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"view sample composition verification","view_sample_composition_from_search_results_page","view sample composition verification successful","Pass");
					stepCount++;				
				}
			}
		}
		/*
		 * 
		 */
		public void view_sample_characterization_from_search_results_page(String sampleName) throws TestExecutionException {
			navigate_to_CHARACTERIZATION_page();
			waitUntilElementVisible(By.cssSelector(".ng-isolate-scope>ul li:nth-child(2) a"));
			captureScreenshot(dir+"/snapshots/sampleCharacterizationPage.png");
			boolean retVal1  = isTextPresent_regExp(By.cssSelector(".mainContent.ng-scope .contentTitle:nth-child(1) tbody tr th.ng-binding"), "Sample "+sampleName+" Characterization");
			int siz = selenium.findElements(By.cssSelector(".ng-isolate-scope>ul li")).size();
			System.out.println("Number of tabs: " + siz);
			for (int i=2;i<siz;i++){
				click(By.cssSelector(".ng-isolate-scope>ul li:nth-child("+i+") a"));
				try {
					_wait(4000);
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				click(By.cssSelector(".ng-isolate-scope>ul li:nth-child(1) a")); //Click on All tab 
			boolean retVal2 = isTextPresent_regExp(By.xpath("//table[2]/tbody/tr[1]/td/div"),"Physico-chemical Characterization");
			if (retVal1 == false || retVal2 == false){
				logger.error("view sample characterization verification failed");
				TestExecutionException e = new TestExecutionException("view sample characterization verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"view sample characterization verification","view_sample_characterization_from_search_results_page","view sample characterization verification failed","Fail", "sampleCharacterizationPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());		
			}else {
				logger.info("view sample characterization verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"view sample characterization verification","view_sample_characterization_from_search_results_page","view sample characterization verification successful","Pass");
				stepCount++;				
			}
			}
		}
		/*
		 * 
		 */
		public void view_sample_publication_from_search_results_page(String sampleName, String expText) throws TestExecutionException {
			navigate_to_PUBLICATION_page();
			waitUntilElementVisible(By.cssSelector(".addlink.ng-scope img:nth-child(1)"));
			boolean waitVal = isElementPresent(By.cssSelector(".addlink.ng-scope img:nth-child(1)"));
			if (waitVal == true){
				int siz = selenium.findElements(By.cssSelector(".ng-isolate-scope>ul li")).size();
				logger.info("Number of tabs: " + siz);
				for (int i=2;i<siz;i++){
					click(By.cssSelector(".ng-isolate-scope>ul li:nth-child("+i+") a"));
					wait_For(4000);
				}
					click(By.cssSelector(".ng-isolate-scope>ul li:nth-child(1) a")); //Click: All tab 
				boolean retVal2 = isTextPresent_regExp(By.cssSelector(".ng-isolate-scope>ul li:nth-child(1) a"), expText);
				boolean retVal1  = isTextPresent_regExp(By.cssSelector(".mainContent.ng-scope .contentTitle:nth-child(1) tbody tr th.ng-binding"), "Sample "+sampleName+" Publication");
				captureScreenshot(dir+"/snapshots/samplePublicationPage.png");
				if (retVal1 == false || retVal2 == false){
					logger.error("view sample publication verification failed");
					TestExecutionException e = new TestExecutionException("view sample publication verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"view sample publication verification","view_sample_publication_from_search_results_page","view sample publication verification failed","Fail", "samplePublicationPage.png");
					stepCount++;
					setupAfterSuite();
					Assert.fail(e.getMessage());
				}else {
					logger.info("view sample publication verification successful");
					oPDF.enterBlockSteps(bTable,stepCount,"view sample publication verification","view_sample_publication_from_search_results_page","view sample publication verification successful","Pass");
					stepCount++;				
				}
			}
		}
		/*
		 * 
		 */	
		// Samples 		
		public void navigate_to_submit_to_new_sample_page() throws TestExecutionException {
			click(By.linkText("SAMPLES"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
			click(By.linkText("Submit a New Sample"));
		}
		/*
		 * 
		 */
		public void navigate_to_submit_to_new_sample_composition_page() throws TestExecutionException {
			click(By.xpath("html/body/div[1]/table/tbody/tr[3]/td[1]/navigation/table/tbody/tr[4]/td"));
			logger.info("Menu button: Clicked [ Compostion ] left menu button");
			//click(By.linkText("COMPOSITION"));
			try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		/*
		 * 
		 */
		public void navigate_to_submit_to_new_sample_characterization_page() throws TestExecutionException {
			click(By.xpath("html/body/div[1]/table/tbody/tr[3]/td[1]/navigation/table/tbody/tr[5]/td"));
			logger.info("Menu button: Clicked [ Characterization ] left menu button");
			try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		/*
		 * 
		 */
		public void navigate_to_submit_to_new_sample_publication_page() throws TestExecutionException {
			click(By.xpath("html/body/div[1]/table/tbody/tr[3]/td[1]/navigation/table/tbody/tr[6]/td"));
			logger.info("Menu button: Clicked [ Publication ] left menu button");
			try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		/*
		 * 
		 */
		// Protocol navigation
		public void navigate_to_submit_a_new_protocol_page() throws TestExecutionException {
			click(By.linkText("PROTOCOLS"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			verifyManageProtocols ();
			click(By.linkText("Create a New Protocol"));
		}
		/*
		 * 
		 */
		public void wait_until_element_present(By by, String expVal) throws TestExecutionException {
			try{
				waitUntil(by, expVal);
			}catch (Exception e){
			}
		}
		/*
		 * 
		 */
		// Publication 
		public void navigate_to_SEARCH_PUBLICATION_page() throws TestExecutionException {
			//Navigate to publication >> Search Existing Publications 
			click(By.linkText("PUBLICATIONS"));
			try{
				waitUntil(By.cssSelector(".mainContent.ng-scope .contentTitle:nth-child(1) tbody tr th:nth-child(1)"),"Manage Publications");
			}catch (Exception e){
			}			
			click(By.linkText("Search for Samples by Publication"));
		}
		/*
		 * 
		 */
		public void navigate_to_search_existing_PUBLICATION_page() throws TestExecutionException {
			click(By.linkText("PUBLICATIONS"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Manage Publications");
			}catch (Exception e){
			}
			click(By.linkText("Search Existing Publications"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search");
			}catch (Exception e){
			}
			try {
				_wait(4000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		/*
		 * 
		 */
		public void navigate_to_submit_to_new_publication_page() throws TestExecutionException {
			click(By.linkText("PUBLICATIONS"));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Manage Publications");
			}catch (Exception e){
			}			
			click(By.linkText("Create a New Publication"));
		}
		/*
		 * 
		 */
		public void selectSubmitPublicationStatus (String option) throws TestExecutionException {
			select("id", "status",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void selectSubmitPublicationType (String option) throws TestExecutionException {
			try {
				_wait(600);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			select("id", "category",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void selectPublicationType (String option) throws TestExecutionException {
			select("name", "category",option);
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		public void choosePublicationType (String option) throws TestExecutionException {
			select("id", "titleOperand",option);
			oPDF.enterBlockSteps(bTable,stepCount,"Publication Type","choosePublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		
		public void selectStateProvinceTerritory (String option, String TypeInOther) throws TestExecutionException {
			select("id", "edit-state-province-territory-select",option);
			wait_For(2000);
			enter(By.name("state_province_territory[other]"),TypeInOther);
			
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions"," selectStateProvinceTerritory","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		public void selectSponsorCode (String option) throws TestExecutionException {
			select("name", "sponsorCode",option);
			wait_For(2000);
	
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions"," selectSponsorCode","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		
		
		public void selectContactPersonStateProvinceTerritory (String option) throws TestExecutionException {
			select("id", "edit-contact-person-state-province",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		/*
		 * 
		 */
		public void selectCountry (String option) throws TestExecutionException {
			select("id", "edit-country-select",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		public void selectContactPersonCountry (String option) throws TestExecutionException {
			select("id", "edit-contact-person-country",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		
		
		public void selectPartner (String option) throws TestExecutionException {
			keyEnter(By.cssSelector("#partnerApplicationId"),option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPartner","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		public void selectOrganizationType (String option) throws TestExecutionException {
			keyEnter(By.id("selectOrganizationType"),option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPartner","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		
		
		public void selectStatus (String option) throws TestExecutionException {
			select("id", "edit-field-membership-status-value",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		
		
		/*
		 * 
		 */
		
		public void selectParentCategrory (String option) throws TestExecutionException {
			select("name", "parent",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		
		public void selectParentCategrory2(String parentcat) throws TestExecutionException {
			
			click(By.cssSelector("html.js body.toolbar-themes.toolbar-has-tabs.toolbar-has-icons.toolbar-themes-admin-theme--seven.user-logged-in.path-library.has-glyphicons div.main-container.container.js-quickedit-main-content div.row section.col-sm-12 div.region.region-content div#library.tab-content.admin div#library-edit.tab-pane.active form div#library-parameters div.folder select"));
			//click(By.cssSelector("#library-display > div:nth-child(1) > div.frame > div:nth-child(2) > div > div:nth-child(3) > button.admin.edit-file > a"));
			wait_For(6000);
			keyEnter(By.name("parent"),parentcat);
			wait_For(1000);
			
		}
		
		public void enterPost(String Post) throws TestExecutionException {
			
			wait_For(10000);
			
			selenium.findElement(By.id("cke_25")).sendKeys("This is a new Post for the thread in the selected Forum.");
			
			wait_For(3000);
			
		}
		
		public void enterPostReplyMessage() throws TestExecutionException {
			
			wait_For(10000);
			
			selenium.findElement(By.id("cke_25")).sendKeys("This is a reply message to the selected thread in a forum.");
			
			wait_For(3000);
			
		}
		
		
		
		
		public void click_add_image_button() throws TestExecutionException {
			
			selenium.findElement(By.cssSelector("#cke_22")).click();
			
			wait_For(3000);
			
		}
		
		public void click_add_links_button() throws TestExecutionException {
			
			selenium.findElement(By.cssSelector("#cke_13")).click();
			
			wait_For(3000);
			
		}
		
		
		public void select_search_Country (String option) throws TestExecutionException {
			select("body > div > div > section > div.region.region-content > icrp-root > div > icrp-search-page > div > div.col-sm-3 > icrp-search-form > form > ui-panel:nth-child(2) > div.ui-panel-content > ui-select:nth-child(10) > div > div.select-input-container.default > div > input","Enter Countries",option);
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		
		public void select_parent_from_drop_down (String option) throws TestExecutionException {
			Select parentcat = new Select(selenium.findElement(By.name("parent")));
			parentcat.selectByValue("2");
			//click(By.cssSelector(".btn.btn-success.btn-xs"));
			oPDF.enterBlockSteps(bTable,stepCount,"User Actions","selectPublicationType","Action "+ option + " selected","Pass");
			stepCount++;				
		}
		/*
		 * 
		 */
		
		
		
		
		
		
		// Verification 
		public void verifyManageProtocols () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String option1 = "Manage Protocols"; 
			String option2 = "PROTOCOL LINKS";
			String option3 = "Create a New Protocol";
			String option4 = "Search Existing Protocols";
			String option5 = "This is the manage protocols section. A protocol is a predefined procedural method used in the design and implementation of assays. For example, a protocol could describe the steps a laboratory used for characterizing nanomaterials. In this section, depending on your authorization level, you may submit a new protocol, or search for an existing protocol.";
			captureScreenshot(dir+"/snapshots/manageProtocolsPage.png");
			verifyFileds(option1);
			verifyFileds(option2);
			verifyLink(By.linkText(option3));
			verifyLink(By.linkText(option4));
			verifyFileds(option5);
		}
		/*
		 * 
		 */
		public void verifyManageSamples () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String option1 = "Manage Samples"; 
			String option2 = "SAMPLE LINKS";
			String option3 = "Submit a New Sample";
			String option4 = "Copy an Existing Sample";
			String option5 = "Search Existing Samples";
			String option6 = "This is the manage samples section which allows users to enter general information about the sample, detailed information about the composition of the sample, and information about the physico-chemical, in vitro, and other characterizations performed on the sample. A sample is a formulation of a base nanomaterial platform and any additional components that contribute to the function(s) of the nanomaterial. A sample can also be a control used in comparative analysis. In this section, depending on your authorization level, you may submit new sample information or search for an existing sample for editing, copying, viewing, printing, or exporting.";
			captureScreenshot(dir+"/snapshots/manageSamplesPage.png");
			verifyFileds(option1);
			verifyFileds(option2);
			verifyLink(By.linkText(option3));
			verifyLink(By.linkText(option4));
			verifyLink(By.linkText(option5));
			verifyFileds(option6);
		}
		/*
		 * 
		 */
		public void verifyManagePublications () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String option1 = "Manage Publications"; 
			String option2 = "PUBLICATION LINKS";
			String option3 = "Submit a New Publication";
			String option4 = "Search Existing Publications";
			String option5 = "Search for Samples by Publication";
			String option6 = "This is the manage publications section. Publications can include book chapters, editorials, peer review articles, reports, reviews and other forms of documents. In this section, depending on your authorization level, you may submit a new publication or search for an existing publication.";
			captureScreenshot(dir+"/snapshots/managePublicationsPage.png");
			verifyFileds(option1);
			verifyFileds(option2);
			verifyLink(By.linkText(option3));
			verifyLink(By.linkText(option4));
			verifyLink(By.linkText(option5));
			verifyFileds(option6);		
		}
		/*
		 * 
		 */		
		public void verifyManageCuration () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String option1 = "Manage Curation"; 
			String option2 = "CURATION LINKS";
			String option3 = "Review Data Pending Release to Public";
			String option4 = "Manage Batch Data Availability";
			String option5 = "This is the manage curation section. In this section, curators can view a list of samples, publications, and protocols pending public review, select an item from the pending list, review the item, and make the item accessible to public. Curators can also generate, regenerate and delete data availability metrics in batch.";
			captureScreenshot(dir+"/snapshots/manageCurationPage.png");
			verifyFileds(option1);
			verifyFileds(option2);
			verifyLink(By.linkText(option3));
			verifyLink(By.linkText(option4));
			verifyFileds(option5);
		}
		/*
		 * 
		 */
		public void verifyWelcomePage () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    // Welcome message changes quite frequently
			String option1 = "Welcome to caNanoLab"; 
			String option2 = "Welcome to the cancer Nanotechnology Laboratory";
			verifyFileds(option1);
			verifyFileds(option2);
			oPDF.enterBlockSteps(bTable,stepCount,"Welcome Page","Diagram","Successfully verified Welcome page","Pass");
			stepCount++;
		}
		/*
		 * 
		 */
		public void verifySubmitProtocolPage () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    // Submit Protocol Form
			//String option1 = "Submit Protocol"; 
			String option2 = "Protocol Type *";
			String option3 = "Protocol Name*";
			String option4 = "Protocol Abbreviation"; 
			String option5 = "Protocol Version";
			String option6 = "Protocol File";
			String option7 = "File Title";
			String option8 = "Description";
			String option9 = "Access to the Protocol";
			//String option10 = "type";
			//String option11 = "protocolName";
			//String option12 = "protocolAbbreviation";
			//String option13 = "protocolVersion";
			//String option14 = "external0";
			//String option15 = "external1";
			//String option16 = "uploadedFile";
			//String option17 = "fileTitle";
			//String option18 = "fileDescription";
			//String option19 = "addAccess";
			//String option20 = "addAccess";
			//String option21 = "addAccess";
			captureScreenshot(dir+"/snapshots/submitProtocolPage.png");
			//verifyFileds(option1);
			verifyFileds(option2);
			verifyFileds(option3);
			verifyFileds(option4);
			verifyFileds(option5);
			verifyFileds(option6);
			verifyFileds(option7);
			verifyFileds(option8);
			verifyFileds(option9);		
			//verifyElementIsPresent(By.id(option10));
			//verifyElementIsPresent(By.id(option11));
			//verifyElementIsPresent(By.id(option12));
			//verifyElementIsPresent(By.id(option13));
			//verifyElementIsPresent(By.id(option14));
			//verifyElementIsPresent(By.id(option15));
			//verifyElementIsPresent(By.id(option16));
			//verifyElementIsPresent(By.id(option17));
			//verifyElementIsPresent(By.id(option18));
			//verifyElementIsPresent(By.id(option19));
		}
		/*
		 * 
		 */
		public void verifyProtocolSearchPage () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    // Submit Protocol Form
			String option1 = "Protocol Search"; 
			String option2 = "Protocol Type";
			String option3 = "Protocol Name";
			String option4 = "Protocol Abbreviation"; 
			String option5 = "Protocol File Title";
			String option6 = "type";
			String option7 = "nameOperand";
			String option8 = "protocolName";
			String option9 = "abbreviationOperand";
			String option10 = "protocolAbbreviation";
			String option11 = "titleOperand";
			String option12 = "fileTitle";
			String option13 = "input[type=\"submit\"]";
			String option14 = "input[type=\"reset\"]";
			captureScreenshot(dir+"/snapshots/searchProtocolPage.png");
			verifyFileds(option1);
			verifyFileds(option2);
			verifyFileds(option3);
			verifyFileds(option4);
			verifyFileds(option5);
			verifyElementIsPresent(By.id(option6));
			verifyElementIsPresent(By.id(option7));
			verifyElementIsPresent(By.id(option8));
			verifyElementIsPresent(By.id(option9));
			verifyElementIsPresent(By.id(option10));
			verifyElementIsPresent(By.id(option11));
			verifyElementIsPresent(By.id(option12));
			verifyElementIsPresent(By.cssSelector(option13));
			verifyElementIsPresent(By.cssSelector(option14));	
		}
		/*
		 * 
		 */
		public void verifySubmitSamplePage () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    // Submit Protocol Form
			//String option1 = "Submit Sample"; 
			String option2 = "Sample Name *";
			String option3 = "Point of Contact *";
			String option4 = "Primary Contact?"; 
			String option5 = "Contact Person";
			String option6 = "Organization";
			String option7 = "Role";
			String option8 = "* Please use the back button located above. The browser back button will not function properly.";
			String option9 = "//form[@id='sampleForm']/table/tbody/tr[2]/td[2]";
			String option10 = "//*[@id='sampleForm']/div/div/button[2]";
			String option11 = "//*[@id='sampleForm']/div/div/button[1]";
			String option12 = "div.btn-group.pull-right";
			String option13 = "sampleName";
			String option14 = "html/body/div[1]/table/tbody/tr[3]/td[2]/table/tbody/tr[2]/td/div[1]/div/div/table/tbody/tr/td/button";
			captureScreenshot(dir+"/snapshots/submitSamplePage.png");
			//verifyFileds(option1);
			verifyFileds(option2);
			verifyFileds(option3);
			verifyFileds(option4);
			verifyFileds(option5);
			verifyFileds(option6);
			verifyFileds(option7);
			verifyFileds(option8);
			verifyElementIsPresent(By.xpath(option9));
			verifyElementIsPresent(By.xpath(option10));
			verifyElementIsPresent(By.xpath(option11));
			verifyElementIsPresent(By.cssSelector(option12));
			verifyElementIsPresent(By.id(option13));
			verifyElementIsPresent(By.xpath(option14));				
		}
		/*
		 * 
		 */
		public void verifyCopySamplePage () throws TestExecutionException {
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    // Submit Protocol Form
			//String option1 = "Submit Sample"; 
			String option2 = "Existing Sample *";
			String option3 = "New Sample Name *";
			String option4 = "//*[@id='cloneSampleForm']/table[2]/tbody/tr/td[2]/input[2]";
			String option5 = "//*[@id='resetButton']";
			String option6 = "//*[@id='cloneSampleForm']/table[1]/tbody/tr/td[1]/table/tbody/tr[1]/td[3]/a/img";
			captureScreenshot(dir+"/snapshots/submitSamplePage.png");
			//verifyFileds(option1);
			verifyFileds(option2);
			verifyFileds(option3);
			verifyElementIsPresent(By.xpath(option4));
			verifyElementIsPresent(By.xpath(option5));
			verifyElementIsPresent(By.xpath(option6));
		}
		/*
		 * 
		 */
		public void publication_search_results_verification () throws TestExecutionException {
			boolean retVal = isTextPresent_regExp(By.cssSelector(".mainContent.ng-scope .contentTitle:nth-child(1) tbody tr th:nth-child(1)"), "Sample Information by Publication");
			logger.info("Sample Information by Publication page status is :["+retVal+"]");
			int rCount = getRowCount(By.cssSelector(".table.publication"));
			captureScreenshot(dir+"/snapshots/searchResultPage.png");
			if (retVal == false || rCount < 3){
				logger.error("Publication Search Results Verification Failed");
				TestExecutionException e = new TestExecutionException("Publication search results verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication search results verification","publication_search_results_verification","sample search results verification failed","Fail", "searchResultPage.png");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());			
			}else {
				logger.info("Publication search results verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample search results verification","publication_search_results_verification","Publication search results verification successful","Pass");
				stepCount++;				
			}	
		}
		/*
		 * 
		 */
		// Following method will validate sample search by publication	
		public void Verify_sample_search_by_publication_PubMed_ID(String pbmedid, String pubRef) throws TestExecutionException {
			navigate_to_SEARCH_PUBLICATION_page();
			enter(By.id("id"),pbmedid);
			choosePublicationType("PubMed");
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(1)"),"Publication REF");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(2)"),"Authors");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(3)"),"Title");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(4)"),"Sample Composition");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(5)"),"Sample Characterization");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(6)"),"Journal");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(7)"),"Year");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(8)"),"Vol(lss)Pg");
			}catch (Exception e){
			}
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			publication_search_results_verification();
			captureScreenshot(dir+"/snapshots/sampleInformationByPublication.png");
		    boolean retval1 = isDisplayed(By.linkText(pubRef));
		    if (retval1 == true){
				logger.info("Successfully verified Sample Information by Publication Search result page");
				oPDF.enterBlockSteps(bTable,stepCount,"Successfully verified Sample Information by Publication Search result page","Verify_sample_search_by_publication_PubMed_ID","verification successful","Pass");
				stepCount++;		    	

		    }else {
				logger.error("Failed to verify Sample Information by Publication Search result page");
				TestExecutionException e = new TestExecutionException("sample information from pubmedid search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Failed to verify Sample Information by Publication Search result page","Verify_sample_search_by_publication_PubMed_ID","verification failed","Fail", "sampleInformationByPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_sample_search_by_publication_DOI(String doiid, String doiRef) throws TestExecutionException {
			navigate_to_SEARCH_PUBLICATION_page();
			enter(By.id("id"),doiid);
			choosePublicationType("DOI");
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(1)"),"Publication REF");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(2)"),"Authors");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(3)"),"Title");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(4)"),"Sample Composition");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(5)"),"Sample Characterization");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(6)"),"Journal");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(7)"),"Year");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(8)"),"Vol(lss)Pg");
			}catch (Exception e){
			}
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			publication_search_results_verification();
			captureScreenshot(dir+"/snapshots/sampleInformationByPublication.png");
		    boolean retval1 = isDisplayed(By.linkText(doiRef));
		    if (retval1 == true){
				logger.info("Successfully verified Sample Information by Publication Search result page");
				oPDF.enterBlockSteps(bTable,stepCount,"Successfully verified Sample Information by Publication Search result page","Verify_sample_search_by_publication_DOI","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Failed to verify Sample Information by Publication Search result page");
				TestExecutionException e = new TestExecutionException("sample information from pubmedid search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Failed to verify Sample Information by Publication Search result page","Verify_sample_search_by_publication_DOI","verification failed","Fail", "sampleInformationByPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_sample_search_by_publication_PubMed_ID_as_a_Curator(String pbmedid, String txtVerification) throws TestExecutionException {
			//Wait for caNanoLab Home page welcome message
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"WELCOME TO caNanoLab");
			}catch (Exception e){
			}
			//Navigate to publication search page
			navigate_to_SEARCH_PUBLICATION_page();
			//Enter PubMed id for search
			enter(By.id("id"),pbmedid);
			choosePublicationType("PubMed");
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(1)"),"Publication REF");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(2)"),"Authors");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(3)"),"Title");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(4)"),"Sample Composition");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(5)"),"Sample Characterization");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(6)"),"Journal");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(7)"),"Year");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(8)"),"Vol(lss)Pg");
			}catch (Exception e){
			}
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			publication_search_results_verification();
			captureScreenshot(dir+"/snapshots/"+pbmedid+"Publication.png");
		    //boolean retval = isTextPresent(txtVerification);
		    boolean retVal1 = isDisplayed(By.linkText(txtVerification));
		    if (retVal1 == true){
				logger.info("sample information from pubmedid search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from pubmedid search verification","Verify_sample_search_by_publication_PubMed_ID_as_a_Curator","verification successful","Pass");
				stepCount++;		    	
		
		    }else {
				logger.error("sample information from pubmedid search verification failed");
				TestExecutionException e = new TestExecutionException("sample information from pubmedid search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from pubmedid search verification","Verify_sample_search_by_publication_PubMed_ID_as_a_Curator","verification failed","Fail", pbmedid+"Publication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_sample_search_by_publication_DOI_as_a_Curator(String doiid, String expPubRef) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"WELCOME TO caNanoLab");
			}catch (Exception e){
			}			
			navigate_to_SEARCH_PUBLICATION_page();
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search by Publication");
			}catch (Exception e){
			}
			//Enter DOI into the search criteria 
			enter(By.id("id"),doiid);
			choosePublicationType("DOI");
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(1)"),"Publication REF");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(2)"),"Authors");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(3)"),"Title");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(4)"),"Sample Composition");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(5)"),"Sample Characterization");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(6)"),"Journal");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(7)"),"Year");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(8)"),"Vol(lss)Pg");
			}catch (Exception e){
			}			
			try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
			captureScreenshot(dir+"/snapshots/CuratordoisampleDOIInformationByPublication.png");
		    boolean retVal1 = isDisplayed(By.linkText(expPubRef));
			if (retVal1 == true) {
				logger.info("sample information from DOI search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from DOI search verification","Verify_sample_search_by_publication_DOI_as_a_Curator","verification successful","Pass");
				stepCount++;		    	
			} else {
				logger.error("sample information from DOI search verification failed");
				TestExecutionException e = new TestExecutionException("sample information from DOI search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from DOI search verification","Verify_sample_search_by_publication_DOI_as_a_Curator","verification failed","Fail", "CuratordoisampleDOIInformationByPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }					
		}
		/*
		 * 
		 */		
		public void Verify_sample_search_by_publication_PubMed_ID_as_a_Researcher(String pbmedid, String txtVerification) throws TestExecutionException {
			//Wait for caNanoLab Home page welcome message
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"WELCOME TO caNanoLab");
			}catch (Exception e){
			}
			//Navigate to publication search page
			navigate_to_SEARCH_PUBLICATION_page();
			//Enter PubMed id for search
			enter(By.id("id"),pbmedid);
			choosePublicationType("PubMed");
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(1)"),"Publication REF");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(2)"),"Authors");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(3)"),"Title");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(4)"),"Sample Composition");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(5)"),"Sample Characterization");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(6)"),"Journal");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(7)"),"Year");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(8)"),"Vol(lss)Pg");
			}catch (Exception e){
			}
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			publication_search_results_verification();
			captureScreenshot(dir+"/snapshots/"+pbmedid+"Publication.png");
		    //boolean retval = isTextPresent(txtVerification);
		    boolean retVal1 = isDisplayed(By.linkText(txtVerification));
		    if (retVal1 == true){
				logger.info("sample information from pubmedid search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from pubmedid search verification","Verify_sample_search_by_publication_PubMed_ID_as_a_Curator","verification successful","Pass");
				stepCount++;		    	
		
		    }else {
				logger.error("sample information from pubmedid search verification failed");
				TestExecutionException e = new TestExecutionException("sample information from pubmedid search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from pubmedid search verification","Verify_sample_search_by_publication_PubMed_ID_as_a_Curator","verification failed","Fail", pbmedid+"Publication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */		
		public void Verify_sample_search_by_publication_DOI_as_a_Researcher(String doiid, String expPubRef) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"WELCOME TO caNanoLab");
			}catch (Exception e){
			}			
			navigate_to_SEARCH_PUBLICATION_page();
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search by Publication");
			}catch (Exception e){
			}
			//Enter DOI into the search criteria 
			enter(By.id("id"),doiid);
			choosePublicationType("DOI");
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(1)"),"Publication REF");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(2)"),"Authors");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(3)"),"Title");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(4)"),"Sample Composition");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(5)"),"Sample Characterization");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(6)"),"Journal");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(7)"),"Year");
				waitUntil(By.cssSelector(".table.publication tbody tr th:nth-child(8)"),"Vol(lss)Pg");
			}catch (Exception e){
			}			
			try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
			captureScreenshot(dir+"/snapshots/CuratordoisampleDOIInformationByPublication.png");
		    boolean retVal1 = isDisplayed(By.linkText(expPubRef));
			if (retVal1 == true) {
				logger.info("sample information from DOI search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from DOI search verification","Verify_sample_search_by_publication_DOI_as_a_Curator","verification successful","Pass");
				stepCount++;		    	
			} else {
				logger.error("sample information from DOI search verification failed");
				TestExecutionException e = new TestExecutionException("sample information from DOI search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"sample information from DOI search verification","Verify_sample_search_by_publication_DOI_as_a_Curator","verification failed","Fail", "CuratordoisampleDOIInformationByPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }					
		}
		/*
		 * Verify Publication search result table header
		 */
		public void Verify_publication_search_result_table() throws TestExecutionException {
			logger.info("Waiting for Publication Search Results page");
			try{
				waitUntil(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(2)"),"Bibilography Info");
			}catch (Exception e){
			}
			logger.info("Validating Publication Search Results Table Header");
			String gnullClmn = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(1)"));
			logger.info("Identified Searcg Result Table Column:["+gnullClmn+"]");
			String gBibilographyInfo = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(2)"));
			logger.info("Identified Searcg Result Table Column:["+gBibilographyInfo+"]");
			String gPublicationType = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(3)"));
			logger.info("Identified Searcg Result Table Column:["+gPublicationType+"]");
			String gResearchCategory = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(4)"));
			logger.info("Identified Searcg Result Table Column:["+gResearchCategory+"]");
			String gAssociatedSampleNames = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(5)"));
			logger.info("Identified Searcg Result Table Column:["+gAssociatedSampleNames+"]");
			String gDescription = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(6)"));
			logger.info("Identified Searcg Result Table Column:["+gDescription+"]");
			String gPublicationStatus = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(7)"));
			logger.info("Identified Searcg Result Table Column:["+gPublicationStatus+"]");
			String gCreatedDate = getText(By.cssSelector(".table.sample.ng-scope.ng-table thead tr:nth-child(1) th:nth-child(8)"));
			logger.info("Identified Searcg Result Table Column:["+gCreatedDate+"]");
			//int rCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			if (gnullClmn.equals("Actions") 
				&& gBibilographyInfo.equals("Bibliography Info") 
				&& gPublicationType.equals("Publication Type") 
				&& gResearchCategory.equals("Research Category") 
				&& gAssociatedSampleNames.equals("Associated Sample Names") 
				&& gDescription.equals("Description") 
				&& gPublicationStatus.equals("Publication Status") 
				&& gCreatedDate.equals("Created Date")){
				logger.info("Publication Search results table verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Search results table verification","Verify_publication_search_result_table","Publication Search results table verification successful","Pass");
				stepCount++;
			}else {
				captureScreenshot(dir+"/snapshots/pubtSearchResults.png");
				logger.error("Publication Search results table verification failed");
				TestExecutionException e = new TestExecutionException("Publication Search results table verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Search results table verification","Verify_publication_search_result_table","Publication Search results table verification failed","Fail", "pubtSearchResults.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Publication by keyword
		 */
		public void Verify_publication_search_by_keyword(String keywrd) throws TestExecutionException {
			//Wait for Sample search page
			logger.info("Waiting for Sample search page");
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search");
			}catch (Exception e){
			}
			//Navigating to Search Existing Publication page
			navigate_to_search_existing_PUBLICATION_page();
			//Wait for Publication Search page
			logger.info("Waiting for Publication Search page");
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search");
			}catch (Exception e){
			}
			//Enter search term
			enter(By.id("keywordsStr"),keywrd);
			click(By.cssSelector("input[type=\"submit\"]"));
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/keywordPublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Keyword publication search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Keyword publication search verification","Verify_publication_search_by_keyword","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Keyword publication search verification failed");
				TestExecutionException e = new TestExecutionException("Keyword publication search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Keyword publication search verification","Verify_publication_search_by_keyword","verification failed","Fail", "keywordPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * Publication_Type
		 */
		public void Verify_publication_search_by_Publication_Type() throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			selectPublicationType ("report");
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication type search verification","Verify_publication_search_by_Publication_Type","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication search verification failed");
				TestExecutionException e = new TestExecutionException("Keyword publication search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication type search verification","Verify_publication_search_by_Publication_Type","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * Research_Category
		 */
		public void Verify_publication_search_by_Research_Category() throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			click(By.xpath("(//input[@id='researchArea'])[3]"));
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/cataPublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Category search verification","Verify_publication_search_by_Research_Category","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Category search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Category search verification","Verify_publication_search_by_Research_Category","verification failed","Fail", "cataPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * PubMed_ID
		 */
		public void test_004_Verify_publication_search_by_PubMed_ID(String pbmedid) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			enter(By.id("pubMedId"),pbmedid);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/idPublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication ID search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication ID search verification","test_004_Verify_publication_search_by_PubMed_ID","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication ID search verification failed");
				TestExecutionException e = new TestExecutionException("Publication ID search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication ID search verification","test_004_Verify_publication_search_by_PubMed_ID","verification failed","Fail", "idPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_search_by_Digital_Object_ID(String doiid) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			enter(By.id("digitalObjectId"),doiid);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/doiPublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication DOI search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication DOI search verification","Verify_publication_search_by_Digital_Object_ID","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication DOI search verification failed");
				TestExecutionException e = new TestExecutionException("Publication DOI search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication DOI search verification","Verify_publication_search_by_Digital_Object_ID","verification failed","Fail", "doiPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void search_publication_title_no_match(String ttle) throws TestExecutionException {
			navigate_to_search_existing_PUBLICATION_page();
			//
			enter(By.id("title"), ttle);
			click(By.cssSelector("input[type=\"submit\"]"));
			wait_For(3000);
			String getNoResultMsg = getText(By.cssSelector("div.ng-binding:nth-child(8)"));
			logger.info("Actual Search Message:["+ getNoResultMsg +"]");
			captureScreenshot(dir+"/snapshots/noMatch.png");
		    if (getNoResultMsg.equals("No publications were found for the given parameters")){
				logger.info("Publication Title No Match Verification Successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title No Match Verification","search_publication_title_no_match","verification successful","Pass", "noMatch.png");
				stepCount++;		    	
		    }else {
				logger.error("Publication Title No Match Verification failed");
				TestExecutionException e = new TestExecutionException("Publication Title No Match Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title No Match Verification","search_publication_title_no_match","verification failed","Fail", "noMatch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void search_publication_title(String ttle, String getEditORAddToFavorites) throws TestExecutionException {
			/*
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			*/
			navigate_to_search_existing_PUBLICATION_page();
			//
			enter(By.id("title"), ttle);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Title search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title search verification","Verify_publication_contains_search_by_Publication_Title","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication DOI search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Title search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title search verification","Verify_publication_contains_search_by_Publication_Title","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		    String buildPubTitleBioInfo = null;
		    buildPubTitleBioInfo = ""+ ttle +".";
		    if (getEditORAddToFavorites.isEmpty()==false) {
		    	//Edit Publication
		    	if (getEditORAddToFavorites.equals("Edit")){
				for (int i=1;i<resultCount;i++){
				    String tableCellData = null;
					tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(2)")).replaceAll("\\n", " ");
					int currentRowCountVal = i ;
					logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
					if (tableCellData.contains(buildPubTitleBioInfo)) {
						//Edit Publication
						logger.info("Clicking Edit link on the identified value:["+ tableCellData +"]");
						click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+i+") td:nth-child(1) .ng-scope:nth-child(1)"));
						wait_For(3000);
					}
				break;
				}
		    	}
		    	//Add to Favorites
		    	if (getEditORAddToFavorites.equals("Add to Favorites")){
				for (int r=1;r<resultCount;r++){
				    String tableCellData = null;
					tableCellData = getText(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+r+") td:nth-child(2)")).replaceAll("\\n", " ");
					int currentRowCountVal = r ;
					logger.info("Current Row is:["+ currentRowCountVal +"] and identified Value is: ["+ tableCellData +"]");
					if (tableCellData.contains(buildPubTitleBioInfo)) {
						//Add to Favorites
						logger.info("Clicking Add to Favorites link on the identified value:["+ tableCellData +"]");
						click(By.cssSelector(".table.sample.ng-scope.ng-table tbody tr:nth-child("+r+") td:nth-child(1) .ng-scope:nth-child(3)"));
						wait_For(3000);
					}
				break;
				}
		    	}
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_contains_search_by_Publication_Title(String ttle) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			enter(By.id("title"), ttle);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Title search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title search verification","Verify_publication_contains_search_by_Publication_Title","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication DOI search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Title search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title search verification","Verify_publication_contains_search_by_Publication_Title","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_equals_search_by_Publication_Title(String gOption, String ttle) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			select("id", "titleOperand", gOption);
			enter(By.id("title"),ttle);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Title search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title search verification","Verify_publication_equals_search_by_Publication_Title","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication Title search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Title search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Title search verification","Verify_publication_equals_search_by_Publication_Title","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_search_by_Authors(String authr) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			enter(By.id("authorsStr"),authr);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Authors search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Authors search verification","Verify_publication_search_by_Authors","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication Authors search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Authors search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Authors search verification","Verify_publication_search_by_Authors","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_search_by_Sample_Name_option(String sampCnt, String smplOpt) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			chooseSampleOptions(smplOpt);
			enter(By.id("sampleName"), sampCnt);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Sample Name search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Sample Name search verification","Verify_publication_search_by_Sample_Name_option","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication Sample Name search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Sample Name search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Sample Name search verification","Verify_publication_search_by_Sample_Name_option","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_search_by_Composition_Nanomaterial_Entity(String smplOpt) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			chooseCompNanoEntityOptions(smplOpt);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Sample Name search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Sample Name search verification","Verify_publication_search_by_Sample_Name_option","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication Sample Name search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Sample Name search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Sample Name search verification","Verify_publication_search_by_Sample_Name_option","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_search_by_Composition_Functionalizing_Entity(String smplOpt) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			//
			chooseCompFuncEntityOptions(smplOpt);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Functionalizing Entity search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Functionalizing Entity search verification","Verify_publication_search_by_Composition_Functionalizing_Entity","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication Functionalizing Entity search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Functionalizing Entity search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Functionalizing Entity search verification","Verify_publication_search_by_Composition_Functionalizing_Entity","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_publication_search_by_Function(String smplOpt) throws TestExecutionException {
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "Sample Search");
			}catch (Exception e){
			}
			navigate_to_search_existing_PUBLICATION_page();
			wait_For(3000);
			//
			chooseFunctionOptions(smplOpt);
			click(By.cssSelector("input[type=\"submit\"]"));
			//
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search Results");
			}catch (Exception e){
			}
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/PublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Publication Function search successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Function search verification","Verify_publication_search_by_Function","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Publication Function search verification failed");
				TestExecutionException e = new TestExecutionException("Publication Function search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Function search verification","Verify_publication_search_by_Function","verification failed","Fail", "PublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void verify_publication_search_by_keyword_as_a_Curator(String keywrd) throws TestExecutionException {
			//Wait for Sample search page
			logger.info("Waiting for Sample search page");
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search");
			}catch (Exception e){
			}
			//Navigating to Search Existing Publication page
			navigate_to_search_existing_PUBLICATION_page();
			//Wait for Publication Search page
			logger.info("Waiting for Publication Search page");
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search");
			}catch (Exception e){
			}
			//Enter search term
			enter(By.id("keywordsStr"),keywrd);
			click(By.cssSelector("input[type=\"submit\"]"));
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/keywordPublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Keyword publication search successful as Curator");
				oPDF.enterBlockSteps(bTable,stepCount,"Keyword publication search as curator verification","Verify_publication_search_by_keyword","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Keyword publication search verification failed as Curator");
				TestExecutionException e = new TestExecutionException("Keyword publication search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Keyword publication search as curator verification","Verify_publication_search_by_keyword","verification failed","Fail", "keywordPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void verify_publication_search_by_keyword_as_a_Researcher(String keywrd) throws TestExecutionException {
			//Wait for Sample search page
			logger.info("Waiting for Sample search page");
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Sample Search");
			}catch (Exception e){
			}
			//Navigating to Search Existing Publication page
			navigate_to_search_existing_PUBLICATION_page();
			//Wait for Publication Search page
			logger.info("Waiting for Publication Search page");
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Publication Search");
			}catch (Exception e){
			}
			//Enter search term
			enter(By.id("keywordsStr"), keywrd);
			click(By.cssSelector("input[type=\"submit\"]"));
			//Wait for Publication Search Result
			Verify_publication_search_result_table();
			int resultCount = getRowCount(By.cssSelector(".table.sample.ng-scope.ng-table"));
			int totalDisplayResults = resultCount - 2;
			logger.info("Publication search result displaying total:["+ totalDisplayResults +"] records");
			captureScreenshot(dir+"/snapshots/keywordPublicationSearch.png");
		    if (resultCount >= 3){
				logger.info("Keyword publication search successful as Curator");
				oPDF.enterBlockSteps(bTable,stepCount,"Keyword publication search as Researcher verification","Verify_publication_search_by_keyword","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Keyword publication search verification failed as Curator");
				TestExecutionException e = new TestExecutionException("Keyword publication search verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Keyword publication search as Researcher verification","Verify_publication_search_by_keyword","verification failed","Fail", "keywordPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_the_ability_to_submit_a_New_Publication_as_a_Researcher(String pbType, String pbStatus, String pbmedID, String doiID) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)")," WELCOME TO caNanoLab");
			}catch (Exception e){
			}
			navigate_to_submit_to_new_publication_page();
			selectSubmitPublicationType(pbType);
			selectSubmitPublicationStatus(pbStatus);
			try {
				_wait(300);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			enter(By.id("publicationForm.pubMedId"), pbmedID);
			enter(By.id("publicationForm.digitalObjectId"), doiID);
			//From publication title all the field has been hard coded
			try {
				_wait(300);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			enter(By.id("publicationForm.title"), "Translocation of differently sized and charged polystyrene nanoparticles in in vitro intestinal cell models of increasing complexity.");
			enter(By.id("publicationForm.journalName"), "Nanotoxicology");
			enter(By.id("publicationForm.year"), "2014");
			enter(By.id("publicationForm.startPage"), "1");
			enter(By.id("publicationForm.endPage"), "9");
			click(By.id("addAuthor"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("firstName"), "Agata");
			enter(By.id("lastName"), "Walczak");
			enter(By.id("initial"), "AP");
			click(By.cssSelector("div > input.promptButton"));
			click(By.id("addAuthor"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("firstName"), "Evelien");
			enter(By.id("lastName"), "Kramer");
			enter(By.id("initial"), "E");
			click(By.cssSelector("div > input.promptButton"));
			click(By.cssSelector("input.ng-scope"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			captureScreenshot(dir+"/snapshots/sbmtPublicationSearch.png");
		    boolean retval = isTextPresent("Publication successfully saved with title");
		    if (retval == true){
				logger.info("publication submited successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication submit verification","Verify_the_ability_to_submit_a_New_Publication_as_a_Researcher","verification successful","Pass");
				stepCount++;		    
		    }else {
				logger.error("Keyword publication search verification failed");
				TestExecutionException e = new TestExecutionException("Publication submit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication submit verification","Verify_the_ability_to_submit_a_New_Publication_as_a_Researcher","verification failed","Fail", "sbmtPublicationSearch.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * Following methods are for navigate CURATION page
		 */
		public void clickMenubarLinks(String mnuBrLnks, String pgTitle) throws TestExecutionException {
			click(By.linkText(mnuBrLnks));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), pgTitle);
			}catch (Exception e){
			}			
		}
		/*
		 * 
		 */
		public void clickPageLinks(String pgeLnks, String pTitle) throws TestExecutionException {
			click(By.linkText(pgeLnks));
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), pTitle);
			}catch (Exception e){
			}			
		}
		/*
		 * 
		 */
		public void clickIndexLinks(String pLnks, String pIndx) throws TestExecutionException {
			try {
				implicitwait(30);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String bldXpth = "(//a[contains(text(),'" + pLnks +"')])[" + pIndx +"]";
			click(By.xpath(bldXpth));
		}
		/*
		 * 
		 */
		public void clickSampleEdit(String dataName) throws TestExecutionException {
			try {
				implicitwait(30);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			int rCount = getRowCount(By.cssSelector(".table.editTableWithGrid"));
			String tableCellData = null;
			for (int i=1;i<rCount;i++){
				tableCellData = getText(By.cssSelector("td.ng-binding.firepath-matching-node"));
								//     (By.cssSelector("td.ng-binding.firepath-matching-node"))
				if (tableCellData.equals(dataName)) {
					//click(By.cssSelector(".table.editTableWithGrid("+i+") td:nth-child(1) a"));
					click(By.xpath("(//a[contains(text(),'Edit')])["+i+"]"));
					break;
				}
			  }
		}
		/*
		 * 
		 */
		public void verifyLink(By by) throws TestExecutionException{
			boolean retVal1 = isDisplayed(by);
			boolean retVal2 = isEnabled(by);
			if (retVal1 == true && retVal2 == true){
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of the Link","verifyLink","Verification successful for "+ by,"Pass");
				stepCount++;				
			}else {
				logger.error("Link verification failed");
				TestExecutionException e = new TestExecutionException("Verification of Link failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Verification of Link","verifyLink","Verification failed for " + by,"Fail");
				stepCount++;
				setupAfterSuite();	
				Assert.fail(e.getMessage());				
			}
		}
		/*
		 * 
		 */
		public void clickRadio() throws TestExecutionException {
			click(By.id("option2"));
		}
		
		public void click_Active_Radio() throws TestExecutionException {
				click(By.id("edit-status-1"));	
		}
		
		public void click_Blocked_Radio() throws TestExecutionException {
			click(By.id("edit-status-0"));	
		}
	
		
		public void click_Manager_Checkbox() throws TestExecutionException {
			click(By.id("edit-roles-manager"));	
		}
		
		public void click_Partner_Checkbox() throws TestExecutionException {
			click(By.id("edit-roles-partner"));	
		}
		
		
		/*
		 * 
		 */
		public void clickBatchSubmit() throws TestExecutionException {
			try {
				implicitwait(10);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			click(By.cssSelector("input[type=\"submit\"]"));
   	   }
		/*
		 * Following are the caNanoLab CURATION page verification test cases 
		 */
		public void Verify_Curator_should_be_able_to_review_pending_data(String getDataTypeEditVal, String getdTyp, String getdNam) throws TestExecutionException {
			wait_For(3000);
			logger.info("Verifying Review By Curator page");
			try{
				waitUntil(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(1)"), getdTyp);
			}catch (Exception e){
			}
			int rCount = getRowCount(By.cssSelector(".editTableWithGrid"));
			String dType = getText(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(1)"));
			String dName = getText(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(2)"));
			captureScreenshot(dir+"/snapshots/dataPendingReview.png");
		    if (dType.equals(getdTyp) && dName.equals(getdNam)){
				logger.info("Pending review data table displyed successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Pending data review verification","Verify_Curator_should_be_able_to_review_pending_data","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Pending review data verification failed");
				TestExecutionException e = new TestExecutionException("Pending review data verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Pending data review verification","Verify_Curator_should_be_able_to_review_pending_data","verification failed","Fail", "dataPendingReview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		    logger.info("Clicking on the Edit link from Review by Curator page");
			if (dType.equals(getdTyp) && dName.equals(getdNam)){
				String tableCellData = null;
				for (int i=2;i<rCount;i++){
				tableCellData = getText(By.cssSelector(".editTableWithGrid tbody tr:nth-child("+ i +") td:nth-child(1)")).replaceAll("\\n", "");
				logger.info("Review by curator identified data type in the current row is:["+ tableCellData +"]");
				if (tableCellData.equals(getDataTypeEditVal)) {
				click(By.cssSelector(".editTableWithGrid tbody tr:nth-child("+ i +") td:nth-child(3) a"));
				wait_For(4000);
				try{
					waitUntil(By.cssSelector(".submissionView tbody tr:nth-child(4) td:nth-child(1)"), "Keywords");
				}catch (Exception e){
				}
				String editViewVal = getText(By.cssSelector(".submissionView tbody tr:nth-child(4) td:nth-child(1)"));
			    if (editViewVal.equals("Keywords")){
					logger.info("Pending review data edit view displayed successfully");
					oPDF.enterBlockSteps(bTable,stepCount,"Pending data review edit view verification","Verify_Curator_should_be_able_to_review_pending_data","verification successful","Pass");
					stepCount++;		    	
			    }else {
			    	captureScreenshot(dir+"/snapshots/editdataPendingReview.png");
					logger.error("Pending review data verification failed");
					TestExecutionException e = new TestExecutionException("Pending review data edit view verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Pending data review edit view verification","Verify_Curator_should_be_able_to_review_pending_data","verification failed","Fail", "editdataPendingReview.png");
					stepCount++;
					setupAfterSuite();
					Assert.fail(e.getMessage());		    			    	
			    }
				break;
				}
				}
			}				
		}
		/*
		 * 
		 */
		public void verify_user_able_to_submit_generate_data_availability_for_all_samples_search() throws TestExecutionException {
			wait_For(3000);
			clickPageLinks("Manage Batch Data Availability", "Manage Batch Data Availability");
			try{
			click(By.cssSelector(".ng-pristine.ng-valid input:nth-child(1)"));
			click(By.cssSelector(".cellLabel label:nth-child(2)"));
			}catch (Exception e){
			}
			click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input[type='submit']"));
			wait_For(15000);
			String msgVerif = getText(By.cssSelector("li.ng-scope.ng-binding")).replaceAll("\\n", "");
		    boolean retVal = isTextPresent("It will take a while to generate data availability metrics");
			clickMenubarLinks("RESULTS", "Long Running Processes");
			wait_For(1000);
			captureScreenshot(dir+"/snapshots/sbmtGenerateDataAvailabilitySamples.png");
		    if (msgVerif.contains("It will take a while to generate data availability metrics") && retVal == true){
				logger.info("Generate data availability for all samples submited successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Generate data availability for all samples submit verification passed","verify_user_able_to_submit_generate_data_availability_for_all_samples_search","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Generate data availability for all samples verification failed");
				TestExecutionException e = new TestExecutionException("Generate data availability for all samples submit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication submit verification","verify_user_able_to_submit_generate_data_availability_for_all_samples_search","verification failed","Fail", "sbmtGenerateDataAvailabilitySamples.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 	
		 */
		public void Verify_Curator_user_can_view_My_Worksapce() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "My Workspace");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/myworksapceview.png");
			String getMySampleTag = getText(By.cssSelector("div:nth-child(7)"));
			String getMyProtocolTag = getText(By.cssSelector("div:nth-child(10)"));
			String getMyPublicationTag = getText(By.cssSelector("div:nth-child(13)"));
			wait_For(30000); // My workspace has performance issue
			if (getMySampleTag.equals("My Samples") && getMyProtocolTag.equals("My Protocols") && getMyPublicationTag.equals("My Publications")) {
				logger.info("My Workspace page as Curator view successful");
				oPDF.enterBlockSteps(bTable,stepCount,"My workspace page view verification passed","Verify_Curator_user_can_view_My_Worksapce","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("My Workspace page as Curator view failed");
				TestExecutionException e = new TestExecutionException("My Workspace page view verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"My Workspace page verification","Verify_Curator_user_can_view_My_Worksapce","verification failed","Fail", "myworksapceview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_Researcher_user_can_view_My_Worksapce() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "My Workspace");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/myworksapceview.png");
			String getMySampleTag = getText(By.cssSelector("div:nth-child(7)"));
			String getMyProtocolTag = getText(By.cssSelector("div:nth-child(10)"));
			String getMyPublicationTag = getText(By.cssSelector("div:nth-child(13)"));
			wait_For(30000); // My workspace has performance issue
			if (getMySampleTag.equals("My Samples") && getMyProtocolTag.equals("My Protocols") && getMyPublicationTag.equals("My Publications")) {
				logger.info("My Workspace page view as Researcher successful");
				oPDF.enterBlockSteps(bTable,stepCount,"My workspace page view as Researcher verification passed","Verify_Researcher_user_can_view_My_Worksapce","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("My Workspace page as Researcher view failed");
				TestExecutionException e = new TestExecutionException("My Workspace page view verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"My Workspace page as Reseracher verification","Verify_Researcher_user_can_view_My_Worksapce","verification failed","Fail", "myworksapceview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_User_can_uncheck_Samples_from_My_Workspace() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "My Workspace");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/myworksapceview.png");
			String getMySampleTag = getText(By.cssSelector("div:nth-child(7)"));
			String getMyProtocolTag = getText(By.cssSelector("div:nth-child(10)"));
			String getMyPublicationTag = getText(By.cssSelector("div:nth-child(13)"));
			//Uncheck samples
			uncheck(By.cssSelector(".ng-pristine.ng-valid:nth-child(1)"));
			wait_For(30000); // My workspace has performance issue
			if (getMySampleTag != "My Samples" && getMyProtocolTag.equals("My Protocols") && getMyPublicationTag.equals("My Publications")) {
				logger.info("Myworkspace uncheck verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification successful","Verify_User_can_uncheck_Samples_from_My_Workspace","verification successful","Pass");
				stepCount++;		    	
		    }else {
				captureScreenshot(dir+"/snapshots/myworksapceview.png");
				logger.error("Myworkspace uncheck verification failed");
				TestExecutionException e = new TestExecutionException("Myworkspace uncheck verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification failed","Verify_User_can_uncheck_Samples_from_My_Workspace","verification failed","Fail", "myworksapceview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_User_can_Uncheck_protocols_from_My_Workspace() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "My Workspace");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/myworksapceview.png");
			String getMySampleTag = getText(By.cssSelector("div:nth-child(7)"));
			String getMyProtocolTag = getText(By.cssSelector("div:nth-child(10)"));
			String getMyPublicationTag = getText(By.cssSelector("div:nth-child(13)"));
			//Uncheck protocol
			uncheck(By.cssSelector(".ng-pristine.ng-valid:nth-child(3)"));
			wait_For(30000); // My workspace has performance issue
			if (getMySampleTag.equals("My Samples") && getMyProtocolTag != "My Protocols" && getMyPublicationTag.equals("My Publications")) {
				logger.info("Myworkspace uncheck verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification successful","Verify_User_can_uncheck_Samples_from_My_Workspace","verification successful","Pass");
				stepCount++;		    	
		    }else {
				captureScreenshot(dir+"/snapshots/myworksapceview.png");
				logger.error("Myworkspace uncheck verification failed");
				TestExecutionException e = new TestExecutionException("Myworkspace uncheck verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification failed","Verify_User_can_uncheck_Samples_from_My_Workspace","verification failed","Fail", "myworksapceview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_User_can_uncheck_Publications_from_My_Workspace_page() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "My Workspace");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/myworksapceview.png");
			String getMySampleTag = getText(By.cssSelector("div:nth-child(7)"));
			String getMyProtocolTag = getText(By.cssSelector("div:nth-child(10)"));
			String getMyPublicationTag = getText(By.cssSelector("div:nth-child(13)"));
			//Uncheck publications
			uncheck(By.cssSelector(".ng-pristine.ng-valid:nth-child(5)"));
			wait_For(30000); // My workspace has performance issue
			if (getMySampleTag.equals("My Samples") && getMyProtocolTag.equals("My Protocols") && getMyPublicationTag != "My Publications") {
				logger.info("Myworkspace uncheck verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification successful","Verify_User_can_uncheck_Samples_from_My_Workspace","verification successful","Pass");
				stepCount++;		    	
		    }else {
				captureScreenshot(dir+"/snapshots/myworksapceview.png");
				logger.error("Myworkspace uncheck verification failed");
				TestExecutionException e = new TestExecutionException("Myworkspace uncheck verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification failed","Verify_User_can_uncheck_Samples_from_My_Workspace","verification failed","Fail", "myworksapceview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_Curator_User_can_View_samples_from_My_Workspace_page() throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"), "My Workspace");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/myworksapceview.png");
			String getMySampleTag = getText(By.cssSelector("div:nth-child(7)"));
			String getMyProtocolTag = getText(By.cssSelector("div:nth-child(10)"));
			String getMyPublicationTag = getText(By.cssSelector("div:nth-child(13)"));
			//Uncheck publications
			uncheck(By.cssSelector(".ng-pristine.ng-valid:nth-child(5)"));
			wait_For(30000); // My workspace has performance issue
			if (getMySampleTag.equals("My Samples") && getMyProtocolTag.equals("My Protocols") && getMyPublicationTag != "My Publications") {
				logger.info("Myworkspace uncheck verification successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification successful","Verify_User_can_uncheck_Samples_from_My_Workspace","verification successful","Pass");
				stepCount++;		    	
		    }else {
				captureScreenshot(dir+"/snapshots/myworksapceview.png");
				logger.error("Myworkspace uncheck verification failed");
				TestExecutionException e = new TestExecutionException("Myworkspace uncheck verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Myworkspace uncheck verification failed","Verify_User_can_uncheck_Samples_from_My_Workspace","verification failed","Fail", "myworksapceview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void Verify_Curator_User_can_Edit_samples_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");	    	
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}					   	
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			clickIndexLinks("Edit", "1");			
			try {
				_wait(6000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Update Sample");
			}catch (Exception e){
			}	
			boolean retVal1 = isTextPresent("Sample Name");
			boolean retVal2 = isTextPresent("Data Availability Metrics");
			boolean retVal3 = isTextPresent("Keywords");
			boolean retVal4 = isTextPresent("Point of Contact");
			captureScreenshot(dir+"/snapshots/myworksapcesamplesedit.png");
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true){
				logger.info("Samples Edit successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples Edit verification passed","Verify_Curator_User_can_Edit_samples_from_My_Workspace_page","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Samples Edit failed");
				TestExecutionException e = new TestExecutionException("Samples Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples Edit verification","Verify_Curator_User_can_Edit_samples_from_My_Workspace_page","verification failed","Fail", "myworksapcesamplesedit.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
								
		}
		/*
		 * 
		 */
		public void Verify_Researcher_User_can_View_samples_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}				   	
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			clickIndexLinks("View", "1");						
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			boolean retVal1 = isTextPresent("Sample Name");
			boolean retVal2 = isTextPresent("Created Date");
			boolean retVal3 = isTextPresent("Keywords");
			boolean retVal4 = isTextPresent("Point of Contact");			
			captureScreenshot(dir+"/snapshots/resmyworksapcesamplesview.png");			
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true){
				logger.info("Samples View successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples View verification passed","Verify_Researcher_User_can_View_samples_from_My_Workspace_page","verification successful","Pass");
				stepCount++;			
		    }else {
				logger.error("Samples View failed");
				TestExecutionException e = new TestExecutionException("Samples View verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples View verification","Verify_Researcher_User_can_View_samples_from_My_Workspace_page","verification failed","Fail", "resmyworksapcesamplesview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }								
		}
		/*
		 * 
		 */
		public void Verify_Researcher_User_can_Edit_samples_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}			
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			clickIndexLinks("Edit", "1");		
			try {
				_wait(6000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Update Sample");
			}catch (Exception e){
			}	
			boolean retVal1 = isTextPresent("Sample Name");
			boolean retVal2 = isTextPresent("Data Availability Metrics");
			boolean retVal3 = isTextPresent("Keywords");
			boolean retVal4 = isTextPresent("Point of Contact");
			captureScreenshot(dir+"/snapshots/resmyworksapcesamplesedit.png");
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true){
				logger.info("Samples Edit successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples Edit verification passed","Verify_Researcher_User_can_Edit_samples_from_My_Workspace_page","verification successful","Pass");
				stepCount++;			
		    }else {
				logger.error("Samples Edit failed");
				TestExecutionException e = new TestExecutionException("Samples Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples Edit verification","Verify_Researcher_User_can_Edit_samples_from_My_Workspace_page","verification failed","Fail", "resmyworksapcesamplesedit.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }					
		}
		/*
		 * 
		 */
		public void Verify_Curator_User_can_View_My_Protocols_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");	    	
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}				   	
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			clickIndexLinks("View", "3");			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}							
			boolean retVal1 = isTextPresent("Physicochemical and biological assays for quality control of biopharmaceuticals");		
			captureScreenshot(dir+"/snapshots/myworksapceprotocolsview.png");			
		    if (retVal1 == true){
				logger.info("Protocols View successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols View verification passed","Verify_Curator_User_can_View_My_Protocols_from_My_Workspace_page","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Protocols View failed");
				TestExecutionException e = new TestExecutionException("Protocols View verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols View verification","Verify_Curator_User_can_View_My_Protocols_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
								
		}
		/*
		 * 
		 */
		public void Verify_Researcher_User_can_View_My_Protocols_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
	    	try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}			
		   	click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			clickIndexLinks("View", "12");
			try {
				_wait(6000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			boolean retVal1 = isTextPresent("Physicochemical and biological assays for quality control of biopharmaceuticals");
			captureScreenshot(dir+"/snapshots/myworksapceprotocolsview.png");
		    if (retVal1 == true){
				logger.info("Protocols View successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples View verification passed","Verify_Researcher_User_can_View_My_Protocols_from_My_Workspace_page","verification successful","Pass");
				stepCount++;		    	
		
		    }else {
				logger.error("Protocols View failed");
				TestExecutionException e = new TestExecutionException("Protocols View verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols View verification","Verify_Researcher_User_can_View_My_Protocols_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
								
		}
		/*
		 * 
		 */
		public void Verify_Curator_User_can_Edit_My_Protocols_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}			
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			clickIndexLinks("Edit", "3");			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}							
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Update Protocol");
			}catch (Exception e){
			}			
			boolean retVal1 = isTextPresent("Protocol Type");
			boolean retVal2 = isTextPresent("Protocol Name");
			boolean retVal3 = isTextPresent("Protocol Abbreviation");
			boolean retVal4 = isTextPresent("Protocol Version");
			boolean retVal5 = isTextPresent("Protocol File");
			boolean retVal6 = isTextPresent("File Title");
			boolean retVal7 = isTextPresent("Description");
			captureScreenshot(dir+"/snapshots/myworksapceprotocolsedit.png");
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true && retVal5 == true && retVal6 == true && retVal7 == true){
				logger.info("Protocols Edit successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols Edit verification passed","Verify_Curator_User_can_Edit_My_Protocols_from_My_Workspace_page","verification successful","Pass");
				stepCount++;		    	
		    }else {
				logger.error("Protocols Edit failed");
				TestExecutionException e = new TestExecutionException("Protocols Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols Edit verification","Verify_Curator_User_can_Edit_My_Protocols_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }						
		}
		/*
		 * 
		 */
		public void Verify_Reseracher_User_can_Edit_My_Protocols_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}					   	
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			clickIndexLinks("Edit", "13");			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}							
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Update Protocol");
			}catch (Exception e){
			}				
			boolean retVal1 = isTextPresent("Protocol Type");
			boolean retVal2 = isTextPresent("Protocol Name");
			boolean retVal3 = isTextPresent("Protocol Abbreviation");
			boolean retVal4 = isTextPresent("Protocol Version");
			boolean retVal5 = isTextPresent("Protocol File");
			boolean retVal6 = isTextPresent("File Title");
			boolean retVal7 = isTextPresent("Description");
			captureScreenshot(dir+"/snapshots/myworksapceprotocolsedit.png");			
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true && retVal5 == true && retVal6 == true && retVal7 == true){
				logger.info("Protocols Edit successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols Edit verification passed","Verify_Reseracher_User_can_Edit_My_Protocols_from_My_Workspace_page","verification successful","Pass");
				stepCount++;		  	
		    }else {
				logger.error("Protocols Edit failed");
				TestExecutionException e = new TestExecutionException("Protocols Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Protocols Edit verification","Verify_Reseracher_User_can_Edit_My_Protocols_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }								
		}
		/*
		 * 
		 */
		//Publications
		/*
		 * 
		 */
		public void Verify_Curator_User_can_View_My_Publications_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}			
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			clickIndexLinks("View", "5");
			try {
				_wait(7000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			boolean retVal1 = isTextPresent("41287680");		
			captureScreenshot(dir+"/snapshots/myworksapcepublicationsview.png");			
		    if (retVal1 == true){
				logger.info("Publications View successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications View verification passed","Verify_Curator_User_can_View_My_Publications_from_My_Workspace_page","verification successful","Pass");
				stepCount++;			
		    }else {
				logger.error("Publications View failed");
				TestExecutionException e = new TestExecutionException("Publications View verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications View verification","Verify_Curator_User_can_View_My_Publications_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }					
		}
		/*
		 * 
		 */
		public void Verify_Researcher_User_can_View_My_publications_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}			
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			clickIndexLinks("View", "15");
			try {
				_wait(7000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			boolean retVal1 = isTextPresent("38338560");
			captureScreenshot(dir+"/snapshots/myworksapcepublicationsview.png");
		    if (retVal1 == true){
				logger.info("Publications View successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications View verification passed","Verify_Researcher_User_can_View_My_publications_from_My_Workspace_page","verification successful","Pass");
				stepCount++;		    	
		
		    }else {
				logger.error("Publications View failed");
				TestExecutionException e = new TestExecutionException("Publications View verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications View verification","Verify_Researcher_User_can_View_My_publications_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }					
		}
		/*
		 * 
		 */
		public void Verify_Curator_User_can_Edit_My_Publications_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");	    	
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}			   	
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			clickIndexLinks("Edit", "6");			
			try {
				_wait(7000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}							
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Update Publication");
			}catch (Exception e){
			}				   					
			boolean retVal1 = isTextPresent("Publication Type");
			boolean retVal2 = isTextPresent("Publication Status");
			boolean retVal3 = isTextPresent("Title");
			boolean retVal4 = isTextPresent("Year of Publication");
			boolean retVal5 = isTextPresent("Authors");
			boolean retVal6 = isTextPresent("Keywords");
			boolean retVal7 = isTextPresent("Description");
			boolean retVal8 = isTextPresent("Research Category");
			boolean retVal9 = isTextPresent("Sample Name");			
			captureScreenshot(dir+"/snapshots/myworksapcepublicationsedit.png");			
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true && retVal5 == true && retVal6 == true && retVal7 == true && retVal8 == true && retVal9 == true){
				logger.info("Publications Edit successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications Edit verification passed","Verify_Curator_User_can_Edit_My_Publications_from_My_Workspace_page","verification successful","Pass");
				stepCount++;			
		    }else {
				logger.error("Publications Edit failed");
				TestExecutionException e = new TestExecutionException("Publications Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications Edit verification","Verify_Curator_User_can_Edit_My_Publications_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsedit.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }					
		}
		/*
		 * 
		 */
		public void Verify_Researcher_User_can_Edit_My_Publications_from_My_Workspace_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");	    	
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}				   	
			click(By.xpath("(//input[@type='checkbox'])[2]"));
			click(By.xpath("(//input[@type='checkbox'])[1]"));			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			clickIndexLinks("Edit", "16");			
			try {
				_wait(7000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}							
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Update Publication");
			}catch (Exception e){
			}			   					
			boolean retVal1 = isTextPresent("Publication Type");
			boolean retVal2 = isTextPresent("Publication Status");
			boolean retVal3 = isTextPresent("Title");
			boolean retVal4 = isTextPresent("Year of Publication");
			boolean retVal5 = isTextPresent("Authors");
			boolean retVal6 = isTextPresent("Keywords");
			boolean retVal7 = isTextPresent("Description");
			boolean retVal8 = isTextPresent("Research Category");
			boolean retVal9 = isTextPresent("Sample Name");			
			captureScreenshot(dir+"/snapshots/myworksapcepublicationsedit.png");			
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true && retVal5 == true && retVal6 == true && retVal7 == true && retVal8 == true && retVal9 == true){
				logger.info("Publications Edit successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications Edit verification passed","Verify_Researcher_User_can_Edit_My_Publications_from_My_Workspace_page","verification successful","Pass");
				stepCount++;			
		    }else {
				logger.error("Publications Edit failed");
				TestExecutionException e = new TestExecutionException("Publications Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publications Edit verification","Verify_Researcher_User_can_Edit_My_Publications_from_My_Workspace_page","verification failed","Fail", "myworksapceprotocolsedit.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }								
		}
		/*
		 * 
		 */
		public void Ensure_User_can_view_samples_protocols_and_publications_and_use_back_button_from_view_page() throws TestExecutionException {
			verifyPage(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"My Workspace");	    	
			try{
				waitUntil(By.cssSelector("td.columnOne"), "View  Edit");
			}catch (Exception e){
			}					   	
			click(By.xpath("(//input[@type='checkbox'])[3]"));
			click(By.xpath("(//input[@type='checkbox'])[2]"));			
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			clickIndexLinks("View", "1");						
			try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			boolean retVal1 = isTextPresent("Sample Name");
			boolean retVal2 = isTextPresent("Created Date");
			boolean retVal3 = isTextPresent("Keywords");
			boolean retVal4 = isTextPresent("Point of Contact");			
			captureScreenshot(dir+"/snapshots/myworksapcesamplesview.png");			
		    if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true){
				logger.info("Samples View successful");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples View verification passed","Ensure_User_can_view_samples_protocols_and_publications_and_use_back_button_from_view_page","verification successful","Pass");
				stepCount++;		
		    }else {
				logger.error("Samples View failed");
				TestExecutionException e = new TestExecutionException("Samples View verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Samples View verification","Ensure_User_can_view_samples_protocols_and_publications_and_use_back_button_from_view_page","verification failed","Fail", "myworksapcesamplesview.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }			
		    click(By.xpath("//button"));		    
		    try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}			
			boolean retVal5 = isTextPresent("My Samples");
			boolean retVal6 = isTextPresent("My Protocols");
			boolean retVal7 = isTextPresent("My Publications");			
			captureScreenshot(dir+"/snapshots/myworksapces.png");			
		    if (retVal5 == true && retVal6 == true && retVal7 == true){
				logger.info("My Workspace page return successful");
				oPDF.enterBlockSteps(bTable,stepCount,"My Workspace page return verification passed","Ensure_User_can_view_samples_protocols_and_publications_and_use_back_button_from_view_page","verification successful","Pass");
				stepCount++;	
		    }else {
				logger.error("My Workspace page return failed");
				TestExecutionException e = new TestExecutionException("My Workspace page return verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"My Workspace page return verification","Ensure_User_can_view_samples_protocols_and_publications_and_use_back_button_from_view_page","verification failed","Fail", "myworksapces.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());		    			    	
		    }
		}
		/*
		 * 
		 */
		public void remove_publication_by_PubmedID(String pbmedID) throws TestExecutionException {
		    navigate_to_search_existing_PUBLICATION_page();
			enter(By.id("pubMedId"),pbmedID);
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Publication Search Results");
			}catch (Exception e){
			}
			try{
	             waitUntil(By.xpath("//th[2]/div"), "Bibliography Info");
			}catch (Exception e){	
			}
			click(By.linkText("Edit"));
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			click(By.xpath("html/body/div[1]/table/tbody/tr[3]/td[2]/table/tbody/tr[2]/td/div/div/form/table[4]/tbody/tr/td[1]/input"));
			try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			checkAlertOK();
			try{
				waitUntil(By.cssSelector(".ng-scope.ng-binding"), "Publication successfully removed");
			}catch (Exception e){
			}
			captureScreenshot(dir+"/snapshots/removedPublication.png");
			boolean retVal = isTextPresent("Publication successfully");
			
			if (retVal == true){
				logger.info("System Removed publication successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Removal verification","remove_publication_by_Title","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to Remove publication successfully");
				TestExecutionException e = new TestExecutionException("Publication Removal verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Removal verification","remove_publication_by_Title","verification failed","Fail", "removedPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void remove_publication_by_Title(String pbmedTitle) throws TestExecutionException {
		    navigate_to_search_existing_PUBLICATION_page();
		    enter(By.id("title"),pbmedTitle);
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Publication Search Results");
			}catch (Exception e){
			}
			try{
	             waitUntil(By.xpath("//th[2]/div"), "Bibliography Info");
			}catch (Exception e){	
			}
			click(By.linkText("Edit"));
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			click(By.xpath("html/body/div[1]/table/tbody/tr[3]/td[2]/table/tbody/tr[2]/td/div/div/form/table[4]/tbody/tr/td[1]/input"));
			try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			checkAlertOK();
			try{
				waitUntil(By.cssSelector(".ng-scope.ng-binding"), "Publication successfully removed");
			}catch (Exception e){
			}					
			captureScreenshot(dir+"/snapshots/removedPublication.png");
			boolean retVal = isTextPresent("Publication successfully");
			
			if (retVal == true){
				logger.info("System Removed publication successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Removal verification","remove_publication_by_Title","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to Remove publication successfully");
				TestExecutionException e = new TestExecutionException("Publication Removal verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Removal verification","remove_publication_by_Title","verification failed","Fail", "removedPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void edit_publication_by_Title(String pbmedTitle) throws TestExecutionException {
		    navigate_to_search_existing_PUBLICATION_page();
		    enter(By.id("title"),pbmedTitle);
			click(By.cssSelector("input[type=\"submit\"]"));
			try{
				waitUntil(By.cssSelector(".contentTitle>tbody>tr>th:nth-child(1)"),"Publication Search Results");
			}catch (Exception e){
			}
			try{
	             waitUntil(By.xpath("//th[2]/div"), "Bibliography Info");
			}catch (Exception e){	
			}
			click(By.linkText("Edit"));
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("publicationForm.keywordsStr"), "Edit\nQA\nTest\nValidation\nPublication\nSuccessful");
			click(By.xpath("//input[@value='Update']"));
			try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try{
				waitUntil(By.cssSelector(".ng-scope.ng-binding"), "Publication successfully updated");
			}catch (Exception e){
			}					
			captureScreenshot(dir+"/snapshots/editPublication.png");
			boolean retVal = isTextPresent("Publication successfully updated");			
			if (retVal == true){
				logger.info("System Edit publication successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Edit verification","edit_publication_by_Title","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to Edit publication successfully");
				TestExecutionException e = new TestExecutionException("Publication Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Edit verification","edit_publication_by_Title","verification failed","Fail", "editPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * PubMed ID Generator
		 */
		public String pubmed_id() {
		   String pubMedIDDateNTime = "";
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String yearFrmt = Date_Year();
			pubMedIDDateNTime = "" + yearFrmt + dateFrmt + timeFrmt + "";
		   return pubMedIDDateNTime;
		}
		/*
		 * DOI Generator
		 */
		public String doi_id() {
		   String doiID = "";
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			//pubMedIDDateNTime = "" + dateFrmt + timeFrmt + "";
			doiID = "" + monthFrmt + "/dm" + dateFrmt + timeFrmt + "";
		   return doiID;
		}
		/*
		 * Publication Title
		 */
		public String publication_title(String getTitle) {
		   String pubTile = "";
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			pubTile = "" + getTitle + " " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
		   return pubTile;
		}
		/*
		 * Publication Title Ram
		 */
		public String get_publication_title(String getRamTitle) {
		   String ramPubTile = "";
			ramPubTile = "" + getRamTitle + "";
		   return ramPubTile;
		}
		/*
		 * Access to the Publication
		 */
		public void accessToThePublication(String gAccessBy, String gUserLoginName, String gUserName, String gAccessToThePublication) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".subSubmissionView tbody tr th"), "Access Information");
				waitUntil(By.cssSelector(".subSubmissionView tbody tr:nth-child(2) td:nth-child(1)"), "Access by *");
				waitUntil(By.cssSelector(".subSubmissionView tbody tr:nth-child(3) td:nth-child(1)"), "Collaboration Group Name *");
			}catch (Exception e){
			}
			if (gAccessBy.isEmpty()==false){
				if (gAccessBy.equals("Collaboration Group")){
						click(By.id("byGroup"));
				} else if (gAccessBy.equals("User")){
						click(By.id("byUser"));
				} else if (gAccessBy.equals("User")) {
						click(By.id("byPublic"));
			    }
			}
			if (gUserLoginName.isEmpty()==false){
				click(By.id("browseIcon2"));
				wait_For(5000);
				String getUserLoginNameVal = getText(By.id("matchedUserNameSelect")).replaceAll("\\n", "###");
				String getUserLoginNameVal1 = getText(By.id("matchedUserNameSelect")).replaceAll("\\n", " ");
				logger.info("User Login Identified Lists:["+ getUserLoginNameVal +"]");
				if (getUserLoginNameVal1.contains(gUserLoginName)){
					select("id", "matchedUserNameSelect", gUserLoginName);
					wait_For(1000);
					select("id", "roleName", gAccessToThePublication);
					wait_For(2000);
					click(By.xpath("(//input[@value='Save'])[2]"));
					wait_For(9000);
				} else {
					String [] partsSampleUserVal = getUserLoginNameVal.split("###");
					String partsSampleUserVal1 = partsSampleUserVal[5];
					logger.info("User Login Identified:["+ partsSampleUserVal1 +"]");
					select("id", "matchedUserNameSelect", partsSampleUserVal1);
					wait_For(1000);
					select("id", "roleName", gAccessToThePublication);
					wait_For(2000);
					click(By.xpath("(//input[@value='Save'])[2]"));
					wait_For(25000);
					gUserLoginName = partsSampleUserVal1;
				}
			}
			try{
			waitUntilElementVisible(By.cssSelector(".btn.btn-primary.btn-xxs:nth-child(1)"));
			waitUntilElementVisible(By.cssSelector(".editTableWithGrid.ng-scope tbody tr:nth-child(1)"));
			}catch (Exception e){
			}
			String getAccessTag = getText(By.cssSelector(".editTableWithGrid.ng-scope tbody tr:nth-child(1)")).replaceAll("\\n", "");
			logger.info("AccessTag:["+ getAccessTag +"]");
			boolean retVal1 = isTextPresent(gUserName);

			if (getAccessTag.contains("Group Name Access") && retVal1 == true){
				logger.info("Access Added successfully for the User:["+ gUserLoginName +"]");
				oPDF.enterBlockSteps(bTable,stepCount, "Add Access Role Verification", "accessToThePublication", "Access Added successfully for the User:["+ gUserLoginName +"]","Pass");
				stepCount++;
			} else {
				captureScreenshot(dir+"/snapshots/AccessAdd.png");
				logger.error("System unbale to add Access info successfully for the following user:["+ gUserLoginName +"]");
				TestExecutionException e = new TestExecutionException("Publication Edit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Add Access Role Verification","accessToThePublication","verification failed","Fail", "AccessAdd.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Delete Publication
		 */
		public void delete_publication(String getConDeleteOKOrCancel) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Update Publication");
			}catch (Exception e){
			}
			String gPublicationTitle = getAttribute(By.id("publicationForm.title"), "value");
			String lcaseConfMsg = getConDeleteOKOrCancel.toLowerCase();
			if (gPublicationTitle.isEmpty()==false){
				click(By.xpath("//input[@value='Delete']"));
				wait_For(7000);
				if (lcaseConfMsg.equals("ok")){
				logger.info("Clicking OK button");
				checkAlertOK();
				}
				if (lcaseConfMsg.equals("cancel")){
				logger.info("Clicking Cancel button");
				checkAlertCancel();
				}
			}
			String bldSuccessMsg = "Publication successfully removed with title \""+ gPublicationTitle +"\"";
			logger.info("Expected Publication Delete Confirmation Message:["+ bldSuccessMsg +"]");
			try{
				waitUntil(By.cssSelector(".mainContent .mainContent.ng-scope p.ng-scope.ng-binding"), bldSuccessMsg);
			}catch (Exception e){
			}
			String getConfirmationMessage = getText(By.cssSelector(".mainContent .mainContent.ng-scope p.ng-scope.ng-binding"));
			logger.info("Actual Publication Delete Confirmation Message:["+ getConfirmationMessage +"]");
			if (getConfirmationMessage.equals(bldSuccessMsg)){
				logger.info("Publication :["+ gPublicationTitle +"] removed successfully");
				oPDF.enterBlockSteps(bTable,stepCount, "Publication Delete Verification", "delete_publication", "Publication :["+ gPublicationTitle +"] Removed successfully", "Pass");
				stepCount++;
			} else {
				captureScreenshot(dir+"/snapshots/removedPublication.png");
				logger.error("Publication :["+ gPublicationTitle +"] unable to removed successfully");
				TestExecutionException e = new TestExecutionException("Submit Publication Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication Delete Verification","delete_publication", "Publication :["+ gPublicationTitle +"] unable to removed successfully","Fail", "removedPublication.png");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
			search_publication_title_no_match(gPublicationTitle);
		}
		/*
		 * Submit a New Publication
		 */
		public void submit_a_new_publication(String getpbType, String getpbStatus, String getPubmedID, String getDOI, String getTitle, 
											 String getJournal, String getYear, String getVolume, String getStartPage, String getEndPage, 
											 String getAuthors, String getAuthFirstName, String getAuthLastName, String getAuthInitials,
											 String getKeywords, String getDescription, String getResearchCategory,
											 String getUpload, String getUploadPath, String getEnterFileURL, String getEnterFileURLPath,
											 String getSampleName, String getAccessToThePublication, String getAccessBy, 
											 String getUserLoginName, String getUserName, String getAccessToTheRole, 
											 String getSubmitOrResetOrUpdate, String getSearchPublication, String getEditAndAddToFavorites) throws TestExecutionException {
			//Wait for Submit Publication page
			logger.info("Waiting for Submit or Update Publication page");
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				try{
					waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Submit Publication");
				}catch (Exception e){
				}
			} else if (getSubmitOrResetOrUpdate.equals("Update")){
				try{
					waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Update Publication");
				}catch (Exception e){
				}
			} else if (getSubmitOrResetOrUpdate.equals("Reset")){
				try{
					waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Submit Publication");
				}catch (Exception e){
				}
			}
			wait_For(10000);
			//Publication Type
			String getPublicationTypeVal = getText(By.id("category")).replaceAll("\\n", " ");
			logger.info("Publication Type Values: ["+ getPublicationTypeVal +"]");
			selectSubmitPublicationType(getpbType); //Publication Type *
			//Publication Status
			String getPublicationStatusVal = getText(By.id("status")).replaceAll("\\n", " ");
			logger.info("Publication Status Values: ["+ getPublicationStatusVal +"]");
			selectSubmitPublicationStatus(getpbStatus); //Publication Status*
			if (getPubmedID.isEmpty()==true){
				String pbmedID = pubmed_id();
				getPubmedID = null;
				getPubmedID = pbmedID;
				logger.info("Generated PubMed ID:["+getPubmedID+"]");
			}
			if (getDOI.isEmpty()==true){
				String doiID = doi_id();
				getDOI = null;
				getDOI = doiID;
				logger.info("Generated DOI:["+getDOI+"]");
			}
			if (getPubmedID.isEmpty()==false){
			enter(By.id("publicationForm.pubMedId"), getPubmedID);
			}
			if (getDOI.isEmpty()==false){
			enter(By.id("publicationForm.digitalObjectId"), getDOI);
			}
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			String yearFrmt = Date_Year();
			//String pubTile = "" + getTitle + " " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
			String pubTile = publication_title(getTitle);
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				enter(By.id("publicationForm.title"), pubTile);
			} else if (getSubmitOrResetOrUpdate.equals("Update")){
				//pubTile = getTitle;
				enter(By.id("publicationForm.title"), pubTile);
			}
			String ramPublicationTtitle = ""+ pubTile +"";
			logger.info("Publication Title:["+ ramPublicationTtitle +"]");
			String journalNm = "" + getJournal + " " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				enter(By.id("publicationForm.journalName"), journalNm);
			} else if (getSubmitOrResetOrUpdate.equals("Update")){
				journalNm = getJournal;
				enter(By.id("publicationForm.journalName"), journalNm);
			}
			if (getYear.isEmpty()==true){
				String yearPubli = ""+ yearFrmt +"";
				getYear = null;
				getYear = yearPubli;
				logger.info("Year of Publication:["+getYear+"]");
			}
			if (getSubmitOrResetOrUpdate.equals("Submit")){
			enter(By.id("publicationForm.year"), getYear);
			}
			enter(By.id("publicationForm.volume"), getVolume);
			enter(By.id("publicationForm.startPage"), getStartPage);
			enter(By.id("publicationForm.endPage"), getEndPage);
			//Author
			if (getAuthors.isEmpty()==false && getAuthors.equals("Add")){
					click(By.id("addAuthor"));
					wait_For(1000);
					String authFirstName = getAuthFirstName;
					String authLastName = getAuthLastName;
					String authInitial = getAuthInitials;
					enter(By.id("firstName"), authFirstName);
					enter(By.id("lastName"), authLastName);
					enter(By.id("initial"), authInitial);
					click(By.xpath("//input[@value='Save']"));
					wait_For(1000);
			}
			if (getAuthors.isEmpty()==false && getAuthors.equals("Auto")){
					click(By.id("addAuthor"));
					wait_For(1000);
					String authFirstName1 = "Shamim";
					String authLastName1 = "Ahmed";
					String authInitial1 = "SA";
					logger.info("First Name:["+ authFirstName1 +"]");
					logger.info("Last Name:["+ authLastName1 +"]");
					logger.info("Initial:["+ authInitial1 +"]");
					enter(By.id("firstName"), authFirstName1);
					enter(By.id("lastName"), authLastName1);
					enter(By.id("initial"), authInitial1);
					click(By.xpath("//input[@value='Save']"));
					click(By.id("addAuthor"));
					wait_For(1000);
					String authFirstName2 = "Bill";
					String authLastName2 = "Gates";
					String authInitial2 = "BG";
					logger.info("First Name:["+ authFirstName2 +"]");
					logger.info("Last Name:["+ authLastName2 +"]");
					logger.info("Initial:["+ authInitial2 +"]");
					enter(By.id("firstName"), authFirstName2);
					enter(By.id("lastName"), authLastName2);
					enter(By.id("initial"), authInitial2);
					click(By.xpath("//input[@value='Save']"));
					click(By.id("addAuthor"));
					wait_For(1000);
					String authFirstName3 = "Warren";
					String authLastName3 = "Buffett";
					String authInitial3 = "WB";
					logger.info("First Name:["+ authFirstName3 +"]");
					logger.info("Last Name:["+ authLastName3 +"]");
					logger.info("Initial:["+ authInitial3 +"]");
					enter(By.id("firstName"), authFirstName3);
					enter(By.id("lastName"), authLastName3);
					enter(By.id("initial"), authInitial3);
					click(By.xpath("//input[@value='Save']"));
					wait_For(1000);
			}
			enter(By.id("publicationForm.keywordsStr"), getKeywords);
			enter(By.id("publicationForm.description"), getDescription);
			select("id", "publicationForm.researchArea", getResearchCategory);
			//file upload here
			if (getUpload.isEmpty()==false){
				if (getUpload.equals("Upload")){
					click(By.id("external0"));
					wait_For(1000);
					enter(By.id("uploadedFile"), getUploadPath);
					wait_For(5000);
				}
			}
			if (getEnterFileURL.isEmpty()==false){
				if (getEnterFileURL.equals("Enter File URL")){
					click(By.id("external1"));
					wait_For(1000);
					enter(By.id("externalUrl"), getUploadPath);
					wait_For(5000);
				}
			}
			if (getSampleName.isEmpty()==false){
					click(By.cssSelector("button.sampleSearchLookup"));
					wait_For(7000);
					String getSampleNameVal = getText(By.id("matchedSampleSelect")).replaceAll("\\n", " ");
					String getSampleNameVal1 = getText(By.id("matchedSampleSelect")).replaceAll("\\n", "###");
					logger.info("Sample Name Values: ["+ getSampleNameVal1 +"]");
					if (getSampleNameVal.contains(getSampleName)){
						logger.info("Search for Samples match found");
						select("id", "matchedSampleSelect", getSampleName);
						click(By.id("selectMatchedSampleButton"));
						wait_For(7000);
					} else {
			           	String[] partsSamples = getSampleNameVal1.split("###");
			            String partSample1 = partsSamples[25];
			            logger.info("Search for Samples Name Identified:["+ partSample1 +"]");
						select("id", "matchedSampleSelect", partSample1);
						click(By.id("selectMatchedSampleButton"));
						wait_For(7000);
					}
			}
			if (getAccessToThePublication.isEmpty()==false){
				if (getAccessToThePublication.equals("Add")){
					click(By.id("addAccess"));
					if (getAccessBy.equals("User")){
						accessToThePublication(getAccessBy, getUserLoginName, getUserName, getAccessToTheRole);
					} else if (getAccessBy.equals("Collaboration")){
						wait_For(2000);
						element_display(By.id("byGroup"));
						click(By.id("byGroup"));
						String readCollbGrpNm = read_group_name();
						enter(By.id("groupName"), readCollbGrpNm);
						click(By.id("browseIcon1"));
						element_load(By.id("matchedGroupNameSelect"));
						select("id", "matchedGroupNameSelect", readCollbGrpNm);
						wait_For(1000);
						select("id", "roleName", "read update delete");
						wait_For(1000);
						click(By.cssSelector(".subSubmissionView tbody tr:nth-child(5) td:nth-child(2) div input:nth-child(1)"));
						element_display_false(By.cssSelector(".subSubmissionView tbody tr:nth-child(5) td:nth-child(2) div input:nth-child(1)"));
						wait_For(20000);
					}
				}
			}
			wait_For(3000);
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				click(By.cssSelector("input[type=\"submit\"]"));
			}else if (getSubmitOrResetOrUpdate.equals("Update")) {
				click(By.xpath("//input[@value='Update']"));
			}else if (getSubmitOrResetOrUpdate.equals("Reset")) {
				click(By.cssSelector("input[type=\"reset\"]"));
			}
			String ramConfirmOutpt = get_publication_title(ramPublicationTtitle);
			//Submit Successful
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				String bldSuccessMsg = "Publication successfully updated with title \""+ ramConfirmOutpt +"\"";
				logger.info("Expected Publication Confirmation Message:["+ bldSuccessMsg +"]");
				try{
					waitUntil(By.cssSelector(".mainContent .mainContent.ng-scope p.ng-scope.ng-binding"), bldSuccessMsg);
				}catch (Exception e){
				}
				String getConfirmationMessage = getText(By.cssSelector(".mainContent .mainContent.ng-scope p.ng-scope.ng-binding"));
				logger.info("Actual Publication Confirmation Message:["+ getConfirmationMessage +"]");
				if (getConfirmationMessage.equals(bldSuccessMsg)){
					logger.info("Publication :["+ ramPublicationTtitle +"] submitted successfully");
					oPDF.enterBlockSteps(bTable,stepCount, "Submit Publication Verification", "submit_a_new_publication", "Publication :["+ ramPublicationTtitle +"] submitted successfully", "Pass");
					stepCount++;
				} else {
					captureScreenshot(dir+"/snapshots/submitPublication.png");
					logger.error("Publication :["+ ramPublicationTtitle +"] unable to submit successfully");
					TestExecutionException e = new TestExecutionException("Submit Publication Verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Submit Publication Verification","submit_a_new_publication", "Publication :["+ ramPublicationTtitle +"] unable to submit successfully","Fail", "submitPublication.png");
					stepCount++;
					setupAfterSuite();
					Assert.fail(e.getMessage());
				}
			}
			//Update Successful
			if (getSubmitOrResetOrUpdate.equals("Update")){
				String bldSuccessMsg = "Publication successfully updated with title \""+ ramConfirmOutpt +"\"";
				logger.info("Expected Publication Confirmation Message:["+ bldSuccessMsg +"]");
				try{
					waitUntil(By.cssSelector(".mainContent .mainContent.ng-scope p.ng-scope.ng-binding"), bldSuccessMsg);
				}catch (Exception e){
				}
				String getConfirmationMessage = getText(By.cssSelector(".mainContent .mainContent.ng-scope p.ng-scope.ng-binding"));
				logger.info("Actual Publication Confirmation Message:["+ getConfirmationMessage +"]");
				if (getConfirmationMessage.equals(bldSuccessMsg)){
					logger.info("Publication :["+ ramPublicationTtitle +"] submitted successfully");
					oPDF.enterBlockSteps(bTable,stepCount, "Submit Publication Verification", "submit_a_new_publication", "Publication :["+ ramPublicationTtitle +"] submitted successfully", "Pass");
					stepCount++;
				} else {
					captureScreenshot(dir+"/snapshots/submitPublication.png");
					logger.error("Publication :["+ ramPublicationTtitle +"] unable to submit successfully");
					TestExecutionException e = new TestExecutionException("Submit Publication Verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Submit Publication Verification","submit_a_new_publication", "Publication :["+ ramPublicationTtitle +"] unable to submit successfully","Fail", "submitPublication.png");
					stepCount++;
					setupAfterSuite();
					Assert.fail(e.getMessage());
				}
			}
			if (getSearchPublication.isEmpty()==false){
				if (getSearchPublication.equals("Search")){
					search_publication_title(ramConfirmOutpt, getEditAndAddToFavorites);
				}
			}
		}
		/*
		 *     
		 */
		public void Verify_the_ability_to_submit_a_New_Publication(String pbType, String pbStatus, String pubTitle, String smpNam, String accessUsrID, String accessUsrInfo) throws TestExecutionException {
			navigate_to_submit_to_new_publication_page();
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			selectSubmitPublicationType(pbType);
			selectSubmitPublicationStatus(pbStatus);
			
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			String pubTile = "" + pubTitle + dateFrmt +timeFrmt + "";
			String pbmedID = "" + dateFrmt + timeFrmt + "";
			String doiID = "" + monthFrmt + "/dm" + dateFrmt + timeFrmt + "";
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("publicationForm.pubMedId"), pbmedID);
			enter(By.id("publicationForm.digitalObjectId"), doiID);
			enter(By.id("publicationForm.title"), pubTile);
			enter(By.id("publicationForm.journalName"), "Test Nanotoxicology");
			enter(By.id("publicationForm.year"), "2014");
			enter(By.id("publicationForm.startPage"), "1");
			enter(By.id("publicationForm.endPage"), "9");
			click(By.id("addAuthor"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("firstName"), "Test");
			enter(By.id("lastName"), "QA");
			enter(By.id("initial"), "TQ");
			click(By.cssSelector("div > input.promptButton"));
			click(By.id("addAuthor"));
			try {
				_wait(100);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("firstName"), "Ahmed");
			enter(By.id("lastName"), "Shamim");
			enter(By.id("initial"), "SA");
			click(By.cssSelector("div > input.promptButton"));
			try {
				implicitwait(50);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			enter(By.id("publicationForm.keywordsStr"), "QA\nTest\nValidation\nPublication");
			enter(By.id("publicationForm.description"), "PubMed does not include the full text of journal articles; however, click the icon in the top right corner of the abstract display to link to the full text, if available.\n\nIn addition, the abstract display may include a LinkOut â€“ more resources link located at the bottom of the display, with additional full text sources.\n\nAdditional tips for obtaining articles.\n\nSection Contents\n\n    Many articles are available for free.\n    If you are a physician, researcher, or health professional, utilize your affiliation with a medical library or institution.\n    If you are a member of the general public or not affiliated with a medical library or institution, try finding free copies, check with your local library, or go directly to the publisher.");
			click(By.id("external1"));
			enter(By.id("externalUrl"), "http://www.ncbi.nlm.nih.gov/pubmed");
			click(By.cssSelector(".invisibleTable>tbody>tr>td>a>img"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			choseSamplesForPublicationOption(smpNam);
			click(By.id("selectMatchedSampleButton"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.info("Unable to add samples to the Publication");
				e.printStackTrace();
			}
			click(By.id("addAccess"));
			click(By.id("byUser"));
			click(By.id("browseIcon2"));
			//click(By.cssSelector("img[alt=\"search existing users\"]"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.info("Unable to search access user list");
				e.printStackTrace();
			}
			choseAccessUserName(accessUsrID);
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.info("Unable to add Access User Name to the Publication");
				e.printStackTrace();
			}
			choseAccessPublication("read update delete");
			click(By.xpath("(//input[@value='Save'])[2]"));
			try{
				waitUntil(By.cssSelector(".ng-binding"), accessUsrInfo);
			}catch (Exception e){
				logger.info("Access privilege Could not added to the Publication");		    	
			}
			boolean retVal1 = isTextPresent("Access to the Publication");
			boolean retVal2 = isTextPresent("Group Name");
			boolean retVal3 = isTextPresent("Access");
			boolean retVal4 = isTextPresent("Curator");
			boolean retVal5 = isTextPresent("read update delete");
			boolean retVal6 = isTextPresent(accessUsrInfo);
			if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true && retVal5 == true && retVal6 == true){
				logger.info("Access User to the Publication has been added successfully");		    	
		    }else {
				logger.error("Could not added Access User to the Publication successfully");		    			    	
		    }
			click(By.cssSelector("input.ng-scope"));
			try{
				waitUntil(By.cssSelector(".ng-scope.ng-binding"), "Publication successfully");
			}catch (Exception e){
			}
			String scnSht = "sbmtPublication"+ timeFrmt +".png";
			captureScreenshot(dir+"/snapshots/"+ scnSht +"");
			boolean retVal7 = isTextPresent("Publication successfully");
			if (retVal7 == true){
				logger.info("System submited publication successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication submit verification","Verify_the_ability_to_submit_a_New_Publication","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to submit publication successfully");
				TestExecutionException e = new TestExecutionException("Publication submit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Publication submit verification","Verify_the_ability_to_submit_a_New_Publication","verification failed","Fail", scnSht);
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/***********************************************
		 * Submit Sample
		 ***********************************************/
		/*
		 * Sample Composition - File
		 */
		public void submit_a_sample_composition_file(
												     String getFileAdd,
												     String getFileUpload, String getFileEnterFileURL,
												     String getFileUploadBrowse, String getFileEnterFileURLAddress,
												     String getFileType, String getFileTitle, String getFileKeywords, String getFileDescription,
												     String getSubmitOrReset
													) throws TestExecutionException {
			logger.info("File Upload Start");
			//File
			//File Upload or Enter File URL
			if (getFileAdd.isEmpty()==false){
			/*********************************/
			if (getFileAdd.equals("File")){
				element_load(By.id("fileType"));
				//Upload
				if (getFileUpload.isEmpty()==false){
					if (getFileUpload.equals("Upload")){
					click(By.id("external0"));
					}
					if (getFileUploadBrowse.isEmpty()==false){
						if (getFileUploadBrowse.equals("SamplesFile")){
							random_image_upload();
						} else {
							enter(By.id("uploadedFile"), getFileUploadBrowse);
						}
					}
					if (getFileType.isEmpty()==false){
						wait_For(7000);
						element_load(By.id("fileType"));
						String getFiletypeVal = getText(By.id("fileType")).replaceAll("\\n", "###");
						logger.info("getFiletypeVal:["+getFiletypeVal);
						select("id", "fileType", getFileType);
						Select FileTypeList = new Select(selenium.findElement(By.id("fileType")));
						int countVal = 1000;
						for (int i=0;i<countVal;i++){
							String getFiletypeSelectedVal = FileTypeList.getFirstSelectedOption().getText();
							logger.info("getFiletypeSelectedVal:["+getFiletypeSelectedVal);
							if (getFiletypeSelectedVal.equals(getFileType)){
								logger.info("Successfully Selected Dropdown List Value:["+ getFiletypeSelectedVal +"]");
								break;
							}
							if (!getFiletypeSelectedVal.equals(getFileType)){
								select("id", "fileType", getFileType);
							}
						}
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
				//enter File URL
				if (getFileEnterFileURL.isEmpty()==false){
					if (getFileEnterFileURL.equals("Enter File URL")){
					click(By.id("external1"));
					
					}
					if (getFileEnterFileURL.isEmpty()==false){
						enter(By.id("externalUrl"), getFileEnterFileURL);
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
			}
		    }
			/*********************************/
			//Submit or Reset
			if (getSubmitOrReset.isEmpty()==false){
				if (getSubmitOrReset.equals("Submit")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(6)"));
					verify_submit_sample_composition_file(getFileType);
				}
				if (getSubmitOrReset.equals("Reset")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(5)"));
				}
			}
		}
		/*
		 * 
		 */
		public void verify_submit_sample_composition_file(String getExpCompositionFileType) throws TestExecutionException {
			element_display(By.cssSelector(".composition_file tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding"));
			String getCompoFileVal = getText(By.cssSelector(".composition_file tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding")).replaceAll("\\n", "");
			String convgetCompoFileVal = UppercaseFirstLetters(getExpCompositionFileType);
			logger.info("getExpCompositionFileType["+getExpCompositionFileType);
			logger.info("convgetNanoEntityVal["+convgetCompoFileVal);
			String getTitle = getText(By.cssSelector(".contentTitle tbody tr th")).replaceAll("\\n", "");
			logger.info("getTitle["+getTitle);
			if (getCompoFileVal.equals(convgetCompoFileVal)){
				logger.info("Submit Composition File verfication successful");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Composition File Submit verfication", "verify_submit_sample_composition_file", "Sample Composition File Submit Verification Successfully", "Pass");
				stepCount++;
			} else {
				logger.error("Sample Composition File Submit verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Composition File Submit verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition File Submit verfication","verify_submit_sample_composition_file","Sample Composition File Submit verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Sample Composition - Chemical Association
		 */
		public void submit_a_sample_composition_chemical_association(String getAssociationType,
																	 String getDescription,
																	 String getElementSelectA,
																	 String getElementSelectB,
																	 String getEelementSelectAA,
																	 String getEelementSelectBB,
																	 String getEelementSelectAAA,
																     String getFileAdd,
																     String getFileUpload, String getFileEnterFileURL,
																     String getFileUploadBrowse, String getFileEnterFileURLAddress,
																     String getFileType, String getFileTitle, String getFileKeywords, String getFileDescription,
																     String getFileSaveOrCancel,
																     String getSubmitOrReset
																	) throws TestExecutionException {
			element_load(By.id("type"));
			element_load(By.id("compositionTypeA"));
			element_load(By.id("compositionTypeB"));
			//Association Type
			if (getAssociationType.isEmpty()==false){
				element_display(By.id("type"));
				select("id", "type", getAssociationType);
			}
			if (getDescription.isEmpty()==false){
				element_display(By.id("associationDescription"));
				enter(By.id("associationDescription"), getDescription);
			}
			//Element
			if (getElementSelectA.isEmpty()==false){
				element_display(By.id("compositionTypeA"));
				select("id", "compositionTypeA", getElementSelectA);
			}
			if (getElementSelectB.isEmpty()==false){
				element_display(By.id("compositionTypeB"));
				select("id", "compositionTypeB", getElementSelectB);
				wait_For(2000);
			}
			if (getEelementSelectAA.isEmpty()==false){
				wait_For(2000);
				element_display(By.id("entityIdA"));
				element_load(By.id("entityIdA"));
				select("id", "entityIdA", getEelementSelectAA);
				wait_For(2000);
			}
			if (getEelementSelectBB.isEmpty()==false){
				wait_For(2000);
				element_display(By.id("entityIdB"));
				element_load(By.id("entityIdB"));
				select("id", "entityIdB", getEelementSelectBB);
				wait_For(2000);
			}
			if (getEelementSelectAAA.isEmpty()==false){
				wait_For(2000);
				element_display(By.id("composingElementIdA"));
				element_load(By.id("composingElementIdA"));
				select("id", "composingElementIdA", getEelementSelectAAA);
				wait_For(2000);
			}
			//File
			//File Upload or Enter File URL
			if (getFileAdd.isEmpty()==false){
			/*********************************/
			if (getFileAdd.equals("Add")){
				click(By.id("addFile"));
				element_load(By.id("fileType"));
				//Upload
				if (getFileUpload.isEmpty()==false){
					if (getFileUpload.equals("Upload")){
					click(By.id("external0"));
					}
					if (getFileUploadBrowse.isEmpty()==false){
						if (getFileUploadBrowse.equals("SamplesFile")){
							random_image_upload();
						} else {
							enter(By.id("uploadedFile"), getFileUploadBrowse);
						}
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
				//enter File URL
				if (getFileEnterFileURL.isEmpty()==false){
					if (getFileEnterFileURL.equals("Enter File URL")){
					click(By.id("external1"));
					
					}
					if (getFileEnterFileURL.isEmpty()==false){
						enter(By.id("externalUrl"), getFileEnterFileURL);
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
			}
			// Save File
			if (getFileSaveOrCancel.isEmpty()==false){
				if (getFileSaveOrCancel.equals("Save")){
					logger.info("Save File");
					click(By.cssSelector(".submissionView.ng-scope tbody tr:nth-child(3) td .subSubmissionView tbody tr:nth-child(7) td:nth-child(2) input:nth-child(5)"));
					wait_For(7000);
					element_display(By.cssSelector(".editTableWithGrid tbody tr:nth-child(2) td:nth-child(5) .btn.btn-primary.btn-xxs"));
				}
				if (getFileSaveOrCancel.equals("Cancel")){
					wait_For(3000);
					click(By.cssSelector(".submissionView.ng-scope tbody tr:nth-child(3) td .subSubmissionView tbody tr:nth-child(7) td:nth-child(2) input:nth-child(6)"));
				}
			}
		    }
			/*********************************/
			//Submit or Reset
			if (getSubmitOrReset.isEmpty()==false){
				if (getSubmitOrReset.equals("Submit")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(5)"));
					verify_submit_sample_chemical_association(getAssociationType);
				}
				if (getSubmitOrReset.equals("Reset")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(4)"));
				}
			}
		}
		/*
		 * 
		 */
		public void verify_submit_sample_chemical_association(String getExpChamicalAssociationType) throws TestExecutionException {
			element_display(By.cssSelector(".chemical_association tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding"));
			String getChamicalAssoVal = getText(By.cssSelector(".chemical_association tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding")).replaceAll("\\n", "");
			String convgetChamicalAssoVal = UppercaseFirstLetters(getExpChamicalAssociationType);
			logger.info("getExpChamicalAssociationType["+getExpChamicalAssociationType);
			logger.info("convgetNanoEntityVal["+convgetChamicalAssoVal);
			String getTitle = getText(By.cssSelector(".contentTitle tbody tr th")).replaceAll("\\n", "");
			logger.info("getTitle["+getTitle);
			if (getChamicalAssoVal.equals(convgetChamicalAssoVal)){
				logger.info("Submit Chamical Association verfication successful");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Chamical Association Submit verfication", "verify_submit_sample_chemical_association", "Sample Chamical Association Submit Verification Successfully", "Pass");
				stepCount++;
			} else {
				logger.error("Sample Chamical Association Submit verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Chamical Association Submit verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Chamical Association Submit verfication","verify_submit_sample_chemical_association","Sample Chamical Association Submit verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Sample Composition - Functionalizing Entity
		 */
		public void submit_a_sample_composition_functionalizing(String getFunctionalizingEntityType,
																String getChemicaleName,
																String getPubChemDataSource,
																String getPubChemID,
																String getAmount,
																String getAmountUnit,
																String getMolecularFormulaType,
																String getMolecularFormula,
																String getActiveMethod, 
																String getActivationEffect,
																String getDescription,
																String getInherentFunctionAdd,
																String getInherentFunctionFunctionType,
																String getInherentFunctionDescription,
																String getInherentFunctionSaveOrCancel,
																String getInherentFunctionRemove,
															    String getFileAdd,
															    String getFileUpload, String getFileEnterFileURL,
															    String getFileUploadBrowse, String getFileEnterFileURLAddress,
															    String getFileType, String getFileTitle, String getFileKeywords, String getFileDescription,
															    String getFileSaveOrCancel,
															    String getCopyToTheOtherSample,
																String getSubmitOrReset
																) throws TestExecutionException {
			element_load(By.id("type"));
			element_load(By.id("functionType"));
			wait_For(3000);
			//Functionalizing Entity Type
			if (getFunctionalizingEntityType.isEmpty()==false){
				element_display(By.id("type"));
				select("id", "type", getFunctionalizingEntityType);
			}
			if (getChemicaleName.isEmpty()==false){
				element_display(By.id("feChemicalName"));
				enter(By.id("feChemicalName"), getChemicaleName);
			}
			if (getPubChemDataSource.isEmpty()==false){
				element_display(By.id("pubChemDataSource"));
				element_load(By.id("pubChemDataSource"));
				select("id", "pubChemDataSource", getPubChemDataSource);
			}
			if (getPubChemID.isEmpty()==false){
				if (getPubChemID.equals("random")){
					int getConNumber = randInt(11111111, 99999999);
					String getRandNumberStr = Integer.toString(getConNumber);
					element_display(By.id("pubChemId"));
					enter(By.id("pubChemId"), getRandNumberStr);
				} else {
					enter(By.id("pubChemId"), getPubChemID);
				}
			}
			if (getAmount.isEmpty()==false){
				element_display(By.id("amountValue"));
				enter(By.id("amountValue"), getAmount);
			}
			if (getAmountUnit.isEmpty()==false){
				element_load(By.id("feUnit"));
				element_display(By.id("feUnit"));
				select("id", "feUnit", getAmountUnit);
			}
			if (getMolecularFormulaType.isEmpty()==false){
				element_display(By.id("mfType"));
				element_load(By.id("mfType"));
				select("id", "mfType", getMolecularFormulaType);
			}
			if (getMolecularFormula.isEmpty()==false){
				element_display(By.id("molecularFormula"));
				enter(By.id("molecularFormula"), getMolecularFormula);
			}
			if (getActiveMethod.isEmpty()==false){
				element_display(By.id("feaMethod"));
				element_load(By.id("feaMethod"));
				select("id", "feaMethod", getActiveMethod);
			}
			if (getActivationEffect.isEmpty()==false){
				element_display(By.id("activationEffect"));
				enter(By.id("activationEffect"), getActivationEffect);
			}
			if (getDescription.isEmpty()==false){
				element_display(By.id("description"));
				enter(By.id("description"), getDescription);
			}
			String getValChamicalName = getText(By.id("feChemicalName"));
			if (getValChamicalName.equals(getChemicaleName)){
				logger.info("Successfully entered chamical name:["+ getValChamicalName +"]");
			} else{
				logger.error("Unable to enter chamical name:["+ getValChamicalName +"] into the Chamical Name field");
			}
			//Inherent Function
			if (getInherentFunctionAdd.isEmpty()==false){
				if (getInherentFunctionAdd.equals("Add")){
					element_display(By.id("addInherentFunction"));
					click(By.id("addInherentFunction"));
				}
			}
			if (getInherentFunctionFunctionType.isEmpty()==false){
				element_display(By.id("functionType"));
				element_load(By.id("functionType"));
				select("id", "functionType", getInherentFunctionFunctionType);
			}
			if (getInherentFunctionDescription.isEmpty()==false){
				element_display(By.id("functionDescription"));
				enter(By.id("functionDescription"), getInherentFunctionDescription);
			}
			if (getInherentFunctionSaveOrCancel.isEmpty()==false){
				if (getInherentFunctionSaveOrCancel.equals("Save")){
					click(By.cssSelector("#newInherentFunction tbody tr:nth-child(4) td:nth-child(2) div input:nth-child(3)"));
				}
				if (getInherentFunctionSaveOrCancel.equals("Cancel")){
					click(By.cssSelector("#newInherentFunction tbody tr:nth-child(4) td:nth-child(2) div input:nth-child(4)"));
				}
			}
			if (getInherentFunctionRemove.isEmpty()==false){
				if (getInherentFunctionRemove.equals("Remove")){
					click(By.id("deleteInherentFunction"));
				}
			}
			wait_For(3000);
			//File
			//File Upload or Enter File URL
			if (getFileAdd.isEmpty()==false){
			/*********************************/
			if (getFileAdd.equals("Add")){
				click(By.id("addFile"));
				element_load(By.id("fileType"));
				//Upload
				if (getFileUpload.isEmpty()==false){
					if (getFileUpload.equals("Upload")){
					click(By.id("external0"));
					}
					if (getFileUploadBrowse.isEmpty()==false){
						if (getFileUploadBrowse.equals("SamplesFile")){
							random_image_upload();
						} else {
							enter(By.id("uploadedFile"), getFileUploadBrowse);
						}
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
				//enter File URL
				if (getFileEnterFileURL.isEmpty()==false){
					if (getFileEnterFileURL.equals("Enter File URL")){
					click(By.id("external1"));
					
					}
					if (getFileEnterFileURL.isEmpty()==false){
						enter(By.id("externalUrl"), getFileEnterFileURL);
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
			}
			// Save File
			if (getFileSaveOrCancel.isEmpty()==false){
				if (getFileSaveOrCancel.equals("Save")){
					logger.info("Save File");
					click(By.cssSelector(".submissionView.ng-scope tbody tr:nth-child(3) td .subSubmissionView tbody tr:nth-child(7) td:nth-child(2) input:nth-child(5)"));
					element_display(By.cssSelector(".editTableWithGrid tbody tr:nth-child(2) td:nth-child(5) .btn.btn-primary.btn-xxs"));
				}
				if (getFileSaveOrCancel.equals("Cancel")){
					click(By.cssSelector(".submissionView.ng-scope tbody tr:nth-child(3) td .subSubmissionView tbody tr:nth-child(7) td:nth-child(2) input:nth-child(6)"));
				}
			}
		    }
			wait_For(3000);
			/*********************************/
			//Copy to other samples with the same primary organization?
			//Copy to the other samples
			if (getCopyToTheOtherSample.isEmpty()==true){
				String getSampleNameVal1 = getText(By.id("otherSamples")).replaceAll("\\n", "###");
				logger.info("Sample Name Values: ["+ getSampleNameVal1 +"]");
		           	String[] partsSamples = getSampleNameVal1.split("###");
		           	int randVal = randInt(1, 3);
		            String partSample1 = partsSamples[randVal];
		            logger.info("Copy to the other Samples Name Identified:["+ partSample1 +"]");
		            if (partSample1.isEmpty()==false){
		            element_display(By.id("otherSamples"));
					select("id", "otherSamples", partSample1);
					wait_For(1000);
		            }
			} else if (getCopyToTheOtherSample.isEmpty()==false){
				element_display(By.id("otherSamples"));
				select("id", "otherSamples", getCopyToTheOtherSample);
			}
			wait_For(3000);
			//Save or Reset
			if (getSubmitOrReset.isEmpty()==false){
				if (getSubmitOrReset.equals("Submit")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(4)"));
					element_display(By.cssSelector(".functionalizing_entity tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding"));
					verify_submit_sample_functinalizing_entity(getFunctionalizingEntityType);
				}
				if (getSubmitOrReset.equals("Reset")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(3)"));
				}
			}
		}
		/*
		 * 
		 */
		public void verify_submit_sample_functinalizing_entity(String getExpFunctionalizingEntityType) throws TestExecutionException {
			element_display(By.cssSelector(".functionalizing_entity tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding"));
			String getFuncEntityVal = getText(By.cssSelector(".functionalizing_entity tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding")).replaceAll("\\n", "");
			String convgetFuncEntityVal = UppercaseFirstLetters(getExpFunctionalizingEntityType);
			logger.info("getExpFunctionalizingEntityType["+getExpFunctionalizingEntityType);
			logger.info("convgetNanoEntityVal["+convgetFuncEntityVal);
			String getTitle = getText(By.cssSelector(".contentTitle tbody tr th")).replaceAll("\\n", "");
			logger.info("getTitle["+getTitle);
			if (getFuncEntityVal.equals(convgetFuncEntityVal)){
				logger.info("Submit Functionalizing entity verfication successful");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Functionalizing Entity Submit verfication", "verify_submit_sample_functinalizing_entity", "Sample Functionalizing Entity Submit Verification Successfully", "Pass");
				stepCount++;
			} else {
				logger.error("Sample Functionalizing Entity Submit verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Functionalizing Entity Submit verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Functionalizing Entity Submit verfication","verify_submit_sample_functinalizing_entity","Sample Functionalizing Entity Submit verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Sample Composition - Nanomaterial Entity
		 */
		public String nanomaterial_entity_description(String getDescription) {
		    String sampName = "";
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			sampName = "" + getDescription + " " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
		   return sampName;
		}
		/*
		 * Sample Composition - Nanomaterial Entity - Biopolymer Properties Name
		 */
		public String nanomaterial_entity_biopolymer_name(String getBioName) {
		    String sampBioName = "";
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			sampBioName = "" + getBioName + "" + monthFrmt + "" + dateFrmt + "" + timeFrmt + "";
		   return sampBioName;
		}
		/*
		 * Submit smaple composition Nanomaterial Entity (Please note that following method has dependency on submitted sample)
		 */
		public void submit_a_sample_composition_nanomaterrial(String getNanomaterialEntityType, String getDescription,
															  String getBiopolymerName, String getBiopolymerType, String getBiopolymerSequence,
															  String getCompEleType, String getCompEleChemicalName,
															  String getCompElePubChemDataSource, String getCompElePubChemId,
															  String getCompEleAmount, String getCompEleAmountUnit, 
															  String getCompEleMolecularFormulaType, String getMolecularFormula,
															  String getComEleDescription, String getCompEleInherentFunctionAdd,
															  String getComEleInherentFunctionType, String getComEleInherentDescription,
															  String getInherentFunctionSaveOrCancelOrRemove,
															  String getCompositionElementSaveOrCancel,
															  String getFileAdd,
															  String getFileUpload, String getFileEnterFileURL,
															  String getFileUploadBrowse, String getFileEnterFileURLAddress,
															  String getFileType, String getFileTitle, String getFileKeywords, String getFileDescription,
															  String getFileSaveOrCancel,
															  String getCopyToTheOtherSample,
															  String getSubmitOrReset
															  ) throws TestExecutionException {
			element_load(By.id("type"));
			element_load(By.id("otherSamples"));
			wait_For(3000);
			//Nanomaterial Entity Type
			if (getNanomaterialEntityType.isEmpty()==false){
				select("id", "type", getNanomaterialEntityType);
				element_load(By.id("biopolymerType"));
			}
			if (getDescription.isEmpty()==false){
				String getDescVal = nanomaterial_entity_description(getDescription);
				enter(By.id("neDescription"), getDescVal);
			}
			//Biopolymer Properties 
			if (getBiopolymerName.isEmpty()==false){
				String getBiopolyNameVal = nanomaterial_entity_biopolymer_name(getBiopolymerName);
				enter(By.id("biopolymerName"), getBiopolyNameVal);
			}
			if (getBiopolymerType.isEmpty()==false){
				select("id", "biopolymerType", getBiopolymerType);
			}
			if (getBiopolymerSequence.isEmpty()==false){
				enter(By.id("biopolymerSequence"), getBiopolymerSequence);
			}
			//Composing Element 
			if (getCompEleType.isEmpty()==false){
				select("id", "elementType", getCompEleType);
			}
			if (getCompEleChemicalName.isEmpty()==false){
				enter(By.id("elementName"), getCompEleChemicalName);
			}
			if (getCompElePubChemDataSource.isEmpty()==false){
				element_load(By.id("pubChemDataSource"));
				select("id", "pubChemDataSource", getCompElePubChemDataSource);
			}
			if (getCompElePubChemId.isEmpty()==false){
				if (getCompElePubChemId.equals("random")){
					int getConNumber = randInt(11111111, 99999999);
					String getRandNumberStr = Integer.toString(getConNumber);
					enter(By.id("pubChemId"), getRandNumberStr);
				} else {
					enter(By.id("pubChemId"), getCompElePubChemId);
				}
			}
			if (getCompEleAmount.isEmpty()==false){
				enter(By.id("elementValue"), getCompEleAmount);
			}
			if (getCompEleAmountUnit.isEmpty()==false){
				element_load(By.id("elementValueUnit"));
				select("id", "elementValueUnit", getCompEleAmountUnit);
			}
			if (getCompEleMolecularFormulaType.isEmpty()==false){
				element_load(By.id("molFormulaType"));
				select("id", "molFormulaType", getCompEleMolecularFormulaType);
			}
			if (getMolecularFormula.isEmpty()==false){
				enter(By.id("molFormula"), getMolecularFormula);
			}
			if (getComEleDescription.isEmpty()==false){
				enter(By.id("elementDescription"), getComEleDescription);
			}
			if (getCompEleInherentFunctionAdd.isEmpty()==false){
				if (getCompEleInherentFunctionAdd.equals("Add")){
					click(By.id("addInherentFunction"));
					element_load(By.id("functionType"));
				}
			}
			if (getComEleInherentFunctionType.isEmpty()==false){
				select("id", "functionType", getComEleInherentFunctionType);
			}
			if (getComEleInherentDescription.isEmpty()==false){
				enter(By.id("functionDescription"), getComEleInherentDescription);
			}
			if (getInherentFunctionSaveOrCancelOrRemove.isEmpty()==false){
				if (getInherentFunctionSaveOrCancelOrRemove.equals("Save")){
					click(By.cssSelector(".promptbox tbody tr:nth-child(3) td:nth-child(2) .promptButton:nth-child(1)"));
					element_display(By.cssSelector(".editTableWithGrid tbody tr:nth-child(2) td:nth-child(4) .noBorderButton"));
				}
				if (getInherentFunctionSaveOrCancelOrRemove.equals("Cancel")){
					click(By.cssSelector(".promptbox tbody tr:nth-child(3) td:nth-child(2) .promptButton:nth-child(2)"));
				}
				if (getInherentFunctionSaveOrCancelOrRemove.equals("Remove")){
					click(By.cssSelector(".promptbox tbody tr:nth-child(3) td:nth-child(1) .promptButton:nth-child(1)"));
				}
			}
			if (getCompositionElementSaveOrCancel.isEmpty()==false){
				if (getCompositionElementSaveOrCancel.equals("Save")){
					click(By.cssSelector(".subSubmissionView tbody tr:nth-child(8) td:nth-child(2) input:nth-child(3)"));
					wait_For(4000);
					verify_composing_element(getComEleDescription);
				}
				if (getCompositionElementSaveOrCancel.equals("Cancel")){
					click(By.cssSelector(".subSubmissionView tbody tr:nth-child(8) td:nth-child(2) input:nth-child(4)"));
				}
			}
			//File
			//File Upload or Enter File URL
			if (getFileAdd.isEmpty()==false){
			/*********************************/
			if (getFileAdd.equals("Add")){
				click(By.id("addFile"));
				element_load(By.id("fileType"));
				//Upload
				if (getFileUpload.isEmpty()==false){
					if (getFileUpload.equals("Upload")){
					click(By.id("external0"));
					}
					if (getFileUploadBrowse.isEmpty()==false){
						if (getFileUploadBrowse.equals("SamplesFile")){
							random_image_upload();
						} else {
							enter(By.id("uploadedFile"), getFileUploadBrowse);
						}
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
				//enter File URL
				if (getFileEnterFileURL.isEmpty()==false){
					if (getFileEnterFileURL.equals("Enter File URL")){
					click(By.id("external1"));
					
					}
					if (getFileEnterFileURL.isEmpty()==false){
						enter(By.id("externalUrl"), getFileEnterFileURL);
					}
					if (getFileType.isEmpty()==false){
						select("id", "fileType", getFileType);
					}
					if (getFileTitle.isEmpty()==false){
						String timeFrmtfile = DateHHMMSS2();
						String dateFrmtfile = Date_day();
						String monthFrmtfile = Date_Month();
						String getBuildFileTitle = getFileTitle +" "+ monthFrmtfile + "" + dateFrmtfile + "" + timeFrmtfile + "";
						enter(By.id("fileTitle"), getBuildFileTitle);
					}
					if (getFileKeywords.isEmpty()==false){
						enter(By.id("fileKeywords"), getFileKeywords);
					}
					if (getFileDescription.isEmpty()==false){
						enter(By.id("fileDescription"), getFileDescription);
					}
				}
			}
			// Save File
			if (getFileSaveOrCancel.isEmpty()==false){
				if (getFileSaveOrCancel.equals("Save")){
					logger.info("Save File");
					click(By.cssSelector(".submissionView.ng-scope tbody tr:nth-child(3) td .subSubmissionView tbody tr:nth-child(7) td:nth-child(2) input:nth-child(5)"));
					element_display(By.cssSelector(".editTableWithGrid tbody tr:nth-child(2) td:nth-child(5) .btn.btn-primary.btn-xxs"));
				}
				if (getFileSaveOrCancel.equals("Cancel")){
					click(By.cssSelector(".submissionView.ng-scope tbody tr:nth-child(3) td .subSubmissionView tbody tr:nth-child(7) td:nth-child(2) input:nth-child(6)"));
				}
			}
		    }
			/*********************************/
			//Copy to the other samples
			if (getCopyToTheOtherSample.isEmpty()==true){
				String getSampleNameVal1 = getText(By.id("otherSamples")).replaceAll("\\n", "###");
				logger.info("Sample Name Values: ["+ getSampleNameVal1 +"]");
		           	String[] partsSamples = getSampleNameVal1.split("###");
		           	int randVal = randInt(1, 3);
		            String partSample1 = partsSamples[randVal];
		            logger.info("Copy to the other Samples Name Identified:["+ partSample1 +"]");
		            if (partSample1.isEmpty()==false){
					select("id", "otherSamples", partSample1);
					wait_For(1000);
		            }
			} else if (getCopyToTheOtherSample.isEmpty()==false){
				select("id", "otherSamples", getCopyToTheOtherSample);
			}
			//Save or Reset
			if (getSubmitOrReset.isEmpty()==false){
				if (getSubmitOrReset.equals("Submit")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(4)"));
					verify_submit_sample_nonomaterial_entity(getNanomaterialEntityType);
				}
				if (getSubmitOrReset.equals("Reset")){
					click(By.cssSelector(".invisibleTable tbody tr td:nth-child(2) input:nth-child(3)"));
				}
			}
		}
		/*
		 * 
		 */
		public void verify_submit_sample_nonomaterial_entity(String getExpNanomaterialEntityType) throws TestExecutionException {
			element_display(By.cssSelector(".nanomaterial_entity tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding"));
			String getNanoEntityVal = getText(By.cssSelector(".nanomaterial_entity tbody tr td .summaryViewNoGrid.dataTable.ng-scope tbody tr:nth-child(2) td:nth-child(1) .characterization.ng-binding")).replaceAll("\\n", "");
			String convgetNanoEntityVal = UppercaseFirstLetters(getExpNanomaterialEntityType);
			logger.info("getExpNanomaterialEntityType["+getExpNanomaterialEntityType);
			logger.info("convgetNanoEntityVal["+convgetNanoEntityVal);
			if (getNanoEntityVal.equals(convgetNanoEntityVal)){
				logger.info("Submit nanomaterial entity verfication successful");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Nanomaterial Entity Submit verfication", "verify_submit_sample_nonomaterial_entity", "Sample Nanomaterial Entity Submit Verification Successfully", "Pass");
				stepCount++;
			} else {
				logger.error("Sample Nanomaterial Entity Submit verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Nanomaterial Entity Submit verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Nanomaterial Entity Submit verfication","verify_submit_sample_nonomaterial_entity","Sample Nanomaterial Entity Submit verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * This method convert first characters as upper case 
		 */
		public static String UppercaseFirstLetters(String str) {
		    boolean prevWasWhiteSp = true;
		    char[] chars = str.toCharArray();
		    for (int i = 0; i < chars.length; i++) {
		        if (Character.isLetter(chars[i])) {
		            if (prevWasWhiteSp) {
		                chars[i] = Character.toUpperCase(chars[i]);    
		            }
		            prevWasWhiteSp = false;
		        } else {
		            prevWasWhiteSp = Character.isWhitespace(chars[i]);
		        }
		    }
		    return new String(chars);
		}
		/*
		 * 
		 */
		public void random_image_upload() throws TestExecutionException {
			int getRandomNumber = randInt(1 , 5);
			String getRandomNumberStr = Integer.toString(getRandomNumber);
			String getImagePathRand = "C:\\My Frameworks\\WebDriver\\Application\\caNanoLab\\UploadFile\\pic 0"+getRandomNumberStr+".jpg";
			logger.info("getImagePathRand["+getImagePathRand);
			enter(By.id("uploadedFile"), getImagePathRand);
		}
		/*
		 * 
		 */
		
		public void choose_library_file_upload() throws TestExecutionException {
			// selenium.findElement(By.name("upload")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\Upload.pdf");
			selenium.findElement(By.name("upload")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Upload.pdf");
			//selenium.findElement(By.name("upload")).sendKeys("/local/content/jenkins/8080/jobs/ICRP/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Upload.pdf");
		}
			
		public void choose_library_image_upload() throws TestExecutionException {
			// selenium.findElement(By.name("thumbnail")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\image.jpg");
			selenium.findElement(By.name("thumbnail")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/image.jpg");
			//selenium.findElement(By.name("thumbnail")).sendKeys("/local/content/jenkins/8080/jobs/ICRP/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/image.jpg");
		}
		
		public void choose_statement_upload() throws TestExecutionException {
			// selenium.findElement(By.name("files[statement_of_willingness]")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\Letter1.txt");
			selenium.findElement(By.name("files[statement_of_willingness]")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Letter1.txt");
		}
		
		public void choose_data_upload() throws TestExecutionException {
			// selenium.findElement(By.name("fileId")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\Automation Partner Upload File - Pos.csv");
			selenium.findElement(By.name("fileId")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Automation Partner Upload File - Pos.csv");
		}
		
		public void choose_bad_data_upload() throws TestExecutionException {
			// selenium.findElement(By.name("fileId")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\Automation Partner Upload File - Pos2.csv");
			selenium.findElement(By.name("fileId")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Automation Partner Upload File - Pos2.csv");
			
		}
		
		public void choose_image_upload() throws TestExecutionException {
			// selenium.findElement(By.name("files[fid]")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\image.jpg");
			selenium.findElement(By.name("files[fid]")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/image.jpg");
			//selenium.findElement(By.name("files[fid]")).sendKeys("/local/content/jenkins/8080/jobs//ICRP/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/image.jpg");
		}
		
		
		public void choose_peer_review_upload() throws TestExecutionException {
			// selenium.findElement(By.name("files[peer_review_process]")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\Letter2.txt");
			selenium.findElement(By.name("files[peer_review_process]")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Letter2.txt");
			//selenium.findElement(By.name("files[peer_review_process]")).sendKeys("/local/content/jenkins/8080//jobs/ICRP/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/Letter2.txt");
		}
		
		public void choose_logo_file_upload() throws TestExecutionException {
			// selenium.findElement(By.name("logoFile")).sendKeys("C:\\My Frameworks\\WebDriver\\Application\\ICRP\\UploadFile\\image.jpg");
			selenium.findElement(By.name("logoFile")).sendKeys("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/image.jpg");
			//selenium.findElement(By.name("logo-file")).sendKeys("/local/content/jenkins/8080/jobs/ICRP/workspace/My Frameworks/WebDriver/Application/ICRP/UploadFile/image.jpg");
		}
		
		
		
		public void verify_composing_element(String getVerifyCompEleDescription) throws TestExecutionException {
			element_display(By.cssSelector(".editTableWithGrid.ng-scope tbody tr:nth-child(2) td .btn.btn-primary.btn-xxs"));
			String getDesVal = getText(By.cssSelector(".editTableWithGrid.ng-scope tbody tr:nth-child(5) .ng-binding")).replaceAll("\\n", "");
			logger.info("getDesVal["+getDesVal);
			if (getDesVal.equals(getVerifyCompEleDescription)){
				logger.info("Sample Composing Elelment verfication successful");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample composing element verfication", "verify_composing_element", "Sample Composing Elelment Verification Successfully", "Pass");
				stepCount++;
			} else {
				logger.error("Sample Composing Elelment verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Composing Elelment verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Composing Elelment verfication","verify_sample_reset","Sample Composing Elelment verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Sample Name
		 */
		public String sample_name(String getTitle) {
		   String sampName = "";
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String monthFrmt = Date_Month();
			sampName = "" + getTitle + " " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
		   return sampName;
		}
		/*
		 * Random number
		 */
		public static int randInt(int min, int max) {
		    Random rand = new Random();
		    int randomNum = rand.nextInt((max - min) + 1) + min;
		    logger.info("Random Number has been selected as:[" + randomNum +"] between :["+ min +"] and ["+ max +"]");
		    return randomNum;
		}
		/*
		 * 
		 */
		public void submit_a_new_sample(String getSampleName, String getClickPOCAddButton, 
										String getPOCOrganizationName, String getPOCRole,
										String getAddressYesOrNo, String getPOCSaveOrCancel,
										String getKeywordA, String getKeywordB, String getKeywordC,
										String getAccessAddYes, String getAccessBy, String getUserLoginName, String getUserName, String getAccessToTheSample,
										String getSubmitOrReset) throws TestExecutionException {
			element_display(By.id("sampleName"));
			element_enabled(By.id("sampleName"));
			wait_For(9000);
			//Sample Name
			String getSampleNameVal = sample_name(getSampleName);
			if (getSampleName.isEmpty()==false){
				enter(By.id("sampleName"), getSampleNameVal);
				write_sample_name(getSampleNameVal);
			}
			if (getClickPOCAddButton.isEmpty()==false){
				if (getClickPOCAddButton.equals("Add")){
					click(By.cssSelector(".btn.btn-primary.btn-xxs"));
					element_load(By.cssSelector("#organization-name > select.ng-pristine.ng-valid"));
				}
			}
			//Point Of Contact Information
			//Organization Name
			if (getPOCOrganizationName.isEmpty()==false){
				select("cssSelector", "#organization-name > select.ng-pristine.ng-valid", getPOCOrganizationName);
			} else if (getPOCOrganizationName.isEmpty()==true){
				String getOrganizationListVal = getText(By.cssSelector("#organization-name > select.ng-pristine.ng-valid")).replaceAll("\\n", "###");
				int getRandNumber = randInt(5, 9);
				String [] organizationLstVal = getOrganizationListVal.split("###");
				String partRand = organizationLstVal[getRandNumber];
				logger.info("Random value:["+ partRand +"] identified from Organization Name list box");
				select("cssSelector", "#organization-name > select.ng-pristine.ng-valid", partRand);
			}
			//Role
			if (getPOCRole.isEmpty()==false){
				select("cssSelector", "#role > select.ng-pristine.ng-valid", getPOCRole);
			} else if (getPOCRole.isEmpty()==true){
				String getRoleListVal = getText(By.cssSelector("#role > select.ng-pristine.ng-valid")).replaceAll("\\n", "###");
				int getRoleRandNumber = randInt(0, 1);
				String [] roleLstVal = getRoleListVal.split("###");
				String partRand = roleLstVal[getRoleRandNumber];
				logger.info("Random value:["+ partRand +"] identified from Role list box");
				select("cssSelector", "#role > select.ng-pristine.ng-valid", partRand);
			}
			//Address
			if (getAddressYesOrNo.isEmpty()==false){
				if (getAddressYesOrNo.equals("Yes")){
					enter(By.id("address-line1"), "9605 Medical Center Drive");
					enter(By.id("address-line2"), "370-16");
				    enter(By.id("address-city"), "Rockville");
				    enter(By.id("address-stateProvince"), "MD");
				    enter(By.id("address-zip"), "20850");
				    enter(By.id("address-country"), "USA");
				    enter(By.id("firstName"), "Ahmed");
				    enter(By.id("lastName"), "Shamim");
				    enter(By.id("phoneNumber"), "202-509-3188");
				    enter(By.id("email"), "shamim.ahmed@nih.gov");
				    wait_For(300);
				    click(By.cssSelector(".btn.btn-primary.btn-modal"));
				}
				if (getAddressYesOrNo.equals("No")){
					logger.info("POC address fileds optional");
				}
			}
			//POC Save or Cancel
			if (getPOCSaveOrCancel.isEmpty()==false){
				if (getPOCSaveOrCancel.equals("Save")){
				    wait_For(300);
				    logger.info("POC Save");
				    click(By.cssSelector(".btn.btn-primary.btn-modal"));
				    verify_poc_table();
				}
				if (getPOCSaveOrCancel.equals("Cancel")){
					logger.info("POC Canceled");
					click(By.cssSelector(".btn.btn-warning.btn-modal"));
				}
			}
			//keyword
			if(getKeywordA.isEmpty()==false){
				enter(By.id("newKeyword"), getKeywordA);
				click(By.cssSelector(".btn.btn-primary.btn-xs"));
				wait_For(1000);
				verify_keyword(getKeywordA);
			}
			if(getKeywordB.isEmpty()==false){
				enter(By.id("newKeyword"), getKeywordB);
				click(By.cssSelector(".btn.btn-primary.btn-xs"));
				wait_For(1000);
				verify_keyword(getKeywordB);
			}
			if(getKeywordC.isEmpty()==false){
				enter(By.id("newKeyword"), getKeywordC);
				click(By.cssSelector(".btn.btn-primary.btn-xs"));
				wait_For(1000);
				verify_keyword(getKeywordC);
			}
			//Access to the
			if (getAccessAddYes.isEmpty()==false){
				if (getAccessAddYes.equals("Yes")){
				   click(By.cssSelector(".btn.btn-primary.btn-xxs.ng-scope"));
				    if (getAccessBy.equals("User")){
					   access_to_the_sample(getAccessBy, getUserLoginName, getUserName, getAccessToTheSample);
					   //access_to_the_sample("User", "Researcher CaNano", "canano_res", "read update delete")
					} else if (getAccessBy.equals("Collaboration Group")){
						wait_For(2000);
						element_display(By.id("byGroup"));
						click(By.id("byGroup"));
						String readCollbGrpNm = read_group_name();
						enter(By.id("groupName"), readCollbGrpNm);
						click(By.id("browseIcon1"));
						element_load(By.id("matchedGroupNameSelect"));
						select("id", "matchedGroupNameSelect", readCollbGrpNm);
						wait_For(1000);
						select("id", "roleName", "read update delete");
						wait_For(1000);
						click(By.cssSelector("html body.ng-scope div.container table tbody tr td#maincontent.mainContent table tbody tr td.mainContent.ng-scope div.nanoPageContainer.ng-scope div.spacer div div form#sampleForm.ng-valid.ng-dirty table.submissionView tbody tr td ng-include.ng-scope div#newAccess.ng-scope table.subSubmissionView tbody tr td div input"));
						element_display_false(By.cssSelector("html body.ng-scope div.container table tbody tr td#maincontent.mainContent table tbody tr td.mainContent.ng-scope div.nanoPageContainer.ng-scope div.spacer div div form#sampleForm.ng-valid.ng-dirty table.submissionView tbody tr td ng-include.ng-scope div#newAccess.ng-scope table.subSubmissionView tbody tr td div input"));
						wait_For(20000);
					}
				}
			}
			//Submit or Reset
			if (getSubmitOrReset.isEmpty()==false){
				if (getSubmitOrReset.equals("Save")){
				click(By.cssSelector(".btn.btn-primary.ng-scope.ng-binding"));
				verify_sample_submit_header(getSampleNameVal);
				verify_poc_table();
				verify_keyword(getKeywordA);
				//verify_access(getUserName);
				verify_sample_delete_button();
				verify_sample_copy_button();
				//verify_sample_menu_navigation();
				}
				if (getSubmitOrReset.equals("Reset")){
				click(By.cssSelector(".btn.btn-default"));
				verify_sample_reset();
				}
			}
		}
		/*
		 * 
		 */
		public void verify_sample_reset() throws TestExecutionException {
			String getSampleNameTxt = getText(By.id("sampleName"));
			logger.info("getSampleNameTxt["+getSampleNameTxt);
			if (getSampleNameTxt.isEmpty() == true){
				logger.info("Sample Reset verfication successful");
				oPDF.enterBlockSteps(bTable, stepCount, "Sample Reset verfication", "verify_sample_reset", "Sample Reset Verification Successfully", "Pass");
				stepCount++;
			}
			if (getSampleNameTxt.isEmpty() == false){
				logger.error("Sample Reset verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Reset verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Reset verfication","verify_sample_reset","Sample Reset verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void verify_sample_menu_navigation() throws TestExecutionException {
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				boolean getNavi1 = isDisplayedTrue(By.linkText("COMPOSITION"));
				boolean getNavi2 = isDisplayedTrue(By.linkText("CHARACTERIZATION"));
				boolean getNavi3 = isDisplayedTrue(By.linkText("PUBLICATION"));
				logger.info("COMPOSITION ["+getNavi1);
				logger.info("CHARACTERIZATION ["+getNavi2);
				logger.info("PUBLICATION ["+getNavi3);
				if (getNavi1 == true && getNavi2 == true && getNavi3 == true){
					logger.info("COMPOSITION ["+getNavi1);
					logger.info("CHARACTERIZATION ["+getNavi2);
					logger.info("PUBLICATION ["+getNavi3);
					logger.info("Sample Navigation Tree verfication successful");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Navigation Tree verfication", "verify_sample_menu_navigation", "Sample Navigation Tree Verification Successfully", "Pass");
					stepCount++;
					break;
				}
			}
			boolean getNavi1f = isDisplayedTrue(By.linkText("COMPOSITION"));
			boolean getNavi2f = isDisplayedTrue(By.linkText("CHARACTERIZATION"));
			boolean getNavi3f = isDisplayedTrue(By.linkText("PUBLICATION"));
			logger.info("COMPOSITION ["+getNavi1f);
			logger.info("CHARACTERIZATION ["+getNavi2f);
			logger.info("PUBLICATION ["+getNavi3f);
			if (getNavi1f == false && getNavi2f == false && getNavi3f == false){
				logger.info("COMPOSITION ["+getNavi1f);
				logger.info("CHARACTERIZATION ["+getNavi2f);
				logger.info("PUBLICATION ["+getNavi3f);
				logger.error("Sample Navigation Tree verfication Failed.");
				TestExecutionException e = new TestExecutionException("Sample Navigation Tree verfication failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Navigation Tree verfication","verify_sample_Copy_button","Sample Navigation Tree verfication Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void verify_sample_copy_button() throws TestExecutionException {
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				boolean getCopyBtn = isDisplayedTrue(By.cssSelector(".btn.btn-default:nth-child(2)"));
				logger.info("getCopyBtn["+getCopyBtn);
				if (getCopyBtn == true){
					logger.info("Copy button exists for the current Sample");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Copy Button Verification", "verify_sample_Copy_button", "Sample Copy Button Verification Successfully", "Pass");
					stepCount++;
					break;
				}
			}
			boolean getCopyBtnf = isDisplayedTrue(By.cssSelector(".btn.btn-danger"));
			logger.info("getCopyBtnf["+getCopyBtnf);
			if (getCopyBtnf == false){
				logger.error("Sample Copy button does not exists. Test Failed.");
				TestExecutionException e = new TestExecutionException("Sample Copy Button Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Copy Button Verification","verify_sample_Copy_button","Sample Copy button does not exists. Test Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void verify_sample_delete_button() throws TestExecutionException {
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				boolean getDeleteBtn = isDisplayedTrue(By.cssSelector(".btn.btn-danger"));
				logger.info("getDeleteBtn["+getDeleteBtn);
				if (getDeleteBtn == true){
					logger.info("Delete button exists for the current Sample");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Delete Button Verification", "verify_sample_delete_button", "Sample Delete Button Verification Successfully", "Pass");
					stepCount++;
					break;
				}
			}
			boolean getDeleteBtnf = isDisplayedTrue(By.cssSelector(".btn.btn-danger"));
			logger.info("getDeleteBtnf["+getDeleteBtnf);
			if (getDeleteBtnf == false){
				logger.error("Sample Delete button does not exists. Test Failed.");
				TestExecutionException e = new TestExecutionException("Sample Delete Button Verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Delete Button Verification","verify_sample_delete_button","Sample Delete button does not exists. Test Failed.","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Verify Sample submit header
		 */
		public void verify_sample_submit_header(String getSampleName) throws TestExecutionException {
			String getBldUpdatTxt = "Update "+ getSampleName +" Sample";
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				String expSampleHeaderVal = getText(By.cssSelector(".contentTitle tbody tr th")).replaceAll("\\n", "");
				logger.info("expSampleHeaderVal["+expSampleHeaderVal);
				if (expSampleHeaderVal.equals(getBldUpdatTxt)){
					logger.info("Successfully submitted Sample:["+ getSampleName +"] in to the system");
					oPDF.enterBlockSteps(bTable, stepCount, "Sample Submit Verification", "verify_sample_submit_header", "Successfully submitted Sample:["+ getSampleName +"] in to the system", "Pass");
					stepCount++;
					break;
				}
			}
			String expSampleHeaderVal1 = getText(By.cssSelector(".contentTitle tbody tr th")).replaceAll("\\n", "");
			logger.info("expSampleHeaderVal1["+ expSampleHeaderVal1 +"]");
			logger.info("getBldUpdatTxt["+ getBldUpdatTxt +"]");
			if (expSampleHeaderVal1.equals(getBldUpdatTxt) == false){
				logger.error("Submitted Sample:["+ getSampleName +"] failed");
				TestExecutionException e = new TestExecutionException("sample submit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Submit Verification","verify_sample_submit_header","Submitted Sample:["+ getSampleName +"] failed","Fail");
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * Access to the sample
		 */
		public void access_to_the_sample(String gAccessBy, String gUserLoginName, String gUserName, String gAccessToTheSample) throws TestExecutionException {
			try{
				waitUntil(By.cssSelector(".subSubmissionView tbody tr th"), "Access Information");
				waitUntil(By.cssSelector(".subSubmissionView tbody tr:nth-child(2) td:nth-child(1)"), "Access by *");
				waitUntil(By.cssSelector(".subSubmissionView tbody tr:nth-child(3) td:nth-child(1)"), "Collaboration Group Name *");
			}catch (Exception e){
			}
			if (gAccessBy.isEmpty()==false){
				if (gAccessBy.equals("Collaboration Group")){
						click(By.id("byGroup"));
				} else if (gAccessBy.equals("User")){
						click(By.id("byUser"));
				} else if (gAccessBy.equals("Public")) {
						click(By.id("byPublic"));
			    }
			}
			if (gAccessBy.equals("Public")){
				click(By.cssSelector(".subSubmissionView tbody tr td div input:nth-child(1)"));
				wait_For(25000);
				gUserLoginName = gAccessBy;
			} else {
				if (gUserLoginName.isEmpty()==false){
					click(By.id("browseIcon2"));
					wait_For(5000);
					element_load(By.id("matchedUserNameSelect"));
					String getUserLoginNameVal = getText(By.id("matchedUserNameSelect")).replaceAll("\\n", "###");
					String getUserLoginNameVal1 = getText(By.id("matchedUserNameSelect")).replaceAll("\\n", " ");
					logger.info("User Login Identified Lists:["+ getUserLoginNameVal +"]");
					if (getUserLoginNameVal1.contains(gUserLoginName)){
						select("id", "matchedUserNameSelect", gUserLoginName);
						wait_For(1000);
						select("id", "roleName", gAccessToTheSample);
						wait_For(2000);
						click(By.cssSelector(".subSubmissionView tbody tr td div input:nth-child(1)"));
						wait_For(9000);
					} else {
						String [] partsSampleUserVal = getUserLoginNameVal.split("###");
						String partsSampleUserVal1 = partsSampleUserVal[5];
						logger.info("User Login Identified:["+ partsSampleUserVal1 +"]");
						select("id", "matchedUserNameSelect", partsSampleUserVal1);
						wait_For(1000);
						select("id", "roleName", gAccessToTheSample);
						wait_For(2000);
						click(By.cssSelector(".subSubmissionView tbody tr td div input:nth-child(1)"));
						wait_For(25000);
						gUserLoginName = partsSampleUserVal1;
					}
				}
				try{
				waitUntilElementVisible(By.cssSelector(".btn.btn-primary.btn-xxs:nth-child(1)"));
				waitUntilElementVisible(By.cssSelector(".editTableWithGrid.ng-scope tbody tr:nth-child(1)"));
				waitUntilElementVisible(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr td:nth-child(1)"));
				}catch (Exception e){
				}
				String getAccessUserName = null;
				if (gUserName.equals("canano_res")){
					verify_access(gUserName);
					getAccessUserName = getText(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr:nth-child(2) td:nth-child(1)")).replaceAll("\\n", "");
					logger.info("getAccessUserName:["+getAccessUserName);
				} else if(!gUserName.equals("canano_res")){
					verify_access_others(gUserName);
					getAccessUserName = getText(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr:nth-child(3) td:nth-child(1)")).replaceAll("\\n", "");
					logger.info("getAccessUserName:["+getAccessUserName);
				}
				String getAccessTag = getText(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr th:nth-child(1)")).replaceAll("\\n", "");
				logger.info("AccessTag:["+ getAccessTag +"]");
				if (getAccessTag.contains("User Login Name") && getAccessUserName.contains(gUserName)){
					logger.info("Access Added successfully for the User:["+ gUserLoginName +"]");
					oPDF.enterBlockSteps(bTable,stepCount, "Add Access Role Verification", "access_to_the_sample", "Access Added successfully for the User:["+ gUserLoginName +"]","Pass");
					stepCount++;
				} else {
					captureScreenshot(dir+"/snapshots/AccessAdd.png");
					logger.error("System unbale to add Access info successfully for the following user:["+ gUserLoginName +"]");
					TestExecutionException e = new TestExecutionException("sample Edit verification failed");
					oPDF.enterBlockSteps(bTable,stepCount,"Add Access Role Verification","access_to_the_sample","verification failed","Fail", "AccessAdd.png");
					stepCount++;
					setupAfterSuite();
					Assert.fail(e.getMessage());
				}
			}
		}
		/*
		 * 
		 */
		public void verify_access(String getAccess) throws TestExecutionException {
			element_display(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr:nth-child(2) td:nth-child(1)"));
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				String expAccessVal = getText(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr:nth-child(2) td:nth-child(1)")).replaceAll("\\n", " ");
				logger.info("expAccessVal["+expAccessVal);
				if (expAccessVal.contains(getAccess)){
					logger.info("Successfully Sample Access Added to the Sample");
					break;
				}
			}
		}
		/*
		 * 
		 */
		public void verify_access_others(String getAccess) throws TestExecutionException {
			element_display(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr:nth-child(3) td:nth-child(1)"));
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				String expAccessVal = getText(By.cssSelector(".editTableWithGrid.ng-scope:nth-child(5) tbody tr:nth-child(3) td:nth-child(1)")).replaceAll("\\n", " ");
				logger.info("expAccessVal["+expAccessVal);
				if (expAccessVal.contains(getAccess)){
					logger.info("Successfully Sample Access Added to the Sample");
					break;
				}
			}
		}
		/*
		 * 
		 */
		public void verify_keyword(String getKeyword) throws TestExecutionException {
			String convKeywordToUppr = getKeyword.toUpperCase();
			int verifyCount = 10000;
			for (int i=1;i<verifyCount;i++){
				String expKeywordsVal = getText(By.cssSelector(".keywords-container")).replaceAll("\\n", " ");
				logger.info("expKeywordsVal["+expKeywordsVal);
				if (expKeywordsVal.contains(convKeywordToUppr)){
					logger.info("Successfully Sample Keyword Added");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample Keyword Verification","verify_keyword","Successfully Sample Keyword:["+ getKeyword +"] added","Pass");
					stepCount++;
					break;
				}
			}
		}
		/*
		 * 
		 */
		public void verify_poc_table() throws TestExecutionException {
			int loadCount = 10000;
			for (int i=1;i<loadCount;i++){
				String getPrimaryContactVal = getText(By.cssSelector(".editTableWithGrid tbody tr td:nth-child(1)"));
				boolean getEditBtnVal = isDisplayedTrue(By.cssSelector(".editTableWithGrid tbody tr td:nth-child(5) .btn.btn-primary.btn-xxs"));
				logger.info("getPrimaryContactVal["+getPrimaryContactVal);
				if (getPrimaryContactVal.equals("Yes") && getEditBtnVal == true){
					logger.info("Successfully Sample POC saved");
					oPDF.enterBlockSteps(bTable,stepCount,"Sample POC Verification","verify_poc_table","Successfully Sample POC saved","Pass");
					stepCount++;
					break;
				}
			}
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(1)"), "Primary Contact?");
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(2)"), "Contact Person");
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(3)"), "Organization");
			wait_until_element_present(By.cssSelector(".editTableWithGrid tbody tr th:nth-child(4)"), "Role");
		}
		/*
		 * Submit a New Sample
		 */
		public void submit_new_sample(String getSampleName, String getSubmitOrResetOrUpdate) throws TestExecutionException {
			//Wait for Submit Sample page
			logger.info("Waiting for Submit or Update Sample page");
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				try{
					waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Submit Sample");
				}catch (Exception e){
				}
			} else if (getSubmitOrResetOrUpdate.equals("Update")){
				try{
					waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Update Sample");
				}catch (Exception e){
				}
			} else if (getSubmitOrResetOrUpdate.equals("Reset")){
				try{
					waitUntil(By.cssSelector(".contentTitle tbody tr th"),"Submit Sample");
				}catch (Exception e){
				}
			}
			//String timeFrmt = DateHHMMSS2();
			//String dateFrmt = Date_day();
			//String monthFrmt = Date_Month();
			//String yearFrmt = Date_Year();
			//String pubTile = "" + getTitle + " " + monthFrmt + " " + dateFrmt + " " + timeFrmt + "";
			String sampNam = sample_name(getSampleName);
			if (getSubmitOrResetOrUpdate.equals("Submit")){
				enter(By.id("sampleName"), sampNam);
			} else if (getSubmitOrResetOrUpdate.equals("Update")){
				sampNam = getSampleName;
				enter(By.id("sampleName"), sampNam);
			}
		}
		/*
		 * 
		 */
		// Submit Samples
		public void Verify_the_ability_to_submit_a_New_Samples_general_info(String samplNam, String orgNam, String smpRole, String accessUsrID, String accessUsrInfo) throws TestExecutionException {
			try {
				_wait(3000);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			navigate_to_submit_to_new_sample_page();
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String gSampleName = "" + samplNam + dateFrmt +timeFrmt + "";
			try {
				_wait(100);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("sampleName"), gSampleName);
			click(By.xpath("//form[@id='sampleForm']/table/tbody/tr[2]/td[2]/button"));
			try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			chooseSampleOrganizationName(orgNam);
			try {
				_wait(100);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			chooseSampleRole(smpRole);
			enter(By.id("address-line1"), "9605 Medical Center Drive");
			enter(By.id("address-line2"), "370-16");
		    enter(By.id("address-city"), "Rockville");
		    enter(By.id("address-stateProvince"), "MD");
		    enter(By.id("address-zip"), "20850");
		    enter(By.id("address-country"), "USA");
		    enter(By.id("firstName"), "Ahmed");
		    enter(By.id("lastName"), "Shamim");
		    enter(By.id("phoneNumber"), "202-509-3188");
		    enter(By.id("email"), "shamim.ahmed@nih.gov");
		    click(By.xpath("html/body/div[3]/div/div/div[1]/div[4]/button[2]"));
			try{
		        waitUntil(By.cssSelector(".message.ng-binding:nth-child(1)"), "Point of contact saved");
			}catch (Exception e){		    	
			}
			verifyTitle("Point of contact saved");
			isElementPresent(By.xpath("//form[@id='sampleForm']/table/tbody/tr[2]/td[2]/button"));
			boolean retVal7 = isTextPresent("Point of contact saved");
			if (retVal7 == true){
				logger.info("Sample Point of contacts added successfully");		    	
		    }else {
				logger.error("Could not added Point of Contact to the sample successfully");	
		    }
		    try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    click(By.id("addAccess"));
			click(By.id("byUser"));
			click(By.id("browseIcon2"));
			//click(By.cssSelector("img[alt=\"search existing users\"]"));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.info("Unable to search access user list");
				e.printStackTrace();
			}
			choseAccessUserName(accessUsrID);
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				logger.info("Unable to add Access User Name to the Samples");
				e.printStackTrace();
			}
			choseAccessPublication("read update delete");
			String curaAccess = accessUsrInfo;
			if (curaAccess == "canano_res") {
				click(By.cssSelector("input[type=\"button\"]"));
			} else {
				click(By.cssSelector("div > input[type=\"button\"]"));
			}
			try{
				waitUntil(By.cssSelector(".ng-binding:nth-child(1)"), accessUsrInfo);
			}catch (Exception e){
				logger.info("Verifying access to the sample information");		    	
			}
			boolean retVal1 = isTextPresent("Access to the");
			boolean retVal2 = isTextPresent("Group Name");
			boolean retVal3 = isTextPresent("Access");
			boolean retVal4 = isTextPresent("Curator");
			boolean retVal5 = isTextPresent("read update delete");
			boolean retVal6 = isTextPresent(accessUsrInfo);
			
			if (retVal1 == true && retVal2 == true && retVal3 == true && retVal4 == true && retVal5 == true && retVal6 == true){
				logger.info("Sample Access User has been added successfully");		    	
		    }else {
				logger.error("Could not added Access User ID to the sample successfully");	
		    }
		    addSampleKeyword("sample");
		    addSampleKeyword("qa");
		    addSampleKeyword("test");
		    addSampleKeyword("samples");
		    try {
				_wait(300);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			click(By.xpath("//form[@id='sampleForm']/div/div/button[2]"));
			
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			try{
				waitUntil(By.cssSelector(".ng-binding:nth-child(1)"), "Update Sample");
			}catch (Exception e){		    	
			}
			String scnSht = "sbmtSamsple"+ timeFrmt +".png";
			
			captureScreenshot(dir+"/snapshots/"+ scnSht +"");
			
			boolean retVal8 = isTextPresent("Update Sample");
			
			if (retVal8 == true){
				logger.info("System submited sample General Info successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Geberal Info submit verification","Verify_the_ability_to_submit_a_New_Sample","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to submit Sample General Info successfully");
				TestExecutionException e = new TestExecutionException("Sample General Info submit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample General Info submit verification","Verify_the_ability_to_submit_a_New_Sample","verification failed","Fail", scnSht);
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}
		}
		/*
		 * 
		 */
		public void Search_Samples__For_Composition_Naomaterial_Entity(String searchOption) throws TestExecutionException {
			try {
				_wait(3000);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			click(By.linkText("SAMPLES"));
			logger.info("Link: [ Sample ] clicked");
			try {
				_wait(2000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			click(By.linkText("Search Existing Samples"));
			logger.info("Link: [ Search Existing Samples ] clicked");
			samples_contains_search_by_sample_name(searchOption);
			logger.info("Search Option: [ "+ searchOption +"] Entered");
			click(By.xpath("//input[@value='Search']"));
			logger.info("Button: Click [ Search ] button");
			logger.info("Wait For Search Result");
			try {
				_wait(7000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			click(By.linkText("Edit"));
			logger.info("Link: Clicked [ Edit ] link");
			try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			logger.info("Wait For Sample Edit Page");
			try{
				waitUntil(By.cssSelector(".ng-binding:nth-child(1)"), "Update Sample");
			}catch (Exception e){		    	
			}
		}
		/*
		 * 
		 */
		public void Verify_the_ability_to_add_a_Sample_Composition_Naomaterial_Entity_as_Curator() throws TestExecutionException {
			navigate_to_submit_to_new_sample_composition_page();
			click(By.xpath("(//a[contains(text(),'Add')])[1]"));
			logger.info("Button: Clicked [ Compostion Nanomaterial Entity Add ] button");
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			choseNanomaterialEntity("biopolymer");
			logger.info("Select: [ biopolymer ] from Nanomaterial Entity Dropdown list");
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("neDescription"), "test nanomaterial entity");
			logger.info("Enter: [ Nanomaterial Description ]");
			enter(By.id("biopolymerName"), "biopolymer");
			logger.info("Enter: [ Nanomaterial Biopolymer Name ]");
			choseBiopolymerType("protein");
			logger.info("Select: [ protein ] from Biopolymer Type Dropdown list");
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("biopolymerSequence"), "test Biopolymer Name");
			logger.info("Enter: [ Nanomaterial Biopolymer Sequence ]");
			enter(By.id("biopolymerSequence"), "test Sequence");
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			choseComposingElementType("coat");
			logger.info("Select: [ coat ] from Composing Element Type Dropdown list");
			chosePubChemDataSource("Compound");
			logger.info("Select: [ compound ] from PubChem Data Source Dropdown list");
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("elementName"), "test coat");
			logger.info("Enter: [ Element Name ] as test coat");
			enter(By.id("pubChemId"), "321421341234");
			logger.info("Enter: [ Pubchem ID ] as 321421341234");
			enter(By.id("elementValue"), "0.5");
			logger.info("Enter: [ Element Value ] as 0.5");
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			choseAmountUnit("%");
			choseMolecularFormulaType("Hill");
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("molFormula"), "test Molecular Formula");
			enter(By.id("elementDescription"), "test element description");
			click(By.id("addInherentFunction"));
			try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			choseElementFunctionType("imaging function");
			choseImagingModalityType("bioluminescence");
			enter(By.id("functionDescription"), "test fucntion description");
			click(By.cssSelector("div > input.promptButton"));
		    click(By.xpath("(//input[@value='Save'])[2]"));
		    try {
				_wait(9000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    click(By.id("addFile"));
		    click(By.id("external1"));
		    try {
				_wait(2000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    enter(By.id("externalUrl"), "http://www.test.com");
		    choseFileTypeForSample("document");			    
		    
		    enter(By.id("fileTitle"), "document website");
		    enter(By.id("fileKeywords"), "sample");
		    enter(By.id("fileDescription"), "test Description");
		    click(By.xpath("(//input[@value='Save'])[3]"));
		    try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    chosePrimaryOrganization("Test Submit Sample As Curator12130923");
		    try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    navigate_to_submit_to_new_sample_composition_page();
		    try {
				_wait(5000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		 
            String scnSht = "sbmtSamsplecompostionNanomaterial.png";			
			captureScreenshot(dir+"/snapshots/"+ scnSht +"");			
			boolean retVal8 = isTextPresent("test nanomaterial entity");			
			if (retVal8 == true){
				logger.info("System submited sample Composition Nanomaterial Entity successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Geberal Info submit verification","Verify_the_ability_to_add_a_Sample_Composition_Naomaterial_Entity_as_Curator","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to submit Sample Composition Nanomaterial Entity successfully");
				TestExecutionException e = new TestExecutionException("Sample Composition Nanomaterial Entity submit verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition Nanomaterial Entity submit verification","Verify_the_ability_to_add_a_Sample_Composition_Naomaterial_Entity_as_Curator","verification failed","Fail", scnSht);
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}   
		}
		/*
		 * 
		 */		
		public void Verify_the_ability_to_add_a_Sample_Composition_Functionalizing_Entity_as_Curator() throws TestExecutionException {
			navigate_to_submit_to_new_sample_composition_page();
			click(By.xpath("(//a[contains(text(),'Add')])[2]"));
			logger.info("Button: Clicked [ Compostion Functionalizing Entity Add ] button");
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			choseFunctionalizingEntityType("Magnetic Particle");
		    enter(By.id("feChemicalName"), "Test Sample Chemical");
		    enter(By.id("pubChemId"), "34523465462345234");
		    enter(By.id("amountValue"), "0.5");
		    enter(By.id("molecularFormula"), "Test Molecular Formula");
		    enter(By.id("activationEffect"), "Test Activation Effects");
		    enter(By.id("description"), "Test Description"); 
		    choseFunctionalizingPubChemDataSource("Compound");
		    choseFunctionalizingAmountUnit("%");
		    choseFunctionalizingMolecularFormulaType("Hill");
		    choseFunctionalizingActivationMethod("infrared");
		    choseFunctionalizingFunctionType("endosomolysis");
		    enter(By.id("functionDescription"), "Test Inherent Function Description");
		    verifyFileds("PubChem DataSource");
		    verifyFileds("PubChem Id");
		    verifyFileds("Amount");
		    verifyFileds("Amount Unit");
		    verifyFileds("Molecular Formula Type");
		    verifyFileds("Molecular Formula");
		    verifyFileds("Activation Method");
		    verifyFileds("Activation Effect");
		    verifyFileds("Description");
		    try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    click(By.xpath("(//input[@value='Save'])[2]"));
		    try {
				_wait(9000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    click(By.id("addFile"));
		    try {
				_wait(9000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    click(By.id("external1"));
		    try {
				_wait(3000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    enter(By.id("externalUrl"), "http://www.test.com");
		    enter(By.id("fileTitle"), "Test File Title");
		    enter(By.id("fileKeywords"), "Keyword Test");
		    enter(By.id("fileDescription"), "Test Description");
		    choseFunctionalizingFileType("document");
		    click(By.xpath("(//input[@value='Save'])[3]"));
		    try {
				_wait(9000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    chosePrimaryOrganization("Test Submit Sample As Curator12130923");
		    click(By.cssSelector("input.ng-scope"));
		    try{
				waitUntil(By.cssSelector(".characterization.ng-binding"), "Magnetic Particle");
			}catch (Exception e){		    	
			}
		    try {
				_wait(3000);
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		    String scnSht = "sbmtSamsplecompostionfunctionalizing.png";
			
			captureScreenshot(dir+"/snapshots/"+ scnSht +"");
			
			boolean retVal8 = isTextPresent("Test Sample Chemical");
			
			if (retVal8 == true){
				logger.info("System submited sample Composition functionalizing entity successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition functionalizing entity verification","Verify_the_ability_to_add_a_Sample_Composition_Functionalizing_Entity_as_Curator","verification successful","Pass");
				stepCount++;
			} else {
				logger.error("System unbale to submit Sample Composition functionalizing entity successfully");
				TestExecutionException e = new TestExecutionException("Sample Composition functionalizing entity verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Sample Composition functionalizing entity submit verification","Verify_the_ability_to_add_a_Sample_Composition_Functionalizing_Entity_as_Curator","verification failed","Fail", scnSht);
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			}   
		}	
		/*
		 * 
		 */
		// Submit a New Protocol
		public void submit_a_New_Protocols(String gProtocolType, String protocolNam, String gProtocolAbbreviation, String gProtocolVersion, String gProtocolUploadFile, String gProtocolURL, String gProtocolfileTitle, String gProtocolfileDescription, String accUNm, String accUsrNm) throws TestExecutionException {
			verifyWelcomePage ();
			navigate_to_submit_a_new_protocol_page();
			verifySubmitProtocolPage ();			
			choseProtocolType(gProtocolType);			
			String timeFrmt = DateHHMMSS2();
			String dateFrmt = Date_day();
			String gProtocolName = "" + protocolNam + dateFrmt +timeFrmt + "";
			try {
				_wait(100);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("protocolName"), gProtocolName);
			enter(By.id("protocolAbbreviation"), gProtocolAbbreviation);
			enter(By.id("protocolVersion"), gProtocolVersion);			
			click(By.id(gProtocolUploadFile));
			try {
				_wait(300);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			enter(By.id("externalUrl"), gProtocolURL);			
			enter(By.id("fileTitle"), gProtocolfileTitle);
			enter(By.id("fileDescription"), gProtocolfileDescription);
			if (accUsrNm.equals("canano_res")){
				accessToThe(accUNm, accUsrNm);
			} else if (accUsrNm.equals("collaboration")){
				click(By.id("addAccess"));
				wait_For(2000);
				element_display(By.id("byGroup"));
				click(By.id("byGroup"));
				String readCollbGrpNm = read_group_name();
				enter(By.id("groupName"), readCollbGrpNm);
				click(By.id("browseIcon1"));
				element_load(By.id("matchedGroupNameSelect"));
				select("id", "matchedGroupNameSelect", readCollbGrpNm);
				wait_For(1000);
				select("id", "roleName", "read update delete");
				click(By.cssSelector(".subSubmissionView tbody tr:nth-child(5) td:nth-child(2) div input:nth-child(1)"));
				element_display_false(By.cssSelector(".subSubmissionView tbody tr:nth-child(5) td:nth-child(2) div input:nth-child(1)"));
				wait_For(20000);
			}
			try {
				_wait(7000);
			} catch (Exception e2) {
				// TODO Auto-generated catch block
				e2.printStackTrace();
			}
			click(By.xpath("/html/body/div/table/tbody/tr[3]/td[2]/table/tbody/tr[2]/td/div[1]/div/form/table[3]/tbody/tr/td[2]/button[2]"));
			logger.info("Button: Clicked [ SAVE ] button");
			try {
				_wait(7000);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    String scnSht = "sbmtprotocol.png";			
			captureScreenshot(dir+"/snapshots/"+ scnSht +"");			
			boolean submitCnfMsg = isTextPresent(gProtocolName);			
			if (submitCnfMsg == true){
				logger.info("System submited Protocol successfully");
				oPDF.enterBlockSteps(bTable,stepCount,"Submit Protocol: ''" + gProtocolName + "'' verification","Submit Protocol Test Case","verification successful","Pass", scnSht);
				stepCount++;
			} else {
				logger.error("System unbale to submit Protocol successfully");
				TestExecutionException e = new TestExecutionException("Submit Protocol verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Submit Protocol: ''" + gProtocolName + "'' verification","Submit Protocol Test Case","verification failed","Fail", scnSht);
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			} 
		}
		/*
		 * 
		 */
		// Search Protocol
		public void search_Existing_Protocols(String srchORrest, String gProtocolType, String gcProtocolNme, String gProtocolName, String gcPrtoclAbrevion, String gProtocolAbbreviation, String gcPrtclVersion, String gProtocolVersion) throws TestExecutionException {
			
			 verifyProtocolSearchPage ();
			 choseProtocolType(gProtocolType);
			 choseProtocolName(gcProtocolNme);
			 enter(By.id("protocolName"), gProtocolName);
			 choseProtocolAbbreviation(gcPrtoclAbrevion);
			 enter(By.id("protocolAbbreviation"), gProtocolAbbreviation);
			 choseProtocolFileTitle(gcPrtclVersion);
			 enter(By.id("fileTitle"), gProtocolVersion);		
			 if (srchORrest == "reset") {
		    	 click(By.cssSelector("input[type=\"reset\"]"));
		    	 logger.info("Button: ["+ srchORrest +"] clicked successfully");
				 try {
					_wait(7000);
				 } catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				 }	 
			 } else {
				 click(By.cssSelector("input[type=\"submit\"]"));
				 logger.info("Button: ["+ srchORrest +"] clicked successfully");
				 try {
					_wait(7000);
				 } catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				 }
			 }			 
		    String scnSht = "searchProtocol.png";
			captureScreenshot(dir+"/snapshots/"+ scnSht +"");
			boolean submitCnfMsg = isTextPresent(gProtocolName);			
			if (submitCnfMsg == true){
				logger.info("Successfully search protocol");
				oPDF.enterBlockSteps(bTable,stepCount,"Search Protocol: ''" + gProtocolName + "'' verification","Search Protocol Test Case","verification successful","Pass", scnSht);
				stepCount++;
			} else {
				logger.error("System unbale to successfully search protocol");
				TestExecutionException e = new TestExecutionException("Search Protocol verification failed");
				oPDF.enterBlockSteps(bTable,stepCount,"Search Protocol: ''" + gProtocolName + "'' verification","Search Protocol Test Case","verification failed","Fail", scnSht);
				stepCount++;
				setupAfterSuite();
				Assert.fail(e.getMessage());
			} 			 
		}
		/*
		 * 
		 */			
		public void verify_Sample_Submit_page() throws TestExecutionException {
				try {
					_wait(4000);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				verifyCopySamplePage();
			}
}