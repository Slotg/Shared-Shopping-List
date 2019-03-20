import UIKit

class CategoriesGenericCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "CategoryGenericCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
