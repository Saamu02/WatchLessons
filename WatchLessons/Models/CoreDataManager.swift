//
//  CoreDataManager.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 04/03/2023.
//

import CoreData

class CoreDataManager: NSObject {
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WatchLessonsCoreData")
        
        container.loadPersistentStores { description, error in
            
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return Self.persistentContainer.viewContext
    }
    
    func saveContext () {
        
        if context.hasChanges {
            
            do {
                try context.save()
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createData(lessonData: Lesson) {
        let entry = WatchLessonsData(context: context)
        entry.image = lessonData.thumbnail
        entry.id = Int64(lessonData.id!)
        entry.videoDescription = lessonData.description
        entry.videoName = lessonData.name
        entry.videoURL = lessonData.videoUrl
        
        do {
            try context.save()
            
        } catch {
            print(error)
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "WatchLessonsData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try CoreDataManager.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            
        } catch {
            print(error)
        }
    }
    
    func fetchLessonsData() -> [Lesson] {
        var lessonsArray = [Lesson]()
        
        let fetchRequest: NSFetchRequest<WatchLessonsData>
        fetchRequest = WatchLessonsData.fetchRequest()

        do {
            let objects = try context.fetch(fetchRequest)
            
            for lesson in objects {
                var lessonObject = Lesson()
                lessonObject.id = Int(lesson.id)
                lessonObject.videoUrl = lesson.videoURL!
                lessonObject.name = lesson.videoName!
                lessonObject.description = lesson.videoDescription!
                lessonObject.thumbnail = lesson.image!
                lessonsArray.append(lessonObject)
            }
            
        } catch {
            print(error)
        }
        
        return lessonsArray
    }
}
