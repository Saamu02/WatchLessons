//
//  LessonsListViewModel.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 02/03/2023.
//

import Combine
import Network
import CoreData
import UIKit

class LessonsListsViewModel: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let networkManager = NetworkManager.shared
    
    @Published var lessons = [Lesson]()
    @Published var errorDescription = ""
    @Published var showError = false
    @Published var fetchingData = true
    @Published var networkStatus: NWPath.Status = .satisfied
    @Published var image: UIImage?
    
    private var isConnectedToInternet = true
    private let monitorQueue = DispatchQueue(label: "monitor")
    private var coreDataManager = CoreDataManager()
    
    func fetchLesson() {
        checkConnectivity()
    }
    
    func checkConnectivity() {

        NWPathMonitor()
            .publisher(queue: monitorQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                switch status {
                    
                case .satisfied:
                    self.fetchLesssonsFromAPI()
                                
                default:
                    self.fetchLessonsFromCoreData()
                }
            }
            .store(in: &cancellableSet)
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
                    
                    self.coreDataManager.deleteAllData()
                    
                    for lesson in $0.lessons {
                        self.coreDataManager.createData(lessonData: lesson)
                    }
                    
                    self.fetchLessonsFromCoreData()
                }
            )
            .store(in: &cancellableSet)
    }
    
    func fetchLessonsFromCoreData() {
        self.fetchingData = false
        self.lessons = coreDataManager.fetchLessonsData()
    }
}
