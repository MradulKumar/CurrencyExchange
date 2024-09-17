//
//  CurrencyExchangeUITests.swift
//  CurrencyExchangeUITests
//
//  Created by Mradul Kumar on 16/09/24.
//

import XCTest

final class CurrencyExchangeUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Testing the app to check ui elements are placed.
    func testNormalLaunch() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // 5 seconds, taken a larger timeout than above method because this test case will verify the UI after api response
        // this can also be run once the data is received
        let timeout: TimeInterval = 5
        
        let amountTextField = app.textFields[AccessibilitiyIdentifiers.amountTextField]
        let currencySelectionButton = app.buttons[AccessibilitiyIdentifiers.currencySelectionButton]
        
        XCTAssertTrue(amountTextField.waitForExistence(timeout: timeout))
        XCTAssertTrue(currencySelectionButton.waitForExistence(timeout: timeout))
        
        amountTextField.tap()
        amountTextField.typeText("0")
        amountTextField.typeText("\n")
        
        currencySelectionButton.tap()
        
        let scrollView = app.scrollViews[AccessibilitiyIdentifiers.currencyListScrollView]
        scrollView.swipeUp()
        scrollView.swipeDown()
        
        let AEDButton = app.buttons[AccessibilitiyIdentifiers.AEDButton]
        XCTAssertTrue(AEDButton.exists)
        AEDButton.tap()
        
        //waiting before exit
        sleep(10)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
