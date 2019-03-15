import UIKit

class StoreCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "StoreCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    
    func configureCell(title: String, address: String?, itemsCount: Int?) {
        titleLabel.text = title
        addressLabel.text = address
        if let itemsCount = itemsCount {
            itemsCountLabel.text = itemsCount == 0 ? "-" : String(itemsCount)
        }
    }
}
