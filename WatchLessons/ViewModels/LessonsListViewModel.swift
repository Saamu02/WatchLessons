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
        
    @Published var lessons = [Lesson]()
    @Published var errorDescription = ""
    @Published var showError = false
    @Published var fetchingData = true
    @Published var networkStatus: NWPath.Status = .satisfied
    @Published var image: UIImage?
    
    private var isConnectedToInternet = true
    private let monitorQueue = DispatchQueue(label: "monitor")
    private var coreDataManager: CoreDataManagerProtocol
    private var networkManager: NetworkManagerProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager(), networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.coreDataManager = coreDataManager
        self.networkManager = networkManager
    }
    
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
                    
                    print($0.lessons)
                    print($0.lessons.count)
                    self.deleteLessonsFromCoreData()
                    
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
        
        do {
            self.lessons = try coreDataManager.fetchLessonsData()
            
        } catch {
            self.showError = true
            self.errorDescription = "Please make sure you are connected to the internet to recieve value"
        }
    }
    
    func deleteLessonsFromCoreData() {
        self.coreDataManager.deleteAllData()
    }
}
