//
//  MockNetworkManager.swift
//  WatchLessonsTests
//
//  Created by Ussama Irfan on 12/03/2023.
//

import Foundation
import Combine
@testable import WatchLessons

class MockLessonsListNetworkManager: LessonListsNetworkManagerProtocol {
    
    var shouldFail: Bool = false
    
    func fetchData() -> AnyPublisher<Lessons, Error> {
       
        if shouldFail {
            return Fail(error: Error.failedRequest).eraseToAnyPublisher()
            
        } else {
            let lesson = Lesson(id: 1, name: "Mock Lesson", description: "Mock Lesson Description", thumbnail: "Mock thumbnail url", videoUrl: "Mock video url")
            let lessonResponse = Lessons(lessons: [lesson])
            return Just(lessonResponse).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
