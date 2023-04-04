//
//  StorageManager.swift
//  TaskList
//
//  Created by Дмитрий Лубов on 03.04.2023.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    private init() {}

    func saveContext() {
//        let context = persistentContainer.viewContext
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
//        let context = persistentContainer.viewContext
        
        do {
            let taskData = try context.fetch(fetchRequest)
            completion(.success(taskData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func addTask(withTitle title: String) -> Task {
//        let context = persistentContainer.viewContext
        let task = Task(context: context)
        
        task.title = title
        saveContext()
        
        return task
    }
    
    func delete(task: Task) {
//        let context = persistentContainer.viewContext
        context.delete(task)
        saveContext()
    }
}
