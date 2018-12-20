import UIKit

class StoreCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "StoreCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureCell(title: String) {
        titleLabel.text = title
    }
}
