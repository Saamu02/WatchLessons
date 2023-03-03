//
//  LessonsListViewModel.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 02/03/2023.
//

import Foundation
import Combine

class LessonsListsViewModel: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let networkManager = NetworkManager.shared
    
    @Published var lessons = [Lesson]()
    @Published var errorDescription = ""
    @Published var showError = false
    @Published var fetchingData = true
    
    private var isConnectedToInternet = true
    
    func fetchLesson() {
        
        if isConnectedToInternet {
            fetchLesssonsFromAPI()
            
        } else {
            showError = true
            errorDescription = ErrorDescription.noInternetConnect
        }
    }
    
    func fetchLesssonsFromAPI() {
        
        networkManager.fetchData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    self.fetchingData = false
                    
                    switch completion {
                        
                    case .finished:
                        print("Succefully Finished")
                    
                    case .failure(_):
                        self.showError = true
                        self.errorDescription = ErrorDescription.someThingWentWrong
                    }
                },
                
                receiveValue: { [weak self] in
                    guard let self else { return }
                    self.showError = false
                    self.lessons = $0.lessons }
            )
            .store(in: &cancellableSet)

    }
}
