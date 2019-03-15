import Foundation
import UIKit

struct Mock {
    static func addMockValues() {
        guard UserDefaults.standard.bool(forKey: "MocksAreCreated") == false else { return }
        
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        persistentContainer.createStore(title: "Vegetable store", address: "1st st, Dallas, TX")
        persistentContainer.createStore(title: "General Goods", address: "Trump st, Dallas, TX")
        persistentContainer.createStore(title: "Empty Store", address: "666 st, Iceland")
        persistentContainer.createStore(title: "Broccoli Emporium", address: "Vegan ave, Greenland")
        
        let store1 = persistentContainer.fetchRecordForEntityWithTitle("Store", title: "Vegetable store") as! Store
        let store2 = persistentContainer.fetchRecordForEntityWithTitle("Store", title: "General Goods") as! Store
        let store3 = persistentContainer.fetchRecordForEntityWithTitle("Store", title: "Broccoli Emporium") as! Store
        
        persistentContainer.createItem(title: "Broccoli", store: store1)
        persistentContainer.createItem(title: "Apple", store: store1)
        persistentContainer.createItem(title: "Beetroot", store: store1)
        
        persistentContainer.createItem(title: "Paper towels", store: store2)
        persistentContainer.createItem(title: "Water", store: store2)
        
        let broccoli = persistentContainer.fetchRecordForEntityWithTitle("Item", title: "Broccoli") as! Item
        broccoli.addToStores(store3)
        
        UserDefaults.standard.set(true, forKey: "MocksAreCreated")
        
        persistentContainer.save()
    }
}
