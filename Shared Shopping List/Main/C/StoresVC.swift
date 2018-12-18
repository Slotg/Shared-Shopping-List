import UIKit
import CoreData

class StoresVC: UIViewController {
    
    // MARK: - Properties
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var fetchedResultController = persistentContainer.getStoresFetchedResultsController()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBActions
    @IBAction func btnActionAddStore(_ sender: Any) {
        presentCreateSroreAlert()
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
extension StoresVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let stores = fetchedResultController.fetchedObjects else {return 0}
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: - investigate ! removal options
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        let store = fetchedResultController.object(at: indexPath)
        let cellTitle = store.title!
        cell.configureCell(title: cellTitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let store = fetchedResultController.object(at: indexPath)
            store.managedObjectContext?.delete(store)
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StoresVC: NSFetchedResultsControllerDelegate {
    
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
extension StoresVC {
    func presentCreateSroreAlert() {
        let alert = UIAlertController(title: "Enter Store name", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Store name"
        }
        let createStore = UIAlertAction(title: "Create", style: .default) { [weak alert, unowned self] _ in
            guard let alert = alert, let textFieldName = alert.textFields?.first else { return }
            let title = textFieldName.text!
            self.persistentContainer.createStore(title: title)
        }
        let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(dismissAlert)
        alert.addAction(createStore)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Navigation
extension StoresVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItemsList" {
            guard let storeIndexPath = tableView.indexPathForSelectedRow else {return}
            let destination = segue.destination as? ItemsVC
            destination?.itemsParent = fetchedResultController.object(at: storeIndexPath)
        }
    }
}
