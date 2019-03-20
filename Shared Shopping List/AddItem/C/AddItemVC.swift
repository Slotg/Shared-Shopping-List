import UIKit

class AddItemVC: UIViewController {
    
    // MARK: - Properties
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var stores: [Store] = []
    var categories: [Category] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var storesLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    // MARK: - IBActions
    @IBAction func saveItem(_ sender: UIButton) {
        guard let title = titleTextField.text, titleTextField.text != "" else { return }
        persistentContainer.createItem(title: title, stores: stores, categories: categories)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStoresLabel()
        updateCategoriesLabel()
    }
    
    func updateStoresLabel() {
        storesLabel.text = ""
        var newText = ""
        for store in stores {
            newText += store.title!
        }
        storesLabel.text = newText
    }
    
    func updateCategoriesLabel() {
        categoriesLabel.text = ""
        var newText = ""
        for category in categories {
            newText += category.title!
        }
        categoriesLabel.text = newText
    }
}

extension AddItemVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStoreListPicker" {
            let destination = segue.destination as? StoresAllTVC
            destination?.selectedStores = stores
        }
        if segue.identifier == "ShowCategoryListPicker" {
            let destination = segue.destination as? CategoriesAllTVC
            destination?.selectedCategories = categories
        }
    }
}
