import Foundation
import UIKit

struct Mock {
    static func addMockValues() {
        guard UserDefaults.standard.bool(forKey: "MocksAreCreated") == false else { return }
        
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        persistentContainer.createStore(title: "Vegetable store", address: "1st st, Dallas, TX")
        persistentContainer.createStore(title: "General Goods", address: "Trump st, Dallas, TX")
        
        let store1 = persistentContainer.fetchRecordForEntityWithTitle("Store", title: "Vegetable store") as! Store
        let store2 = persistentContainer.fetchRecordForEntityWithTitle("Store", title: "General Goods") as! Store
        
        persistentContainer.createItem(title: "Broccoli", store: store1)
        persistentContainer.createItem(title: "Apple", store: store1)
        persistentContainer.createItem(title: "Beetroot", store: store1)
        
        persistentContainer.createItem(title: "Paper towels", store: store2)
        persistentContainer.createItem(title: "Water", store: store2)
        
        UserDefaults.standard.set(true, forKey: "MocksAreCreated")
    }
}
