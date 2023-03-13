//
//  MockLessonListsCoreDataManager.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 12/03/2023.
//

import Foundation
import CoreData
@testable import WatchLessons

class MockLessonListsCoreDataManager: LessonListsCoreDataManagerProtocol {
    
    var shouldFail: Bool = false
    var mockLessons = [Lesson]()
    
    func fetchLessonsData() throws -> [Lesson] {
        
        if shouldFail {
            throw Error.failFetchingDataFromCoreData

        } else {
            let lesson = Lesson(id: 1, name: "Mock Lesson", description: "Mock Lesson Description", thumbnail: "Mock thumbnail url", videoUrl: "Mock video url")
            return [lesson]
        }
    }
    
    func createData(lessonData: Lesson) {
        mockLessons.append(lessonData)
    }
    
    func deleteAllData() {
        mockLessons = []
    }
}
