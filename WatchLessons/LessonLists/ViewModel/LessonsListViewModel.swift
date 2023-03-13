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
    private var lessonListsCoreDataManager: LessonListsCoreDataManagerProtocol
    private var lessonListsNetworkManager: LessonListsNetworkManagerProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(lessonListsCoreDataManager: LessonListsCoreDataManagerProtocol = LessonListsCoreDataManager(), lessonListsNetworkManager: LessonListsNetworkManagerProtocol = LessonListsNetworkManager()) {
        self.lessonListsCoreDataManager = lessonListsCoreDataManager
        self.lessonListsNetworkManager = lessonListsNetworkManager
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
        
        lessonListsNetworkManager.fetchData()
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
                        self.lessonListsCoreDataManager.createData(lessonData: lesson)
                    }
                    
                    self.fetchLessonsFromCoreData()
                }
            )
            .store(in: &cancellableSet)
    }
    
    func fetchLessonsFromCoreData() {
        self.fetchingData = false
        
        do {
            self.lessons = try lessonListsCoreDataManager.fetchLessonsData()
            
        } catch {
            self.showError = true
            self.errorDescription = "Please make sure you are connected to the internet to recieve value"
        }
    }
    
    func deleteLessonsFromCoreData() {
        self.lessonListsCoreDataManager.deleteAllData()
    }
}
