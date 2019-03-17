import UIKit
import CoreData

class CetegoriesVC: UIViewController {
    
    // MARK: - Properties
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var fetchedResultController = persistentContainer.getCategoriesFetchedResultsController()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpFetchedResultController()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
    }
}

// MARK: - UITableViewDataSource
extension CetegoriesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let categories = fetchedResultController.fetchedObjects else {return 0}
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            fatalError("Unexpected Index Path or Reuse Identifier")
        }
        let category = fetchedResultController.object(at: indexPath)
        let cellTitle = category.title!
        let cellItemsCount = category.items?.count
        cell.configureCell(title: cellTitle, itemsCount: cellItemsCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = fetchedResultController.object(at: indexPath)
            category.managedObjectContext?.delete(category)
        }
    }
}

// MARK: - UITableViewDelegate
extension CetegoriesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CetegoriesVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        default:
            print("...")
        }
    }
}

//MARK: - Navigation
extension CetegoriesVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemsList" {
            guard let storeIndexPath = tableView.indexPathForSelectedRow else {return}
            let destination = segue.destination as? ItemsVC
            destination?.itemsCategory = fetchedResultController.object(at: storeIndexPath)
        }
    }
}
