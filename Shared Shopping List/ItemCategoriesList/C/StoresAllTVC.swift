import UIKit
import CoreData
//MARK: - temporary cotrollerimport UIKit
class StoresAllTVC: UITableViewController {
    
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var fetchedResultController = persistentContainer.getStoresFetchedResultsController()
    var selectedStores: [Store] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFetchedResultController()
        tableView.tableFooterView = UIView()
        navigationController?.delegate = self
    }
    
    private func setUpFetchedResultController() {
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        //TODD: - change
        for store in selectedStores {
            if let index = fetchedResultController.indexPath(forObject: store) {
                tableView.selectRow(at: index, animated: true, scrollPosition: .none)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension StoresAllTVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = fetchedResultController.fetchedObjects else {return 0}
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesGenericCell.reuseIdentifier, for: indexPath) as? CategoriesGenericCell else {
            fatalError("Unexpected Index Path")
        }
        let item = fetchedResultController.object(at: indexPath)
        let cellTitle = item.title!
        cell.configureCell(title: cellTitle)
        return cell
    }
}

extension StoresAllTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let store = fetchedResultController.object(at: indexPath)
        selectedStores.append(store)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let store = fetchedResultController.object(at: indexPath)
        let index = selectedStores.index(of: store)
        selectedStores.remove(at: index!)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StoresAllTVC: NSFetchedResultsControllerDelegate {

}

// MARK: - UINavigationControllerDelegate
extension StoresAllTVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? AddItemVC)?.stores = selectedStores
        (viewController as? AddItemVC)?.updateStoresLabel()
    }
}
