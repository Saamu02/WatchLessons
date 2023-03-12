//
//  CoreDataManagerProtocol.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 12/03/2023.
//

import Foundation

protocol CoreDataManagerProtocol {
    
    func createData(lessonData: Lesson)
    func deleteAllData()
    func fetchLessonsData() throws -> [Lesson]
    
}
