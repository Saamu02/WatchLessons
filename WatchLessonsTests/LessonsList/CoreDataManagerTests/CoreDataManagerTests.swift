//
//  CoreDataManagerTests.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 12/03/2023.
//

import XCTest
import CoreData
@testable import WatchLessons

final class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        
        coreDataManager = CoreDataManager()
        coreDataManager.deleteAllData()
    }
    
    override func tearDown() {
        coreDataManager.deleteAllData()
        coreDataManager = nil
        
        super.tearDown()
    }
    
    func testCoreDataManager_WhenCreateAndFetchData_ShouldReturnData() {
        
        // Arrange
        let lesson = Lesson(id: 1, name: "Test Lesson", description: "Test Lesson Description", thumbnail: "Test thumbnail url", videoUrl: "Test video url")
        
        // Act
        coreDataManager.createData(lessonData: lesson)
        
        var lessons: [Lesson]?
        
        do {
            lessons = try coreDataManager.fetchLessonsData()
            
        } catch {
            XCTFail("Failed to fetch lessons from Core Data")
        }
        
        // Assert
        XCTAssertNotNil(lessons)
        XCTAssertEqual(lessons?.count, 1)
        XCTAssertEqual(lessons?.first?.name, "Test Lesson")
        XCTAssertEqual(lessons?.first?.description, "Test Lesson Description")
        XCTAssertEqual(lessons?.first?.thumbnail, "Test thumbnail url")
        XCTAssertEqual(lessons?.first?.videoUrl, "Test video url")
    }
    
    func testCoreDataManager_WhenDeleteData_ShouldReturnNoData() {
        
        // Arrange
        let lesson = Lesson(id: 1, name: "Test Lesson", description: "Test Lesson Description", thumbnail: "Test thumbnail url", videoUrl: "Test video url")
        coreDataManager.createData(lessonData: lesson)
        
        // Act
        coreDataManager.deleteAllData()
        
        var lessons: [Lesson]?
        do {
            lessons = try coreDataManager.fetchLessonsData()
        } catch {
            XCTFail("Failed to fetch lessons from Core Data")
        }
        
        // Assert
        XCTAssertNotNil(lessons)
        XCTAssertEqual(lessons?.count, 0)
    }
    

}
