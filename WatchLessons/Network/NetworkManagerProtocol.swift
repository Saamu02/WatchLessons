//
//  NetworkManagerProtocol.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 12/03/2023.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchData() -> AnyPublisher<Lessons, Error>
}
