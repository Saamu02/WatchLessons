//
//  LessonsListViewModelTests.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 12/03/2023.
//

import XCTest
import Combine
@testable import WatchLessons

final class LessonsListViewModelTests: XCTestCase {
    
    var sut: LessonsListsViewModel!
    var mockLessonListsNetworkManager: MockLessonsListNetworkManager!
    var mockLessonListsCoreDataManager: MockLessonListsCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockLessonListsNetworkManager = MockLessonsListNetworkManager()
        mockLessonListsCoreDataManager = MockLessonListsCoreDataManager()

        sut = LessonsListsViewModel(lessonListsCoreDataManager: mockLessonListsCoreDataManager, lessonListsNetworkManager: mockLessonListsNetworkManager)
    }

    override func tearDown() {
        sut = nil
        mockLessonListsNetworkManager = nil
        mockLessonListsCoreDataManager = nil
        super.tearDown()
    }

    func testLessonsListsViewModel_FetchLessonWhenConnected_ShouldReturnTheData() {
        
        // Arrange
        mockLessonListsNetworkManager.shouldFail = false
        mockLessonListsCoreDataManager.shouldFail = false
        
        // Act
        sut.fetchLesson()
        
        let seconds = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

            //Assert
            XCTAssertTrue(self.sut.fetchingData)
            XCTAssertFalse(self.sut.showError)
            XCTAssertTrue(self.sut.lessons.count > 0)
            XCTAssertFalse(self.sut.networkStatus == .unsatisfied)
        }
    }
    
    func testLessonsListsViewModel_FetchLessonWhenNotConnected_ShouldReturnTheDataFromCoreData() async {
        
        // Arrange
        mockLessonListsNetworkManager.shouldFail = true
        mockLessonListsCoreDataManager.shouldFail = false
        
        // Act
        sut.fetchLesson()
        
        let seconds = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

            //Assert
            XCTAssertTrue(self.sut.fetchingData)
            XCTAssertFalse(self.sut.showError)
            XCTAssertTrue(self.sut.lessons.count > 0)
            XCTAssertFalse(self.sut.networkStatus == .unsatisfied)
        }
    }
    
    func testLessonsListsViewModel_FetchLessonWhenErrorFetchingDataFromCoreData() {
        
        // Arrange
        mockLessonListsNetworkManager.shouldFail = true
        mockLessonListsCoreDataManager.shouldFail = true
        
        // Act
        sut.fetchLessonsFromCoreData()
        
        //Assert
        XCTAssertFalse(sut.fetchingData)
        XCTAssertTrue(sut.showError)
        XCTAssertTrue(sut.lessons.count == 0)
    }
}
