import UIKit

class CategoryCell: UITableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "CategoryCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    
    func configureCell(title: String, itemsCount: Int?) {
        titleLabel.text = title
        if let itemsCount = itemsCount {
            itemsCountLabel.text = itemsCount == 0 ? "-" : String(itemsCount)
        }
    }
}
