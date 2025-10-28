package com.example.percy;

import io.github.bonigarcia.wdm.WebDriverManager;
import io.percy.selenium.Percy;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import org.testng.Assert;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

public class Test2 {

    private WebDriver driver;
    private Percy percy;

    @BeforeMethod
    void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless=new");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        driver = new ChromeDriver(options);
        percy = new Percy(driver);
    }

    @AfterMethod
    void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    void openFacebookHomePage() {
        driver.get("https://www.facebook.com");
        percy.snapshot("Facebook Home Page");
        String title = driver.getTitle();
        Assert.assertTrue(title != null && !title.isBlank(), "Expected a non-empty page title for Facebook");
    }
}


