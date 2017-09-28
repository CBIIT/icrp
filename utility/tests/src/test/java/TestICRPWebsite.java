import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import java.util.concurrent.TimeUnit;
import java.io.IOException;

import org.junit.Test;
import org.junit.AfterClass;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class TestICRPWebsite {

    @Test
    public void shouldAssertTrue() {
        assertTrue("The primitive value true should equal true", true);
    }

    @Test
    public void shouldBePubliclyAccessible() {
        String websiteUrl =
            System.getProperty("website.url");
        System.out.println("Using " + websiteUrl);
        WebDriver browser = new FirefoxDriver();

        browser.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
        browser.get(websiteUrl);

        assertEquals(
            "ICRP Website should be publicly accessible",
            "International Cancer Research Partnership",
            browser.getTitle());

        browser.close();
    }

    @Test
    public void shouldLogInAsPartner() {
        String websiteUrl =
            System.getProperty("website.url");
        String username =
            System.getProperty("partner.username");
        String password =
            System.getProperty("partner.password");

        System.out.println("Using " + websiteUrl);
        WebDriver browser = new FirefoxDriver();
        browser.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

        browser.get(websiteUrl);
        System.out.println("click login link");
        WebElement loginLink = browser.findElement(By.cssSelector("a[href=\"/user/login\"]"));
        loginLink.click();

        System.out.println("enter username");
        WebElement usernameInput = browser.findElement(By.id("edit-name"));
        usernameInput.sendKeys(username);

        System.out.println("enter password");
        WebElement passwordInput = browser.findElement(By.id("edit-pass"));
        passwordInput.sendKeys(password);

        System.out.println("submit form");
        WebElement loginButton = browser.findElement(By.id("edit-submit"));
        loginButton.click();

        WebDriverWait wait = new WebDriverWait(browser, 10);
        wait.until(ExpectedConditions.urlMatches(websiteUrl + "/?$"));

        System.out.println("check welcome message");
        WebElement welcomeMessage = browser.findElement(By.cssSelector("h1"));
        String welcomeMessageHtml = welcomeMessage.getAttribute("innerHTML");

        assertEquals(
            "Partner greeting page should have a <h1> tag containing 'Welcome ICRP Partner'",
            "Welcome ICRP Partner",
            welcomeMessageHtml);

        browser.close();
    }



}