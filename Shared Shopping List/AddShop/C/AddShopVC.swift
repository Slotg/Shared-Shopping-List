import UIKit

class AddShopVC: UIViewController {
    
    // MARK: - Properties
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func saveShop(_ sender: UIButton) {
        guard let title = titleTextField.text, titleTextField.text != "" else { return }
        let address = addressTextField.text
        self.persistentContainer.createStore(title: title, address: address)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
