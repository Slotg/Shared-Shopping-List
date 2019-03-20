import Foundation
import CoreData

class SSLPersistentContainer: NSPersistentContainer {
    
    func getStoresFetchedResultsController() -> NSFetchedResultsController<Store> {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func getCategoriesFetchedResultsController() -> NSFetchedResultsController<Category> {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }
    
    func getItemsFetchedResultsController(withRelationship parent: NSManagedObject? = nil) -> NSFetchedResultsController<Item> {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //TODO: - temporary bad solution
        if let parent = parent as? Store {
            fetchRequest.predicate = NSPredicate(format: "ANY stores = %@", parent)
        }
        if let parent = parent as? Category {
            fetchRequest.predicate = NSPredicate(format: "ANY categories = %@", parent)
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    
    func createStore(title: String, address: String?) {
        let store = Store(context: viewContext)
        store.title = title
        if let address = address { store.address = address }
    }
    
    func createCategory(title: String) {
        let category = Category(context: viewContext)
        category.title = title
    }
    
    //TODO: - abstract
    func createItem(title: String, store: Store) {
        let item = Item(context: viewContext)
        item.title = title
        item.addToStores(store)
    }
    
    func createItem(title: String, category: Category) {
        let item = Item(context: viewContext)
        item.title = title
        item.addToCategories(category)
    }
    
    func createItem(title: String, stores: [Store] = [], categories: [Category] = []) {
        let item = Item(context: viewContext)
        item.title = title
        for store in stores {
            item.addToStores(store)
        }
        for category in categories {
            item.addToCategories(category)
        }
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
    
    //MARK: - helper method for now
    func fetchRecordForEntityWithTitle(_ entity: String, title: String) -> NSManagedObject {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try viewContext.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return result.first!
    }
}
