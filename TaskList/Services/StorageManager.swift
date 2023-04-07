//
//  StorageManager.swift
//  TaskList
//
//  Created by Дмитрий Лубов on 03.04.2023.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchContext(completion: @escaping(Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskData = try context.fetch(fetchRequest)
            completion(.success(taskData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addTask(withTitle title: String) -> Task {
        let task = Task(context: context)
        
        task.title = title
        saveContext()
        
        return task
    }
    
    func delete(task: Task) {
        context.delete(task)
        saveContext()
    }
}
