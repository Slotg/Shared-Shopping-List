import UIKit

class ItemCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "ItemCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
