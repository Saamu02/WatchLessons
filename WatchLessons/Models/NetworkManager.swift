//
//  NetworkManager.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 01/03/2023.


import Foundation
import Combine

class NetworkManager {
    
    private var cancellableSet: Set<AnyCancellable> = []

   
    func fetchData() {
        
        guard let url = URL(string: "https://iphonephotographyschool.com/test-api/lessons") else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let subscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Lessons.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                }
                
            }, receiveValue: { data in
                print("Retrieved data of size \(data.lessons)")
            })
            .store(in: &cancellableSet)
    }

}
