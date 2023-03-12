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
    var mockNetworkManager: MockNetworkManager!
    var mockCoreDataManager: MockCoreDataManager!

    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockCoreDataManager = MockCoreDataManager()

        sut = LessonsListsViewModel(coreDataManager: mockCoreDataManager, networkManager: mockNetworkManager)
    }

    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testLessonsListsViewModel_FetchLessonWhenConnected_ShouldReturnTheData() {
        
        // Arrange
        mockNetworkManager.shouldFail = false
        mockCoreDataManager.shouldFail = false
        
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
        mockNetworkManager.shouldFail = true
        mockCoreDataManager.shouldFail = false
        
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
        mockNetworkManager.shouldFail = true
        mockCoreDataManager.shouldFail = true
        
        // Act
        sut.fetchLessonsFromCoreData()
        
        //Assert
        XCTAssertFalse(sut.fetchingData)
        XCTAssertTrue(sut.showError)
        XCTAssertTrue(sut.lessons.count == 0)
    }
}
