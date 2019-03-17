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
        
        persistentContainer.createCategory(title: "Food")
        persistentContainer.createCategory(title: "Not Food")
        
        let category1 = persistentContainer.fetchRecordForEntityWithTitle("Category", title: "Food") as! Category
        let category2 = persistentContainer.fetchRecordForEntityWithTitle("Category", title: "Not Food") as! Category
        
        persistentContainer.createItem(title: "Broccoli", store: store1)
        persistentContainer.createItem(title: "Apple", store: store1)
        persistentContainer.createItem(title: "Beetroot", store: store1)
        
        persistentContainer.createItem(title: "Paper towels", store: store2)
        persistentContainer.createItem(title: "Water", store: store2)
        
        let broccoli = persistentContainer.fetchRecordForEntityWithTitle("Item", title: "Broccoli") as! Item
        let apple = persistentContainer.fetchRecordForEntityWithTitle("Item", title: "Apple") as! Item
        let beetroot = persistentContainer.fetchRecordForEntityWithTitle("Item", title: "Beetroot") as! Item
        
        broccoli.addToStores(store3)
        broccoli.addToCategories(category1)
        apple.addToCategories(category1)
        beetroot.addToCategories(category1)
        
        let paperTowel = persistentContainer.fetchRecordForEntityWithTitle("Item", title: "Paper towels") as! Item
        let water = persistentContainer.fetchRecordForEntityWithTitle("Item", title: "Water") as! Item
        paperTowel.addToCategories(category2)
        water.addToCategories(category2)
        
        UserDefaults.standard.set(true, forKey: "MocksAreCreated")
        
        persistentContainer.save()
    }
}
