//
//  SSLPersistentContainer.swift
//  Shared Shopping List
//
//  Created by Test on 12/15/18.
//  Copyright © 2018 Guest account. All rights reserved.
//

import Foundation
import CoreData

class SSLPersistentContainer: NSPersistentContainer {
    
    lazy var storeFetchedResultsController: NSFetchedResultsController<Store> = {
        
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    func createStore(title: String) {
        let store = Store(context: self.viewContext)
        store.title = title
    }
    
    func save() {
        let context = self.viewContext
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
