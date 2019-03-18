import UIKit
import CoreData

class ItemsVC: UIViewController {
    
    //TODO: - hide emtpy Done header
    //TODO: - new Done cell
    
    // MARK: - Properties
    //protocol?
    var itemsCategory: NSManagedObject?
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    private lazy var fetchedResultController = persistentContainer.getItemsFetchedResultsController(withRelationship: itemsCategory!)
    private var doneItems: [Item] = []
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleteDoneItems()
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
extension ItemsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Done"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = fetchedResultController.fetchedObjects else {return 0}
        switch section {
        case 0:
            return items.count
        case 1:
            return doneItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell else {
            fatalError("Unexpected Index Path")
        }
        switch indexPath.section {
        case 0:
            let item = fetchedResultController.object(at: indexPath)
            let cellTitle = item.title!
            cell.configureCell(title: cellTitle)
            return cell
        case 1:
            let item = doneItems[indexPath.row]
            let cellTitle = item.title!
            cell.configureCell(title: cellTitle)
            return cell
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchedResultController.object(at: indexPath)
            item.managedObjectContext?.delete(item)
        }
    }
}

// MARK: - UITableViewDelegate
extension ItemsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            let item = fetchedResultController.object(at: indexPath)
            doneItems.append(item)
            let newIndexPath = IndexPath(row: doneItems.count - 1, section: 1)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            let item = doneItems[indexPath.row]
            let itemIndexPath = fetchedResultController.indexPath(forObject: item)
            doneItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //TODO: - !
            tableView.reloadRows(at: [itemIndexPath!], with: .fade)
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let item = fetchedResultController.object(at: indexPath)
            if doneItems.contains(item) {
                return 0
            }
            return 50
        default:
            return 50
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

//MARK: - Add Item
extension ItemsVC {
    func presentCreateItemAlert() {
        let alert = UIAlertController(title: "Enter Item name", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Item name"
        }
        let createStore = UIAlertAction(title: "Create", style: .default) { [weak alert, unowned self] _ in
            guard let alert = alert, let textFieldName = alert.textFields?.first else { return }
            let title = textFieldName.text!
            //TODO: - temporary bad solution
            if let store = self.itemsCategory as? Store {
                self.persistentContainer.createItem(title: title, store: store)
            }
            if let category = self.itemsCategory as? Category {
                self.persistentContainer.createItem(title: title, category: category)
            }
            
        }
        let dismissAlert = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(dismissAlert)
        alert.addAction(createStore)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Delete done items
extension ItemsVC {
    func deleteDoneItems() {
        for item in doneItems {
            item.managedObjectContext?.delete(item)
        }
    }
}
