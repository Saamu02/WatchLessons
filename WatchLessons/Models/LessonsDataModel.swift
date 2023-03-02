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

struct Lesson: Decodable, Identifiable {
    var id: Int
    let name: String
    let description: String
    let url: String?
    let thumbnail: String
    let videoUrl: String
}

