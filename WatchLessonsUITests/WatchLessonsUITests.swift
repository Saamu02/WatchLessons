//
//  WatchLessonsUITests.swift
//  WatchLessonsUITests
//
//  Created by Ussama Irfan on 01/03/2023.
//

import XCTest

final class WatchLessonsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let collectionViewsQuery = app.collectionViews
        XCTAssert(collectionViewsQuery.element.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["The Key To Success In iPhone Photography"]/*[[".cells.buttons[\"The Key To Success In iPhone Photography\"]",".buttons[\"The Key To Success In iPhone Photography\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let nextLessonButton = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Next lesson "]/*[[".buttons[\"Next lesson \"].staticTexts[\"Next lesson \"]",".staticTexts[\"Next lesson \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(nextLessonButton.exists)
        nextLessonButton.tap()
        
        let backButton = app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Lessons"]
        XCTAssert(backButton.exists)
        backButton.tap()
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["3 Secret iPhone Camera Features For Perfect Focus"]/*[[".cells.buttons[\"3 Secret iPhone Camera Features For Perfect Focus\"]",".buttons[\"3 Secret iPhone Camera Features For Perfect Focus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let downloadButton = app.navigationBars["Lessons"].buttons[" Download"]
        XCTAssert(downloadButton.exists)
        downloadButton.tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
