//  Diary - DiaryManager.swift
//  Created by Ayaan, zhilly on 2022/12/26

import Foundation
import CoreData

final class DiaryManager: CoreDataManageable {
    static let shared: DiaryManager = DiaryManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container: NSPersistentContainer = .init(name: "Diary")
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    func add(_ diary: Diary?) throws {
        guard let entity: NSEntityDescription = NSEntityDescription.entity(
            forEntityName: "DiaryData", in: context
        ) else {
            throw DiaryError.failedFetchEntity
        }
        
        let diaryObject: NSManagedObject = .init(entity: entity, insertInto: context)
        
        diaryObject.setValue(diary?.content ?? String.init(), forKey: "content")
        diaryObject.setValue(diary?.createdAt ?? Date.now, forKey: "createdAt")
        
        try context.save()
    }
    
    func fetchObjects() throws -> [Diary] {
        let fetchRequest: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let result: [DiaryData] = try context.fetch(fetchRequest)
        
        return result.compactMap({ Diary(from: $0) })
    }
    
    func update(_ diary: Diary) throws {
        guard let objectID: NSManagedObjectID = fetchObjectID(from: diary.objectID) else {
            throw DiaryError.invalidObjectID
        }
        let object: NSManagedObject = context.object(with: objectID)
        
        object.setValue(diary.content, forKey: "content")
        object.setValue(diary.weatherMain, forKey: "weatherMain")
        object.setValue(diary.weatherIconID, forKey: "weatherIconID")
        
        try context.save()
    }
    
    func remove(_ diary: Diary) throws {
        guard let objectID: NSManagedObjectID = fetchObjectID(from: diary.objectID) else {
            throw DiaryError.invalidObjectID
        }
        let object: NSManagedObject = context.object(with: objectID)
        
        context.delete(object)
        
        try context.save()
    }
    
    private func fetchObjectID(from diaryID: String?) -> NSManagedObjectID? {
        guard let diaryID: String = diaryID,
              let objectURL: URL = URL(string: diaryID),
              let storeCoordinator: NSPersistentStoreCoordinator = context.persistentStoreCoordinator,
              let objectID: NSManagedObjectID = storeCoordinator.managedObjectID(
                forURIRepresentation: objectURL
              ) else { return nil }
        
        return objectID
    }
}
