import UIKit
import CoreData
//MARK: - temporary cotrollerimport UIKit
class CategoriesAllTVC: UITableViewController {
    
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var fetchedResultController = persistentContainer.getCategoriesFetchedResultsController()
    var selectedCategories: [Category] = []
    
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
        for category in selectedCategories {
            if let index = fetchedResultController.indexPath(forObject: category) {
                tableView.selectRow(at: index, animated: true, scrollPosition: .none)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension CategoriesAllTVC {
    
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

extension CategoriesAllTVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = fetchedResultController.object(at: indexPath)
        selectedCategories.append(category)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let category = fetchedResultController.object(at: indexPath)
        let index = selectedCategories.index(of: category)
        selectedCategories.remove(at: index!)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CategoriesAllTVC: NSFetchedResultsControllerDelegate {

}

// MARK: - UINavigationControllerDelegate
extension CategoriesAllTVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? AddItemVC)?.categories = selectedCategories
        (viewController as? AddItemVC)?.updateCategoriesLabel()
    }
}
