//
//  LessonListsNetworkManager.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.


import Foundation
import Combine

class LessonListsNetworkManager: LessonListsNetworkManagerProtocol {
    
    //    static let shared = NetworkManager()
    private var baseURL: String
    private let urlSession: URLSession
    
    init (url: String = APIHelper.getLessnonsListURL,urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.baseURL = url
    }
    
    func fetchData() -> AnyPublisher<Lessons, Error> {
        
        guard let url = URL(string: baseURL) else { return Result.failure(Error.emptyURL).publisher.eraseToAnyPublisher() }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let apiQueue = DispatchQueue(label: "API", qos: .default, attributes: .concurrent)
        
        return urlSession.dataTaskPublisher(for: url)
            .receive(on: apiQueue)
            .map(\.data)
            .tryMap({ data in
                print(data)
                return data
            })
            .decode(type: Lessons.self, decoder: decoder)
            .mapError{ error in
                
                switch error {
                    
                case is URLError:
                    return Error.failedRequest
                    
                case is DecodingError:
                    return Error.decodingFailed
                    
                default:
                    return Error.addressUnreachable(url)
                }
            }
        
            .eraseToAnyPublisher()
    }
}

