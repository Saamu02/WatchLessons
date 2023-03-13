//
//  BaseCoreDataManager.swift
//  WatchLessons
//
//  Created by Ussama Irfan on 13/03/2023.
//

import CoreData

class CoreDataManager {
    
    public var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WatchLessonsCoreData")
        
        container.loadPersistentStores { description, error in
            
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
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
}
