package gov.nih.nci.HelperMethods;

 

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.ArrayList;

import org.junit.Assert;

import static org.junit.Assert.*;

import org.apache.commons.io.FileUtils;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.Alert;
import org.openqa.selenium.support.ui.Select;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfPTable;

import org.apache.log4j.Logger;
//import com.itextpdf.text.Image;
/*Class	: BaseTestMethods
 *Author: Shamim Ahmed
 *Author: Vivek Ramani
 *Date	: 04-20-2012  
 *Description: This class is the base class where all the test methods are created.
 *Change History: 
*/
public class BaseTestMethods {
	public static final String fileLocation = System.getProperty("user.dir")+"/TestResults/";
	public pdfGenerator oPDF;
	public Document document;
	public PdfPTable bTable;
	public static int stepCount = 1;
	public static File dir;
	public static final String timeout = "120000";
	public static String seleniumBrowser;
	public static String seleniumUrl;
	public static String appRelease;
	public static String releaseDesc;
	public static int speed = 50;
	public String pdfFileName;
	public String finalPdfFileName;
	private static Logger logger=Logger.getLogger("BaseTestMethods");
	protected BaseTestMethods(){
		
	}	
	protected WebDriver selenium = null;
	protected String parentWindowHandler = null;  // Store your parent window
	protected String subWindowHandler = null;	
//SETUP methods	
	public void setupBeforeSuite(String seleniumBrowser, String seleniumUrl, String testName, String testDesc) {
		oPDF = new pdfGenerator();
		document = oPDF.document;	
		if (seleniumBrowser.equals("ie")){
			DesiredCapabilities capabilities = DesiredCapabilities.internetExplorer();
			capabilities.setCapability(InternetExplorerDriver.
			                 INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS,true); 
			File file = new File("C:\\My Frameworks\\WebDriver\\Application\\BrowserSupport\\IEDriverServer.exe");
			System.setProperty("webdriver.ie.driver", file.getAbsolutePath());
			selenium = new InternetExplorerDriver(capabilities);
			selenium.manage().timeouts().implicitlyWait(3000,  TimeUnit.SECONDS);
		
		} else if (seleniumBrowser.equals("firefox")){
			File file = new File("C:\\Selenium\\Selenium Java WebDriver\\geckodriver-v0.12.0-win64\\geckodriver.exe");
			System.setProperty("webdriver.gecko.driver", file.getAbsolutePath());
			selenium = new FirefoxDriver();
			
		} else if (seleniumBrowser.equals("chrome")){
			File file = new File("/home/ncianalysis/.jenkins/jobs/ICRP-e2e-testing/workspace/test/end-to-end/scripts/workspace/My Frameworks/WebDriver/Application/BrowserSupport/chromedriver.exe");
			System.setProperty("webdriver.chrome.driver", file.getAbsolutePath());
			selenium = new ChromeDriver();
		}
		selenium.get(seleniumUrl);
		if (seleniumBrowser.equals("ie")){
		selenium.manage().window().maximize();
		selenium.navigate().to("javascript:document.getElementById('overridelink').click()");
		}
		
		dir=new File(fileLocation + testName + "-" + Date_MM_DD_YYYY());
		if(dir.exists()){
			logger.warn("WARN: A folder with name 'new folder' is already exist in the path "+fileLocation);
		}else{
			dir.mkdir();
		}
		try{
			pdfFileName = dir + "/" + testName + "-" + DateHHMMSS2()+".pdf";
			finalPdfFileName = dir + "/" + "final_" + testName + "-" + DateHHMMSS2()+".pdf";
			oPDF.createPDF(pdfFileName);
			document.add(oPDF.createHeaderTable(appRelease,releaseDesc,seleniumUrl,seleniumBrowser,"ahmeds6",Date_MM_DD_YYYY()));
			oPDF.createBlockHeader(testName,testDesc);
		}catch(Exception e){
			logger.error("ERROR: PDF Report is not created. Error: " + e.getMessage());
		}
		try{
			bTable = new PdfPTable(5);
			oPDF.createBlockTableHeader(bTable);
		}catch(DocumentException de){
			logger.error("ERROR: PDF Block table header is not created. Error: " + de.getMessage());
		}
	}
	
	
	public void openNewBrowserWindow(String seleniumBrowser){
		if (seleniumBrowser.equals("ie")){
			DesiredCapabilities capabilities = DesiredCapabilities.internetExplorer();
			capabilities.setCapability(InternetExplorerDriver.
			                 INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS,true); 
			File file = new File("C:\\My Frameworks\\WebDriver\\Application\\BrowserSupport\\IEDriverServer.exe");
			System.setProperty("webdriver.ie.driver", file.getAbsolutePath());
			selenium = new InternetExplorerDriver(capabilities);
			selenium.manage().timeouts().implicitlyWait(3000,  TimeUnit.SECONDS);
		} else if (seleniumBrowser.equals("firefox")){
			selenium = new FirefoxDriver();
		} else if (seleniumBrowser.equals("chrome")){
			File file = new File("C:\\My Frameworks\\WebDriver\\Application\\BrowserSupport\\chromedriver.exe");
			System.setProperty("webdriver.chrome.driver", file.getAbsolutePath());
			selenium = new ChromeDriver();
		}
	}

	public void setupAfterSuite() {
		selenium.quit();
		stepCount = 1;
		try{
			document.add(bTable);
		}catch(DocumentException de){
			logger.error("ERROR: Error writing steps to PDF :" + de.getMessage());
		}
		try{
			oPDF.saveImageFiles(dir);
		}catch(DocumentException de){
			logger.error("ERROR: Error Saving image files. "+de.getMessage());
		}catch(IOException ie){
			System.out.println("Error Saving image files. "+ie.getMessage());
		}
		try{
			document.close();
			oPDF.savePDF();
		}catch(Exception ie){
			logger.error("ERROR: Error Saving image files. "+ie.getMessage());
		}
	}	

	public void shutdown(){
		selenium.quit();
	}
//

//Verification methods	
	
	protected boolean verifyTitle(String title) throws TestExecutionException{
		try{
			Assert.assertEquals(title,selenium.getTitle());
			return true;
		}catch(AssertionError e){
			return false;
			
		}
	}
	
	protected boolean verifyText(String actual, String expected) throws TestExecutionException{
		try{
			Assert.assertEquals(expected.toLowerCase(), actual.toLowerCase());
			return true;	
		}catch(AssertionError e) {
			logger.error("ERROR: " + e.getMessage());
			return false;
		}
	}
	
	protected boolean isTextPresent_Contains(By by, String textToVerify) throws TestExecutionException{
		try{
			if (selenium.findElement(by).getText().contains(textToVerify)){
				return true;
			}else{
				logger.error("ERROR: found - ["+ selenium.findElement(by).getText() + "]. expected - [" +textToVerify+ "]");
				return false;
			}
		}catch (NoSuchElementException e){
			logger.error("ERROR: found - "+ selenium.findElement(by).getText() + ". expected - " +textToVerify);
			return false;
		}
	}
	
	protected boolean isTextPresent_regExp(By by, String textToVerify) throws TestExecutionException{
		try{
			if (selenium.findElement(by).getText().matches(textToVerify)){
				return true;
			}else{
				logger.error("ERROR: found - "+ selenium.findElement(by).getText() + ". expected - " +textToVerify);
				return false;
			}
		}catch (NoSuchElementException e){
			logger.error("ERROR: found - "+ selenium.findElement(by).getText() + ". expected - " +textToVerify);
			return false;
		}
	}
	
	protected boolean isTextPresent(String textToVerify) throws TestExecutionException{
		try{
			if(selenium.getPageSource().contains(textToVerify)){
				return true;
			}else{
				return false;
			}
		}catch(NoSuchElementException e){
			return false;
		}
	}
	
	protected boolean isTextNotPresent(String textToVerify) throws TestExecutionException{
		try{
			if(selenium.getPageSource().contains(textToVerify)){
				return false;
			}else{
				return true;
			}
		}catch(NoSuchElementException e){
			return true;
		}
	}
	
	protected boolean isVisible(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isDisplayed()){
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			logger.error("ERROR: "+ e.getMessage());
			return false;			
		}
	}
	
	protected boolean isVisibleTrue(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isDisplayed()){
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			return false;				
		}
	}
	
	protected boolean isEnabled(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isEnabled()){
				logger.info("INFO: " + by + " is enabled");
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			logger.error("ERROR: "+ e.getMessage());
			return false;				
		}
	}
	
	protected boolean isEnabledTrue(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isEnabled()){
				logger.info("INFO: " + by + " is enabled");
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			return false;				
		}
	}
	
	protected boolean isNotEnabled(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isEnabled()){
				logger.info("INFO: " + by + " is enabled");
				return false;
			}else{
				return true;
				}
		}catch(NoSuchElementException e){
			return true;				
		}
	}
	
	protected boolean isDisplayed(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isDisplayed()){
				logger.info("INFO: " + by + " is displayed");
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			logger.error("ERROR: "+ e.getMessage());
			return false;				
		}
	}	
	
	protected boolean isNotDisplayed(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isDisplayed()){
				logger.info("INFO: " + by + " is displayed");
				return false;
			}else{
				return true;
				}
		}catch(NoSuchElementException e){
			return false;				
		}
	}
	
	protected boolean isDisplayedTrue(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isDisplayed()){
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			return false;				
		}
	}
	
	protected boolean isSelected(By by) throws TestExecutionException{
		try{
			if( selenium.findElement(by).isSelected()){
				return true;
			}else{
				return false;
				}
		}catch(NoSuchElementException e){
			logger.error("ERROR: "+ e.getMessage());
			return false;				
		}
	}
	protected boolean isElementPresent(By by) throws NoSuchElementException{
		try{
			selenium.findElement(by);
			return true;
		}catch(NoSuchElementException e){
			logger.error("ERROR: "+ e.getMessage());
			return false;
		}
	}	
	

	protected boolean verifyElementIsPresent(By by) throws NoSuchElementException{
		captureScreenshot(dir+"/snapshots/objectElement.png");
		try{
			selenium.findElement(by);
			oPDF.enterBlockSteps(bTable,stepCount,"Verification","Elements Presents","Object element: [''"+ by + "''] verification is passed","Pass", "objectElement.png");
			stepCount++;
			return true;
		}catch(NoSuchElementException e){
			oPDF.enterBlockSteps(bTable,stepCount,"Verification","Elements Presents","Object element: [''"+ by + "''] verification is failed","Fail", "objectElement.png");
			stepCount++;
			logger.error("ERROR: "+ e.getMessage());
			return false;
		}
	}
	
	protected boolean verifyElementIsTrueOrFalse(By by) throws NoSuchElementException{
		try{
			selenium.findElement(by);
			//oPDF.enterBlockSteps(bTable,stepCount,"Verification","Elements Presents","Object element: [''"+ by + "''] verification is True","Pass");
			//stepCount++;
			return true;
		}catch(NoSuchElementException e){
			//captureScreenshot(dir+"/snapshots/objectElement.png");
			//oPDF.enterBlockSteps(bTable,stepCount,"Verification","Elements Presents","Object element: [''"+ by + "''] verification is False", "Info");
			//stepCount++;
			return false;
		}
	}
	
//Basic methods
	
	public void checkAlertOK() {
		try {
			_wait(3000);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
	        WebDriverWait wait = new WebDriverWait(selenium, 2);
	     //   wait.until(ExpectedConditions.alertIsPresent());
	        Alert alert = selenium.switchTo().alert();
	        alert.getText();
	        //selenium.switchTo().alert().accept();
	        //selenium.chooseOkOnNextConfirmation();
	        logger.info("Alert detected: {}" + alert.getText());
	        alert.accept();
	    } catch (Exception e) {
	        logger.info("Unable to click Popup OK button");
	        logger.error("ERROR: "+ e.getMessage());
	    }
	}
	
	public void checkAlertCancel() {
		try {
			_wait(3000);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
	        WebDriverWait wait = new WebDriverWait(selenium, 2);
	     //   wait.until(ExpectedConditions.alertIsPresent());
	        Alert alert = selenium.switchTo().alert();
	        alert.getText();
	        //selenium.switchTo().alert().accept();
	        //selenium.chooseCancelOnNextConfirmation();
	        logger.info("Alert detected: {}" + alert.getText());
	        alert.dismiss();
	    } catch (Exception e) {
	        logger.info("Unable to click Popup Cancel button");
	        logger.error("ERROR: "+ e.getMessage());
	    }
	}
	
	protected void click(By by) throws TestExecutionException{
		
		try{
			Thread.sleep(speed);
			selenium.findElement(by).click();
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}

	protected void submit(By by) throws TestExecutionException{
		
		try{
			Thread.sleep(speed);
			selenium.findElement(by).submit();
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	
	protected void check (By by) throws TestExecutionException{
		String isChecked;
		try{
			Thread.sleep(speed);
			isChecked = selenium.findElement(by).getAttribute("checked");
			if(isChecked == null){ //if not checked
				click(by); //check
			}
		}catch (Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	
	protected void uncheck (By by) throws TestExecutionException{
		String isChecked;
		isChecked = selenium.findElement(by).getAttribute("checked");
		try{
			Thread.sleep(speed);
			if(isChecked != null){ //if checked
				click(by); //uncheck
			}
		}catch (Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	
	protected void radioSelect() throws TestExecutionException{
		
		try{
			Thread.sleep(speed);
			//selenium.findElement(by).click();
		    selenium.findElement(By.xpath("//a[contains(id(),option1)]"));
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	
	protected void enter(By by, String val) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			setFocus(by);
			selenium.findElement(by).sendKeys(Keys.chord(Keys.CONTROL, "a"));
			//selenium.findElement(by).clear();
			selenium.findElement(by).sendKeys(val);
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}

	protected void keyPress(By by, Keys key) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			selenium.findElement(by).sendKeys(key);
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	protected void keyEnter(By by, String key) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			selenium.findElement(by).sendKeys(key);
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	protected int getRowCount(By by) throws TestExecutionException{
		try{
			WebElement table = selenium.findElement(by);
			List<WebElement> rows = table.findElements(By.tagName("tr"));
			logger.info("INFO: Row Count: "+rows.size());
			return rows.size();
		}catch(Exception e){
			return -1;
		}
    }
	
	protected int getColCount(By by) throws TestExecutionException{
		try{
			WebElement table = selenium.findElement(by);
			List<WebElement> cols = table.findElements(By.tagName("td"));
			return cols.size();
		}catch(Exception e){
			return -1;
		}
    }
	

	protected String getText(By by) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			_wait(1000);
			//String cellText = selenium.findElement(by).getAttribute("innerText");
			String cellText = selenium.findElement(by).getText();
			return cellText;
		}catch(Exception e){
			logger.error("ERROR: " + e.getMessage());
			return null;
		}
	}
	protected String getUrl() throws TestExecutionException{
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
	protected String getAttribute(By by, String attrib) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			_wait(1000);
			String cellText = selenium.findElement(by).getAttribute(attrib);
			System.out.println("Value of "+by+" attribute is " + cellText);
			return cellText;
		}catch(Exception e){
			logger.error("ERROR: " + e.getMessage());
			return null;
		}
	}
	
	protected void select(String property,String value, String option) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			if (property.equals("id")){
				Select select = new Select(selenium.findElement(By.id(value)));
				select.selectByVisibleText(option);		
			}else if (property.equals("xpath")){
				Select select = new Select(selenium.findElement(By.xpath(value)));
				select.selectByVisibleText(option);					
			}else if (property.equals("name")){
				Select select = new Select(selenium.findElement(By.name(value)));
				select.selectByVisibleText(option);
			}else if (property.equals("cssSelector")){
				Select select = new Select(selenium.findElement(By.cssSelector(value)));
				select.selectByVisibleText(option);
			}
		}catch(Exception e){
			logger.error("ERROR: " + e.getMessage());
		}
	}
	
	protected void select(String property,String value, int index) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			if (property.equals("id")){
				Select select = new Select(selenium.findElement(By.id(value)));
				select.selectByIndex(index);
			}else if(property.equals("xpath")){
				Select select = new Select(selenium.findElement(By.xpath(value)));
				select.selectByIndex(index);
			}
		}catch(Exception e){
			logger.error("ERROR: " + e.getMessage());
		}
	}
	
	protected String getSelected(By by) throws TestExecutionException{
		String selectedText;
		try{
			Select select = new Select(selenium.findElement(by));
			WebElement selectedOption = select.getFirstSelectedOption();
			selectedText = selectedOption.getText();
			return selectedText;
		}catch(Exception e){
			logger.error("ERROR: " + e.getMessage());
			return null;
		}
	}

	protected void captureScreenshot(String filename){
		File scrFile = ((TakesScreenshot)selenium).getScreenshotAs(OutputType.FILE);
		try {
			FileUtils.copyFile(scrFile, new File(filename));
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			logger.error("ERROR: " + e1.getMessage());
		}
	}
	
	protected void setFocus(By by) throws TestExecutionException{
		try{
			Thread.sleep(speed);
			Actions action = new Actions(selenium);
			action.moveToElement(selenium.findElement(by)).perform();
		}catch(Exception e){
			logger.error("ERROR: " + e.getMessage());
		}
	}

	protected void enterAndSelectFromAutoCompleteTextField(By by1, By by2,String textEntered,String textToSelect) throws TestExecutionException{
		try{
			_wait(5000);
			enter(by1,textEntered+" ");
			_wait(5000);
			List<WebElement> resultSet = selenium.findElements(by2);
			Iterator<WebElement> i = resultSet.iterator();
			while(i.hasNext()){
				WebElement resLink = i.next();
				String resLinkText = resLink.findElement(By.tagName("a")).getText();
				if(resLinkText.equals(textToSelect)){
					click(By.linkText(resLinkText));
					break;
				}
			}
			resultSet.clear();
		}catch(Exception e){
			logger.error("ERROR: "+ e.getMessage());
		}
	}
	
	protected void _wait(int timeUnit) throws Exception{
		//selenium.manage().timeouts().implicitlyWait(timeUnit, TimeUnit.SECONDS);
		Thread.sleep(timeUnit);
	}
	
	protected void implicitwait(int timeUnit) throws Exception{
		selenium.manage().timeouts().implicitlyWait(timeUnit, TimeUnit.SECONDS);
	}
	
	protected void waitUntil(By by, String text) {
		WebDriverWait wait = new WebDriverWait(selenium, 60);
			
//		wait.until(ExpectedConditions.textToBePresentInElementLocated(by, text));
	}
	
	protected void waitUntil_120(By by, String text) {
		WebDriverWait wait = new WebDriverWait(selenium, 120);
			
//		wait.until(ExpectedConditions.textToBePresentInElementLocated(by, text));
	}
	protected void waitUntilElementVisible (By by){
		WebDriverWait wait = new WebDriverWait(selenium, 6000);
//		wait.until(ExpectedConditions.visibilityOfElementLocated(by));
	}

	protected void waitUntilElementIsPresents (By by){
		WebDriverWait wait = new WebDriverWait(selenium, 6000);
//		wait.until(ExpectedConditions.presenceOfElementLocated(by));
    }
	

	
	/*
	  * Method to get current date in format of HHmmss
	*/
	protected static String DateHHMMSS2()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("HHmmss");
		return sdf.format(new Date());
	}

	protected static String Date_HHMM()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");
		return sdf.format(new Date());
	}
  
	protected static String Date_MM_DD_YYYY()
	{
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy-HHmmss");
		return sdf.format(new Date());
	}	
	
	protected static String Date_Year(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		return  sdf.format(new Date());
	}
	
	protected static String Date_Month(){
		SimpleDateFormat sdf = new SimpleDateFormat("MMMMM");
		return  sdf.format(new Date());
	}
	
	protected static String Date_day(){
		SimpleDateFormat sdf = new SimpleDateFormat("dd");
		return  sdf.format(new Date());
	}
	
	public boolean refresh()
	{

	    boolean executedActionStatus = false;       
	    try{

	        ((JavascriptExecutor)selenium).executeScript("document.location.reload()");

	        Thread.sleep(speed);
	        executedActionStatus = true;
	    }
	    catch(Exception er)
	    {       
	    	logger.error("ERROR: " + er.getMessage());

	    }       
	    return executedActionStatus;
	}
	

	public void switchToChildBrowserWindow(){
		parentWindowHandler = selenium.getWindowHandle();
		Set<String> handles = selenium.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()){
		    subWindowHandler = iterator.next();
		}
		selenium.switchTo().window(subWindowHandler); // switch to popup window
	}
	
	public void switchToParentBrowserWindow(){
		selenium.switchTo().window(parentWindowHandler);	
	}
	
	public void GoToNewTabWindow(){
		((JavascriptExecutor)selenium).executeScript("window.open('about:blank', '_blank');");

	    Set<String> tab_handles = selenium.getWindowHandles();
	    int number_of_tabs = tab_handles.size();
	    int new_tab_index = number_of_tabs-1;
	    selenium.switchTo().window(tab_handles.toArray()[new_tab_index].toString()); 
	}
	
	
	public void GoToPreviousTabWindow(){
		((JavascriptExecutor)selenium).executeScript("window.open('about:blank', '_blank');");

	    Set<String> tab_handles = selenium.getWindowHandles();
	    int number_of_tabs = tab_handles.size();
	    int new_tab_index = number_of_tabs-number_of_tabs;
	    selenium.switchTo().window(tab_handles.toArray()[new_tab_index].toString()); 
	}
	

	public void switchToParentAfterClosingChildWindow(){
		switchToChildBrowserWindow();
		selenium.close();
		parentWindowHandler = selenium.getWindowHandle();
		selenium.switchTo().window(parentWindowHandler);
		
	}
	
	public void close(){
		try{
			selenium.close();	
		}catch (Exception e){
			logger.error("ERROR: Error occurred while closing the browser window. Error:"+e.getMessage());
		}
		
	}
	
	public void navigateTo(String url){
		try{
			selenium.navigate().to(url);
		}catch (Exception e){
			logger.error("ERROR: Error occurred while navigating to the url -" + url + " Error:"+e.getMessage());
		}
	}
	
	public void jsExecutor(By by, String js) {
		try{
			WebElement element = selenium.findElement(by);
			JavascriptExecutor executor = (JavascriptExecutor)selenium;
			executor.executeScript(js, element);	
		}catch (Exception e){
			logger.error("ERROR: Error occurred in executing javascript " + e.getMessage());
		}
		
	}
	
	public void ieCertificateOk(){
		try{
			selenium.get("javascript:document.getElementById('overridelink').click");
		}catch (Exception e){
		}
		
	}

/* ----------------------------------------------------------------------------------------------------------------------*/

}
