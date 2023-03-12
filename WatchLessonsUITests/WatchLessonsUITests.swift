//
//  WatchLessonsUITests.swift
//  WatchLessonsUITests
//
//  Created by Ussama Irfan on 01/03/2023.
//

import XCTest

final class WatchLessonsUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {

        try super.setUpWithError()

        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        
        let collectionViewsQuery = app.collectionViews
        XCTAssert(collectionViewsQuery.element.exists)
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["The Key To Success In iPhone Photography"]/*[[".cells.buttons[\"The Key To Success In iPhone Photography\"]",".buttons[\"The Key To Success In iPhone Photography\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(10)
        let nextLessonButton = app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts["Next lesson "]/*[[".buttons[\"Next lesson \"].staticTexts[\"Next lesson \"]",".staticTexts[\"Next lesson \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(nextLessonButton.exists)
        nextLessonButton.tap()
        
        sleep(10)
        let backButton = app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Lessons"]
        XCTAssert(backButton.exists)
        backButton.tap()
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["3 Secret iPhone Camera Features For Perfect Focus"]/*[[".cells.buttons[\"3 Secret iPhone Camera Features For Perfect Focus\"]",".buttons[\"3 Secret iPhone Camera Features For Perfect Focus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(10)
        let downloadButton = app.navigationBars["Lessons"].buttons[" Download"]
        XCTAssert(downloadButton.exists)
        downloadButton.tap()
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
