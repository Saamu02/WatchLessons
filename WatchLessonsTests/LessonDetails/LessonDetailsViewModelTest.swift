//
//  LessonDetailsViewModelTest.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 12/03/2023.
//

import XCTest
@testable import WatchLessons

final class LessonDetailsViewModelTest: XCTestCase {
    
    var sut: LessonDetailViewModel!
    var path: URL!
    
    override func setUp() {
        super.setUp()
        sut = LessonDetailViewModel()
        path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    override func tearDown() {
        sut = nil
        path = nil
        super.tearDown()
    }
    
    func testLessonDetailViewModel_IfFileExist_ShouldReturnTrue() {
        // Arrange
        let fileName = "existing_file"
        let fileURL = path.appendingPathComponent("\(fileName).mp4")
        
        // Act
        do {
            try "test".write(to: fileURL, atomically: true, encoding: .utf8)
            
            //Assert
            XCTAssertTrue(sut.ifFileExist(fileName: fileName))
            
        } catch {
            XCTFail("Failed to create test file: \(error)")
        }
        
        addTeardownBlock {
            
            do {
                try FileManager.default.removeItem(at: fileURL)
                
            } catch {
                XCTFail("Fail to remove test file")
            }
        }
    }
    
    func testLessonDetailViewModel_IfFileDoesNotExist_ShouldReturnFalse() {
        
        // Arrange
        let fileName = "existing_file"
        
        // Act
        let ifFileExist = sut.ifFileExist(fileName: fileName)
        
        // Assert
        XCTAssertFalse(ifFileExist, "The File with the name \"\(fileName)\" exists")
    }
    
    func testLessonDetailViewModel_IFSaveFileAtDocumentDir_FileShouldExist() {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test.mp4")
        let fileName = "video"
        let savedURL = path.appendingPathComponent("\(fileName).mp4")

        do {
            try "test".write(to: url, atomically: true, encoding: .utf8)
            
            sut.saveFileAtDocumentDir(at: url, fileName: fileName)
            
            XCTAssertTrue(FileManager.default.fileExists(atPath: savedURL.path))
            
        } catch {
            XCTFail("Failed to create or remove test file: \(error)")
        }
        
        addTeardownBlock {
            
            do {
                try FileManager.default.removeItem(at: savedURL)
                
            } catch {
                XCTFail("Fail to remove test file")
            }
        }
    }
}


