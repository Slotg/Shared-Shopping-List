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
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    func getStoresFetchedResultsController() -> NSFetchedResultsController<Store> {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func getItemsFetchedResultsController(withRelationship parent: NSManagedObject) -> NSFetchedResultsController<Item> {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ANY stores = %@", parent)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    
    func createStore(title: String) {
        let store = Store(context: viewContext)
        store.title = title
    }
    
    func createItem(title: String, store: Store) {
        let item = Item(context: viewContext)
        item.title = title
        item.addToStores(store)
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
