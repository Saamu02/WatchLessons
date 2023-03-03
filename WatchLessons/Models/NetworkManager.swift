//
//  NetworkManager.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.


import Foundation
import Combine

class NetworkManager {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
   
    static let shared = NetworkManager()
    
    private init () { }
    
    func fetchData() -> AnyPublisher<Lessons, Error> {
        
        guard let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons") else { return Empty<Lessons, Error>().eraseToAnyPublisher() }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: Lessons.self, decoder: decoder)
            .catch{ _ in Empty<Lessons, Error>() }
            .eraseToAnyPublisher()
    }
}


enum Error: LocalizedError {
    
    case addressUnreachable(URL)
    case invalidResponse
    
    var errorDescription: String? {
        
        switch self {
            
        case .addressUnreachable:
            return "Couldn't reach the server"
            
        case .invalidResponse:
            return "The server return invalid response"
        }
    }
}
