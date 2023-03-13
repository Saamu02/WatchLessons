//
//  LessonListsCoreDataManagerProtocol.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 12/03/2023.
//

import Foundation

protocol LessonListsCoreDataManagerProtocol {
    
    func createData(lessonData: Lesson)
    func deleteAllData()
    func fetchLessonsData() throws -> [Lesson]
    
}
