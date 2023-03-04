//
//  LessonsDataModel.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.
//

import Foundation

struct Lessons: Decodable {
    let lessons: [Lesson]
}

struct Lesson: Decodable, Identifiable, Equatable {
    var id: Int?
    var name: String
    var description: String
    var thumbnail: String
    var videoUrl: String
    
    init() {
        id = nil
        name = ""
        description = ""
        thumbnail = ""
        videoUrl = ""
    }
}

