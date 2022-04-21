//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Aleksandra Lazarevic on 18.4.22..
//

import XCTest

class ToDoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddNewItem() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let inicijalniBrojRedova = app.tables.children(matching: .cell).count
        
        app.navigationBars["Active"].buttons["Add"].tap()
        
        let textField = app.textFields["titleTF"]
        textField.tap()
        textField.typeText("PROBA UI TEST")
        
        let contentView = app.textViews["contentTV"]
        contentView.tap()
        contentView.typeText("SADRZAJ UI TEST")
        
        app.navigationBars["Add new"].buttons["Done"].tap()
        
        sleep(5)
        
        let noviBrojRedova = app.tables.children(matching: .cell).count
        
        XCTAssertEqual(inicijalniBrojRedova + 1, noviBrojRedova)
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
