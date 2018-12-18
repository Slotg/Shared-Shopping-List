import UIKit
import CoreData

class ItemsVC: UIViewController {
    
    // MARK: - Properties
    //protocol?
    var itemsParent: Store?
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var fetchedResultController = persistentContainer.getItemsFetchedResultsController(withRelationship: itemsParent!)
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBActions
    @IBAction func btnActionAddItem(_ sender: Any) {
        presentCreateItemAlert()
    }

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

    // MARK: - UITableViewDelegate, UITableViewDataSource
extension ItemsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = fetchedResultController.fetchedObjects else {return 0}
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - investigate ! removal options
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = fetchedResultController.object(at: indexPath)
        let cellTitle = item.title!
        cell.configureCell(title: cellTitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultController.object(at: indexPath)
            item.managedObjectContext?.delete(item)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension ItemsVC: NSFetchedResultsControllerDelegate {
    
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
        default:
            print("...")
        }
    }
}

//MARK: - Add Store
extension ItemsVC {
    func presentCreateItemAlert() {
        let alert = UIAlertController(title: "Enter Item name", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Item name"
        }
        let createStore = UIAlertAction(title: "Create", style: .default) { [weak alert, unowned self] _ in
            guard let alert = alert, let textFieldName = alert.textFields?.first else { return }
            let title = textFieldName.text!
            self.persistentContainer.createItem(title: title, store: self.itemsParent!)
        }
        let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(dismissAlert)
        alert.addAction(createStore)
        self.present(alert, animated: true, completion: nil)
    }
}
